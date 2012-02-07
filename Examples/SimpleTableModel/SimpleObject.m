//
//  SimpleObject.m
//  TableViewModel
//
//  Created by Luke Redpath on 09/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "SimpleObject.h"


@implementation SimpleObject

@synthesize title, description;

- (id)initWithTitle:(NSString *)aTitle description:(NSString *)aDescription;
{
  if (self = [super init]) {
    title = [aTitle copy];
    description = [aDescription copy];
  }
  return self;
}


@end
