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

- (void)dealloc 
{
  [tableModel release];
  [super dealloc];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Simple Table View";
  self.tableView.rowHeight = 65;
  
  tableModel = [[SimpleTableModel alloc] init];
  [tableModel addTableModelListener:self];
  
  cellProvider = self;
  
  NSArray *repositoriesFromPlist = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"repositories" ofType:@"plist"]];
  
  NSMutableArray *objects = [NSMutableArray array];
  [repositoriesFromPlist enumerateObjectsUsingBlock:^(id repository, NSUInteger idx, BOOL *stop) {
    SimpleObject *object = [[SimpleObject alloc] initWithTitle:[repository objectForKey:@"name"] description:[repository objectForKey:@"description"]];
    [objects addObject:object];
    [object release];
  }];
  
  [tableModel setObjects:objects];
}

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

#pragma mark Table View Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *reuseIdentifier = [cellProvider cellReuseIdentifierForIndexPath:indexPath];
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [cellProvider cellForObjectAtIndexPath:indexPath reuseIdentifier:reuseIdentifier];
  }
  [cellProvider configureCell:cell forObject:[tableModel objectAtIndexPath:indexPath] atIndexPath:indexPath];
  
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [tableModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
  return [tableModel numberOfRows];
}

@end
