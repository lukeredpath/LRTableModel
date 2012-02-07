//
//  TestHelper.h
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND
#import "OCHamcrest.h"
#import "LRTestCase.h"

@interface NSInvocation (LRAdditions)
+ (NSInvocation *)invocationForSelector:(SEL)selector onClass:(Class)aClass;
@end

@interface FakeTestCase : NSObject
{
  NSMutableArray *failures;
}
@property (nonatomic, readonly) NSArray *failures;
- (NSUInteger)numberOfFailures;
- (NSException *)lastFailure;
@end

@interface SimpleObject : NSObject
{}
+ (id)factoryMethod;
- (void)doSomething;
- (void)doSomethingElse;
- (id)returnSomething;
- (int)returnSomeValue;
- (id)returnSomethingForValue:(NSString *)value;
- (void)doSomethingWith:(id)object andObject:(id)another;
- (void)doSomethingWithObject:(id)object;
- (void)doSomethingWithInt:(NSInteger)anInt;
- (void)doSomethingWithBool:(BOOL)aBool;
- (void)doSomethingWithBlock:(void (^)())block;
- (void)doSomethingWithBlockThatYields:(void (^)(id object))block;
@end

@protocol LRTestCase;

id<HCMatcher> passed();
id<HCMatcher> failedWithNumberOfFailures(int numberOfFailures);
id<HCMatcher> failedWithExpectationError(NSString *errorDescription);

#define assertTrue(expression) assertThatBool(expression, equalToBool(YES))
#define assertFalse(expression) assertThatBool(expression, equalToBool(NO))

@class LRMockery;

void LR_assertNothingRaisedWithLocation(void (^block)(void), SenTestCase *testCase, NSString *fileName, int lineNumber);
#define assertNothingRaised(block) LR_assertNothingRaisedWithLocation(block, self, [NSString stringWithUTF8String:__FILE__], __LINE__)

void LRM_assertContextNotSatisfied(LRMockery *context, NSString *fileName, int lineNumber);
#define assertContextNotSatisfied(context) LRM_assertContextNotSatisfied(context, [NSString stringWithUTF8String:__FILE__], __LINE__)

void *anyBlock();

