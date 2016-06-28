//
//  PersonViewModel.m
//  MVVM
//
//  Created by Darren Leith on 08/06/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

#import "PersonViewModel.h"

@implementation PersonViewModel

//we have moved the view logic into our view model

- (instancetype)initWithPerson:(Person *)person {
	
	if (self = [super init]) {
		_person = person; //readonly, so cant use self.person. Have to use _ to get access to synthesized ivar. This seems a bit silly
		
		if (person.salutation.length > 0) {
			_nameText = [NSString stringWithFormat:@"%@ %@ %@", self.person.salutation, self.person.firstName, self.person.lastName];
		} else {
			_nameText = [NSString stringWithFormat:@"%@ %@", self.person.firstName, self.person.lastName];
		}
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"EEEE MMMM d, yyyy"];
		_birthdateText = [dateFormatter stringFromDate:person.birthdate];
		
	}
	return self;
}

@end
