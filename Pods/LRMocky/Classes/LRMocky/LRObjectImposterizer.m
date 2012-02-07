//
//  LRObjectImposterizer.m
//  Mocky
//
//  Created by Luke Redpath on 24/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRObjectImposterizer.h"
#import <objc/runtime.h>

#define kOBJECT_IMPOSTERIZER_ASSOCIATION_KEY "_mockyCurrentImposterizer"

@interface LRObjectImposterizer ()
- (void)removeInvocationHandlerForImposterizedClass;
@end

@implementation LRObjectImposterizer

- (id)initWithObject:(id)object;
{
  if (self = [super init]) {
    objectToImposterize = [object retain];
  }
  return self;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
  if ([self.delegate shouldActAsImposterForInvocation:anInvocation]) {
    [self.delegate handleImposterizedInvocation:anInvocation];
  }
  else {
    [anInvocation invokeWithTarget:objectToImposterize];
  }
}

- (void)dealloc
{
  [imposterizedInvocation release];
  [objectToImposterize release];
  [super dealloc];
}

- (void)undoSideEffects
{
  [self removeInvocationHandlerForImposterizedClass];
  objc_setAssociatedObject(objectToImposterize, kOBJECT_IMPOSTERIZER_ASSOCIATION_KEY, nil, OBJC_ASSOCIATION_ASSIGN); 
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
  return [objectToImposterize methodSignatureForSelector:sel];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
  if ([super respondsToSelector:aSelector]) {
    return YES;
  }
  return [objectToImposterize respondsToSelector:aSelector];
}

- (LRImposterizer *)matchingImposterizer;
{
  return [[[LRObjectImposterizer alloc] initWithObject:objectToImposterize] autorelease];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"forObject:%@", objectToImposterize];
}

- (void)setupInvocationHandlerForImposterizedClassForInvocation:(NSInvocation *)invocation
{
  Class metaclass = object_getClass(objectToImposterize);
  
  imposterizedInvocation = [invocation retain];
  
  // configure it's forwardInvocation: method to delegate to the imposterizer
	Method forwardInvocationMethod = class_getInstanceMethod([self class], @selector(forwardInvocationForRealObject:));
	IMP forwardInvocationImp = method_getImplementation(forwardInvocationMethod);
	const char *forwardInvocationTypes = method_getTypeEncoding(forwardInvocationMethod);
	class_addMethod(metaclass, @selector(forwardInvocation:), forwardInvocationImp, forwardInvocationTypes);
  
  // ensure that calls to the stubbed selector are handled by forwardInvocation:
	originalClassMethod = class_getInstanceMethod(metaclass, invocation.selector);
	IMP forwarderImp = [metaclass instanceMethodForSelector:@selector(__MOCKY_SELECTOR_THAT_WILL_NOT_EXIST)];
  class_replaceMethod(metaclass, invocation.selector, forwarderImp, method_getTypeEncoding(originalClassMethod));
  
  // finally, we need a way to get the imposterizer from the imposterized object
  objc_setAssociatedObject(objectToImposterize, kOBJECT_IMPOSTERIZER_ASSOCIATION_KEY, self, OBJC_ASSOCIATION_ASSIGN);
}

- (void)removeInvocationHandlerForImposterizedClass
{
  Class metaclass = object_getClass(objectToImposterize);
  class_replaceMethod(metaclass, imposterizedInvocation.selector, 
    method_getImplementation(originalClassMethod), method_getTypeEncoding(originalClassMethod));
}

/* swap the class of the imposterized object to a dynamic subclass that forwards stubbed invocations
    back to the imposterizer. This technique is borrowed entirely from OCMock */

- (void)setupInvocationHandlerForImposterizedObjectForInvocation:(NSInvocation *)invocation
{  
  if (class_isMetaClass(object_getClass(objectToImposterize))) { // it's a class!
    return [self setupInvocationHandlerForImposterizedClassForInvocation:invocation];
  }
  
  // create a subclass of the imposterized object
  Class realClass = [objectToImposterize class];
	double timestamp = [NSDate timeIntervalSinceReferenceDate];
	const char *className = [[NSString stringWithFormat:@"%@-Imposterizer-%p-%f", realClass, objectToImposterize, timestamp] cString]; 
	Class subclass = objc_allocateClassPair(realClass, className, 0);
	objc_registerClassPair(subclass);
	object_setClass(objectToImposterize, subclass);
  
  // configure it's forwardInvocation: method to delegate to the imposterizer
	Method forwardInvocationMethod = class_getInstanceMethod([self class], @selector(forwardInvocationForRealObject:));
	IMP forwardInvocationImp = method_getImplementation(forwardInvocationMethod);
	const char *forwardInvocationTypes = method_getTypeEncoding(forwardInvocationMethod);
	class_addMethod(subclass, @selector(forwardInvocation:), forwardInvocationImp, forwardInvocationTypes);
  
  // ensure that calls to the stubbed selector are handled by forwardInvocation:
  Class dynamicSubclass = [objectToImposterize class]; 
	Method originalMethod = class_getInstanceMethod(dynamicSubclass, invocation.selector);
	IMP forwarderImp = [subclass instanceMethodForSelector:@selector(__MOCKY_SELECTOR_THAT_WILL_NOT_EXIST)];
	class_addMethod(dynamicSubclass, method_getName(originalMethod), forwarderImp, method_getTypeEncoding(originalMethod)); 
  
  // finally, we need a way to get the imposterizer from the imposterized object
  objc_setAssociatedObject(objectToImposterize, kOBJECT_IMPOSTERIZER_ASSOCIATION_KEY, self, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation LRObjectImposterizer (RealObjectHandler)

- (void)forwardInvocationForRealObject:(NSInvocation *)anInvocation
{
  // self is the imposterized object, not the imposterizer
  LRObjectImposterizer *imposterizer = objc_getAssociatedObject(self, kOBJECT_IMPOSTERIZER_ASSOCIATION_KEY);
  
  if (imposterizer) {
    [imposterizer forwardInvocation:anInvocation];
  }
}

@end
