//
//  LRTableModelEvent.h
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  LRTableModelInsertRowEvent = 0,
  LRTableModelUpdateRowEvent,
  LRTableModelDeleteRowEvent,
  LRTableModelRefreshDataEvent
} LRTableModelEventType;

@interface LRTableModelEvent : NSObject {
  LRTableModelEventType type;
  NSIndexPath *__strong indexPath;
}
@property (nonatomic, readonly) LRTableModelEventType type;
@property (nonatomic, readonly) NSIndexPath *indexPath;

- (id)initWithEventType:(LRTableModelEventType)eventType indexPath:(NSIndexPath *)theIndexPath;
- (BOOL)isEqualToEvent:(LRTableModelEvent *)otherEvent;
- (NSArray *)indexPaths;
+ (id)insertionAtRow:(NSInteger)row section:(NSInteger)section;
+ (id)updatedRow:(NSInteger)row section:(NSInteger)section;
+ (id)deletedRow:(NSInteger)row section:(NSInteger)section;
+ (id)refreshedData;
@end
