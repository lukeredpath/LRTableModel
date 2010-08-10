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
- (NSArray *)sortedObjects;
@end

@implementation SimpleTableModel

@synthesize sortOrder;

- (id)initWithCellProvider:(id<LRTableModelCellProvider>)theCellProvider;
{
  if (self = [super initWithCellProvider:theCellProvider]) {
    objects = [[NSMutableArray alloc] init];
    sortOrder = SortOrderUnordered;
  }
  return self;
}

- (void)dealloc
{
  [objects release];
  [super dealloc];
}

- (NSArray *)sortedObjects
{
  if (sortOrder == SortOrderUnordered) {
    return objects;
  }
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:(sortOrder == SortOrderAscending)];
  return [objects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

- (void)setSortOrder:(SortOrder)newSortOrder
{
  sortOrder = newSortOrder;
  [self notifyListeners:[LRTableModelEvent refreshed]];
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

- (void)setObjects:(NSArray *)newObjects;
{
  [objects removeAllObjects];
  [objects setArray:newObjects];
  [self notifyListeners:[LRTableModelEvent refreshed]];
}

- (void)insertObject:(id)anObject atIndex:(NSInteger)index;
{
  [objects insertObject:anObject atIndex:index];
  [self notifyListeners:[LRTableModelEvent insertionAtRow:index]];
}

#pragma mark -
#pragma mark LRTableModel methods

- (NSInteger)numberOfRows;
{
  return [objects count]; 
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
{
  return [[self sortedObjects] objectAtIndex:indexPath.row];
}

@end
