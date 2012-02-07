//
//  FunctionalMockeryTestCase.h
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#define LRMOCKY_SHORTHAND
#define LRMOCKY_SUGAR

#import "TestHelper.h"
#import "LRMocky.h"

@class FakeTestCase;
@class SimpleObject;

@interface FunctionalMockeryTestCase : SenTestCase {
  LRMockery *context;
  FakeTestCase *testCase;
  SimpleObject *testObject;
}
@end
