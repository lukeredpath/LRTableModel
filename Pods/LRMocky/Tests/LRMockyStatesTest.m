//
//  LRMockyStatesTest.m
//  Mocky
//
//  Created by Luke Redpath on 30/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRMockyStates.h"

@interface LRMockyStateMachine (Testing)
@property (nonatomic, readonly) LRMockyState *currentState;
@end

@implementation LRMockyStateMachine (Testing)
- (LRMockyState *)currentState
{
  return currentState;
}
@end

id<HCMatcher> isInState(LRMockyState *state)
{
  NSInvocation *invocation   = [HCInvocationMatcher createInvocationForSelector:@selector(currentState) onClass:[LRMockyStateMachine class]];
  return [[[HCInvocationMatcher alloc] initWithInvocation:invocation matching:equalTo(state)] autorelease];
}

@interface LRMockyStatesTest : SenTestCase 
{}
@end

@implementation LRMockyStatesTest

- (void)testCanTransitionToNewState
{
  LRMockyStateMachine *context = [[LRMockyStateMachine alloc] initWithName:@"Test"];

  [[context state:@"First"] activate];
  
  assertThat(context, isInState([context state:@"First"]));
}

- (void)testCanTransitionToNewStateFromExistingState
{
  LRMockyStateMachine *context = [[LRMockyStateMachine alloc] initWithName:@"Test"];
  [context startsAs:@"First"];
  
  [[context state:@"Second"] activate];
  
  assertThat(context, isInState([context state:@"Second"]));
}

@end
