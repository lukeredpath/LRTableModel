//
//  SimpleTableViewController.h
//  TableViewModel
//
//  Created by Luke Redpath on 09/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LRTableModelEventListener.h"

@class SortableTableModel;

@interface SimpleTableViewController : UITableViewController <LRTableModelEventListener> {
  SortableTableModel *tableModel;
  UISegmentedControl *sortOrderControl;
}
@property (unsafe_unretained, nonatomic, readonly) SortableTableModel *tableModel;

- (void)configureToolbarItems;
@end
