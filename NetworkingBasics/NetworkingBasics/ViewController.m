//
//  ViewController.m
//  NetworkingBasics
//
//  Created by Darren Leith on 05/07/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	
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
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
