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
#include <WCDB/Syntax.h>

namespace WCDB {

namespace Syntax {

#pragma mark - Identifier
Identifier::Type WindowFunctionInvocation::getType() const
{
    return type;
}

std::string WindowFunctionInvocation::getDescription() const
{
    std::ostringstream stream;
    stream << name << "(";
    if (!expressions.empty()) {
        stream << expressions;
    } else if (wildcard) {
        stream << "*";
    }
    stream << ") ";
    if (useFilter) {
        stream << filter << " ";
    }
    stream << "OVER";
    if (!window.empty()) {
        stream << space << window;
    } else {
        stream << "(" << windowDef << ")";
    }
    return stream.str();
}

void WindowFunctionInvocation::iterate(const Iterator& iterator, void* parameter)
{
    Identifier::iterate(iterator, parameter);
    if (!expressions.empty()) {
        listIterate(expressions, iterator, parameter);
    }
    if (useFilter) {
        filter.iterate(iterator, parameter);
    }
    if (window.empty()) {
        windowDef.iterate(iterator, parameter);
    }
}

} // namespace Syntax

} // namespace WCDB