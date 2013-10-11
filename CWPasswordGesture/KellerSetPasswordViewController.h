//
//  SetPasswordGestureViewController.h
//  PasswordGestures
//
//  Created by Cory Wiles on 11/30/10.
//  Copyright 2010 Wiles, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keller.h"

/**
 * @todo
 * Need to add isConfirmed so that in the event of a viewDidUnload or memorywarning
 * I can release and nil out the confirmPasswordArray.
 *
 * Also need to research how to handle if a call comes in or the app enters the background
 */

@interface KellerSetPasswordViewController : UIViewController <UIGestureRecognizerDelegate, KellerPasswordGestureDelegate>

@property (nonatomic, assign, getter = isLogin) BOOL login;

@end
