//
//  GroupedTableModel.h
//  TableViewModel
//
//  Created by Luke Redpath on 11/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleTableModel.h"

@interface GroupedTableModel : SimpleTableModel
{
  NSMutableArray *sections;
  NSMutableArray *sectionTitles;
}
- (void)setSections:(NSArray *)arrayOfSectionArrays sectionTitles:(NSArray *)titles;
- (void)rotateLastItem;
@end
