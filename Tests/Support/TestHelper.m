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

@implementation LRMockEventListener
- (void)tableModelChanged:(LRTableModelEvent *)changeEvent {}
@end

id insertEventAtRow(int rowIndex) {
  return LRM_with(equalTo([LRTableModelEvent insertionAtRow:rowIndex section:0]));
}

id anyEvent() {
  return LRM_with(instanceOf([LRTableModelEvent class]));
}

id updateEventAtRow(int rowIndex) {
  return LRM_with(equalTo([LRTableModelEvent updatedRow:rowIndex section:0]));
}

id deleteEventAtRow(int rowIndex) {
  return LRM_with(equalTo([LRTableModelEvent deletedRow:rowIndex section:0]));
}

id refreshEvent() {
  return LRM_with(equalTo([LRTableModelEvent refreshedData]));
}

