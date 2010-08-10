//
//  SimpleTableViewModel.m
//  TableViewModel
//
//  Created by Luke Redpath on 09/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "SimpleTableModel.h"
#import "LRTableModelEvent.h"

@interface SimpleTableModel ()
- (void)notifyListeners:(LRTableModelEvent *)event;
@end

@implementation SimpleTableModel

- (id)init
{
  if (self = [super init]) {
    objects = [[NSMutableArray alloc] init];
    eventListeners = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [eventListeners release];
  [objects release];
  [super dealloc];
}

- (void)addObject:(id)anObject;
{
  [objects addObject:anObject];
  
  NSInteger indexOfNewObject = [objects indexOfObject:anObject];
  [self notifyListeners:[LRTableModelEvent insertionAtRow:indexOfNewObject]];
}

- (void)removeObject:(id)anObject;
{
  NSInteger indexOfObject = [objects indexOfObject:anObject];
  
  [objects removeObject:anObject];
  [self notifyListeners:[LRTableModelEvent deletedRow:indexOfObject]];
}

- (void)replaceObjectAtIndex:(NSInteger)index withObject:(id)anObject;
{
  [objects replaceObjectAtIndex:index withObject:anObject];
  [self notifyListeners:[LRTableModelEvent updatedRow:index]];
}

- (NSInteger)numberOfSections;
{
  return 1;
}

- (NSInteger)numberOfRows;
{
  return 1; 
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
{
  return [objects objectAtIndex:indexPath.row];
}

- (void)addTableModelListener:(id<LRTableModelEventListener>)listener;
{
  [eventListeners addObject:listener];
}

- (void)removeTableModelListener:(id<LRTableModelEventListener>)listener;
{
  [eventListeners removeObject:listener];
}

- (void)notifyListeners:(LRTableModelEvent *)event;
{
  for (id<LRTableModelEventListener> listener in eventListeners) {
    [listener tableModelChanged:event];
  }
}

@end
