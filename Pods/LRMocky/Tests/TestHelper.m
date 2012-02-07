//
//  TestHelper.m
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRExpectation.h"
#import "LRMockery.h"
#import "LRExpectationMessage.h"

@implementation NSInvocation (LRAdditions)

+ (NSInvocation *)invocationForSelector:(SEL)selector onClass:(Class)aClass;
{
  NSMethodSignature *signature = [aClass instanceMethodSignatureForSelector:selector];
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
  [invocation setSelector:selector];
  return invocation;
}

@end

@implementation FakeTestCase

@synthesize failures;

- (id)init
{
  if (self = [super init]) {
    failures = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc;
{
  [failures release];
  [super dealloc];
}

- (void)failWithException:(NSException *)exception
{
  [failures addObject:exception];
}

- (NSUInteger)numberOfFailures;
{
  return [failures count];
}

- (NSNumber *)numberOfFailuresAsNumber;
{
  return [NSNumber numberWithInt:[self numberOfFailures]];
}

- (NSString *)description;
{
  return [NSString stringWithFormat:@"MockTestCase with %d failures, %@", [self numberOfFailures], failures];
}

- (NSException *)lastFailure;
{
  return [failures lastObject];
}

@end

@implementation SimpleObject; 
+ (id)factoryMethod { return nil; };
- (void)doSomething {}
- (void)doSomethingElse {}
- (id)returnSomething { return nil; }
- (int)returnSomeValue { return 0; }
- (id)returnSomethingForValue:(NSString *)value { return nil; }
- (void)doSomethingWith:(id)object andObject:(id)another {}
- (void)doSomethingWithObject:(id)object {}
- (void)doSomethingWithInt:(NSInteger)anInt {}
- (void)doSomethingWithBool:(BOOL)aBool {}
- (void)doSomethingWithBlock:(void (^)())block {}
- (void)doSomethingWithBlockThatYields:(void (^)(id object))block {}
@end

#pragma mark Custom assertions and matchers

id<HCMatcher> isExceptionOfType(id<HCMatcher>nameMatcher)
{
  NSInvocation *nameInvocation = [HCInvocationMatcher createInvocationForSelector:@selector(name) onClass:[NSException class]];
  
  return [[[HCInvocationMatcher alloc] initWithInvocation:nameInvocation matching:nameMatcher] autorelease];
}

id<HCMatcher> exceptionWithDescription(id<HCMatcher> descriptionMatcher)
{
  NSInvocation *descInvocation = [HCInvocationMatcher 
    createInvocationForSelector:@selector(description) onClass:[NSException class]];

  return [[[HCInvocationMatcher alloc] initWithInvocation:descInvocation matching:descriptionMatcher] autorelease];
}

id<HCMatcher> isExceptionOfTypeWithDescription(id<HCMatcher>nameMatcher, id<HCMatcher>descMatcher)
{
  return allOf(isExceptionOfType(nameMatcher), exceptionWithDescription(descMatcher), nil);
}

id<HCMatcher> passed()
{
  id<HCMatcher> valueMatcher = [HCIsEqual isEqualTo:[NSNumber numberWithInt:0]];
  NSInvocation *invocation   = [HCInvocationMatcher createInvocationForSelector:@selector(numberOfFailuresAsNumber) onClass:[FakeTestCase class]];
  return [[[HCInvocationMatcher alloc] initWithInvocation:invocation matching:valueMatcher] autorelease];
}

id<HCMatcher> failedWithNumberOfFailures(int numberOfFailures)
{
  id<HCMatcher> valueMatcher = [HCIsEqual isEqualTo:[NSNumber numberWithInt:numberOfFailures]];
  NSInvocation *invocation   = [HCInvocationMatcher createInvocationForSelector:@selector(numberOfFailuresAsNumber) onClass:[FakeTestCase class]];
  return [[[HCInvocationMatcher alloc] initWithInvocation:invocation matching:valueMatcher] autorelease];
}

id<HCMatcher> failedWithExpectationError(NSString *errorDescription)
{
  NSInvocation *invocation   = [HCInvocationMatcher createInvocationForSelector:@selector(failures) onClass:[FakeTestCase class]];
  return [[[HCInvocationMatcher alloc] initWithInvocation:invocation matching:hasItem(exceptionWithDescription(containsString(errorDescription)))] autorelease];
}

void LR_assertNothingRaisedWithLocation(void (^block)(void), SenTestCase *testCase, NSString *fileName, int lineNumber)
{
  @try {
    
    passed();
  }
  @catch (NSException * e) {
    NSException *exception = [NSException failureInFile:fileName atLine:lineNumber withDescription:
     [NSString stringWithFormat:@"Expected block not to raise, but raised '%@'", [e description]]];
    [testCase failWithException:exception];
  }
}

@implementation NSInvocation (BetterDescription)
- (NSString *)description
{
  return [NSString stringWithFormat:@"NSInvocation for:@selector(%@)", NSStringFromSelector([self selector])];
}
@end

#pragma mark - Failed mocking checks (for examples)

@interface LRMockery (TestingAdditions)
- (void)assertNotSatisfiedInFile:(NSString *)fileName lineNumber:(int)lineNumber;
@end

@implementation LRMockery (TestingAdditions)

- (void)assertNotSatisfiedInFile:(NSString *)fileName lineNumber:(int)lineNumber
{
  NSMutableArray *passedExpectations = [NSMutableArray array];
  
  for (id<LRExpectation> expectation in expectations) {
    if ([expectation isSatisfied] == YES) {
      LRExpectationMessage *message = [[LRExpectationMessage alloc] init];
      [expectation describeTo:message];
      [passedExpectations addObject:message];
      [message release];
    }
  }
  if (passedExpectations.count > 0) {
    NSString *failureMessage = [NSString stringWithFormat:@"Expected context to fail, but the following expectations passed: %@", passedExpectations];
    [testNotifier notifiesFailureWithDescription:failureMessage inFile:fileName lineNumber:lineNumber];
  }
}

@end

void LRM_assertContextNotSatisfied(LRMockery *context, NSString *fileName, int lineNumber)
{
  [context assertNotSatisfiedInFile:fileName lineNumber:lineNumber];
}

void *anyBlock()
{
  return anything();
}
