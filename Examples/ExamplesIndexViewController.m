//
//  ExamplesIndexViewController.m
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "ExamplesIndexViewController.h"
#import "LRTableModelEvent.h"

@implementation ExamplesTableModel

- (id)initWithCellProvider:(id <LRTableModelCellProvider>)theCellProvider
{
  if (self = [super initWithCellProvider:theCellProvider]) {
    examples = [[NSMutableArray alloc] init];
  }
  return self;
}


- (void)loadExamplesFromPlistNamed:(NSString *)plistName inBundle:(NSBundle *)bundle
{
  examples = [NSArray arrayWithContentsOfFile:[bundle pathForResource:plistName ofType:@"plist"]];
  [self notifyListeners:[LRTableModelEvent refreshedData]];
}

- (NSInteger)numberOfSections;
{
  return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)sectionIndex;
{
  return [examples count]; 
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
{
  return [examples objectAtIndex:indexPath.row];
}

@end

@implementation ExamplesIndexViewController


- (ExamplesTableModel *)examplesTableModel
{
  if (examplesTableModel == nil) {
    examplesTableModel = [[ExamplesTableModel alloc] initWithCellProvider:self];
    [examplesTableModel addTableModelListener:self];
  }
  return examplesTableModel;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.tableView.rowHeight = 65;
  self.tableView.dataSource = self.examplesTableModel;
  
  [self.examplesTableModel loadExamplesFromPlistNamed:@"Examples" inBundle:[NSBundle mainBundle]];
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
  cell.textLabel.text = [object valueForKey:@"name"];
  cell.detailTextLabel.text = [object valueForKey:@"description"];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSDictionary *exampleData = [self.examplesTableModel objectAtIndexPath:indexPath];
  
  UIViewController *exampleViewController = [[NSClassFromString([exampleData valueForKey:@"controller"]) alloc] init];
  exampleViewController.title = [exampleData valueForKey:@"name"];
  [self.navigationController pushViewController:exampleViewController animated:YES];
}

@end
