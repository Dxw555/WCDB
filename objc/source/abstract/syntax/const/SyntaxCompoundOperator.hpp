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

#ifndef SyntaxCompoundOperator_hpp
#define SyntaxCompoundOperator_hpp

#include <WCDB/Enum.hpp>

namespace WCDB {

namespace Syntax {

enum class CompoundOperator : int {
    Union,
    UnionAll,
    Intersect,
    Except,
};

}

template<>
constexpr const char* Enum::description(const Syntax::CompoundOperator& compoundOperator)
{
    switch (compoundOperator) {
    case Syntax::CompoundOperator::Union:
        return "UNION";
    case Syntax::CompoundOperator::UnionAll:
        return "UNION ALL";
    case Syntax::CompoundOperator::Intersect:
        return "INTERSECT";
    case Syntax::CompoundOperator::Except:
        return "EXCEPT";
    }
}

} // namespace WCDB

#endif /* SyntaxCompoundOperator_hpp */