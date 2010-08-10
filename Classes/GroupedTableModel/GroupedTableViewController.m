//
//  GroupedTableViewController.m
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "GroupedTableViewController.h"
#import "GithubRepositories.h"

@implementation GroupedTableModel

@end

@implementation GroupedTableViewController

- (GroupedTableModel *)tableModel
{
  if (tableModel == nil) {
    tableModel = [[GroupedTableModel alloc] initWithCellProvider:self];
    [tableModel addTableModelListener:self];
  }
  return tableModel;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.tableView.dataSource = self.tableModel;
  
  NSMutableArray *repositoryNames = [NSMutableArray array];
  [[GithubRepositories exampleRepositories] enumerateObjectsUsingBlock:^(id repository, NSUInteger idx, BOOL *stop) {
    [repositoryNames addObject:[repository valueForKey:@"name"]];
  }];

  [self.tableModel setObjects:repositoryNames];
}

- (void)tableModelChanged:(LRTableModelEvent *)changeEvent
{
  [self.tableView reloadData];
}

- (void)configureCell:(UITableViewCell *)cell forObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
  cell.textLabel.text = object;
}

@end
