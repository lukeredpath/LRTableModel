//
//  ExampleTests.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

@interface SimpleExpectationTests : FunctionalMockeryTestCase
{}
@end

@implementation SimpleExpectationTests

- (void)testCanExpectSingleMethodCallAndPass;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomething];
  }];
  
  [testObject doSomething];
  assertContextSatisfied(context);

  assertThat(testCase, passed());
}

- (void)testCanExpectSingleMethodCallAndFail;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomething];
  }];
  
  assertContextSatisfied(context);
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomething exactly(1) times but received it 0 times", testObject]));
}

- (void)testFailsWhenUnexpectedMethodIsCalled;
{
  [testObject doSomething];  
  assertContextSatisfied(context);

  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Unexpected method doSomething called on %@", testObject]));
}

- (void)testCanAllowSingleMethodCellAndPassWhenItIsCalled;
{
  [context checking:^(LRExpectationBuilder *builder){
    [allowing(testObject) doSomething];
  }];
  
  [testObject doSomething];
  assertContextSatisfied(context);
  
  assertThat(testCase, passed());
}

- (void)testCanAllowSingleMethodCellAndPassWhenItIsNotCalled;
{
  [context checking:^(LRExpectationBuilder *builder){
    [allowing(testObject) doSomething];
  }];
  
  assertContextSatisfied(context);
  
  assertThat(testCase, passed());
}

- (void)testCanExpectMethodCallWithSpecificParametersAndPassWhenTheCorrectParameterIsUsed;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) returnSomethingForValue:@"one"];
  }];
  
  [testObject returnSomethingForValue:@"one"];
  assertContextSatisfied(context);
  
  assertThat(testCase, passed());
}

- (void)testCanExpectMethodCallWithSpecificParametersAndFailWhenTheWrongParameterIsUsed;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) returnSomethingForValue:@"one"];
  }];
  
  [testObject returnSomethingForValue:@"two"];
  assertContextSatisfied(context);
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive returnSomethingForValue: with(@\"one\") exactly(1) times but received it 0 times.", testObject]));
}

- (void)testCanExpectMethodCallWithSpecificParametersAndFailWhenAtLeastOneParameterIsWrong;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWith:@"foo" andObject:@"bar"];
  }];
  
  [testObject doSomethingWith:@"foo" andObject:@"qux"];
  assertContextSatisfied(context);
  
  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomethingWith:andObject: with(@\"foo\", @\"bar\") exactly(1) times but received it 0 times.", testObject]));
}

- (void)testCanExpectMethodCallWithSpecificNonObjectParametersAndPass;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWithInt:20];
  }];
  
  [testObject doSomethingWithInt:20];
  
  assertContextSatisfied(context);
  
  assertThat(testCase, passed());
}

- (void)testCanExpectMethodCallWitBoolParametersAndPass;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWithBool:YES];
  }];
  
  [testObject doSomethingWithBool:YES];
  
  assertContextSatisfied(context);
  
  assertThat(testCase, passed());
}

- (void)testCanExpectMethodCallWithSpecificNonObjectParametersAndFail;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomethingWithInt:10];
  }];
  
  [testObject doSomethingWithInt:20];
  assertContextSatisfied(context);

  assertThat(testCase, failedWithExpectationError([NSString stringWithFormat:
    @"Expected %@ to receive doSomethingWithInt: with(10) exactly(1) times but received it 0 times.", testObject]));
}

- (void)testCanExpectMethodCallsWithBlockArgumentsAndPass;
{
  id mockArray = [context mock:[NSArray class]];
 
  [context checking:^(LRExpectationBuilder *builder) {
    [oneOf(mockArray) indexesOfObjectsPassingTest:anyBlock()];
  }];
  
  [(NSArray *)mockArray indexesOfObjectsPassingTest:^(id object, NSUInteger idx, BOOL *stop) { return YES; }];
}

- (void)testCanExpectMethodCallsWithBlockArgumentsWithObjectAndPass;
{
  [context checking:^(LRExpectationBuilder *builder) {
    [oneOf(testObject) doSomethingWithBlockThatYields:anyBlock()]; andThen(performBlockArgumentsWithObject(@"some string"));
  }];
  
  [testObject doSomethingWithBlockThatYields:^(id object) {
    assertThat(object, is(equalTo(@"some string")));
  }];
}

- (void)testCanResetTheMockery
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomething];
  }];
  
  [context reset];
  
  assertContextSatisfied(context);
  assertThat(testCase, passed());
}

@end
