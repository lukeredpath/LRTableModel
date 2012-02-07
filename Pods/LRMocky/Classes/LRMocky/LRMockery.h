//
//  LRMockery.h
//  LRMiniTestKit
//
//  Created by Luke Redpath on 18/07/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRExpectation.h"
#import "LRTestCase.h"

@class LRExpectationBuilder;
@class SenTestCase;
@class LRMockyStateMachine;
@class LRMockObject;


/** Represents a context in which mocks are created and verified.
 
 */
@interface LRMockery : NSObject {
  NSMutableArray *expectations;
  NSMutableArray *mockObjects;
  id<LRTestCaseNotifier> testNotifier;
}
@property (nonatomic, assign) BOOL automaticallyResetWhenAsserting;

///------------------------------------------------------------------------------------/
/// @name Creating and initializing 
///------------------------------------------------------------------------------------/

/** Creates a mocking context for a generic test case.
 
 @param testCase The current test case.
 @return An auto-released LRMockery instance.
 */
+ (id)mockeryForTestCase:(id)testCase;

/** Creates a mocking context for a SenTest test case.
 
 Mocky currently only supports SenTest and SenTest-derived frameworks so currently, 
 calling this is the same as calling mockeryForTestCase:.
 
 @param testCase The current SenTest test case.
 @return An auto-released LRMockery instance.
 */
+ (id)mockeryForSenTestCase:(SenTestCase *)testCase;

/** Initializes a new mocking context.
 
 The notifier is used to notify tests of failures or other events, and is used as an
 adapter to abstract away the underlying test framework. Different notifier 
 implementations can be used to add support for other testing frameworks.
 
 @param aNotifier A concrete notifier implementation
 @see LRTestCaseNotifier
 @return An initialized Mockery that will report failures using the given notifier.
 */
- (id)initWithNotifier:(id<LRTestCaseNotifier>)aNotifier;

///------------------------------------------------------------------------------------/
/// @name Creating mocks
///------------------------------------------------------------------------------------/

/** Creates a new class mock object.
 
 Class mocks act as stand-ins for the given class. By default, any invocations performed
 on the mock that haven't been previously configured will raise an exception.
 
 @param klass The class you wish to mock.
 @return An auto-released mock object that acts as an imposter for instances of klass.
 */
- (id)mock:(Class)klass;

/** Creates a new named class mock object.
 
 Mock objects can be given names to allow for easier identification within your tests.
 This could be useful if you have more than one mock object instance for a single Class.
 
 @param klass The class you with to mock.
 @param name A descriptive name for the mock.
 */
- (id)mock:(Class)klass named:(NSString *)name;

- (id)mock;

- (id)mockNamed:(NSString *)name;

/** Creates a new protocol mock object.
 
 Similar to a class mock, but protocol mocks only represent an object that implements
 the specified protocol. Using protocol mocks encourages your classes to not be tied
 to concrete classes.
 
 @param protocol The protocol you with to mock.
 */
- (id)protocolMock:(Protocol *)protocol;

/** Creates a partial mock for an object.
 
 A partial mock can be used to mock and stub methods on real objects, which otherwise
 act as normal objects. Stubbing can be used to return canned values from real objects
 (handy if you are unable to inject a mock in it's place).
 
 You do not generally need to call this method manually although you may if you wish.
 You can set up expectations on real objects directly and a partial mock will be 
 created automatically.
 
 In addition, any stubs configured on a partial mock will still be handled when the
 stubbed method is called directly on the original object.
 
 @warning Dynamic handling of stubbed methods on objects does not work for toll-free
 bridged classes (NSString, NSArray, NSNumber etc.).
 
 @param object The object that you wish to create a partial mock for.
 */
- (id)partialMockForObject:(id)object;

///------------------------------------------------------------------------------------/
/// @name Expecting NSNotifications
///------------------------------------------------------------------------------------/

/** Sets an expectation that a NSNotification will be posted.
 
 Whilst normal expectations are set on mock objects, Mocky has special support for
 setting notification expectations.
 
 Simply, Mocky will observe the named notification to see if was posted by the default
 NSNotificationCenter. If it is not, the expectation will fail.
 
 @param name The name of the notification you expect to be posted.
 */
- (void)expectNotificationNamed:(NSString *)name;

/** Sets an expectation that a NSNotification will be posted from a specific object.
 
 As above, although only notifications posted by the specified sender will be observed.
 
 @param name The name of the notification you expect to be posted.
 @param sender The object you expect to post the notification.
 */
- (void)expectNotificationNamed:(NSString *)name fromObject:(id)sender;

///------------------------------------------------------------------------------------/
/// @name Creating state machines
///------------------------------------------------------------------------------------/

/** Creates a new state machine.
 
 State machines can be used in conjunction with expectations to check that they only 
 occur in a certain state. 
 
 @param name A descriptive name for the state this represents.
 @see LRMockyStateMachine
 */
- (LRMockyStateMachine *)states:(NSString *)name;

/** Creates a new state machine in a default state.
 
 @param name A descriptive name for the state this represents.
 @param defaultState The default state for the state machine.
 @see states:
 */
- (LRMockyStateMachine *)states:(NSString *)name defaultTo:(NSString *)defaultState;

///------------------------------------------------------------------------------------/
/// @name Setting up expectations
///------------------------------------------------------------------------------------/

/** Starts a new expectation checking block.
 
 Checking blocks are used to configure the expectations within the current mocking
 context. 
 
 checking: can be called multiple times, all expectations created within each
 block will be appended to the previous expectations.
 
 @param expectationBlock An expectation block containing expectation calls.
 @see LRExpectationBuilder
 */
- (void)checking:(void (^)(LRExpectationBuilder *))expectationBlock;


/** Add's a new expectation to the current context.
 
 Mostly used internally to add expectations created by LRExpectationBuilder. 
 
 Most people will never need to call this manually, although if you have manually created
 an LRExpectation object you could use this to safely add it to the current context.
 
 @param expectation The expectation to add.
 */
- (void)addExpectation:(id<LRExpectation>)expectation;

///------------------------------------------------------------------------------------/
/// @name Checking expectations
///------------------------------------------------------------------------------------/

/** Evaluates all expectations to check that they are satisfied.
 
 In order for your expectations to be verified, this method needs to be called at the
 end of your test case.
 
 In order for Xcode to provide useful error information when an expectation fails, it
 needs to know the line number of file in which this method was called. To that end, 
 Mocky provides a macro, assertContextSatisfied(context) that should be called in place 
 of this method.
 
 This method will not throw an exception if an expectation fails; it will directly 
 inform the test case using the notifier it was initialized with.
 */
- (void)assertSatisfied;

///------------------------------------------------------------------------------------/
/// @name Resetting the current context
///------------------------------------------------------------------------------------/

/** Removes all expectations from the current context. */
- (void)reset;

@end

/** Calls [LRMockery assertSatisifed] on the given context, passing in the relevant file
    name and line number information. 
 
 If LRMOCKY_SUGAR is defined (recommended), you can simply call the helper macro,
 assertContextSatisifed(context), which will call this function with the correct
 file and line information for you.
 */
void LRM_assertContextSatisfied(LRMockery *context, NSString *fileName, int lineNumber);

#ifdef LRMOCKY_SUGAR
#define assertContextSatisfied(context) LRM_assertContextSatisfied(context, [NSString stringWithUTF8String:__FILE__], __LINE__)
#endif
