//
//  LRMultipleAction.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRMultipleAction.h"


@implementation LRMultipleAction

- (id)init
{
  if (self = [super init]) {
      actions = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)addAction:(id<LRExpectationAction>)action
{
  [actions addObject:action];
}

- (void)invoke:(NSInvocation *)invocation
{
  for (id<LRExpectationAction> action in actions) {
    [action invoke:invocation]; 
  }
}

@end

LRMultipleAction *LRA_doAll(id<LRExpectationAction>firstAction, ...)
{
  id eachAction;
  va_list actionList;
  
  LRMultipleAction *multipleAction = [[LRMultipleAction alloc] init];
  
  if (firstAction) {
    [multipleAction addAction:firstAction];
    
    va_start(actionList, firstAction);
    while ((eachAction = va_arg(actionList, id<LRExpectationAction>))) {
      [multipleAction addAction:eachAction];
    }
    va_end(actionList);
  }
  
  return [multipleAction autorelease];
}
