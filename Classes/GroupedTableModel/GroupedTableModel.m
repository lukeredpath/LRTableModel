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
  [self notifyListeners:[LRTableModelEvent refreshedData]];
}

- (NSString *)headerforSection:(NSInteger)section;
{
  return [sectionTitles objectAtIndex:section];
}

/*
 * this takes the last object from the list, pushes it to the top
 * and moves everything down one (which means the last object in
 * each section moves to the top of the next section 
 */
- (void)rotateLastItem;
{
  NSMutableArray *lastSection = [sections lastObject];
  
  id lastObject = [[lastSection lastObject] retain];
  NSInteger indexOfLastObject = [lastSection indexOfObject:lastObject];
  [lastSection removeLastObject];
  [self notifyListeners:[LRTableModelEvent deletedRow:indexOfLastObject section:[sections indexOfObject:lastSection]]];
  
  for (NSMutableArray *section in sections) {
    [section insertObject:lastObject atIndex:0];
    [self notifyListeners:[LRTableModelEvent insertionAtRow:0 section:[sections indexOfObject:section]]];
    [lastObject release];
    
    if (section != [sections lastObject]) {
      lastObject = [[section lastObject] retain];
      NSInteger indexOfLastObject = [section indexOfObject:lastObject];
      [section removeLastObject];
      [self notifyListeners:[LRTableModelEvent insertionAtRow:indexOfLastObject section:[sections indexOfObject:section]]];
    }
  }
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
