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
    indexPath = [theIndexPath retain];
  }
  return self;
}

- (void)dealloc
{
  [indexPath release];
  [super dealloc];
}

- (NSString *)description
{
  NSString *eventType = nil;
  switch (self.type) {
    case LRTableModelInsertEvent:
      eventType = @"LRTableModelInsertEvent";
      break;
    case LRTableModelUpdateEvent:
      eventType = @"LRTableModelUpdateEvent";
      break;
    case LRTableModelDeleteEvent:
      eventType = @"LRTableModelDeleteEvent";
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
  return [otherEvent.indexPath isEqual:self.indexPath] &&
    otherEvent.type == self.type;
}

+ (id)insertionAtRow:(NSInteger)row;
{
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
  return [[[self alloc] initWithEventType:LRTableModelInsertEvent indexPath:indexPath] autorelease];
}

+ (id)updatedRow:(NSInteger)row;
{
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
  return [[[self alloc] initWithEventType:LRTableModelUpdateEvent indexPath:indexPath] autorelease];
}

+ (id)deletedRow:(NSInteger)row;
{
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
  return [[[self alloc] initWithEventType:LRTableModelDeleteEvent indexPath:indexPath] autorelease];
}

@end
