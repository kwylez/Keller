//
//  CWViewController.m
//  CWPasswordGesture
//
//  Created by Cory D. Wiles on 10/7/13.
//  Copyright (c) 2013 Cory D. Wiles. All rights reserved.
//

#import "CWViewController.h"

#import "KellerPasswordReminderViewController.h"

@interface CWViewController()

@property (nonatomic, strong) UIButton *reminderButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *viewProtectedContentButton;
@property (nonatomic, strong) UIButton *createPasswordButton;

- (void)presentController:(id)sender;
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
  
  [self.reminderButton setTitle:@"Remind me" forState:UIControlStateNormal];
  
  self.reminderButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];

  [self.reminderButton addTarget:self
          action:@selector(presentController:)
forControlEvents:UIControlEventTouchUpInside];

  [self.view addSubview:self.reminderButton];
  
  self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  
  self.loginButton.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
  
  self.loginButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
  
  [self.loginButton addTarget:self
                          action:@selector(presentController:)
                forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:self.loginButton];
  
  self.viewProtectedContentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  
  self.viewProtectedContentButton.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self.viewProtectedContentButton setTitle:@"Protected" forState:UIControlStateNormal];
  
  self.viewProtectedContentButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
  
  [self.viewProtectedContentButton addTarget:self
                       action:@selector(presentController:)
             forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:self.viewProtectedContentButton];
  
  self.createPasswordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  
  self.createPasswordButton.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self.createPasswordButton setTitle:@"Create Pass" forState:UIControlStateNormal];
  
  self.createPasswordButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
  
  [self.createPasswordButton addTarget:self
                                      action:@selector(presentController:)
                            forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:self.createPasswordButton];
  
  [self addConstraintsForView];
}



- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)presentController:(id)__unused sender {
  
  KellerPasswordReminderViewController *reminder = [[KellerPasswordReminderViewController alloc] initWithCollectionViewLayout:nil];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:reminder];
  
  [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)addConstraintsForView {

  NSDictionary *userViewDictionary = NSDictionaryOfVariableBindings(_reminderButton, _loginButton, _viewProtectedContentButton, _createPasswordButton);
  NSArray *userViewConstraints     = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_reminderButton]-[_loginButton(==_reminderButton)]-[_viewProtectedContentButton(==_reminderButton)]-[_createPasswordButton(==_reminderButton)]-|"
                                                                             options:NSLayoutFormatAlignAllCenterY
                                                                             metrics:nil
                                                                               views:userViewDictionary];
  
  [self.view addConstraints:userViewConstraints];
  
  userViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_reminderButton]"
                                                                options:NSLayoutFormatAlignAllCenterX
                                                                metrics:nil
                                                                  views:userViewDictionary];
  [self.view addConstraints:userViewConstraints];
}

@end
