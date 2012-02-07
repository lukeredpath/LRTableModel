# Mocky, an Objective-C mock object library

Mocky is an Objective-C mock object library based on the [jMock](http://jmock.org) Java library. It was built with the following goals in mind:

* An API that matches the jMock API as closely as possible
* Works out of the box with SenTestCase, allow adapters for other testing frameworks
* Support for Objective-C blocks
* Hamcrest matcher support built right in
* Sequences and state support

## Requirements

Currently, Mocky only builds for iOS 4.0. The aim is to produce builds for iOS 4.0 and OSX 10.6 and above.

Mocky can still be used to develop applications that run on older systems (including the iPad on iOS 3.2) however your Unit Test bundle's Base SDK will need to be set to iOS 4.0 or OSX 10.6 respectively.

Because Mocky depends on Hamcrest, which is partly written in Objective-C++, the -lstdc++ linker flag will need to be added to your test target.

## A simple example

Mocky is still in the early stages of development; the best way of getting an idea of what features are supported is to take a look at the functional tests. Here's a simple example that expects a method to be called.

    - (void)testSuccessfulMocking
    {
      LRMockery *context = [LRMockery mockeryForTestCase:self];

      id testObject = [context mock:[NSString class] named:@"My Mock String"];

      [context checking:^(that){
        [[oneOf(testObject) receives] uppercaseString];
      }];

      [testObject uppercaseString];
      [context assertSatisfied];
    }

Mocks can also be configured to return values:

    [context checking:^(that){
      [[oneOf(testObject) receives] doSomething]; andThen(returnsObject(@"FOOBAR"));
    }];
    
    assertThat([testObject doSomething], equalTo(@"FOOBAR"));
    
Or perform a block:

    __block id outsideTheBlock = nil;
    
    [context checking:^(that){
      [[oneOf(testObject) receives] uppercaseString]; andThen(performsBlock(^(NSInvocation *invocation) {
        outsideTheBlock = @"FOOBAR";
      }));
    }];
    
    [testObject uppercaseString];
    [context assertSatisfied];
    
    assertThat(outsideTheBlock, equalTo(@"FOOBAR"));
    
## Credits and Licence

This library is licensed under the MIT license.

This library would not exist if it were not for jMock and all of [it's contributors](http://www.jmock.org/team.html), so thanks to them. 

Also a massive thanks to Steve Freeman and Nat Pryce for their excellent book [Growing Object Oriented Software, Guided by Tests](http://www.growing-object-oriented-software.com/) which not only introduced me to jMock but is a great example of how to do TDD with mock objects well. I highly recommend you buy this book if you want to improve your TDD skills.

A version of the AuctionSniper application developed in the book that I developed using iOS/Objective-C can be found [here](http://github.com/lukeredpath/iPhoneAuctionSniper).

