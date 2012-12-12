//
//  LRAbstractTableModel.h
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRTableModel.h"

/* This is intended as an abstract base class that implementers of the 
 LRTableModel protocol can use to create table models that support background
 updates.
 
 Despite the name, this class doesn't actually implement the LRTableModel
 protocol itself - it doesn't have the information it needs to do so.
 */
@interface LRSelfNotifyingTableModel : NSObject

- (void)addTableModelListener:(id<LRTableModelEventListener>)listener;
- (void)removeTableModelListener:(id<LRTableModelEventListener>)listener;

/* The following methods are intended to be called by sub-classes. */

- (void)notifyListeners:(LRTableModelEvent *)event;
- (void)beginUpdates;
- (void)endUpdates;
- (void)performUpdatesWithBlock:(dispatch_block_t)updateBlock;

@end
