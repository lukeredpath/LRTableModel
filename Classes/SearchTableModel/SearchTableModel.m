//
//  SearchTableModel.m
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "SearchTableModel.h"
#import "SimpleObject.h"

@interface SearchTableModel ()
- (NSArray *)activeCollection;
@end

@implementation SearchTableModel

- (id)init
{
  if (self = [super init]) {
    filteredObjects = nil;
  }
  return self;
}

- (void)dealloc
{
  [filteredObjects release];
  [super dealloc];
}

- (NSArray *)activeCollection;
{
  if (filteredObjects) {
    return filteredObjects;
  }
  return objects;
}

- (NSInteger)numberOfRows;
{
  return [[self activeCollection] count];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
{
  return [[self activeCollection] objectAtIndex:indexPath.row];
}

NSPredicate *predicateForPrefix(NSString *prefix)
{
  return [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings) {
    return [[(SimpleObject *)evaluatedObject title] hasPrefix:prefix];
  }];
}

- (void)filterObjectsWithPrefix:(NSString *)prefix;
{
  [filteredObjects release];
  filteredObjects = [[objects filteredArrayUsingPredicate:predicateForPrefix(prefix)] retain];
}

- (void)clearSearchFilter;
{
  [filteredObjects release];
  filteredObjects = nil;
  [self notifyListeners:[LRTableModelEvent refreshed]];
}

@end
