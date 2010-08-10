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

- (id)initWithCellProvider:(id<LRTableModelCellProvider>)theCellProvider;
{
  if (self = [super init]) {
    objects = [[NSMutableArray alloc] init];
    eventListeners = [[NSMutableArray alloc] init];
    cellProvider = [theCellProvider retain];
  }
  return self;
}

- (void)dealloc
{
  [cellProvider release];
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

- (void)setObjects:(NSArray *)newObjects;
{
  [objects removeAllObjects];
  [objects setArray:newObjects];
  [self notifyListeners:[LRTableModelEvent refreshed]];
}

- (NSInteger)numberOfSections;
{
  return 1;
}

- (NSInteger)numberOfRows;
{
  return [objects count]; 
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

#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *reuseIdentifier = [cellProvider cellReuseIdentifierForIndexPath:indexPath];
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [cellProvider cellForObjectAtIndexPath:indexPath reuseIdentifier:reuseIdentifier];
  }
  [cellProvider configureCell:cell forObject:[self objectAtIndexPath:indexPath] atIndexPath:indexPath];
  
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
  return [self numberOfRows];
}

@end
