//
//  NSInvocation+LRAdditions.h
//  Mocky
//
//  Created by Luke Redpath on 30/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSInvocation (LRAdditions)
- (void)copyBlockArguments;
- (void)releaseBlockArguments;
@end
