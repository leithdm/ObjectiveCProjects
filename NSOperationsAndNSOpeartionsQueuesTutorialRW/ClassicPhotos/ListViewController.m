//
//  ListViewController.m
//  ClassicPhotos
//
//  Created by Soheil M. Azarpour on 8/11/12.
//  Copyright (c) 2012 iOS Developer. All rights reserved.
//

#import "ListViewController.h"

@implementation ListViewController
// 1: Synthesize photos.
@synthesize photos = _photos;

#pragma mark -
#pragma mark - Lazy instantiation

// 2: Use lazy instantiation to load data source, i.e. photos dictionary.
- (NSDictionary *)photos {
    
    if (!_photos) {
        NSURL *dataSourceURL = [NSURL URLWithString:kDatasourceURLString];
        _photos = [[NSDictionary alloc] initWithContentsOfURL:dataSourceURL];
    }
    return _photos;
}


#pragma mark -
#pragma mark - Life cycle

- (void)viewDidLoad {
    // 3: Give your view a title.
    self.title = @"Classic Photos";

    // 3.1: Set the height of rows in table view to 80.0 points.
    self.tableView.rowHeight = 80.0;
    [super viewDidLoad];
}


- (void)viewDidUnload {
    // 4: Set photos to nil when ListViewController is unloaded.
    [self setPhotos:nil];
    [super viewDidUnload];
}


#pragma mark -
#pragma mark - UITableView data source and delegate methods

// 5: Return the number of rows to be displayed.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.photos.count;
    return count;
}

// 6: This is an optional UITableViewDelegate method. For better viewing, change the height of each row to 80.0. The default value is 44.0.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellIdentifier = @"Cell Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // 7: Get the key from the dictionary, create the NSURL from value of the key, and download the image as NSData.
    NSString *rowKey = [[self.photos allKeys] objectAtIndex:indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:[self.photos objectForKey:rowKey]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = nil;
    
    // 8: If you have successfully downloaded the data, create the image, and apply sepia filter.
    if (imageData) {
        UIImage *unfiltered_image = [UIImage imageWithData:imageData];
        image = [self applySepiaFilterToImage:unfiltered_image];
    }
    
    cell.textLabel.text = rowKey;
    cell.imageView.image = image;
    
    return cell;
}


#pragma mark -
#pragma mark - Image filtration

// 9: This method applies sepia filter to the image. If you would like to know more about Core Image filters, you can read Beginning Core Image in iOS 5 Tutorial.
- (UIImage *)applySepiaFilterToImage:(UIImage *)image {
    
    CIImage *inputImage = [CIImage imageWithData:UIImagePNGRepresentation(image)];
    UIImage *sepiaImage = nil;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, inputImage, @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef outputImageRef = [context createCGImage:outputImage fromRect:[outputImage extent]];
    sepiaImage = [UIImage imageWithCGImage:outputImageRef];
    CGImageRelease(outputImageRef);
    return sepiaImage;
}

@end
