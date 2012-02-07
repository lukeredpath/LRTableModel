//
//  LRImposterizer.h
//  Mocky
//
//  Created by Luke Redpath on 24/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LRImposterizerDelegate
- (BOOL)shouldActAsImposterForInvocation:(NSInvocation *)invocation;
- (void)handleImposterizedInvocation:(NSInvocation *)invocation;
@end

@interface LRImposterizer : NSObject {
  id<LRImposterizerDelegate> delegate;
}
@property (nonatomic, assign) id<LRImposterizerDelegate> delegate;

- (LRImposterizer *)matchingImposterizer;
@end
