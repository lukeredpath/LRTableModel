//
//  LRCollectionTableModel.m
//  LRTableModel
//
//  Created by Luke Redpath on 12/12/2012.
//
//

#import "LRCollectionTableModel.h"

@implementation LRCollectionTableModel {
  NSArray *_objects;
}

- (id)initWithObjects:(NSArray *)objects
{
  if ((self = [super init])) {
    _objects = [objects copy];
  }
  return self;
}

- (void)setObjects:(NSArray *)objects
{
  [self beginUpdates];
  
  _objects = [objects copy];
  
  [self notifyListeners:[LRTableModelEvent refreshedData]];
  [self endUpdates];
}

#pragma mark - LRTableModel

- (NSInteger)numberOfSections
{
  return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)sectionIndex
{
  return _objects.count;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
  return [_objects objectAtIndex:indexPath.row];
}

- (NSString *)titleforSection:(NSInteger)section
{
  return self.sectionTitle;
}

@end
