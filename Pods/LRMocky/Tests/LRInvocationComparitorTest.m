//
//  LRInvocationComparitorTest.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRInvocationComparitor.h"
#import "LRImposter.h"
#import "LRClassImposterizer.h"
#define LRMOCKY_SHORTHAND

@interface InvocationTesterObject : NSObject
- (id)takesAnObject:(id)object;
- (id)takesAnInt:(int)anInt;
@end

@implementation InvocationTesterObject

- (id)takesAnObject:(id)object { return nil; }
- (id)takesAnInt:(int)anInt { return nil; }
- (id)takesAFloat:(float)aFloat { return nil; }

@end

@interface InvocationCapturer : LRImposter
{
  NSInvocation *lastInvocation;
}
@property (nonatomic, readonly) NSInvocation *invocation;
@end

@implementation InvocationCapturer

@synthesize invocation = lastInvocation;

- (id)init
{
  LRImposterizer *theImposterizer = [[[LRClassImposterizer alloc] initWithClass:[InvocationTesterObject class]] autorelease];
  return [super initWithImposterizer:theImposterizer];
}

- (void)handleImposterizedInvocation:(NSInvocation *)invocation
{
  [lastInvocation release];
  [invocation retainArguments];
  [invocation setReturnValue:&self];
  lastInvocation = [invocation retain];
}

@end

@interface LRInvocationComparitorTest : SenTestCase
{
  InvocationTesterObject *testObject;
  id capture;
}
@end

@implementation LRInvocationComparitorTest

- (void)setUp;
{
  testObject = [[InvocationTesterObject alloc] init];
  capture = [[InvocationCapturer alloc] init];
}

- (void)testSanity
{
  assertThat([[capture takesAnObject:@"bar"] invocation], isNot(nilValue()));
  assertThat([[capture takesAnObject:@"bar"] invocation], isNot(equalTo([[capture takesAnObject:@"foo"] invocation])));
}

- (void)testCanCompareObjectMethodParameters
{
  NSInvocation *expected = [[capture takesAnObject:@"foo"] invocation];
  LRInvocationComparitor *comparitor = [LRInvocationComparitor comparitorForInvocation:expected];
  
  assertTrue([comparitor matchesParameters:[[capture takesAnObject:@"foo"] invocation]]);
  assertFalse([comparitor matchesParameters:[[capture takesAnObject:@"bar"] invocation]]);
}

- (void)testCanCompareIntegerParameters
{
  NSInvocation *expected = [[capture takesAnInt:10] invocation];
  LRInvocationComparitor *comparitor = [LRInvocationComparitor comparitorForInvocation:expected];
  
  assertTrue([comparitor matchesParameters:[[capture takesAnInt:10] invocation]]);
  assertFalse([comparitor matchesParameters:[[capture takesAnInt:20] invocation]]);
}

- (void)testCanCompareFloatParameters
{
  NSInvocation *expected = [[capture takesAFloat:3.14] invocation];
  LRInvocationComparitor *comparitor = [LRInvocationComparitor comparitorForInvocation:expected];
  
  assertTrue([comparitor matchesParameters:[[capture takesAFloat:3.14] invocation]]);
  assertFalse([comparitor matchesParameters:[[capture takesAFloat:10.45] invocation]]);
}

- (void)testCanCompareParametersThatUseObjectMatchers
{
  NSInvocation *expected = [[capture takesAnObject:hasItem(@"foo")] invocation];
  LRInvocationComparitor *comparitor = [LRInvocationComparitor comparitorForInvocation:expected];
  
  assertTrue([comparitor matchesParameters:[[capture takesAnObject:[NSArray arrayWithObject:@"foo"]] invocation]]);
  assertFalse([comparitor matchesParameters:[[capture takesAnObject:[NSArray arrayWithObject:@"bar"]] invocation]]);
}

@end
