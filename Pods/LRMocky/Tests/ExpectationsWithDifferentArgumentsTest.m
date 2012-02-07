//
//  ExpectationsWithDifferentArguments.m
//  Mocky
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

@interface ExpectationsWithDifferentArguments : FunctionalMockeryTestCase
{}
@end

@implementation ExpectationsWithDifferentArguments

- (void)testCanExpectTheSameMethodWithDifferentArguments
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWithObject:@"foo"];
    [oneOf(testObject) doSomethingWithObject:@"bar"];
  }];
  
  [testObject doSomethingWithObject:@"foo"];
  [testObject doSomethingWithObject:@"bar"];
  
  assertContextSatisfied(context);
  assertThat(testCase, passed());
}

- (void)testCanExpectTheSameMethodWithDifferentArgumentsUsingMatchers
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWithObject:equalTo(@"foo")];
    [oneOf(testObject) doSomethingWithObject:equalTo(@"bar")];
  }];
  
  [testObject doSomethingWithObject:@"foo"];
  [testObject doSomethingWithObject:@"bar"];
  
  assertContextSatisfied(context);
  assertThat(testCase, passed());
}

@end
