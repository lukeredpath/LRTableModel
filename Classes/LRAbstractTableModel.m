//
//  LRAbstractTableModel.m
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRAbstractTableModel.h"


@implementation LRAbstractTableModel

@synthesize cellProvider;

- (id)init
{
  return [self initWithCellProvider:nil];
}

- (id)initWithCellProvider:(id<LRTableModelCellProvider>)theCellProvider;
{
  if (self = [super init]) {
    eventListeners = [[NSMutableArray alloc] init];
    cellProvider = theCellProvider;
  }
  return self;
}


- (void)notifyListeners:(LRTableModelEvent *)event;
{
  for (id<LRTableModelEventListener> listener in eventListeners) {
    [listener tableModelChanged:event];
  }
}

- (void)beginUpdates
{
  for (id<LRTableModelEventListener> listener in eventListeners) {
    [listener tableModelWillBeginUpdates];
  }
}

- (void)endUpdates
{
  for (id<LRTableModelEventListener> listener in eventListeners) {
    [listener tableModelDidEndUpdates];
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

- (NSInteger)numberOfRowsInSection:(NSInteger)sectionIndex; // abstract
{
  return 0;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath; // abstract
{
  return nil;
}

- (NSString *)headerforSection:(NSInteger)section; // abstract
{
  return nil;
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *reuseIdentifier = @"LRGenericCellIdentifier";
  
  if ([cellProvider respondsToSelector:@selector(cellReuseIdentifierForIndexPath:)]) {
    reuseIdentifier = [cellProvider cellReuseIdentifierForIndexPath:indexPath];
  }  
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    if ([cellProvider respondsToSelector:@selector(cellForObjectAtIndexPath:reuseIdentifier:)]) {
      cell = [cellProvider cellForObjectAtIndexPath:indexPath reuseIdentifier:reuseIdentifier];
    } else {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
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
  return [self numberOfRowsInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return [self headerforSection:section];
}

@end
