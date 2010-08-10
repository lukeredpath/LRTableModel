//
//  LRAbstractTableModel.h
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRTableModel.h"

@interface LRAbstractTableModel : NSObject <LRTableModel> {
  NSMutableArray *eventListeners;
  id<LRTableModelCellProvider> cellProvider;
}
- (void)notifyListeners:(LRTableModelEvent *)event;
@end
