//
//  LRExpectation.h
//  Mocky
//
//  Created by Luke Redpath on 22/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRExpectationAction.h"
#import "LRDescribable.h"

extern NSString *const LRMockyExpectationError;

@protocol LRExpectation <NSObject, LRDescribable>
- (BOOL)isSatisfied;
- (void)addAction:(id<LRExpectationAction>)action;
@optional
- (BOOL)calledWithInvalidState;
@end
