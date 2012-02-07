//
//  LRTableViewModel.h
//  TableViewModel
//
//  Created by Luke Redpath on 09/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRTableModelEventListener.h"
#import "LRTableModelCellProvider.h"

@protocol LRTableModel <NSObject>

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)sectionIndex;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)headerforSection:(NSInteger)section;
- (void)addTableModelListener:(id<LRTableModelEventListener>)listener;
- (void)removeTableModelListener:(id<LRTableModelEventListener>)listener;

@end
