//
//  LRTableModelEvent.m
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRTableModelEvent.h"


@implementation LRTableModelEvent

@synthesize type;
@synthesize indexPath;

- (id)initWithEventType:(LRTableModelEventType)eventType indexPath:(NSIndexPath *)theIndexPath;
{
  if (self = [super init]) {
    type = eventType;
    indexPath = theIndexPath;
  }
  return self;
}


- (NSArray *)indexPaths;
{
  return [NSArray arrayWithObject:indexPath];
}

- (NSString *)description
{
  NSString *eventType = nil;
  switch (self.type) {
    case LRTableModelInsertRowEvent:
      eventType = @"LRTableModelInsertRowEvent";
      break;
    case LRTableModelUpdateRowEvent:
      eventType = @"LRTableModelUpdateRowEvent";
      break;
    case LRTableModelDeleteRowEvent:
      eventType = @"LRTableModelDeleteRowEvent";
      break;
    case LRTableModelRefreshDataEvent:
      eventType = @"LRTableModelRefreshDataEvent";
      break;
    default:
      eventType = @"UnknownEventType";
      break;
  }
  return [NSString stringWithFormat:@"%@ atIndexPath:{%d, %d}", eventType, self.indexPath.section, self.indexPath.row];
}   

- (BOOL)isEqual:(id)object
{
  if (![object isKindOfClass:[self class]]) {
    return NO;
  }
  return [self isEqualToEvent:object];
}

- (BOOL)isEqualToEvent:(LRTableModelEvent *)otherEvent
{
  if (self.indexPath == nil) {
    return self.type == otherEvent.type;
  }
  return [otherEvent.indexPath isEqual:self.indexPath] &&
    otherEvent.type == self.type;
}

+ (id)insertionAtRow:(NSInteger)row section:(NSInteger)section;
{
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
  return [[self alloc] initWithEventType:LRTableModelInsertRowEvent indexPath:indexPath];
}

+ (id)updatedRow:(NSInteger)row section:(NSInteger)section;
{
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
  return [[self alloc] initWithEventType:LRTableModelUpdateRowEvent indexPath:indexPath];
}

+ (id)deletedRow:(NSInteger)row section:(NSInteger)section;
{
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
  return [[self alloc] initWithEventType:LRTableModelDeleteRowEvent indexPath:indexPath];
}

+ (id)refreshedData;
{
  return [[self alloc] initWithEventType:LRTableModelRefreshDataEvent indexPath:nil];
}

@end
