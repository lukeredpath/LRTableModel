//
//  LRExpectationAction.h
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LRExpectationAction
- (void)invoke:(NSInvocation *)invocation;
@end
