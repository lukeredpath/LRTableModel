//
//  LRConsecutiveCallAction.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRConsecutiveCallAction.h"


@implementation LRConsecutiveCallAction 

- (id)initWithActions:(NSArray *)actionList;
{
  if (self = [super init]) {
    actions = [actionList copy];
    numberOfCalls = 0;  
  }
  return self;
}

- (void)dealloc;
{
  [actions release];
  [super dealloc];
}

- (void)invoke:(NSInvocation *)invocation
{
  [(id<LRExpectationAction>)[actions objectAtIndex:numberOfCalls] invoke:invocation];
  
  numberOfCalls++;
  if (numberOfCalls == [actions count]) {
    numberOfCalls = [actions count] - 1;
  }
}

@end

LRConsecutiveCallAction *LRA_onConsecutiveCalls(id<LRExpectationAction>firstAction, ...)
{
  id eachAction;
  va_list actionList;
  
  NSMutableArray *actions = [NSMutableArray array];
  
  if (firstAction) {
    [actions addObject:firstAction];
    
    va_start(actionList, firstAction);
    while ((eachAction = va_arg(actionList, id<LRExpectationAction>))) {
      [actions addObject:eachAction];
    }
    va_end(actionList);
  }

  return [[[LRConsecutiveCallAction alloc] initWithActions:actions] autorelease];
}
