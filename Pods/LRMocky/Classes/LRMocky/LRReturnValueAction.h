//
//  LRReturnValueAction.h
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectationAction.h"

@interface LRReturnValueAction : NSObject <LRExpectationAction> {
  id objectToReturn;
  NSData *returnValue;
}
- (id)initWithObject:(id)object;
- (id)initWithValue:(void *)value;
@end

LRReturnValueAction *LRA_returnObject(id object);
LRReturnValueAction *LRA_returnValue(void *value);
LRReturnValueAction *LRA_returnInt(int anInt);
LRReturnValueAction *LRA_returnInteger(NSInteger anInteger);
LRReturnValueAction *LRA_returnFloat(float aFloat);
LRReturnValueAction *LRA_returnLong(long aLong);
LRReturnValueAction *LRA_returnBool(BOOL aBool);

#ifdef LRMOCKY_SHORTHAND
#define returnObject  LRA_returnObject
#define returnsObject  LRA_returnObject
#define returnValue   LRA_returnValue
#define returnsValue   LRA_returnValue
#define returnInt     LRA_returnInt
#define returnsInt     LRA_returnInt
#define returnInteger LRA_returnInteger
#define returnsInteger LRA_returnInteger
#define returnFloat   LRA_returnFloat
#define returnsFloat   LRA_returnFloat
#define returnLong    LRA_returnLong
#define returnsLong    LRA_returnLong
#define returnBool    LRA_returnBool
#define returnsBool    LRA_returnBool
#endif
