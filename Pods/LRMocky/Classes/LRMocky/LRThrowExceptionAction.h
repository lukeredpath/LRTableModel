//
//  LRThrowExceptionAction.h
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectationAction.h"

@interface LRThrowExceptionAction : NSObject <LRExpectationAction> {
  NSException *exceptionToThrow;
}
- (id)initWithException:(NSException *)exception;
@end

LRThrowExceptionAction *LRA_throwException(NSException *exception);

#ifdef LRMOCKY_SHORTHAND
#define throwException LRA_throwException
#endif
