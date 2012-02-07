//
//  LRExpectationBuilder.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRExpectationBuilder.h"
#import "LRMockObject.h"
#import "LRMockery.h"
#import "LRInvocationExpectation.h"
#import "LRExpectationCardinality.h"
#import "LRMockyStates.h"
#import "LRObjectImposterizer.h"
#import "NSInvocation+OCMAdditions.h"

@interface LRExpectationBuilder ()
@property (nonatomic, retain) LRInvocationExpectation *currentExpecation;
- (void)actAsImposterForMockObject:(LRMockObject *)mock;
- (void)prepareExpectationForObject:(id)mockObject 
                    withCardinality:(id<LRExpectationCardinality>)cardinality;
@end

@implementation LRExpectationBuilder

@synthesize currentExpecation;

+ (id)builderInContext:(LRMockery *)context;
{
  return [[[self alloc] initWithMockery:context] autorelease];
}

- (id)initWithMockery:(LRMockery *)aMockery;
{
  if (self = [super init]) {
    mockery = [aMockery retain];
  }
  return self;
}

- (void)dealloc;
{
  [imposterizer release];
  [mockery release];
  [super dealloc];
}

- (id)receives;
{
  return self;
}

- (id)oneOf:(id)mockObject;
{
  return [self exactly:1 of:mockObject];
}

- (id)exactly:(int)numberOfTimes of:(id)mockObject;
{
  [self prepareExpectationForObject:mockObject withCardinality:LRM_exactly(numberOfTimes)];
  return self;
}

- (id)atLeast:(int)minimum of:(id)mockObject;
{
  [self prepareExpectationForObject:mockObject withCardinality:LRM_atLeast(minimum)];
  return self;
}

- (id)atMost:(int)maximum of:(id)mockObject;
{
  [self prepareExpectationForObject:mockObject withCardinality:LRM_atMost(maximum)];
  return self;
}

- (id)between:(int)minimum and:(int)maximum of:(id)mockObject;
{
  [self prepareExpectationForObject:mockObject withCardinality:LRM_between(minimum, maximum)];
  return self;
}

- (id)allowing:(id)mockObject;
{
  [self prepareExpectationForObject:mockObject withCardinality:LRM_atLeast(0)];
  return self;
}

- (id)never:(id)mockObject;
{
  [self prepareExpectationForObject:mockObject withCardinality:LRM_exactly(0)];
  return self;
}

- (void)requiresState:(LRMockyState *)state;
{
  self.currentExpecation.requiredState = state;
}

- (void)shouldTransitionToState:(LRMockyState *)state;
{
  [self.currentExpecation addAction:[LRMockyStateTransitionAction transitionToState:state]];
}

- (id)will:(id<LRExpectationAction>)action;
{
  [self.currentExpecation addAction:action];
  return self;
}

#pragma mark Private methods

- (void)actAsImposterForMockObject:(LRMockObject *)mock;
{
  imposterizer = mock.imposterizer;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
  return [imposterizer methodSignatureForSelector:sel];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
  return [imposterizer respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{  
  self.currentExpecation.invocation = anInvocation;

  if ([imposterizer isKindOfClass:[LRObjectImposterizer class]]) {
    [(LRObjectImposterizer *)imposterizer setupInvocationHandlerForImposterizedObjectForInvocation:anInvocation];
  }
  [mockery addExpectation:self.currentExpecation];
}

- (void)prepareExpectationForObject:(id)mockObject 
                    withCardinality:(id<LRExpectationCardinality>)cardinality;
{
  if (![mockObject isKindOfClass:[LRMockObject class]]) {
    mockObject = [mockery partialMockForObject:mockObject];
  }
  
  self.currentExpecation = [LRInvocationExpectation expectation];
  self.currentExpecation.cardinality = cardinality;
  self.currentExpecation.mockObject = mockObject;
  
  [self actAsImposterForMockObject:mockObject];
}

@end
