//
//  DetailViewController.h
//  KhanAcademyBrowser
//
//  Created by Paul Agron on 1/15/15.
//  Copyright (c) 2015 Paul Agron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Badge.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Badge* detailItem;
@property (weak, nonatomic) IBOutlet UILabel* detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView* imageView;
@end

