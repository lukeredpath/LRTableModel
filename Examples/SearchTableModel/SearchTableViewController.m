//
//  SearchTableViewController.m
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "SearchTableViewController.h"
#import "SimpleObject.h"
#import "SearchTableModel.h"
#import "GithubRepositories.h"

@implementation SearchTableViewController

@synthesize searchTableModel;

- (id)init
{
  return [self initWithNibName:@"SearchTableViewController" bundle:nil];
}


- (void)awakeFromNib
{
  [self.searchTableModel addTableModelListener:self];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.tableView.rowHeight = 65;
  self.searchDisplayController.searchResultsTableView.rowHeight = self.tableView.rowHeight;
  
  NSMutableArray *objects = [NSMutableArray array];
  [[GithubRepositories exampleRepositories] enumerateObjectsUsingBlock:^(id repository, NSUInteger idx, BOOL *stop) {
    SimpleObject *object = [[SimpleObject alloc] initWithTitle:[repository objectForKey:@"name"] description:[repository objectForKey:@"description"]];
    [objects addObject:object];
  }];
  
  [self.searchTableModel setObjects:objects];
}

#pragma mark -
#pragma mark LRTableModel methods

- (void)tableModelChanged:(LRTableModelEvent *)changeEvent
{
  [self.tableView reloadData];
}

- (UITableViewCell *)cellForObjectAtIndexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier
{
  return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}

- (void)configureCell:(UITableViewCell *)cell forObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
  SimpleObject *simpleObject = object;
  
  cell.detailTextLabel.numberOfLines = 2;
  cell.textLabel.text = simpleObject.title;
  cell.detailTextLabel.text = simpleObject.description;
}

#pragma mark -
#pragma mark UISearchDisplayDelegate methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
  [self.searchTableModel filterObjectsWithPrefix:searchString];
  return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
  [self.searchTableModel clearSearchFilter];
}

@end
