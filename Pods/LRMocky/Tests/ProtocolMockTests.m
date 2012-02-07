//
//  ProtocolMockTests.m
//  Mocky
//
//  Created by Luke Redpath on 24/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"

@protocol SimpleProtocol
- (void)requiredMethod;
@optional
- (void)optionalMethod;
@end

@interface ProtocolMockTests : FunctionalMockeryTestCase
{
  id protocolImp;
}
@end

@implementation ProtocolMockTests

- (void)setUp
{
  [super setUp];
  protocolImp = [[context protocolMock:@protocol(SimpleProtocol)] retain];
}

- (void)testCanSetExpectationsOnRequiredMethods
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(protocolImp) requiredMethod];
  }];
  
  [protocolImp requiredMethod];

  assertContextSatisfied(context);
  assertThat(testCase, passed());
}

- (void)testCanSetExpectationsOnOptionalMethods
{
  [context checking:^(LRExpectationBuilder *builder){
    [oneOf(protocolImp) optionalMethod];
  }];
  
  [protocolImp optionalMethod];
  
  assertContextSatisfied(context);
  assertThat(testCase, passed());
}

@end