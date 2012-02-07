//
//  CardinalityTests.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

@interface CardinalityTests : FunctionalMockeryTestCase
@end

@implementation CardinalityTests

#pragma mark Exactly (x) times

- (void)testCanSpecifyExpectationIsCalledOnceAndFailIfCalledTwice
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  assertContextSatisfied(context);
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething exactly(1) times but received it 2 times.", testObject]));
}

- (void)testCanSpecifyExpectationIsCalledExactNumberOfTimesAndFailIfCalledFewerTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[exactly(3) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  assertContextSatisfied(context);
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething exactly(3) times but received it 2 times.", testObject]));
}

- (void)testCanSpecifyExpectationIsCalledExactNumberOfTimesAndFailIfCalledMoreTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[exactly(2) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  assertContextSatisfied(context);
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething exactly(2) times but received it 3 times.", testObject]));
}

#pragma mark At least (x) times

- (void)testCanSpecifyExpectationIsCalledAtLeastNumberOfTimesAndFailIfCalledFewerTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[atLeast(2) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  assertContextSatisfied(context);
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething atLeast(2) times but received it 1 times.", testObject]));
}

- (void)testCanSpecifyExpectationIsCalledAtLeastNumberOfTimesAndPassIfCalledMoreTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[atLeast(2) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  assertContextSatisfied(context);
  
  assertThat(testCase, passed());
}

- (void)testCanSpecifyExpectationIsCalledAtLeastNumberOfTimesAndPassIfCalledTheExactNumberOfTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[atLeast(2) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  assertContextSatisfied(context);
  
  assertThat(testCase, passed());
}

#pragma mark At most (x) times

- (void)testCanSpecifyExpectationIsCalledAtMostNumberOfTimesAndFailIfCalledMoreTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[atMost(2) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  assertContextSatisfied(context);
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething atMost(2) times but received it 3 times.", testObject]));
}

- (void)testCanSpecifyExpectationIsCalledAtMostNumberOfTimesAndPassIfCalledFewerTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[atMost(2) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  assertContextSatisfied(context);
  
  assertThat(testCase, passed());
}

- (void)testCanSpecifyExpectationIsCalledAtMostNumberOfTimesAndPassIfCalledTheExactNumberOfTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[atMost(2) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  assertContextSatisfied(context);
  
  assertThat(testCase, passed());
}

#pragma mark Between (x) and (y) times

- (void)testCanSpecifyExpectationIsCalledBetweenNumberOfTimesAndFailIfCalledMoreTimesThanTheUpperLimit
{
  [context checking:^(LRExpectationBuilder *builder){
    [[between(2, 5) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  assertContextSatisfied(context);
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething between(2 and 5) times but received it 6 times.", testObject]));
}

- (void)testCanSpecifyExpectationIsCalledBetweenNumberOfTimesAndFailIfCalledFewerTimesThanTheLowerLimit
{
  [context checking:^(LRExpectationBuilder *builder){
    [[between(2, 5) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  assertContextSatisfied(context);
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething between(2 and 5) times but received it 1 times.", testObject]));
}

- (void)testCanSpecifyExpectationIsCalledBetweenNumberOfTimesAndPassIfCalledLowerLimitTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[between(2, 5) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  assertContextSatisfied(context);
  
  assertThat(testCase, passed());
}

- (void)testCanSpecifyExpectationIsCalledBetweenNumberOfTimesAndPassIfCalledUpperLimitTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[between(2, 5) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  assertContextSatisfied(context);
  
  assertThat(testCase, passed());
}

- (void)testCanSpecifyExpectationIsCalledBetweenNumberOfTimesAndPassIfCalledBetweenUpperAndLowerLimitTimes
{
  [context checking:^(LRExpectationBuilder *builder){
    [[between(2, 5) of:testObject] doSomething];
  }];
  
  [testObject doSomething];
  [testObject doSomething];
  [testObject doSomething];
  assertContextSatisfied(context);
  
  assertThat(testCase, passed());
}

#pragma mark Never allowed

- (void)testCanSpecifyExpectationIsNotAllowedAndFailIfItIsCalled
{
  [context checking:^(LRExpectationBuilder *builder){
    [never(testObject) doSomething];
  }];
  
  [testObject doSomething];
  assertContextSatisfied(context);
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething exactly(0) times but received it 1 times.", testObject]));
}

- (void)testCanSpecifyExpectationIsNotAllowedAndPassIfItIsNotCalled
{
  [context checking:^(LRExpectationBuilder *builder){
    [never(testObject) doSomething];
  }];
  
  assertContextSatisfied(context);
  
  assertThat(testCase, passed());
}

@end
