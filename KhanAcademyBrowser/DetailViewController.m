//
//  DetailViewController.m
//  KhanAcademyBrowser
//
//  Created by Paul Agron on 1/15/15.
//  Copyright (c) 2015 Paul Agron. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(Badge*)newDetailItem {
  if (_detailItem != newDetailItem) {
      _detailItem = newDetailItem;
          
      // Update the view.
      [self configureView];
  }
}

- (void)configureView {
  // Update the user interface for the detail item.
  if (self.detailItem) {
    self.detailDescriptionLabel.text = self.detailItem.extendedDescription;
    self.imageView.image = [UIImage imageWithData:_detailItem.largeImage];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  [self configureView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
