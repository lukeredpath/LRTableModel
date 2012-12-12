//
//  SimpleTableViewModel.m
//  TableViewModel
//
//  Created by Luke Redpath on 09/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "SortableTableModel.h"
#import "LRTableModelEvent.h"

@interface SortableTableModel ()
- (NSArray *)sortedObjects;
@end

@implementation SortableTableModel {
  NSMutableArray *_mutableObjects;
  NSArray *_sortedObjects;
}

- (NSArray *)objects
{
  return [_mutableObjects copy];
}

- (NSArray *)sortedObjects
{
  if (self.sortDescriptors.count == 0) {
    return self.objects;
  }
  if (_sortedObjects == nil) {
    _sortedObjects = [self.objects sortedArrayUsingDescriptors:self.sortDescriptors];
  }

  return _sortedObjects;
}

- (void)setSortDescriptors:(NSArray *)sortDescriptors
{
  [self performUpdatesWithBlock:^{
    _sortedObjects = nil;
    _sortDescriptors = [sortDescriptors copy];
    
    // changing the sort descriptors always triggers a refresh
    [self notifyListeners:[LRTableModelEvent refreshedData]];
  }];
}

- (void)addObject:(id)anObject;
{
  [self performUpdatesWithBlock:^{
    _sortedObjects = nil;
    
    [_mutableObjects addObject:anObject];
    
    NSInteger indexOfNewObject = [_mutableObjects indexOfObject:anObject];
    [self notifyListeners:[LRTableModelEvent insertionAtRow:indexOfNewObject section:0]];
  }];
}

- (void)removeObject:(id)anObject;
{
  [self performUpdatesWithBlock:^{
    NSInteger indexOfObject = [_mutableObjects indexOfObject:anObject];
    
    _sortedObjects = nil;
    
    [_mutableObjects removeObject:anObject];
    [self notifyListeners:[LRTableModelEvent deletedRow:indexOfObject section:0]];
  }];
}

- (void)replaceObjectAtIndex:(NSInteger)index withObject:(id)anObject;
{
  [self performUpdatesWithBlock:^{
    _sortedObjects = nil;
    
    [_mutableObjects replaceObjectAtIndex:index withObject:anObject];
    [self notifyListeners:[LRTableModelEvent updatedRow:index section:0]];
  }];
}

- (void)setObjects:(NSArray *)newObjects;
{
  [self performUpdatesWithBlock:^{
    _sortedObjects = nil;
    
    [_mutableObjects setArray:newObjects];
    [self notifyListeners:[LRTableModelEvent refreshedData]];
  }];
}

- (void)insertObject:(id)anObject atIndex:(NSInteger)index;
{
  [self performUpdatesWithBlock:^{
    _sortedObjects = nil;
    
    [_mutableObjects insertObject:anObject atIndex:index];
    [self notifyListeners:[LRTableModelEvent insertionAtRow:index section:0]];
  }];
}

#pragma mark - LRTableModel overrides

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
{
  return [[self sortedObjects] objectAtIndex:indexPath.row];
}

@end
