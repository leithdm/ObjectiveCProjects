//
//  MVVMTests.m
//  MVVMTests
//
//  Created by Darren Leith on 08/06/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"
#import "PersonViewModel.h"


@interface MVVMTests : XCTestCase

@end

@implementation MVVMTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
	NSString *salutation = @"Dr";
	NSString *firstName = @"first";
	NSString *lastName = @"last";
	NSDate *birthdate = [NSDate dateWithTimeIntervalSince1970:5];
	
	Person *p = [[Person alloc] initWithSalutation:salutation firstName:firstName lastName:lastName birthdate:birthdate];
	PersonViewModel *pvm = [[PersonViewModel alloc]initWithPerson:p];
	XCTAssertEqualObjects(pvm.nameText, @"Dr first last"); //note we are testing for equal objects here ..!
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
