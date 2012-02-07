//
//  LRPerformBlockArgumentAction.h
//  Mocky
//
//  Created by Luke Redpath on 30/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectationAction.h"

@interface LRPerformBlockArgumentAction : NSObject <LRExpectationAction> {
  id object;
}
- (id)initWithObject:(id)anObject;
@end

LRPerformBlockArgumentAction *LRA_performBlockArguments();
LRPerformBlockArgumentAction *LRA_performBlockArgumentsWithObject(id object);

#ifdef LRMOCKY_SHORTHAND
#define performBlockArguments  LRA_performBlockArguments()
#define performsBlockArguments LRA_performBlockArguments()
#define performBlockArgumentsWithObject(object) LRA_performBlockArgumentsWithObject(object)
#define performsBlockArgumentsWithObject(object) LRA_performBlockArgumentsWithObject(object)
#endif

