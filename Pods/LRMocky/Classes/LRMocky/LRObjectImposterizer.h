//
//  LRObjectImposterizer.h
//  Mocky
//
//  Created by Luke Redpath on 24/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRImposterizer.h"
#import <objc/runtime.h>

@interface LRObjectImposterizer : LRImposterizer {
  id objectToImposterize;
  Method originalClassMethod;
  NSInvocation *imposterizedInvocation;
}
- (id)initWithObject:(id)object;
- (void)setupInvocationHandlerForImposterizedObjectForInvocation:(NSInvocation *)invocation;
- (void)undoSideEffects;
@end
