//
//  LRImposter.m
//  Mocky
//
//  Created by Luke Redpath on 22/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRImposter.h"

@implementation LRImposter

@synthesize imposterizer;

- (id)initWithImposterizer:(LRImposterizer *)anImposterizer;
{
  if (self = [super init]) {
    imposterizer = [anImposterizer retain];
    imposterizer.delegate = self;
  }
  return self;
}

- (void)dealloc
{
  [imposterizer release];
  [super dealloc];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
  return [imposterizer methodSignatureForSelector:sel];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
  if (aSelector == @selector(handleImposterizedInvocation:)) {
    return YES;
  }
  return [imposterizer respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
  return imposterizer;
}

- (void)setImposterizer:(LRImposterizer *)newImposterizer;
{
  [imposterizer release];
  imposterizer = [newImposterizer retain];
  imposterizer.delegate = self;
}

- (BOOL)shouldActAsImposterForInvocation:(NSInvocation *)invocation
{
  return YES;
}

- (void)handleImposterizedInvocation:(NSInvocation *)invocation;
{
  NSLog(@"Imposter sub-class did not handle invocation %@ did you forget to override handleImposterizedInvocation:?", invocation);
}

@end
