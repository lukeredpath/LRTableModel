//
//  LRMockObject.h
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRImposter.h"

@class LRMockery;
@class LRImposterizer;

@interface LRMockObject : LRImposter {
  LRMockery *context;
  NSString *name;
}
@property (nonatomic, copy) NSString *name;

+ (id)mockForClass:(Class)aClass inContext:(LRMockery *)mockery;
+ (id)mockForProtocol:(Protocol *)protocol inContext:(LRMockery *)mockery;
+ (id)partialMockForObject:(id)object inContext:(LRMockery *)context;
- (id)initWithImposterizer:(LRImposterizer *)anImposterizer context:(LRMockery *)mockery;
- (void)undoSideEffects;
@end
