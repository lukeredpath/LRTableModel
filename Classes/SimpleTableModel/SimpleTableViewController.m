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
#import "GithubRepositories.h"

@implementation SimpleTableViewController

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
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
  [self.navigationItem setRightBarButtonItem:addButton];
  [addButton release];
  
  NSMutableArray *objects = [NSMutableArray array];
  [[GithubRepositories exampleRepositories] enumerateObjectsUsingBlock:^(id repository, NSUInteger idx, BOOL *stop) {
    SimpleObject *object = [[SimpleObject alloc] initWithTitle:[repository objectForKey:@"name"] description:[repository objectForKey:@"description"]];
    [objects addObject:object];
    [object release];
  }];
  
  [self.tableModel setObjects:objects];
}

- (void)addButtonTapped:(id)sender
{
  SimpleObject *object = [[SimpleObject alloc] initWithTitle:@"A new object" description:[NSString stringWithFormat:@"This was created at %@", [NSDate date]]];
  [self.tableModel insertObject:object atIndex:0];
  [object release];
}

#pragma mark -
#pragma mark LRTableModelEventListener methods

- (void)tableModelChanged:(LRTableModelEvent *)changeEvent
{
  switch (changeEvent.type) {
    case LRTableModelRefreshEvent:
      [self.tableView reloadData];
      break;
    case LRTableModelInsertEvent:
      [self.tableView insertRowsAtIndexPaths:changeEvent.indexPaths withRowAnimation:UITableViewRowAnimationTop];
      break;
    default:
      [self.tableView reloadData];
      break;
  }
}

#pragma mark -
#pragma mark LRTableModelCellProvider methods

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
