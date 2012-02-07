//
//  LRExpectationMessage.h
//  Mocky
//
//  Created by Luke Redpath on 27/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LRExpectationMessage : NSObject {
  NSMutableString *message;
}
@property (nonatomic, readonly) NSString *message;
- (void)append:(NSString *)string;
@end
