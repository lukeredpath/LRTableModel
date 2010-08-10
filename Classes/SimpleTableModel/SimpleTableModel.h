//
//  SimpleTableViewModel.h
//  TableViewModel
//
//  Created by Luke Redpath on 09/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRTableModel.h"
#import "LRTableModelCellProvider.h"

/*
 SimpleTableModel is probably the most basic implementation of LRTableModel possible.
 
 As it's interface makes clear, it's essentially a glorified NSArray but one that implements
 the SimpleTableModel protocol and notifies its event listeners appropriately.
 
 The LRTableModel protocol is clearly influenced (*ahem* copied) from the Java Swing
 JTable TableModel interface although there are also some parallells with NSFetchedResultsController
 which has a similar method of informing the controller of changes in the result set.
 
 The key difference here is the TableModel, with both event listeners and a cell provider,
 has enough information to fully act as the UITableViewDataSource making the view controller's
 job a lot easier. 
 
 It no longer needs to deal with the same old boring data source boiler plate
 code, it instead just needs to provide cells and respond to changes in the model by reloading
 the table in a way it deems appropriate, whilst continuing to act as the table view's delegate
 to respond to user interaction with the table (which is clearly the role of the controller).
 
 The final point worth making, is that because LRTableModel is just a protocol, you can implement
 it however you want, depending on what makes sense for your app. You might not even need the
 full range of array mutators as defined below; you might have a very basic table model that
 reacts to events from an external source (e.g. Tweets arriving from the Twitter streaming API).
 
 More examples to come soon.
 */

@interface SimpleTableModel : NSObject <LRTableModel> {
  NSMutableArray *objects;
  NSMutableArray *eventListeners;
  id<LRTableModelCellProvider> cellProvider;
}
- (void)addObject:(id)anObject;
- (void)removeObject:(id)anObject;
- (void)insertObject:(id)anObject atIndex:(NSInteger)index;
- (void)replaceObjectAtIndex:(NSInteger)index withObject:(id)anObject;
- (void)setObjects:(NSArray *)newObjects;
@end
