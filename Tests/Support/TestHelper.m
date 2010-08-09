//
//  AardvarkTest.m
//  TableViewModel
//
//  Created by Luke Redpath on 09/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"

SPEC_BEGIN(DemoSpec)

describe(@"A simple test", ^{
  
  LRMockery *context = [[LRMockery mockeryForTestCase:self] retain];
  
  afterEach(^{
    [context assertSatisfied];
  });
  
  it(@"should work", ^{
    [[@"foo" should] equal:@"foo"];
  });
  
  it(@"should integrate with Mocky", ^{
    id mockObject = [context mock:[NSString class]];
    
    [context checking:^(LRExpectationBuilder *expects) {
      [[expects oneOf:mockObject] uppercaseString];
    }]; 
    
    [mockObject uppercaseString];
  });
  
});

SPEC_END
