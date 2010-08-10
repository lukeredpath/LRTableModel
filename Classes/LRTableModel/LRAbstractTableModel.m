//
//  LRAbstractTableModel.m
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRAbstractTableModel.h"


@implementation LRAbstractTableModel

- (id)initWithCellProvider:(id<LRTableModelCellProvider>)theCellProvider;
{
  if (self = [super init]) {
    eventListeners = [[NSMutableArray alloc] init];
    cellProvider = [theCellProvider retain];
  }
  return self;
}

- (void)dealloc
{
  [cellProvider release];
  [eventListeners release];
  [super dealloc];
}

- (void)notifyListeners:(LRTableModelEvent *)event;
{
  for (id<LRTableModelEventListener> listener in eventListeners) {
    [listener tableModelChanged:event];
  }
}

- (void)addTableModelListener:(id<LRTableModelEventListener>)listener;
{
  [eventListeners addObject:listener];
}

- (void)removeTableModelListener:(id<LRTableModelEventListener>)listener;
{
  [eventListeners removeObject:listener];
}

- (NSInteger)numberOfSections; // abstract
{
  return 1;
}

- (NSInteger)numberOfRows; // abstract
{
  return 0;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath; // abstract
{
  return nil;
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
