//
//  LRDescribable.h
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LRExpectationMessage;

@protocol LRDescribable <NSObject>

- (void)describeTo:(LRExpectationMessage *)message;

@end
