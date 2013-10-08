//
//  PasswordGesturesViewController.m
//  PasswordGestures
//
//  Created by Cory Wiles on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KellerViewController.h"
#import "KellerConstants.h"

@implementation KellerViewController

- (void)loadView {

  UIView *mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];

	mainView.backgroundColor = [UIColor blackColor];
	
	self.view = mainView;
}

- (void)viewDidLoad {
  
	[super viewDidLoad];
  
  /**
   * Iterate over NSUserDefaults
   */

  NSUserDefaults *prefs       = [NSUserDefaults standardUserDefaults];
  NSData *passwordGestureData = [prefs objectForKey:KellerPasswordGestureKey];
  
  if (passwordGestureData != nil) {
    
    NSArray *gestsArray = [NSKeyedUnarchiver unarchiveObjectWithData:passwordGestureData];
    
    if (gestsArray != nil) {
      
      for (id obj in gestsArray) {
        NSLog(@"object in password: %@", obj);
      }
    }
  }
  
  /**
   * End of debugging
   */
  
  UIButton *setPasswordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  
  setPasswordButton.frame = CGRectMake(20, 100, 200, 40);

  [setPasswordButton setTitle:NSLocalizedString(@"Set Password", nil)
                     forState:UIControlStateNormal];
  [setPasswordButton addTarget:self action:@selector(presentSetPasswordViewController)
              forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:setPasswordButton];
  
  UIButton *passReminderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  
  passReminderButton.frame = CGRectMake(20, 150, 200, 40);
  
  [passReminderButton setTitle:NSLocalizedString(@"Password Reminder", nil)
                      forState:UIControlStateNormal];
  [passReminderButton addTarget:self
                         action:@selector(presentReminderPasswordViewController)
               forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:passReminderButton];
}

#pragma mark -
#pragma mark Custom Methods

- (void)presentSetPasswordViewController {
  
  KellerSetPasswordViewController *setPass = [[KellerSetPasswordViewController alloc] init];
  
  setPass.title = @"Set Password";
  
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:setPass];
  
  [self presentViewController:navController animated:YES completion:nil];
}

- (void)presentReminderPasswordViewController {
  
  KellerPasswordReminderViewController *reminder = [[KellerPasswordReminderViewController alloc] init];
  
  [self presentViewController:reminder animated:YES completion:nil];
}

@end
