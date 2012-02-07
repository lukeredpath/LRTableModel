//
//  LRPerformBlockAction.h
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectationAction.h"

typedef void (^LR_invocationActionBlock)(NSInvocation *);

@interface LRPerformBlockAction : NSObject <LRExpectationAction> {
  LR_invocationActionBlock block;
}
- (id)initWithBlock:(LR_invocationActionBlock)theBlock;
@end

LRPerformBlockAction *LRA_performBlock(LR_invocationActionBlock theBlock);

#ifdef LRMOCKY_SHORTHAND
#define performBlock  LRA_performBlock
#define performsBlock LRA_performBlock
#endif
