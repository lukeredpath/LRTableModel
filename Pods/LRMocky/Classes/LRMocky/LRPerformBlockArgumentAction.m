//
//  LRPerformBlockArgumentAction.m
//  Mocky
//
//  Created by Luke Redpath on 30/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRPerformBlockArgumentAction.h"
#import "NSInvocation+OCMAdditions.h"

@implementation LRPerformBlockArgumentAction

- (id)initWithObject:(id)anObject;
{
  if (self = [super init]) {
    object = [anObject retain];
  }
  return self;
}

- (void)dealloc
{
  [object release];
  [super dealloc];
}

- (void)invoke:(NSInvocation *)invocation
{
  for (int i = 2; i < [[invocation methodSignature] numberOfArguments]; i++) {
    if ([[invocation argumentDescriptionAtIndex:i] rangeOfString:@"Block"].location != NSNotFound) {
      void *arg;
      [invocation getArgument:&arg atIndex:i];
      if (object) {
        void (^block)(id o) = (void (^)(id o))arg;
        block(object);
      } else {
        void (^block)() = (void (^)())arg;
        block();
      }
    }
  } 
}

@end

LRPerformBlockArgumentAction *LRA_performBlockArguments()
{
  return [[[LRPerformBlockArgumentAction alloc] init] autorelease]; 
}

LRPerformBlockArgumentAction *LRA_performBlockArgumentsWithObject(id object)
{
  return [[[LRPerformBlockArgumentAction alloc] initWithObject:object] autorelease]; 
}
