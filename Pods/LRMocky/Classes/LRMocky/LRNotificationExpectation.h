//
//  LRNotificationExpectation.h
//  Mocky
//
//  Created by Luke Redpath on 31/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectation.h"

@interface LRNotificationExpectation : NSObject <LRExpectation> {
  NSString *name;
  id sender;
  BOOL isSatisfied;
}
+ (id)expectationWithNotificationName:(NSString *)name;
+ (id)expectationWithNotificationName:(NSString *)name sender:(id)sender;
- (id)initWithName:(NSString *)name sender:(id)sender;
@end
