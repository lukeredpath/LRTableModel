//
//  LRExpectationBuilder.h
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectation.h"

@class LRMockObject;
@class LRMockery;
@class LRInvocationExpectation;
@class LRMockyState;
@class LRImposterizer;

@interface LRExpectationBuilder : NSObject {
  LRMockery *mockery;
  LRInvocationExpectation *currentExpectation;
  LRImposterizer *imposterizer;
}
+ (id)builderInContext:(LRMockery *)context;
- (id)initWithMockery:(LRMockery *)aMockery;
- (id)receives; // syntatic sugar
- (id)oneOf:(id)mockObject;
- (id)exactly:(int)numberOfTimes of:(id)mockObject;
- (id)atLeast:(int)minimum of:(id)mockObject;
- (id)atMost:(int)maximum of:(id)mockObject;
- (id)between:(int)minimum and:(int)maximum of:(id)mockObject;
- (id)will:(id<LRExpectationAction>)action;
- (id)allowing:(id)mockObject;
- (id)never:(id)mockObject;
- (void)shouldTransitionToState:(LRMockyState *)state;
- (void)requiresState:(LRMockyState *)state;
@end


#ifdef LRMOCKY_SUGAR
#define mockery()           [LRMockery mockeryForTestCase:self]
#define that                LRExpectationBuilder *builder
#define andThen(action)     [builder will:action]
#define andReturn(object)   [builder will:returnsObject(object)];
#define oneOf(arg)          [builder oneOf:arg]
#define allowing(arg)       [builder allowing:arg]
#define never(arg)          [builder never:arg]
#define exactly(x)           builder exactly:x
#define atLeast(x)           builder atLeast:x
#define atMost(x)            builder atMost:x
#define between(x, y)        builder between:x and:y
#define then(state)         [builder shouldTransitionToState:state]
#define when(state)         [builder requiresState:state];
#define stub(arg)           [builder allowing:arg] 
#define matching(matcher)   (id)matcher
#endif

#ifndef LRMOCKY_KIWI_COMPATIBILITY_MODE
#define it                  builder
#endif
