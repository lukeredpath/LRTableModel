//
//  LRExpectationMessage.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "LRExpectationMessage.h"


@implementation LRExpectationMessage

@dynamic message;

- (id)init {
  if ((self = [super init])) {
    message = [[NSMutableString alloc] init];
  }
  return self;
}

- (void)append:(NSString *)string;
{
  [message appendString:string];
}

- (NSString *)message
{
  return [[message copy] autorelease];
}

- (NSString *)description;
{
  return [self message];
}

@end
