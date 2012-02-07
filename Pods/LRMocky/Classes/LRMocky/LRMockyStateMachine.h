//
//  LRMockyStateMachine.h
//  Mocky
//
//  Created by Luke Redpath on 30/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRMockyState;

@interface LRMockyStateMachine : NSObject {
  NSString *name;
  LRMockyState *currentState;
}
@property (nonatomic, readonly) LRMockyState *currentState;

- (id)initWithName:(NSString *)aName;
- (void)startsAs:(NSString *)label;
- (void)transitionToState:(LRMockyState *)newState;
- (BOOL)isCurrentState:(LRMockyState *)state;
- (LRMockyState *)state:(NSString *)label;
- (LRMockyState *)becomes:(NSString *)label;
- (LRMockyState *)hasBecome:(NSString *)label;
@end
