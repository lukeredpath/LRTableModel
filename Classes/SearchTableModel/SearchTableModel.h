//
//  SearchTableModel.h
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleTableModel.h"

@interface SearchTableModel : SimpleTableModel {
  NSArray *filteredObjects;
}
- (void)filterObjectsWithPrefix:(NSString *)prefix;
- (void)clearSearchFilter;
@end
