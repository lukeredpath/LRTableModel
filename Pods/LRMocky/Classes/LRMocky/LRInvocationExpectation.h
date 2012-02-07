//
//  LRInvocationExpectation.h
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectation.h"
#import "LRExpectationAction.h"
#import "LRDescribable.h"

@protocol LRExpectationCardinality;

@class LRMockObject;
@class LRMockyState;

@interface LRInvocationExpectation : NSObject <LRExpectation> {
  NSInvocation *expectedInvocation;
  NSInvocation *similarInvocation;
  NSUInteger numberOfInvocations;
  NSMutableArray *actions;
  id<LRExpectationCardinality> cardinality;
  LRMockObject *mockObject;
  LRMockyState *requiredState;
  BOOL calledWithInvalidState;
}
@property (nonatomic, retain) NSInvocation *invocation;
@property (nonatomic, retain) id<LRExpectationCardinality> cardinality;
@property (nonatomic, retain) LRMockObject *mockObject;
@property (nonatomic, retain) LRMockyState *requiredState;
@property (nonatomic, readonly) BOOL calledWithInvalidState;

+ (id)expectation;
- (void)addAction:(id<LRExpectationAction>)anAction;
- (BOOL)matches:(NSInvocation *)invocation;
- (void)invoke:(NSInvocation *)invocation;
- (void)setInvocation:(NSInvocation *)invocation;
@end
