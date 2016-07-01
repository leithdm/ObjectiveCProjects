//
//  main.m
//  NSOperation
//
//  Created by Darren Leith on 01/07/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyNonConcurrentOperation : NSOperation
@property id myData;
-(instancetype)initWithData:(id)data;
@end

@implementation MyNonConcurrentOperation
- (instancetype)initWithData:(id)data {
	if (self = [super init])
		_myData = data;
	return self;
}

-(void)main {
	@try {
		NSLog(@"%@", self.myData);
	}
	@catch(...) {
		// Do not rethrow exceptions.
	}
}


@end

int main(int argc, const char * argv[]) {
	
	@autoreleasepool {
		
		MyNonConcurrentOperation *mnc = [[MyNonConcurrentOperation alloc]initWithData:@"Run me"];
		[mnc main];
		return 0;
	}
}
