//
//  LRTestCase.m
//  Mocky
//
//  Created by Luke Redpath on 22/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRTestCase.h"
#import "NSException_SenTestFailure.h"

@interface SenTestCase : NSObject
- (void)failWithException:(NSException *)exception;
@end

@implementation LRSenTestCaseNotifier

+ (id)notifierForTestCase:(SenTestCase *)aTestCase;
{
  return [[[self alloc] initWithSenTestCase:aTestCase] autorelease];
}

- (id)initWithSenTestCase:(SenTestCase *)aTestCase;
{
  if (self = [super init]) {
    testCase = [aTestCase retain];
  }
  return self;
}

- (void)dealloc;
{
  [testCase release];
  [super dealloc];
}

- (void)notifiesFailureWithDescription:(NSString *)description 
                                inFile:(NSString *)fileName 
                            lineNumber:(int)lineNumber;
{
  [testCase failWithException:[NSException 
        failureInFile:fileName
               atLine:lineNumber
      withDescription:description
  ]];
}

@end
