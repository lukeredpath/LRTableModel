//
//  ExampleTestCase.m
//  Mocky
//
//  Created by Luke Redpath on 28/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#define LRMOCKY_SHORTHAND
#define LRMOCKY_SUGAR
#define HC_SHORTHAND

#import <SenTestingKit/SenTestingKit.h>
#import "OCHamcrest.h"
#import "LRMocky.h"
#import "TestHelper.h"

@interface BasicExamples : SenTestCase
{}
@end

@implementation BasicExamples

- (void)testSuccessfulMocking
{
  LRMockery *context = mockery();

  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[oneOf(myMockString) receives] uppercaseString];
  }];
  
  [myMockString uppercaseString];
  
  assertContextSatisfied(context);
}

- (void)testFailedMocking 
{
  LRMockery *context = mockery();
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[oneOf(myMockString) receives] uppercaseString];
  }];
  
  [myMockString lowercaseString];
  
  assertContextNotSatisfied(context);
}

- (void)testSuccessfulMockingWithMultipleCallsExpected
{
  LRMockery *context = mockery();
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[[atLeast(2) of:myMockString] receives] uppercaseString];
  }];
  
  [myMockString uppercaseString];
  [myMockString uppercaseString];
  [myMockString uppercaseString];
  
  assertContextSatisfied(context);
}

- (void)testFailedMockingWithMultipleCallsExpected
{
  LRMockery *context = mockery();
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[[between(2, 4) of:myMockString] receives] uppercaseString];
  }];
  
  [myMockString uppercaseString];
  
  assertContextNotSatisfied(context);
}

- (void)testSuccessfulMockingWithHamcrest 
{
  LRMockery *context = mockery();
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[oneOf(myMockString) receives] stringByAppendingString:matching(startsWith(@"super"))];
  }];
  
  [myMockString stringByAppendingString:@"super"];
  
  assertContextSatisfied(context);
}

- (void)testFailedMockingWithHamcrest 
{
  LRMockery *context = mockery();
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[oneOf(myMockString) receives] stringByAppendingString:matching(startsWith(@"super"))];
  }];
  
  [myMockString stringByAppendingString:@"not super"];
  
  assertContextNotSatisfied(context);
}

- (void)testSuccessfulMockWithReturnValue
{
  LRMockery *context = mockery();
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [[oneOf(myMockString) receives] uppercaseString]; andThen(returnsObject(@"FOOBAR"));
  }];
  
  NSString *returnedValue = [myMockString uppercaseString];
  
  assertContextSatisfied(context);

  assertThat(returnedValue, equalTo(@"FOOBAR"));
}

- (void)testSuccessfulMockWithPerformedBlock
{
  LRMockery *context = mockery();
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  __block id outsideTheBlock = nil;
  
  [context checking:^(that){
    [[oneOf(myMockString) receives] uppercaseString]; andThen(performsBlock(^(NSInvocation *invocation) {
      outsideTheBlock = @"FOOBAR";
    }));
  }];
  
  [myMockString uppercaseString];
  
  assertContextSatisfied(context);
  assertThat(outsideTheBlock, equalTo(@"FOOBAR"));
}

- (void)testStubbingMethod
{
  LRMockery *context = mockery();
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [stub(myMockString) uppercaseString]; andReturn(@"some string");
  }];
  
  assertThat([myMockString uppercaseString], equalTo(@"some string"));  
  assertContextSatisfied(context);
}

- (void)testPartialStubbingMethodOnRealObject
{
  LRMockery *context = mockery();
  
  SimpleObject *simpleObject = [[SimpleObject alloc] init];
  
  [context checking:^(that){
    [stub(simpleObject) returnSomething]; andReturn(@"some return value");
  }];
  
  assertThat([simpleObject returnSomething], equalTo(@"some return value"));
  assertContextSatisfied(context);
}

- (void)testContextSatisfiedWhenStubbingMethodNotCalled
{
  LRMockery *context = mockery();
  
  id myMockString = [context mock:[NSString class] named:@"My Mock String"];
  
  [context checking:^(that){
    [stub(myMockString) uppercaseString]; andReturn(@"some string");
  }];
  
  assertContextSatisfied(context);
}

- (void)testPartialStubsOnlyAffectTheStubbedInstance
{
  LRMockery *context = mockery();
  
  SimpleObject *simpleObject = [[SimpleObject alloc] init];
  
  [context checking:^(that){
    [stub(simpleObject) returnSomething]; andReturn(@"some return value");
  }];
  
  assertThat([[SimpleObject new] returnSomething], is(nilValue()));
}

- (void)testStubbingClassMethod
{
  LRMockery *context = mockery();
  
  SimpleObject *expectedObject = [[SimpleObject alloc] init];
  
  [context checking:^(that){
    [stub([SimpleObject class]) factoryMethod]; andReturn(expectedObject);
  }];
  
  assertThat([SimpleObject factoryMethod], equalTo(expectedObject));  
}

- (void)testStubbedClassMethodIsRestoredAfterContextAssertSatisfied
{
  LRMockery *context = mockery();
  
  SimpleObject *expectedObject = [[SimpleObject alloc] init];
  
  [context checking:^(that){
    [stub([SimpleObject class]) factoryMethod]; andReturn(expectedObject);
  }];
  
  assertThat([SimpleObject factoryMethod], equalTo(expectedObject));  
  assertContextSatisfied(context);
  assertThat([SimpleObject factoryMethod], is(nilValue()));
}

@end
