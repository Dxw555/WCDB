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

#pragma once

#include <WCDB/SQL.hpp>

namespace WCDB {

class FrameSpec final : public SpecifiedSyntax<Syntax::FrameSpec, SQL> {
public:
    FrameSpec& range();
    FrameSpec& rows();

    FrameSpec& unboundedPreceding();
    FrameSpec& preceding(const Expression& expression);
    FrameSpec& currentRow();
    FrameSpec& following(const Expression& expression);

    FrameSpec& betweenUnboundedPreceding();
    FrameSpec& betweenPreceding(const Expression& expression);
    FrameSpec& betweenCurrentRow();
    FrameSpec& betweenFollowing(const Expression& expression);

    FrameSpec& andPreceding(const Expression& expression);
    FrameSpec& andCurrentRow();
    FrameSpec& andFollowing(const Expression& expression);
    FrameSpec& andUnboundedFollowing();
};

} // namespace WCDB