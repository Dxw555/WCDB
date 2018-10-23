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

#ifndef LiteralValue_hpp
#define LiteralValue_hpp

#include <WCDB/SQL.hpp>

namespace WCDB {

// BLOB is not supported since it may cause string truncation. Ones should use BindParameter instead.
class LiteralValue : public SQLSyntax<Syntax::LiteralValue> {
public:
    using SQLSyntax<Syntax::LiteralValue>::SQLSyntax;

    template<typename T, typename Enable = typename std::enable_if<LiteralValueConvertible<T>::value>::type>
    LiteralValue(const T& t)
    : LiteralValue(LiteralValueConvertible<T>::asLiteralValue(t))
    {
    }

    LiteralValue(int32_t value);
    LiteralValue(int64_t value);
    LiteralValue(double value);
    LiteralValue(std::nullptr_t);
    LiteralValue(const char* value);

    static LiteralValue currentTime();
    static LiteralValue currentDate();
    static LiteralValue currentTimestamp();
};

} // namespace WCDB

#endif /* LiteralValue_hpp */