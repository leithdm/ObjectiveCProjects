//
//  Person.h
//  MVVM
//
//  Created by Darren Leith on 08/06/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

- (instancetype)initWithSalutation:(NSString *)salutation firstName:(NSString *)firstName lastName:(NSString *)lastName birthdate:(NSDate *)birthdate;

@property (nonatomic, readonly) NSString *salutation;
@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSDate *birthdate;

@end
