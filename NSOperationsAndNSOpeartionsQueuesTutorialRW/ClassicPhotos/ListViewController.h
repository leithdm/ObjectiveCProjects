//
//  ListViewController.h
//  ClassicPhotos
//
//  Created by Soheil M. Azarpour on 8/11/12.
//  Copyright (c) 2012 iOS Developer. All rights reserved.
//

// 1: Import UIKit and Core Image.
#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

// 2: For convenience, define kDatasourceURLString as the string URL of where the datasource file is located.
#define kDatasourceURLString @"https://sites.google.com/site/soheilsstudio/tutorials/nsoperationsampleproject/ClassicPhotosDictionary.plist"

// 3: Make ListViewController a subclass of UITableViewController, by substituting NSObject to UITableViewController.
@interface ListViewController : UITableViewController

// 4: Declare an instance of NSDictionary. This will be the data source.
@property (nonatomic, strong) NSDictionary *photos; // main data source of controller
@end