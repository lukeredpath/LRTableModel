//
//  NSInvocation+LRAdditions.m
//  Mocky
//
//  Created by Luke Redpath on 30/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "NSInvocation+LRAdditions.h"
#import "NSInvocation+OCMAdditions.h"

@implementation NSInvocation (LRAdditions)

- (void)copyBlockArguments;
{
  for (int i = 2; i < [[self methodSignature] numberOfArguments]; i++) {
    if ([[self argumentDescriptionAtIndex:i] rangeOfString:@"Block"].location != NSNotFound) {
      void *arg;
      [self getArgument:&arg atIndex:i];
      void (^block)() = (void (^)())arg;
      [block copy];
    }
  } 
}

- (void)releaseBlockArguments;
{
  for (int i = 2; i < [[self methodSignature] numberOfArguments]; i++) {
    if ([[self argumentDescriptionAtIndex:i] rangeOfString:@"Block"].location != NSNotFound) {
      void *arg;
      [self getArgument:&arg atIndex:i];
      void (^block)() = (void (^)())arg;
      [block release];
    }
  } 
}

@end
