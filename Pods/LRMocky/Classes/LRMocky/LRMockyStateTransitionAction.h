//
//  LRMockyStateTransitionAction.h
//  Mocky
//
//  Created by Luke Redpath on 30/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectationAction.h"

@class LRMockyState;

@interface LRMockyStateTransitionAction : NSObject <LRExpectationAction> 
{
  LRMockyState *state;
}
+ (id)transitionToState:(LRMockyState *)state;
- (id)initWithState:(LRMockyState *)aState;
@end
