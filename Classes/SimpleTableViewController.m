    //
//  SimpleTableViewController.m
//  TableViewModel
//
//  Created by Luke Redpath on 09/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "SimpleTableViewController.h"
#import "SimpleObject.h"
#import "SimpleTableModel.h"

@implementation SimpleTableViewController

NSArray *plistData()
{
  return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"repositories" ofType:@"plist"]];
}

- (void)dealloc 
{
  [tableModel release];
  [super dealloc];
}

- (SimpleTableModel *)tableModel
{
  if (tableModel == nil) {
    tableModel = [[SimpleTableModel alloc] initWithCellProvider:self];
    [tableModel addTableModelListener:self];
  }
  return tableModel;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Simple Table View";
  self.tableView.rowHeight = 65;
  self.tableView.dataSource = self.tableModel;
  
  NSMutableArray *objects = [NSMutableArray array];
  [plistData() enumerateObjectsUsingBlock:^(id repository, NSUInteger idx, BOOL *stop) {
    SimpleObject *object = [[SimpleObject alloc] initWithTitle:[repository objectForKey:@"name"] description:[repository objectForKey:@"description"]];
    [objects addObject:object];
    [object release];
  }];
  
  [self.tableModel setObjects:objects];
}

#pragma mark -
#pragma mark LRTableModelEventListener methods

- (void)tableModelChanged:(LRTableModelEvent *)changeEvent
{
  switch (changeEvent.type) {
    case LRTableModelRefreshEvent:
      [self.tableView reloadData];
      break;
    default:
      [self.tableView reloadData];
      break;
  }
}

#pragma mark -
#pragma mark LRTableModelCellProvider methods

- (NSString *)cellReuseIdentifierForIndexPath:(NSIndexPath *)indexPath;
{
  static NSString *identifier = @"CellIdentifier";
  return identifier;
}

- (UITableViewCell *)cellForObjectAtIndexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier
{
  return [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] autorelease];
}

- (void)configureCell:(UITableViewCell *)cell forObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
  SimpleObject *simpleObject = object;
  
  cell.detailTextLabel.numberOfLines = 2;
  cell.textLabel.text = simpleObject.title;
  cell.detailTextLabel.text = simpleObject.description;
}

@end
