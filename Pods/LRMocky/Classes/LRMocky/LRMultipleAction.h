//
//  LRMultipleAction.h
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectationAction.h"

@interface LRMultipleAction : NSObject <LRExpectationAction> {
  NSMutableArray *actions;
}
- (void)addAction:(id<LRExpectationAction>)action;
@end

LRMultipleAction *LRA_doAll(id<LRExpectationAction>firstAction, ...) NS_REQUIRES_NIL_TERMINATION;

#ifdef LRMOCKY_SHORTHAND
#define doAll LRA_doAll
#endif
