//
//  LRClassImposterizerTest.m
//  Mocky
//
//  Created by Luke Redpath on 24/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#define LRMOCKY_SUGAR
#define LRMOCKY_SHORTHAND
#import "LRMocky.h"
#import "HCBlockMatcher.h"
#import "LRClassImposterizer.h"
#import "LRObjectImposterizer.h"
#import "LRProtocolImposterizer.h"

@interface MyTestClass : NSObject
@property (nonatomic, assign) BOOL receivedInstanceMethodCall;

- (void)anInstanceMethod;
+ (void)aClassMethod;
@end

@implementation MyTestClass
@synthesize receivedInstanceMethodCall;

- (void)anInstanceMethod {
  self.receivedInstanceMethodCall = YES;
}
+ (void)aClassMethod {}
@end

id invocationForSelector(SEL selector)
{
  return satisfiesBlock([NSString stringWithFormat:@"an invocation for @selector(%@)", NSStringFromSelector(selector)], ^(id actual) {
    return (BOOL)([(NSInvocation *)actual selector] == selector);
  });
}

#pragma mark -

@interface ClassImposterizerTest : SenTestCase <LRImposterizerDelegate>
{
  LRMockery *context;
  LRClassImposterizer *imposterizer;
  id mockDelegate;
  NSInvocation *handledInvocation;
}
@end

@implementation ClassImposterizerTest

- (void)setUp
{
  context = [[LRMockery mockeryForTestCase:self] retain];
  imposterizer = [[LRClassImposterizer alloc] initWithClass:[MyTestClass class]];
  imposterizer.delegate = self;
}

- (void)testShouldReportRespondsToInstanceMethods
{
  assertTrue([imposterizer respondsToSelector:@selector(anInstanceMethod)]);
}

- (void)testForwardMethodCallsToItsDelegate
{
  [imposterizer performSelector:@selector(anInstanceMethod)];
  assertThat(handledInvocation, is(invocationForSelector(@selector(anInstanceMethod))));
}

- (BOOL)shouldActAsImposterForInvocation:(NSInvocation *)invocation
{
  return YES;
}

- (void)handleImposterizedInvocation:(NSInvocation *)invocation
{
  handledInvocation = [invocation retain];
}

@end

#pragma mark -

@interface ObjectImposterizerTest : SenTestCase <LRImposterizerDelegate>
{
  LRMockery *context;
  LRObjectImposterizer *imposterizer;
  id objectToImposterize;
  id mockDelegate;
  NSInvocation *handledInvocation;
  BOOL shouldHandleInvocation;
}
@end

@implementation ObjectImposterizerTest

- (void)setUp
{
  context = [[LRMockery mockeryForTestCase:self] retain];
  objectToImposterize = [[MyTestClass alloc] init];
  imposterizer = [[LRObjectImposterizer alloc] initWithObject:objectToImposterize];
  imposterizer.delegate = self;
}

- (void)testShouldReportRespondsToInstanceMethods
{
  assertTrue([imposterizer respondsToSelector:@selector(anInstanceMethod)]);
}

- (void)testForwardMethodCallsToItsDelegateWhenDelegateWantsToHandleInvocation
{
  shouldHandleInvocation = YES;
  [imposterizer performSelector:@selector(anInstanceMethod)];
  assertThat(handledInvocation, is(invocationForSelector(@selector(anInstanceMethod))));
  assertThatBool([objectToImposterize receivedInstanceMethodCall], is(equalToBool(NO)));
}

- (void)testForwardMethodCallsToItsTheOriginalObjectWhenDelegateDoesNotWantsToHandleInvocation
{
  shouldHandleInvocation = NO;
  [imposterizer performSelector:@selector(anInstanceMethod)];
  assertThat(handledInvocation, is(nilValue()));
  assertThatBool([objectToImposterize receivedInstanceMethodCall], is(equalToBool(YES)));
}

- (void)testItCanEnsureDirectMessagesToTheImposterizedObjectAreRoutedThroughTheImposterizer
{
  shouldHandleInvocation = YES;
  NSInvocation *invocation = [NSInvocation invocationForSelector:@selector(anInstanceMethod) onClass:[objectToImposterize class]];
  [imposterizer setupInvocationHandlerForImposterizedObjectForInvocation:invocation];
  [objectToImposterize anInstanceMethod];
  assertThat(handledInvocation, is(invocationForSelector(@selector(anInstanceMethod))));
  assertThatBool([objectToImposterize receivedInstanceMethodCall], is(equalToBool(NO)));
}

- (BOOL)shouldActAsImposterForInvocation:(NSInvocation *)invocation
{
  return shouldHandleInvocation;
}

- (void)handleImposterizedInvocation:(NSInvocation *)invocation
{
  handledInvocation = [invocation retain];
}

@end

#pragma mark -

@protocol TestProtocol
- (void)someRequiredMethod;
@optional
- (void)someOptionalMethod;
@end

@interface ProtocolImposterizerTest : SenTestCase <LRImposterizerDelegate>
{
  LRMockery *context;
  LRProtocolImposterizer *imposterizer;
  id mockDelegate;
  NSInvocation *handledInvocation;
}
@end

@implementation ProtocolImposterizerTest

- (void)setUp
{
  context = [[LRMockery mockeryForTestCase:self] retain];
  imposterizer = [[LRProtocolImposterizer alloc] initWithProtocol:@protocol(TestProtocol)];
  imposterizer.delegate = self;
}

- (void)testShouldReportRespondsToRequiredMethods
{
  assertTrue([imposterizer respondsToSelector:@selector(someRequiredMethod)]);
}

- (void)testShouldReportRespondsToOptionalMethods
{
  assertTrue([imposterizer respondsToSelector:@selector(someOptionalMethod)]);
}

- (void)testForwardsRequiredMethodCallsToItsDelegate
{
  [imposterizer performSelector:@selector(someRequiredMethod)];
  assertThat(handledInvocation, is(invocationForSelector(@selector(someRequiredMethod))));
}

- (void)testForwardsOptionalMethodCallsToItsDelegate
{
  [imposterizer performSelector:@selector(someOptionalMethod)];
  assertThat(handledInvocation, is(invocationForSelector(@selector(someOptionalMethod))));
}

- (BOOL)shouldActAsImposterForInvocation:(NSInvocation *)invocation
{
  return YES;
}

- (void)handleImposterizedInvocation:(NSInvocation *)invocation
{
  handledInvocation = [invocation retain];
}

@end
