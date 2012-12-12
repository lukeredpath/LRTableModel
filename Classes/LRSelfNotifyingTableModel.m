//
//  LRAbstractTableModel.m
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRSelfNotifyingTableModel.h"

@implementation LRSelfNotifyingTableModel {
  NSMutableArray *_eventListeners;
}

- (id)init
{
  if (self = [super init]) {
    _eventListeners = [[NSMutableArray alloc] init];
  }
  return self;
}


- (void)notifyListeners:(LRTableModelEvent *)event;
{
  for (id<LRTableModelEventListener> listener in _eventListeners) {
    [listener tableModelChanged:event];
  }
}

- (void)beginUpdates
{
  for (id<LRTableModelEventListener> listener in _eventListeners) {
    if ([listener respondsToSelector:@selector(tableModelWillBeginUpdates)]) {
      [listener tableModelWillBeginUpdates];
    }
  }
}

- (void)endUpdates
{
  for (id<LRTableModelEventListener> listener in _eventListeners) {
    if ([listener respondsToSelector:@selector(tableModelDidEndUpdates)]) {
      [listener tableModelDidEndUpdates];
    }
  }
}

- (void)performUpdatesWithBlock:(dispatch_block_t)updateBlock
{
  [self beginUpdates];
  
    updateBlock();

  [self endUpdates];
}

- (void)addTableModelListener:(id<LRTableModelEventListener>)listener;
{
  [_eventListeners addObject:listener];
}

- (void)removeTableModelListener:(id<LRTableModelEventListener>)listener;
{
  [_eventListeners removeObject:listener];
}

@end
