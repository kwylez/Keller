//
//  CWViewController.m
//  CWPasswordGesture
//
//  Created by Cory D. Wiles on 10/7/13.
//  Copyright (c) 2013 Cory D. Wiles. All rights reserved.
//

#import "CWViewController.h"

#import "KellerPasswordReminderViewController.h"
#import "KellerSetPasswordViewController.h"

@interface CWViewController()

@property (nonatomic, strong) UIButton *reminderButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *viewProtectedContentButton;
@property (nonatomic, strong) UIButton *createPasswordButton;

- (void)presentReminderController:(id)sender;
- (void)presentCreatedPasswordController:(id)sender;
- (void)addConstraintsForView;

@end

@implementation CWViewController

- (instancetype)init {
  
  self = [super init];
  
  if (self) {
    
    self.title = NSLocalizedString(@"Reset Password", nil);
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  
  return self;
}

- (void)loadView {

  self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  
  self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {

  [super viewDidLoad];
  
  self.reminderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

  self.reminderButton.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self.reminderButton setTitle:@"Reset" forState:UIControlStateNormal];
  
  self.reminderButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];

  [self.reminderButton addTarget:self
          action:@selector(presentReminderController:)
forControlEvents:UIControlEventTouchUpInside];

  [self.view addSubview:self.reminderButton];
  
  self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  
  self.loginButton.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
  
  self.loginButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
  
  [self.loginButton addTarget:self
                          action:@selector(presentReminderController:)
                forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:self.loginButton];
  
  self.viewProtectedContentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  
  self.viewProtectedContentButton.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self.viewProtectedContentButton setTitle:@"Protected" forState:UIControlStateNormal];
  
  self.viewProtectedContentButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
  
  [self.viewProtectedContentButton addTarget:self
                       action:@selector(presentReminderController:)
             forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:self.viewProtectedContentButton];
  
  self.createPasswordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  
  self.createPasswordButton.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self.createPasswordButton setTitle:@"Create" forState:UIControlStateNormal];
  
  self.createPasswordButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
  
  [self.createPasswordButton addTarget:self
                                      action:@selector(presentCreatedPasswordController:)
                            forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:self.createPasswordButton];
  
  [self addConstraintsForView];
}

#pragma mark - Private Methods

- (void)presentReminderController:(id)__unused sender {

  KellerPasswordReminderViewController *reminder = [[KellerPasswordReminderViewController alloc] initWithCollectionViewLayout:nil];
  
  reminder.reset = YES;
  
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:reminder];
  
  [self presentViewController:navController animated:YES completion:nil];
}

- (void)presentCreatedPasswordController:(id)__unused sender {

  KellerSetPasswordViewController *password = [[KellerSetPasswordViewController alloc] init];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:password];
  
  [self presentViewController:navController animated:YES completion:nil];
}

- (void)addConstraintsForView {

  NSDictionary *userViewDictionary = NSDictionaryOfVariableBindings(_reminderButton, _loginButton, _viewProtectedContentButton, _createPasswordButton);
  NSArray *userViewConstraints     = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_createPasswordButton]-[_loginButton(==_createPasswordButton)]-[_viewProtectedContentButton(==_loginButton)]-[_reminderButton(==_loginButton)]-|"
                                                                             options:NSLayoutFormatAlignAllCenterX
                                                                             metrics:nil
                                                                               views:userViewDictionary];
  
  [self.view addConstraints:userViewConstraints];
  
  userViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_createPasswordButton]-|"
                                                                options:NSLayoutFormatAlignAllCenterY
                                                                metrics:nil
                                                                  views:userViewDictionary];
  [self.view addConstraints:userViewConstraints];
}

@end
