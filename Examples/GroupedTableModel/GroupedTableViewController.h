//
//  GroupedTableViewController.h
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRTableModelCellProvider.h"
#import "LRTableModelEventListener.h"

@class GroupedTableModel;

@interface GroupedTableViewController : UITableViewController <LRTableModelCellProvider, LRTableModelEventListener> {
  GroupedTableModel *tableModel;
}
@property (unsafe_unretained, nonatomic, readonly) GroupedTableModel *tableModel;
@end
