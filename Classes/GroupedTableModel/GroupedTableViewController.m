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

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.title = @"Grouped";
  self.tableView.dataSource = self.tableModel;
  
  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(rotateButtonTapped:)] autorelease];
  
  // divide up the repositories from the sample data into groups of x using some basic logic
  
  NSInteger numberOfItemsInGroup = 5;
  
  NSMutableArray *repositoryNamesInSections = [NSMutableArray arrayWithObject:[NSMutableArray array]];
  NSMutableArray *sectionTitles = [NSMutableArray arrayWithObject:[NSString stringWithFormat:@"Items 1 to %d", numberOfItemsInGroup]];
  
  __block NSMutableArray *currentSection = [repositoryNamesInSections objectAtIndex:0];

  [[GithubRepositories exampleRepositories] enumerateObjectsUsingBlock:^(id repository, NSUInteger idx, BOOL *stop) {
    NSString *repositoryName = [repository valueForKey:@"name"];
    
    if (idx > 0 && (idx % numberOfItemsInGroup) == 0) {
      currentSection = [NSMutableArray arrayWithObject:repositoryName];
      [repositoryNamesInSections addObject:currentSection];
      [sectionTitles addObject:[NSString stringWithFormat:@"Items %d to %d", idx + 1, idx + numberOfItemsInGroup]];
    } else {
      [currentSection addObject:repositoryName];
    }
  }];

  [self.tableModel setSections:repositoryNamesInSections sectionTitles:sectionTitles];
}

- (void)tableModelChanged:(LRTableModelEvent *)changeEvent
{
  [self.tableView reloadData];
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
