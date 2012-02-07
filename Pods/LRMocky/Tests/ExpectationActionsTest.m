//
//  ExpectationActionsTest.m
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

@interface ExpectationActionsTest : FunctionalMockeryTestCase 
{}
@end

@implementation ExpectationActionsTest

- (void)testMocksCanReturnAnObjectFromAnExpectedInvocation;
{
  NSString *expectedObject = @"some string";
  
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) returnSomething]; [it will:returnObject(expectedObject)];
  }];
  
  assertThat([testObject returnSomething], equalTo(expectedObject));
}

- (void)testMocksCanReturnAnObjectFromAnAllowedInvocation;
{
  NSString *expectedObject = @"some string";
  
  [context checking:^(LRExpectationBuilder *builder){
    [allowing(testObject) returnSomething]; [it will:returnObject(expectedObject)];
  }];
  
  assertThat([testObject returnSomething], equalTo(expectedObject));
}

- (void)testMocksCanCallBlocksFromAnExpectedInvocation;
{
  NSMutableArray *someArray = [NSMutableArray array];
  
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomething]; [it will:performBlock(^(NSInvocation *invocation) {
      [someArray addObject: NSStringFromSelector([invocation selector])];
    })];
  }];
  
  [testObject doSomething];
  
  assertThat(someArray, hasItem(@"doSomething"));
}

- (void)testMocksCanCallBlocksFromAnAllowedInvocation;
{
  NSMutableArray *someArray = [NSMutableArray array];
  
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) doSomething]; [it will:performBlock(^(NSInvocation *invocation) {
      [someArray addObject: NSStringFromSelector([invocation selector])];
    })];
  }];
  
  [testObject doSomething];
  
  assertThat(someArray, hasItem(@"doSomething"));
}

- (void)testMocksCanReturnANonObjectValueFromAnExpectedInvocation;
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(testObject) returnSomeValue]; [it will:returnInt(10)];
  }];
  
  assertThatInt((int)[testObject returnSomeValue], equalToInt(10));
}

- (void)testMocksCanReturnANonObjectValueFromAnAllowedInvocation;
{
  [context checking:^(LRExpectationBuilder *builder){
    [allowing(testObject) returnSomeValue]; [it will:returnInt(20)];
  }];
  
  assertThatInt((int)[testObject returnSomeValue], equalToInt(20));
}

- (void)testMocksCanReturnDifferentValuesOnConsecutiveCalls;
{
  [context checking:^(LRExpectationBuilder *builder){
    [allowing(testObject) returnSomeValue]; [it will:onConsecutiveCalls(
      returnInt(10),
      returnInt(20),
      returnInt(30),                                       
     nil)];
  }];
  
  assertThatInt((int)[testObject returnSomeValue], equalToInt(10));
  assertThatInt((int)[testObject returnSomeValue], equalToInt(20));
  assertThatInt((int)[testObject returnSomeValue], equalToInt(30));
  assertThatInt((int)[testObject returnSomeValue], equalToInt(30));
}

- (void)testCanExpectMethodCallsWithBlockArgumentsAndCallTheSuppliedBlock;
{
  id mockArray = [context mock:[NSArray class]];
  
  __block NSString *someString = nil;
  
  [context checking:^(LRExpectationBuilder *builder) {
    [oneOf(mockArray) indexesOfObjectsPassingTest:anyBlock()]; andThen(performBlockArguments);
  }];
  
  [(NSArray *)mockArray indexesOfObjectsPassingTest:^(id object, NSUInteger idx, BOOL *stop) { 
    someString = @"some string";
    return YES; 
  }];
  
  assertThat(someString, equalTo(@"some string"));
}

#if !(TARGET_IPHONE_SIMULATOR)
- (void)testMocksCanThrowAnException;
{
  [context checking:^(LRExpectationBuilder *builder){
    [allowing(testObject) doSomething]; [it will:throwException([NSException exceptionWithName:@"Test Exception" reason:nil userInfo:nil])];
  }];
  
  /**
   * this will only pass using the iOS 4.0 Device SDK, it currently fails
   * with the simulator SDK due to a runtime bug. rdar://8081169
   * also see: http://openradar.appspot.com/8081169
   * filed dupe: http://openradar.appspot.com/
   */
  
  @try {
    [testObject doSomething];
    STFail(@"Exception expected but none was thrown");
  }
  @catch (NSException *exception) {
    assertThat([exception name], equalTo(@"Test Exception"));
  }
}
#endif

- (void)testMocksCanPerformMultipleActions;
{
  NSMutableArray *array = [NSMutableArray array];

  [context checking:^(LRExpectationBuilder *builder){
    [allowing(testObject) returnSomething]; [it will:doAll(
      returnObject(@"test"),
      performBlock(^(NSInvocation *invocation){ 
        [array addObject:@"from block"];
      }), 
    nil)];
  }];
  
  assertThat([testObject returnSomething], equalTo(@"test"));
  assertThat(array, hasItem(@"from block"));
}

@end
