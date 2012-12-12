//
//  LRTableViewModelEventListener.h
//  TableViewModel
//
//  Created by Luke Redpath on 09/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRTableModelEvent.h"

@protocol LRTableModelEventListener <NSObject>

- (void)tableModelChanged:(LRTableModelEvent *)changeEvent;

@optional
- (void)tableModelWillBeginUpdates;
- (void)tableModelDidEndUpdates;

@end
