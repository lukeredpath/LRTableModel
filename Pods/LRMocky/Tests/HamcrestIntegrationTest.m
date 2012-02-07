//
//  HamcrestIntegrationTest.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

@interface HamcrestIntegrationTest : FunctionalMockeryTestCase 
{}
@end

@implementation HamcrestIntegrationTest

- (void)testCanExpectInvocationWithEqualObjectAndPass
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWithObject:equalTo(@"foo")];
  }];
  
  [testObject doSomethingWithObject:@"foo"];
  assertContextSatisfied(context);

  assertThat(testCase, passed());
}

- (void)testCanExpectInvocationWithEqualObjectAndFail
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWithObject:equalTo(@"foo")];
  }];
  
  [testObject doSomethingWithObject:@"bar"];
  assertContextSatisfied(context);
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomethingWithObject: with(\"foo\") exactly(1) times but received it 0 times.", testObject]));
}

- (void)testCanExpectInvocationWithStringWithPrefixAndPass
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWithObject:startsWith(@"foo")];
  }];
  
  [testObject doSomethingWithObject:@"foo"];
  assertContextSatisfied(context);
  
  assertThat(testCase, passed());
}

- (void)testCanExpectInvocationWithStringWithPrefixAndFail
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWithObject:startsWith(@"foo")];
  }];
  
  [testObject doSomethingWithObject:@"bar foo"];
  assertContextSatisfied(context);
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
   @"Expected %@ to receive doSomethingWithObject: with(a string starting with \"foo\") exactly(1) times but received it 0 times.", testObject]));
}

- (void)testCanExpectInvocationWithIdenticalObjectAndPass
{
  SimpleObject *dummy = [[SimpleObject alloc] init];

  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWithObject:sameInstance(dummy)];
  }];
  
  [testObject doSomethingWithObject:dummy];
  assertContextSatisfied(context);
  
  assertThat(testCase, passed());
}

- (void)testCanExpectInvocationWithIdenticalObjectAndFail
{
  SimpleObject *dummy = [[SimpleObject alloc] init];

  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWithObject:sameInstance(dummy)];
  }];
  
  SimpleObject *other = [[[SimpleObject alloc] init] autorelease];
  [testObject doSomethingWithObject:other];
  assertContextSatisfied(context);
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomethingWithObject: with(sameInstance(<%@>)) exactly(1) times but received it 0 times.", testObject, dummy, other]));
}

@end
