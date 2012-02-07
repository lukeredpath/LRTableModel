//
//  LRPerformBlockAction.m
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRPerformBlockAction.h"


@implementation LRPerformBlockAction

- (id)initWithBlock:(LR_invocationActionBlock)theBlock;
{
  if (self = [super init]) {
    block = Block_copy(theBlock);
  }
  return self;
}

- (void)dealloc 
{
  Block_release(block);
  [super dealloc];
}

- (void)invoke:(NSInvocation *)invocation
{
  block(invocation);
}

@end

LRPerformBlockAction *LRA_performBlock(LR_invocationActionBlock theBlock)
{
  return [[[LRPerformBlockAction alloc] initWithBlock:theBlock] autorelease];
}
