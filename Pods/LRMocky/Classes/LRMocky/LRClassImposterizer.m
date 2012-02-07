//
//  LRClassImposterizer.m
//  Mocky
//
//  Created by Luke Redpath on 24/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRClassImposterizer.h"

@implementation LRClassImposterizer

- (id)initWithClass:(Class)klass;
{
  if (self = [super init]) {
    klassToImposterize = klass;
  }
  return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
  return [klassToImposterize instanceMethodSignatureForSelector:sel];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
  return [klassToImposterize instancesRespondToSelector:aSelector];
}

- (LRImposterizer *)matchingImposterizer;
{
  return [[[LRClassImposterizer alloc] initWithClass:klassToImposterize] autorelease];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"forClass:%@", NSStringFromClass(klassToImposterize)];
}

@end
