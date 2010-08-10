//
//  SimpleTableViewModelTest.m
//  TableViewModel
//
//  Created by Luke Redpath on 09/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "SimpleTableModel.h"
#import "LRTableModelEventListener.h"
#import "LRTableModelEvent.h"

// this is to work around lack of protocol mock support in mocky
@interface LRMockEventListener : NSObject <LRTableModelEventListener>
{} 
@end

@implementation LRMockEventListener
- (void)tableModelChanged:(LRTableModelEvent *)changeEvent {}
@end

id insertEventAtRow(int rowIndex) {
  return LRM_with(equalTo([LRTableModelEvent insertionAtRow:rowIndex]));
}

id anyEvent() {
  return LRM_with(instanceOf([LRTableModelEvent class]));
}

id updateEventAtRow(int rowIndex) {
  return LRM_with(equalTo([LRTableModelEvent updatedRow:rowIndex]));
}

id deleteEventAtRow(int rowIndex) {
  return LRM_with(equalTo([LRTableModelEvent deletedRow:rowIndex]));
}

id refreshEvent() {
  return LRM_with(equalTo([LRTableModelEvent refreshed]));
}

SPEC_BEGIN(SimpleTableViewModelSpec)

describe(@"SimpleTableModel", ^{

  __block SimpleTableModel *model = nil;
  __block LRMockery *context = [[LRMockery mockeryForTestCase:self] retain];
  
  beforeEach(^{
    model = [[SimpleTableModel alloc] init];
  });
  
  context(@"with a single object", ^{
    beforeEach(^{
      [model addObject:@"an example object"];
    });
    
    it(@"should have one section", ^{
      assertThatInt([model numberOfSections], equalToInt(1));
    });
    
    it(@"should have one row", ^{
      assertThatInt([model numberOfRows], equalToInt(1));
    });
    
    it(@"should return the single object for index path {0, 0}", ^{
      assertThat([model objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]], 
          equalTo(@"an example object"));
    });
  });
  
  context(@"with multiple objects", ^{
    beforeEach(^{
      [model setObjects:[NSArray arrayWithObjects:@"foo", @"bar", @"baz", nil]];
    });
    
    it(@"should have a row for each object", ^{
      assertThatInt([model numberOfRows], equalToInt(3));
    });
  });
  
  context(@"with an event listener", ^{
    __block id mockListener = [context mock:[LRMockEventListener class]];
    
    beforeEach(^{
      [model addTableModelListener:mockListener];
    });
    
    afterEach(^{
      [context assertSatisfied];
      [context reset];
    });
    
    it(@"notifies the listener of an insertion when the object is added", ^{
      [context checking:^(LRExpectationBuilder *expects) {
        [[expects oneOf:mockListener] tableModelChanged:insertEventAtRow(0)];
      }];
      
      [model addObject:@"an object"];
    });
    
    it(@"notifies the listener of an update when an existing object is replaced", ^{
      [context checking:^(LRExpectationBuilder *expects) {
        [[expects oneOf:mockListener] tableModelChanged:insertEventAtRow(0)];
        [[expects oneOf:mockListener] tableModelChanged:insertEventAtRow(1)];
      }];
      
      [model addObject:@"an object"];
      [model addObject:@"another object"];
      
      [context checking:^(LRExpectationBuilder *expects) {
        [[expects oneOf:mockListener] tableModelChanged:updateEventAtRow(1)];
      }];
      
      [model replaceObjectAtIndex:1 withObject:@"a different object"];
    });
    
    it(@"notifies the listener of a deletion when an existing object is removed", ^{
      [context checking:^(LRExpectationBuilder *expects) {
        [[expects oneOf:mockListener] tableModelChanged:insertEventAtRow(0)];
      }];
      
      [model addObject:@"an object"];
      
      [context checking:^(LRExpectationBuilder *expects) {
        [[expects oneOf:mockListener] tableModelChanged:deleteEventAtRow(0)];
      }];
      
      [model removeObject:@"an object"];
    });
    
    it(@"notifies the listener of a refresh when the whole data set is replaced", ^{
      [context checking:^(LRExpectationBuilder *expects) {
        [[expects oneOf:mockListener] tableModelChanged:refreshEvent()];
      }];
      
      [model setObjects:[NSArray arrayWithObjects:@"foo", @"bar", @"baz", nil]];
    });
    
    it(@"does not notify listener when it has been removed", ^{
      [context checking:^(LRExpectationBuilder *expects) {
        [[expects never:mockListener] tableModelChanged:insertEventAtRow(0)];
      }];
      
      [model removeTableModelListener:mockListener];      
      [model addObject:@"an object"];
    });
  });
  
});

SPEC_END
