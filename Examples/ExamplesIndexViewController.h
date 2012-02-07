//
//  ExamplesIndexViewController.h
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRAbstractTableModel.h"

@interface ExamplesTableModel : LRAbstractTableModel
{
  NSArray *examples;
}
- (void)loadExamplesFromPlistNamed:(NSString *)plistName inBundle:(NSBundle *)bundle;
@end

@interface ExamplesIndexViewController : UITableViewController <LRTableModelEventListener, LRTableModelCellProvider> {
  ExamplesTableModel *examplesTableModel;
}
@property (unsafe_unretained, nonatomic, readonly) ExamplesTableModel *examplesTableModel;
@end
