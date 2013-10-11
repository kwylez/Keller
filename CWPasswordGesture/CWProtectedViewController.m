//
//  CWProtectedViewController.m
//  CWPasswordGesture
//
//  Created by Cory D. Wiles on 10/11/13.
//  Copyright (c) 2013 Cory D. Wiles. All rights reserved.
//

#import "CWProtectedViewController.h"

@interface CWProtectedViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  
  UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){10, 10, 200, 200}];
  
  label.text = NSLocalizedString(@"I'm protected", nil);
  
  [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
