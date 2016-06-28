//
//  Person.m
//  MVVM
//
//  Created by Darren Leith on 08/06/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)initWithSalutation:(NSString *)salutation firstName:(NSString *)firstName lastName:(NSString *)lastName birthdate:(NSDate *)birthdate {
	
	if (self = [super init]) {
	_salutation = salutation;
	_firstName = firstName;
	_lastName = lastName;
	_birthdate = birthdate;
	}
	return self;
}

@end
