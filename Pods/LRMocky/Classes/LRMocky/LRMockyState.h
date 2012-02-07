//
//  LRMockyState.h
//  Mocky
//
//  Created by Luke Redpath on 30/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRMockyStateMachine;

@interface LRMockyState : NSObject
{
  NSString *label;
  LRMockyStateMachine *context;
}
+ (id)stateWithLabel:(NSString *)label inContext:(LRMockyStateMachine *)context;
- (id)initWithLabel:(NSString *)aLabel context:(LRMockyStateMachine *)aContext;
- (void)activate;
- (BOOL)isActive;
- (BOOL)isEqualToState:(LRMockyState *)state;
- (BOOL)matches:(NSString *)stateLabel;
@end
