//
//  PasswordReminderViewController.h
//  PasswordGestures
//
//  Created by Cory Wiles on 12/28/10.
//  Copyright 2010 Wiles, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface KellerPasswordReminderViewController : UICollectionViewController

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) NSMutableArray *imageAssets;

@end
