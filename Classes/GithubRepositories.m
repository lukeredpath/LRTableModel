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

@end
