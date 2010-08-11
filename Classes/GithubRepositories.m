//
//  GithubRepositories.m
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "GithubRepositories.h"

@implementation GithubRepositories

+ (NSArray *)exampleRepositories
{
  return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"repositories" ofType:@"plist"]];
}

+ (NSArray *)repositoryNamesInGroupsOf:(NSInteger)numberOfItemsInSection
{  
  NSMutableArray *objectsInSections = [NSMutableArray arrayWithObject:[NSMutableArray array]];

  __block NSMutableArray *currentSection = [objectsInSections objectAtIndex:0];

  [[[self exampleRepositories] valueForKeyPath:@"@unionOfObjects.name"] enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
    if (idx > 0 && (idx % numberOfItemsInSection) == 0) {
      currentSection = [NSMutableArray arrayWithObject:object];
      [objectsInSections addObject:currentSection];
    } else {
      [currentSection addObject:object];
    }
  }];
  
  return objectsInSections;
}

@end
