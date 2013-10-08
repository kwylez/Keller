//
//  CWViewController.m
//  CWPasswordGesture
//
//  Created by Cory D. Wiles on 10/7/13.
//  Copyright (c) 2013 Cory D. Wiles. All rights reserved.
//

#import "CWViewController.h"

#import "KellerPasswordReminderViewController.h"

@interface CWViewController ()

- (void)presentController:(id)sender;

@end

@implementation CWViewController

- (instancetype)init {
  
  self = [super init];
  
  if (self) {
    
    self.title = NSLocalizedString(@"Reset Password", nil);
  }
  
  return self;
}

- (void)loadView {

  self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  
  self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {

  [super viewDidLoad];
  
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  
  [btn setTitle:@"Remind me" forState:UIControlStateNormal];
  
  btn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
  btn.frame           = (CGRect){0, 0, 200, 200};
  btn.center          = self.view.center;

  [btn addTarget:self
          action:@selector(presentController:)
forControlEvents:UIControlEventTouchUpInside];

  [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)presentController:(id)__unused sender {
  
  KellerPasswordReminderViewController *reminder = [[KellerPasswordReminderViewController alloc] initWithCollectionViewLayout:nil];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:reminder];
  
  [self presentViewController:navController animated:YES completion:nil];
}

@end
