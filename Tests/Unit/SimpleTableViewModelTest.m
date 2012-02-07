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


SPEC_BEGIN(SimpleTableViewModelSpec)

describe(@"SimpleTableModel", ^{

  __block SimpleTableModel *model = nil;
  __block __strong LRMockery *mockery = [LRMockery mockeryForTestCase:self];
  
  beforeEach(^{
    model = [[SimpleTableModel alloc] initWithCellProvider:nil];
  });
  
  context(@"with a single object", ^{
    beforeEach(^{
      [model addObject:@"an example object"];
    });
    
    it(@"should have one section", ^{
      assertThatInt([model numberOfSections], equalToInt(1));
    });
    
    it(@"should have one row", ^{
      assertThatInt([model numberOfRowsInSection:0], equalToInt(1));
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
      assertThatInt([model numberOfRowsInSection:0], equalToInt(3));
    });
  });
  
  context(@"with an event listener", ^{
    __block id mockListener = [mockery mock:[LRMockEventListener class]];
    
    beforeEach(^{
      [model addTableModelListener:mockListener];
    });
    
    afterEach(^{
      [mockery assertSatisfied];
      [mockery reset];
    });
    
    it(@"notifies the listener of an insertion when the object is added", ^{
      [mockery checking:^(LRExpectationBuilder *expects) {
        [[expects oneOf:mockListener] tableModelChanged:insertEventAtRow(0)];
      }];
      
      [model addObject:@"an object"];
    });
    
    it(@"notifies the listener of an update when an existing object is replaced", ^{
      [mockery checking:^(LRExpectationBuilder *expects) {
        [[expects oneOf:mockListener] tableModelChanged:insertEventAtRow(0)];
        [[expects oneOf:mockListener] tableModelChanged:insertEventAtRow(1)];
      }];
      
      [model addObject:@"an object"];
      [model addObject:@"another object"];
      
      [mockery checking:^(LRExpectationBuilder *expects) {
        [[expects oneOf:mockListener] tableModelChanged:updateEventAtRow(1)];
      }];
      
      [model replaceObjectAtIndex:1 withObject:@"a different object"];
    });
    
    it(@"notifies the listener of a deletion when an existing object is removed", ^{
      [mockery checking:^(LRExpectationBuilder *expects) {
        [[expects oneOf:mockListener] tableModelChanged:insertEventAtRow(0)];
      }];
      
      [model addObject:@"an object"];
      
      [mockery checking:^(LRExpectationBuilder *expects) {
        [[expects oneOf:mockListener] tableModelChanged:deleteEventAtRow(0)];
      }];
      
      [model removeObject:@"an object"];
    });
    
    it(@"notifies the listener of a refresh when the whole data set is replaced", ^{
      [mockery checking:^(LRExpectationBuilder *expects) {
        [[expects oneOf:mockListener] tableModelChanged:refreshEvent()];
      }];
      
      [model setObjects:[NSArray arrayWithObjects:@"foo", @"bar", @"baz", nil]];
    });
    
    it(@"does not notify listener when it has been removed", ^{
      [mockery checking:^(LRExpectationBuilder *expects) {
        [[expects never:mockListener] tableModelChanged:insertEventAtRow(0)];
      }];
      
      [model removeTableModelListener:mockListener];      
      [model addObject:@"an object"];
    });
  });
  
});

SPEC_END
