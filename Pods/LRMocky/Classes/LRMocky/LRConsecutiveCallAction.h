//
//  LRConsecutiveCallAction.h
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectationAction.h"

@interface LRConsecutiveCallAction : NSObject <LRExpectationAction> {
  NSMutableArray *actions;
  NSUInteger numberOfCalls;
}
- (id)initWithActions:(NSArray *)actionList;
@end

LRConsecutiveCallAction *LRA_onConsecutiveCalls(id<LRExpectationAction>firstAction, ...) NS_REQUIRES_NIL_TERMINATION;

#ifdef LRMOCKY_SHORTHAND
#define onConsecutiveCalls LRA_onConsecutiveCalls
#endif