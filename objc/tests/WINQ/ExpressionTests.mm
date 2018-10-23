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

#import "WINQTestCase.h"
#import <WCDB/WCDB.h>

@interface ExpressionTests : WINQTestCase

@end

@implementation ExpressionTests {
    WCDB::LiteralValue literalValue;
    WCDB::BindParameter bindParameter;
    WCDB::Schema schema;
    NSString* table;
    WCDB::Column column;
    WCDB::Expression expression1;
    WCDB::Expression expression2;
    WCDB::Expression expression3;
    WCDB::Expression expression4;
    WCDB::Expression expression5;
    WCDB::Expression expression6;
    NSString* function;
    WCDB::ColumnType columnType;
    WCDB::StatementSelect select;
    WCDB::Expressions expressions;
    WCDB::RaiseFunction raiseFunction;
    NSString* windowFunction;
    WCDB::Filter filter;
    WCDB::WindowDef windowDef;
    NSString* window;
}

- (void)setUp
{
    [super setUp];
    literalValue = 1;
    bindParameter = WCDB::BindParameter(1);
    schema = @"testSchema";
    table = @"testTable";
    column = WCDB::Column(@"testColumn");
    expression1 = 1;
    expression2 = 2;
    expression3 = 3;
    expression4 = 4;
    expression5 = 5;
    expression6 = 6;
    function = @"testFunction";
    columnType = WCDB::ColumnType::Integer32;
    select = WCDB::StatementSelect().select(1);
    expressions = {
        1,
        2,
    };
    raiseFunction = WCDB::RaiseFunction().ignore();
    windowFunction = @"testWindowFunction";
    filter = WCDB::Filter().where(1);
    windowDef = WCDB::WindowDef();
    window = @"testWindow";
}

- (void)test_default_constructible
{
    WCDB::Expression constructible __attribute((unused));
}

- (void)test_literal_value
{
    auto testingSQL = WCDB::Expression(literalValue);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"1");
}

- (void)test_bind_parameter
{
    auto testingSQL = WCDB::Expression(bindParameter);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::BindParameter };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"?1");
}

- (void)test_column
{
    auto testingSQL = WCDB::Expression(column).table(table).schema(schema);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::Schema, WCDB::SQL::Type::Column };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"testSchema.testTable.testColumn");
}

- (void)test_column_without_schema
{
    auto testingSQL = WCDB::Expression(column).table(table);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::Schema, WCDB::SQL::Type::Column };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"main.testTable.testColumn");
}

- (void)test_column_without_table
{
    auto testingSQL = WCDB::Expression(column);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::Column };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"testColumn");
}

- (void)test_function
{
    auto testingSQL = WCDB::Expression::function(function).distinct().invoke(expressions);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"testFunction(DISTINCT 1, 2)");
}

- (void)test_function_without_distinct
{
    auto testingSQL = WCDB::Expression::function(function).invoke(expressions);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"testFunction(1, 2)");
}

- (void)test_function_without_parameter
{
    auto testingSQL = WCDB::Expression::function(function);

    auto testingTypes = { WCDB::SQL::Type::Expression };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"testFunction()");
}

- (void)test_function_all
{
    auto testingSQL = WCDB::Expression::function(function).invokeAll();

    auto testingTypes = { WCDB::SQL::Type::Expression };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"testFunction(*)");
}

- (void)test_expression_operable
{
    // see ExpressionOperableTests
}

- (void)test_core_function_operable
{
    // see CoreFunctionTests
}

- (void)test_aggregate_function_operable
{
    // see AggregateFunctionTests
}

- (void)test_fts3_function_operable
{
    // see FTS3FunctionTests
}

- (void)test_expressions
{
    auto testingSQL = WCDB::Expression(expressions);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"(1, 2)");
}

- (void)test_cast
{
    auto testingSQL = WCDB::Expression::cast(expression1).as(columnType);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"CAST(1 AS INTEGER)");
}

- (void)test_exists
{
    auto testingSQL = WCDB::Expression::exists(select);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::SelectSTMT, WCDB::SQL::Type::SelectCore, WCDB::SQL::Type::ResultColumn, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"EXISTS(SELECT 1)");
}

- (void)test_not_exists
{
    auto testingSQL = WCDB::Expression::notExists(select);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::SelectSTMT, WCDB::SQL::Type::SelectCore, WCDB::SQL::Type::ResultColumn, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"NOT EXISTS(SELECT 1)");
}

- (void)test_case
{
    auto testingSQL = WCDB::Expression::case_(expression1).when(expression2).then(expression3).else_(expression4);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"CASE 1 WHEN 2 THEN 3 ELSE 4 END");
}

- (void)test_case_without_case
{
    auto testingSQL = WCDB::Expression::case_().when(expression2).then(expression3).else_(expression4);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"CASE WHEN 2 THEN 3 ELSE 4 END");
}

- (void)test_case_multiple_when_then
{
    auto testingSQL = WCDB::Expression::case_(expression1).when(expression2).then(expression3).when(expression4).then(expression5).else_(expression6);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"CASE 1 WHEN 2 THEN 3 WHEN 4 THEN 5 ELSE 6 END");
}

- (void)test_case_without_else
{
    auto testingSQL = WCDB::Expression::case_(expression1).when(expression2).then(expression3);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"CASE 1 WHEN 2 THEN 3 END");
}

- (void)test_raise_function
{
    auto testingSQL = WCDB::Expression(raiseFunction);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::RaiseFunction };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"RAISE(IGNORE)");
}

- (void)test_window_function
{
    auto testingSQL = WCDB::Expression::windowFunction(windowFunction, expressions).over(windowDef);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::WindowDef };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"testWindowFunction(1, 2) OVER()");
}

- (void)test_window_function_without_parameter
{
    auto testingSQL = WCDB::Expression::windowFunction(windowFunction).over(windowDef);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::WindowDef };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"testWindowFunction() OVER()");
}

- (void)test_window_function_all
{
    auto testingSQL = WCDB::Expression::windowFunctionAll(windowFunction).over(windowDef);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::WindowDef };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"testWindowFunction(*) OVER()");
}

- (void)test_window_function_with_filter
{
    auto testingSQL = WCDB::Expression::windowFunction(windowFunction, expressions).filter(filter).over(windowDef);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Filter, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::WindowDef };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"testWindowFunction(1, 2) FILTER(WHERE 1) OVER()");
}

- (void)test_window_function_with_name
{
    auto testingSQL = WCDB::Expression::windowFunction(windowFunction, expressions).over(window);

    auto testingTypes = { WCDB::SQL::Type::Expression, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue, WCDB::SQL::Type::Expression, WCDB::SQL::Type::LiteralValue };
    IterateAssertEqual(testingSQL, testingTypes);
    WINQAssertEqual(testingSQL, @"testWindowFunction(1, 2) OVER testWindow");
}

WCDB::Expression acceptable(const WCDB::Expression& expression)
{
    return expression;
}

- (void)test_convertible
{
    WINQAssertEqual(acceptable(1), @"1");
    WINQAssertEqual(acceptable(@(1)), @"1");
    WINQAssertEqual(acceptable(true), @"1");
    WINQAssertEqual(acceptable(YES), @"1");
    WINQAssertEqual(acceptable(WCDB::Column("testColumn")), @"testColumn");
    WINQAssertEqual(acceptable((float) 0.1), @"0.1");
    WINQAssertEqual(acceptable((double) 0.1), @"0.1");
    WINQAssertEqual(acceptable("test"), @"'test'");
    WINQAssertEqual(acceptable(@"test"), @"'test'");
    WINQAssertEqual(acceptable(std::string("test")), @"'test'");
    WINQAssertEqual(acceptable(nullptr), @"NULL");
    WINQAssertEqual(acceptable(nil), @"NULL");
    WINQAssertEqual(acceptable(WCDB::LiteralValue::currentTime()), @"CURRENT_TIME");
}

@end