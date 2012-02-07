//
//  LRProtocolImposterizer.m
//  Mocky
//
//  Created by Luke Redpath on 24/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRProtocolImposterizer.h"
#import <objc/runtime.h>

@implementation LRProtocolImposterizer

- (id)initWithProtocol:(Protocol *)protocol;
{
  if (self = [super init]) {
    protocolToImposterize = protocol;
  }
  return self;
}

struct objc_method_description methodDescriptionForProtocol(Protocol *protocol, SEL selector)
{
  // assume selector is a required method
  struct objc_method_description mdesc = protocol_getMethodDescription(protocol, selector, YES, YES);
  if (mdesc.types == NULL) { // maybe its an optional method
    mdesc =  protocol_getMethodDescription(protocol, selector, NO, YES);
  }  
  return mdesc;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
  struct objc_method_description mdesc = methodDescriptionForProtocol(protocolToImposterize, sel);
  NSMethodSignature *methodSignature = nil;
  if (mdesc.types != NULL) {
    methodSignature = [NSMethodSignature signatureWithObjCTypes:mdesc.types];
  }
  return methodSignature;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
  struct objc_method_description mdesc = methodDescriptionForProtocol(protocolToImposterize, aSelector);
  return mdesc.types != NULL;
}

- (LRImposterizer *)matchingImposterizer;
{
  return [[[LRProtocolImposterizer alloc] initWithProtocol:protocolToImposterize] autorelease];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"forProtocol:%@", NSStringFromProtocol(protocolToImposterize)];
}

@end
