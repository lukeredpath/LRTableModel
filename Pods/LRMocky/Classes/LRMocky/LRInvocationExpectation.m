//
//  LRInvocationExpectation.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRInvocationExpectation.h"
#import "LRInvocationComparitor.h"
#import "LRExpectationCardinality.h"
#import "LRExpectationMessage.h"
#import "LRMockyStates.h"
#import "NSInvocation+OCMAdditions.h"
#import "NSInvocation+LRAdditions.h"

NSString *const LRMockyExpectationError = @"LRMockyExpectationError";

@interface LRInvocationExpectation ()
@property (nonatomic, retain) NSInvocation *similarInvocation;
@end

@implementation LRInvocationExpectation

@synthesize invocation = expectedInvocation;
@synthesize cardinality;
@synthesize mockObject;
@synthesize similarInvocation;
@synthesize requiredState;
@synthesize calledWithInvalidState;

+ (id)expectation;
{
  return [[[self alloc] init] autorelease];
}

- (id)init;
{
  if (self = [super init]) {
    numberOfInvocations = 0;
    actions = [[NSMutableArray alloc] init];
    calledWithInvalidState = NO;
    self.cardinality = LRM_exactly(1); // TODO choose a better default
  }
  return self;
}

- (void)dealloc;
{
  [mockObject release];
  [cardinality release];
  [actions release];
  [expectedInvocation release];
  [super dealloc];
}

- (BOOL)matches:(NSInvocation *)invocation;
{
  LRInvocationComparitor *comparitor = [LRInvocationComparitor comparitorForInvocation:expectedInvocation];
    
  if ([invocation selector] != [expectedInvocation selector]) {
    return NO;
  }
  if(![comparitor matchesParameters:invocation]) {
    return NO;
  }
  if (self.requiredState && ![self.requiredState isActive]) {
    NSLog(@"Required state %@ but it is not active", self.requiredState);
    calledWithInvalidState = YES;
    return YES;
  }
  return YES;
}

- (void)invoke:(NSInvocation *)invocation
{
  LRInvocationComparitor *comparitor = [LRInvocationComparitor comparitorForInvocation:expectedInvocation];
  
  NSLog(@"Invoking %@", invocation);
    
  if([comparitor matchesParameters:invocation]) {
    numberOfInvocations++;
    
    [invocation copyBlockArguments];
    
    for (id<LRExpectationAction> action in actions) {
      [action invoke:invocation];
    } 
  } else {
    [invocation retainArguments];
    self.similarInvocation = invocation;
  }
}

- (BOOL)isSatisfied;
{
  return [self.cardinality satisfiedBy:numberOfInvocations];
}

- (void)describeTo:(LRExpectationMessage *)message
{
  [message append:[NSString stringWithFormat:@"Expected %@ to receive %@ ", mockObject, NSStringFromSelector([expectedInvocation selector])]];
  
  NSInteger numberOfArguments = [[expectedInvocation methodSignature] numberOfArguments];
  if (numberOfArguments > 2) {
    NSMutableArray *parameters = [NSMutableArray array];
    for (int i = 2; i < numberOfArguments; i++) {
      [parameters addObject:[expectedInvocation argumentDescriptionAtIndex:i]];
    }
    [message append:[NSString stringWithFormat:@"with(%@) ", [parameters componentsJoinedByString:@", "]]];
  } 
  
  [self.cardinality describeTo:message];
  [message append:[NSString stringWithFormat:@" but received it %d times.", numberOfInvocations]];
  
  if (self.similarInvocation && numberOfArguments > 2) {
    [message append:[NSString stringWithFormat:@" %@ was called ", NSStringFromSelector([expectedInvocation selector])]];
    
    NSMutableArray *parameters = [NSMutableArray array];
    for (int i = 2; i < numberOfArguments; i++) {
      [parameters addObject:[self.similarInvocation objectDescriptionAtIndex:i]];
    }
    [message append:[NSString stringWithFormat:@"with(%@).", [parameters componentsJoinedByString:@", "]]];
  }
}

- (void)addAction:(id<LRExpectationAction>)anAction;
{
  [actions addObject:anAction];
}

@end

