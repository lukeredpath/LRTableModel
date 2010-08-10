//
//  LRTableViewModel.h
//  TableViewModel
//
//  Created by Luke Redpath on 09/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRTableModelEventListener.h"

@protocol LRTableModel

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRows;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (void)addTableModelListener:(id<LRTableModelEventListener>)listener;
- (void)removeTableModelListener:(id<LRTableModelEventListener>)listener;

@end
