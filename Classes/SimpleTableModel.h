//
//  SimpleTableViewModel.h
//  TableViewModel
//
//  Created by Luke Redpath on 09/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRTableModel.h"

@interface SimpleTableModel : NSObject <LRTableModel> {
  NSMutableArray *objects;
  NSMutableArray *eventListeners;
}
- (void)addObject:(id)anObject;
- (void)removeObject:(id)anObject;
- (void)replaceObjectAtIndex:(NSInteger)index withObject:(id)anObject;
- (void)setObjects:(NSArray *)newObjects;
@end
