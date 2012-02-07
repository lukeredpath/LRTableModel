//
//  LRMockyStateMachine.m
//  Mocky
//
//  Created by Luke Redpath on 30/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRMockyStateMachine.h"
#import "LRMockyState.h"

@implementation LRMockyStateMachine

@synthesize currentState;

- (id)initWithName:(NSString *)aName;
{
  if (self = [super init]) {
    name = [aName copy];
    [self startsAs:@"<<initial state>>"];
  }
  return self;
}

- (void)dealloc 
{
  [name release];
  [currentState release];
  [super dealloc];
}

- (void)startsAs:(NSString *)label;
{
  [self transitionToState:[self state:label]];
}

- (LRMockyState *)state:(NSString *)label;
{
  return [LRMockyState stateWithLabel:label inContext:self];
}

- (LRMockyState *)becomes:(NSString *)label;
{
  return [self state:label];
}

- (LRMockyState *)hasBecome:(NSString *)label;
{
  return [self state:label];
}

- (void)transitionToState:(LRMockyState *)newState;
{
  [currentState release];
  currentState = [newState retain];
}

- (BOOL)isCurrentState:(LRMockyState *)state;
{
  return [state isEqual:currentState]; 
}

@end
