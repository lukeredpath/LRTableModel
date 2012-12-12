//
//  LRCollectionTableModel.h
//  LRTableModel
//
//  Created by Luke Redpath on 12/12/2012.
//
//

#import <Foundation/Foundation.h>
#import "LRSelfNotifyingTableModel.h"

/* This is about the simplest possible implementation of a table model, and
 can be used when all you need to bind to your table view is a collection of objects
 in a single section.
 */
@interface LRCollectionTableModel : LRSelfNotifyingTableModel <LRTableModel>

/* This property is mainly aimed at sub-classes who wish to get access to the
 objects for use within their own implementation.
 */
@property (nonatomic, readonly) NSArray *objects;

/* 
 Set the title that will be used for the single section represented by the model. 
 
 Default is nil.
 */
@property (nonatomic, copy) NSString *sectionTitle;

- (id)initWithObjects:(NSArray *)objects;

/* 
 Updates the objects in the model.
 
 Calling this will trigger a LRTableModelRefreshDataEvent event. 
 */
- (void)setObjects:(NSArray *)objects;

@end
