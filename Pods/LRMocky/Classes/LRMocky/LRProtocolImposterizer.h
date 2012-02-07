//
//  LRProtocolImposterizer.h
//  Mocky
//
//  Created by Luke Redpath on 24/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRImposterizer.h"

@interface LRProtocolImposterizer : LRImposterizer {
  Protocol *protocolToImposterize;
}
- (id)initWithProtocol:(Protocol *)protocol;
@end
