//
//  PasswordGesturesViewController.h
//  PasswordGestures
//
//  Created by Cory Wiles on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KellerSetPasswordViewController.h"
#import "KellerPasswordReminderViewController.h"

@interface KellerViewController : UIViewController

- (void)presentSetPasswordViewController;
- (void)presentReminderPasswordViewController;

@end