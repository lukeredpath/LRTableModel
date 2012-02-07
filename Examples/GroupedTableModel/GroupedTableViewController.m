//
//  GroupedTableViewController.m
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "GroupedTableViewController.h"
#import "GithubRepositories.h"
#import "GroupedTableModel.h"

@implementation GroupedTableViewController

- (GroupedTableModel *)tableModel
{
  if (tableModel == nil) {
    tableModel = [[GroupedTableModel alloc] initWithCellProvider:self];
    [tableModel addTableModelListener:self];
  }
  return tableModel;
}

#define kNumberOfObjectsInSection 5

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.tableView.dataSource = self.tableModel;
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(rotateButtonTapped:)];

  NSArray *sections = [GithubRepositories repositoryNamesInGroupsOf:kNumberOfObjectsInSection];

  NSMutableArray *sectionTitles = [NSMutableArray array];
  for (int i = 0; i < sections.count; i++) {
    NSInteger firstItemIndex = (i * kNumberOfObjectsInSection);
    [sectionTitles addObject:[NSString stringWithFormat:@"Item %d to %d", firstItemIndex + 1, firstItemIndex + kNumberOfObjectsInSection]];
  }
  
  [self.tableModel setSections:sections sectionTitles:sectionTitles];
}

- (void)tableModelWillBeginUpdates
{
  [self.tableView beginUpdates];
}

- (void)tableModelChanged:(LRTableModelEvent *)changeEvent
{
  switch (changeEvent.type) {
    case LRTableModelInsertRowEvent:
      [self.tableView insertRowsAtIndexPaths:changeEvent.indexPaths withRowAnimation:UITableViewRowAnimationTop];
      break;
    case LRTableModelDeleteRowEvent:
      [self.tableView deleteRowsAtIndexPaths:changeEvent.indexPaths withRowAnimation:UITableViewRowAnimationBottom];
      break;
    default:
      [self.tableView reloadData];
      break;
  }
}

- (void)tableModelDidEndUpdates
{
  [self.tableView endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell forObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
  cell.textLabel.text = object;
}

- (void)rotateButtonTapped:(id)sender
{
  [self.tableModel rotateLastItem];
}

@end

