//
//  PersonViewController.h
//  MVVM
//
//  Created by Darren Leith on 08/06/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "PersonViewModel.h"

@interface PersonViewController : UIViewController

@property (strong, atomic) Person *model;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdateLabel;
@property (weak, nonatomic) PersonViewModel *viewModel; 

@end
