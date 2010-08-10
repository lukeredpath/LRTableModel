//
//  LRTableModelEvent.h
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  LRTableModelInsertEvent = 0,
  LRTableModelUpdateEvent,
  LRTableModelDeleteEvent,
  LRTableModelRefreshEvent
} LRTableModelEventType;

@interface LRTableModelEvent : NSObject {
  LRTableModelEventType type;
  NSIndexPath *indexPath;
}
@property (nonatomic, readonly) LRTableModelEventType type;
@property (nonatomic, readonly) NSIndexPath *indexPath;

- (id)initWithEventType:(LRTableModelEventType)eventType indexPath:(NSIndexPath *)theIndexPath;
- (BOOL)isEqualToEvent:(LRTableModelEvent *)otherEvent;
+ (id)insertionAtRow:(NSInteger)row;
+ (id)updatedRow:(NSInteger)row;
+ (id)deletedRow:(NSInteger)row;
+ (id)refreshed;
@end
