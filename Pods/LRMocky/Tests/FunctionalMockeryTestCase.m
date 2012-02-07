//
//  FunctionalMockeryTestCase.m
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import "FunctionalMockeryTestCase.h"
#import "TestHelper.h"
#import "LRMocky.h"

@implementation FunctionalMockeryTestCase

- (void)setUp;
{
  [super setUp];
  testCase = [FakeTestCase new];
  context = [[LRMockery mockeryForTestCase:testCase] retain];
  testObject = [[context mock:[SimpleObject class]] retain];
}

@end
