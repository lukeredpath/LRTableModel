//
//  LRThrowExceptionAction.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRThrowExceptionAction.h"


@implementation LRThrowExceptionAction

- (id)initWithException:(NSException *)exception;
{
  if (self = [super init]) {
    exceptionToThrow = [exception retain];
  }
  return self;
}

- (void)dealloc 
{
  [exceptionToThrow release];
  [super dealloc];
}

- (void)invoke:(NSInvocation *)invocation
{
  [exceptionToThrow raise];
}

@end

LRThrowExceptionAction *LRA_throwException(NSException *exception)
{
  return [[[LRThrowExceptionAction alloc] initWithException:exception] autorelease];
}
