//
//  CWProtectedViewController.m
//  CWPasswordGesture
//
//  Created by Cory D. Wiles on 10/11/13.
//  Copyright (c) 2013 Cory D. Wiles. All rights reserved.
//

#import "CWProtectedViewController.h"

@interface CWProtectedViewController ()

- (void)done:(id)sender;

@end

@implementation CWProtectedViewController

- (id)init {
  
  self = [super init];
  
  if (self) {
    
  }
  
  return self;
}

- (void)loadView {

  self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  
  self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self action:@selector(done:)];
  self.navigationItem.leftBarButtonItem = doneButtonItem;
  
  UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){10, 10, 200, 200}];
  
  label.text = NSLocalizedString(@"I'm protected", nil);
  
  [self.view addSubview:label];
}

#pragma mark - Private Methods

- (void)done:(id)__unused sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
