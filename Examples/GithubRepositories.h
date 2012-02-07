//
//  GithubRepositories.h
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GithubRepositories : NSObject {

}
+ (NSArray *)exampleRepositories;
+ (NSArray *)repositoryNamesInGroupsOf:(NSInteger)numberOfItemsInSection;
@end
