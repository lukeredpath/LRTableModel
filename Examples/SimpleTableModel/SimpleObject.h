//
//  SimpleObject.h
//  TableViewModel
//
//  Created by Luke Redpath on 09/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SimpleObject : NSObject {
  NSString *title;
  NSString *description;
}
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *description;

- (id)initWithTitle:(NSString *)aTitle description:(NSString *)aDescription;
@end
