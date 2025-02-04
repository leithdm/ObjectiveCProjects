//
//  main.m
//  NetworkTest
//
//  Created by Darren Leith on 04/07/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {

		
		
		NSString *url = @"https://lethalapps.com";
		NSURLSession *session = [NSURLSession sharedSession];
		
		NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
			
			if (error != nil) {
				NSLog(@"%@ %@", error.localizedDescription, [error userInfo]);
				return;
			}
			
			NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
			
		}];
		
		[task resume];
		

	return 0;
}
