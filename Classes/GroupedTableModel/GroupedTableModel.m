//
//  GroupedTableModel.m
//  TableViewModel
//
//  Created by Luke Redpath on 11/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "GroupedTableModel.h"


@implementation GroupedTableModel

- (id)initWithCellProvider:(id <LRTableModelCellProvider>)theCellProvider
{
  if (self = [super initWithCellProvider:theCellProvider]) {
    sections = [[NSMutableArray alloc] initWithObjects:[NSArray array], nil];
    sectionTitles = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc
{
  [sections release];
  [sectionTitles release];
  [super dealloc];
}

- (NSArray *)objectsInSection:(NSInteger)sectionIndex;
{
  return [sections objectAtIndex:sectionIndex];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
  return [[self objectsInSection:indexPath.section] objectAtIndex:indexPath.row];
}

- (void)setSections:(NSArray *)arrayOfSectionArrays sectionTitles:(NSArray *)titles;
{
  [sections setArray:arrayOfSectionArrays];
  [sectionTitles setArray:titles];
  [self notifyListeners:[LRTableModelEvent refreshed]];
}

- (NSString *)headerforSection:(NSInteger)section;
{
  return [sectionTitles objectAtIndex:section];
}

#pragma mark -
#pragma mark LRTableModel

- (NSInteger)numberOfSections
{
  return [sections count];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)sectionIndex;
{
  return [[self objectsInSection:sectionIndex] count];
}

@end
