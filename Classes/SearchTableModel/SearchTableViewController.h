//
//  SearchTableViewController.h
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRTableModel.h"

@class SearchTableModel;

@interface SearchTableViewController : UITableViewController <LRTableModelCellProvider, LRTableModelEventListener, UISearchDisplayDelegate> {
  SearchTableModel *searchTableModel;
}
@property (nonatomic, retain) IBOutlet SearchTableModel *searchTableModel;
@end
