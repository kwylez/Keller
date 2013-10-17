//
//  CWViewController.m
//  CWPasswordGesture
//
//  Created by Cory D. Wiles on 10/7/13.
//  Copyright (c) 2013 Cory D. Wiles. All rights reserved.
//

#import "KellerViewController.h"

#import "KellerPasswordReminderViewController.h"
#import "KellerSetPasswordViewController.h"
#import "CWProtectedViewController.h"

@interface KellerViewController()

@property (nonatomic, strong) UIButton *reminderButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *viewProtectedContentButton;
@property (nonatomic, strong) UIButton *createPasswordButton;
@property (nonatomic, strong) UIButton *resetButton;

- (void)presentReminderController:(id)sender;
- (void)presentCreatedPasswordController:(id)sender;
- (void)presentResetController:(id)sender;
- (void)presentLoginController:(id)sender;
- (void)presentProtectedController:(id)sender;
- (void)logout:(id)sender;
- (void)addConstraintsForView;

@end

@implementation KellerViewController

- (instancetype)init {
  
  self = [super init];
  
  if (self) {
    
    self.title = NSLocalizedString(@"Welcome to Keller", nil);
    
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
  
  [self.reminderButton setTitle:@"Reminder" forState:UIControlStateNormal];
  
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
                       action:@selector(presentLoginController:)
             forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:self.loginButton];
  
  self.viewProtectedContentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  
  self.viewProtectedContentButton.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self.viewProtectedContentButton setTitle:@"Protected" forState:UIControlStateNormal];
  
  self.viewProtectedContentButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
  
  [self.viewProtectedContentButton addTarget:self
                                      action:@selector(presentProtectedController:)
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
  
  self.resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  
  self.resetButton.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self.resetButton setTitle:@"Reset" forState:UIControlStateNormal];
  
  self.resetButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
  
  [self.resetButton addTarget:self
                       action:@selector(presentResetController:)
             forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:self.resetButton];
  
  [self addConstraintsForView];
}

- (void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  
  
  
  UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(logout:)];
  
  self.navigationItem.rightBarButtonItem         = doneButtonItem;
  self.navigationItem.rightBarButtonItem.enabled = NO;

  if ([KellerPasswordManager isLoggedIn]) {
    self.navigationItem.rightBarButtonItem.enabled = YES;
  }
}

#pragma mark - Private Methods

- (void)presentReminderController:(id)__unused sender {
  
  KellerPasswordReminderViewController *reminder = [[KellerPasswordReminderViewController alloc] initWithCollectionViewLayout:nil];
  
  reminder.reset = NO;
  
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:reminder];
  
  [self presentViewController:navController animated:YES completion:^{
  
    [reminder fetchRandomlySampleImagesFromGalleryWithCompletionBlock:^(NSArray *images){

      if ([images count]) {
        [reminder.collectionView reloadData];
      }
    }];
  }];
}

- (void)presentResetController:(id)__unused sender {
  
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

- (void)presentLoginController:(id)__unused sender {

  KellerSetPasswordViewController *password = [[KellerSetPasswordViewController alloc] init];
  
  password.login = YES;
  
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:password];
  
  [self presentViewController:navController animated:YES completion:nil];
}

- (void)presentProtectedController:(id)__unused sender {

  if ([KellerPasswordManager isLoggedIn]) {
    
    CWProtectedViewController *protected = [[CWProtectedViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:protected];
    
    [self presentViewController:navController animated:YES completion:nil];
    
  } else {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Protected", nil)
                                                        message:NSLocalizedString(@"You aren't logged in", nil)
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
  }
}

- (void)logout:(id)__unused sender {
  
  [[KellerPasswordManager sharedManager] logoutWithCompletionBlock:^(BOOL successful){
  
    NSLog(@"logout successful? %@", @(successful));
    
    if (successful) {
       self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    NSString *message = successful ? NSLocalizedString(@"Successful", nil) : NSLocalizedString(@"Failed", nil);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Logout", nil)
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
  }];
}

- (void)addConstraintsForView {
  
  NSDictionary *userViewDictionary = NSDictionaryOfVariableBindings(_reminderButton, _loginButton, _viewProtectedContentButton, _createPasswordButton, _resetButton);
  NSArray *userViewConstraints     = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_createPasswordButton]-[_reminderButton(==_createPasswordButton)]-[_loginButton(==_reminderButton)]-[_viewProtectedContentButton(==_loginButton)]-[_resetButton(==_viewProtectedContentButton)]-|"
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
