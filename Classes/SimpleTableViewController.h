//
//  SimpleTableViewController.h
//  TableViewModel
//
//  Created by Luke Redpath on 09/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRTableModelEventListener.h"
#import "LRTableModelCellProvider.h"

@class SimpleTableModel;

@interface SimpleTableViewController : UITableViewController <LRTableModelEventListener, LRTableModelCellProvider> {
  SimpleTableModel *tableModel;
  id<LRTableModelCellProvider> cellProvider;
}
@end
