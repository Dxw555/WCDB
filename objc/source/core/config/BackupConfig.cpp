/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <WCDB/Assertion.hpp>
#include <WCDB/BackupConfig.hpp>
#include <WCDB/BackupQueue.hpp>
#include <WCDB/String.hpp>

namespace WCDB {

BackupConfig::BackupConfig(const std::shared_ptr<BackupQueue> &queue)
: Config(), m_identifier(String::formatted("Backup-%p", this)), m_queue(queue)
{
    WCTInnerAssert(m_queue != nullptr);
}

bool BackupConfig::invoke(Handle *handle)
{
    if (!handle->beginTransaction()) {
        return false;
    }
    bool result = handle->setNotificationWhenCheckpointed(
    m_identifier,
    std::bind(&BackupConfig::checkpointed, this, std::placeholders::_1, std::placeholders::_2));
    handle->rollbackTransaction();
    if (result) {
        handle->setNotificationWhenCommitted(
        0,
        m_identifier,
        std::bind(&BackupConfig::onCommitted, this, std::placeholders::_1, std::placeholders::_2));
    }
    return result;
}

bool BackupConfig::uninvoke(Handle *handle)
{
    if (!handle->beginTransaction()) {
        return false;
    }
    bool result = handle->setNotificationWhenCheckpointed(m_identifier, nullptr);
    handle->rollbackTransaction();
    handle->unsetNotificationWhenCommitted(m_identifier);
    return result;
}

bool BackupConfig::onCommitted(Handle *handle, int frames)
{
    const auto &path = handle->path;
    int backedUp = m_queue->getBackedUpFrames(path);
    if (frames >= backedUp + framesIntervalForCritical || frames < backedUp) {
        m_queue->put(path, delayForCritical, frames);
    } else if (frames >= backedUp + framesIntervalForNonCritical) {
        m_queue->put(path, delayForNonCritical, frames);
    }
    // it's no need to backup when idled since a checkpoint will happen by checkpoint queue when idled, which will trigger backup immediately
    return true;
}

void BackupConfig::checkpointed(Handle *handle, int rc)
{
    if (rc == SQLITE_OK) {
        // back up immediately if checkpointed
        m_queue->put(handle->path, delayForCritical, 0);
    }
}

} //namespace WCDB
