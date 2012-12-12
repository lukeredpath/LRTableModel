    //
//  SimpleTableViewController.m
//  TableViewModel
//
//  Created by Luke Redpath on 09/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "SimpleTableViewController.h"
#import "SimpleObject.h"
#import "SortableTableModel.h"
#import "GithubRepositories.h"

@implementation SimpleTableViewController


- (SortableTableModel *)tableModel
{
  if (tableModel == nil) {
    tableModel = [[SortableTableModel alloc] init];

    [tableModel addTableModelListener:self];
  }
  return tableModel;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self configureToolbarItems];
  
  self.tableView.rowHeight = 65;
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
  [self.navigationItem setRightBarButtonItem:addButton];
  
  NSMutableArray *objects = [NSMutableArray array];
  
  [[GithubRepositories exampleRepositories] enumerateObjectsUsingBlock:^(id repository, NSUInteger idx, BOOL *stop) {
    SimpleObject *object = [[SimpleObject alloc] initWithTitle:[repository objectForKey:@"name"] description:[repository objectForKey:@"description"]];
    [objects addObject:object];
  }];
  
  [self.tableModel setObjects:objects];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)configureToolbarItems;
{
  NSMutableArray *items = [NSMutableArray array];
  
  if (sortOrderControl == nil) {
    sortOrderControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Unsorted", @"Sort Asc", @"Sort Desc", nil]];
    sortOrderControl.segmentedControlStyle = UISegmentedControlStyleBar;
    sortOrderControl.selectedSegmentIndex = self.tableModel.sortOrder;
    [sortOrderControl addTarget:self action:@selector(sortOrderControlChanged:) forControlEvents:UIControlEventValueChanged];
  }  
  [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
  [items addObject:[[UIBarButtonItem alloc] initWithCustomView:sortOrderControl]];
  [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
  
  self.toolbarItems = items;
}

- (void)addButtonTapped:(id)sender
{
  SimpleObject *object = [[SimpleObject alloc] initWithTitle:@"A new object" description:[NSString stringWithFormat:@"This was created at %@", [NSDate date]]];
  [self.tableModel insertObject:object atIndex:0];
}

- (void)sortOrderControlChanged:(UISegmentedControl *)control
{
  switch (control.selectedSegmentIndex) {
    case 0:
      [self.tableModel setSortDescriptors:nil];
      break;
    case 1:
      [self.tableModel setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
      break;
    case 2:
      [self.tableModel setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO]]];
      break;
    default:
      break;
  }
}

#pragma mark -
#pragma mark LRTableModelEventListener methods

- (void)tableModelChanged:(LRTableModelEvent *)changeEvent
{
  switch (changeEvent.type) {
    case LRTableModelRefreshDataEvent:
      [self.tableView reloadData];
      break;
    case LRTableModelInsertRowEvent:
      [self.tableView insertRowsAtIndexPaths:changeEvent.indexPaths withRowAnimation:UITableViewRowAnimationTop];
      break;
    default:
      [self.tableView reloadData];
      break;
  }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"SimpleCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
  }
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  SimpleObject *simpleObject = object;
  
  cell.detailTextLabel.numberOfLines = 2;
  cell.textLabel.text = simpleObject.title;
  cell.detailTextLabel.text = simpleObject.description;
}

@end
