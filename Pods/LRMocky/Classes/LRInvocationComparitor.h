//
//  LRInvocationComparitor.h
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LRInvocationComparitor : NSObject {
  NSInvocation *expectedInvocation;
}
+ (id)comparitorForInvocation:(NSInvocation *)invocation;
- (id)initWithInvocation:(NSInvocation *)anInvocation;
- (BOOL)matchesParameters:(NSInvocation *)invocation;
@end
