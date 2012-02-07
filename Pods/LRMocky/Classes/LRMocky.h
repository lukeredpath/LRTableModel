//
//  Protocol.h
//  Mocky
//
//  Created by Luke Redpath on 26/07/2010.
//  Copyright (c) 2010 LJR Software Limited. All rights reserved.
//

// base classes
#import "LRMockery.h"
#import "LRExpectationBuilder.h"

// actions
#import "LRReturnValueAction.h"
#import "LRPerformBlockAction.h"
#import "LRConsecutiveCallAction.h"
#import "LRMultipleAction.h"
#import "LRPerformBlockArgumentAction.h"

// state machine
#import "LRMockyStates.h"

#if !(TARGET_IPHONE_SIMULATOR)
#import "LRThrowExceptionAction.h"
#endif
