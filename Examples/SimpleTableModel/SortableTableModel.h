//
//  SimpleTableViewModel.h
//  TableViewModel
//
//  Created by Luke Redpath on 09/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRCollectionTableModel.h"

/*
 SimpleTableModel extends the built-in LRCollectionTableModel to provide
 more fine-grained mutation methods (which in turn generate more fine-grained
 change events.
 
 It also supports sorting with sort descriptors.
 */
@interface SortableTableModel : LRCollectionTableModel 

@property (nonatomic, strong) NSArray *sortDescriptors;

- (void)addObject:(id)anObject;
- (void)removeObject:(id)anObject;
- (void)insertObject:(id)anObject atIndex:(NSInteger)index;
- (void)replaceObjectAtIndex:(NSInteger)index withObject:(id)anObject;

@end
