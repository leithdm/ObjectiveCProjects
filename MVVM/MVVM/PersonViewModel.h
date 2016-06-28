//
//  PersonViewModel.h
//  MVVM
//
//  Created by Darren Leith on 08/06/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface PersonViewModel : NSObject

- (instancetype)initWithPerson:(Person *)person;

@property (nonatomic, readonly) Person *person;
@property (nonatomic, readonly) NSString *nameText;
@property (nonatomic, readonly) NSString *birthdateText; 

@end
