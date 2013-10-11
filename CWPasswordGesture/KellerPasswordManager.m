//
//  Password.m
//  PasswordGestures
//
//  Created by Cory Wiles on 11/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KellerPasswordManager.h"
#import "KellerConstants.h"
#import "KellerSwipeGesture.h"

@interface KellerPasswordManager()

- (void)saveGestureToNSUserDefaults:(id)gesture reset:(BOOL)resetFlag withCompletionBlock:(KellerResetPasswordCompletionBlock)block;
- (NSMutableArray *)currentPassword;

@end

@implementation KellerPasswordManager

+ (KellerPasswordManager *)sharedManager {
  
  static KellerPasswordManager *_defaultManager = nil;
  static dispatch_once_t oncePredicate;
  
  dispatch_once(&oncePredicate, ^{
    _defaultManager = [[KellerPasswordManager alloc] init];
  });
  
  return _defaultManager;
}

- (void)setDelegate:(id<KellerPasswordGestureDelegate>)delegate {
  
  _delegate = delegate;
  
  _delegateFlags.delegateSaveGestureDidSucceed = [_delegate respondsToSelector:@selector(saveGestureDidSucceedWithGesture:)];
  _delegateFlags.delegateSaveGestureDidFail    = [_delegate respondsToSelector:@selector(saveGestureDidFailWithGesture:)];
}

#pragma mark - Public Methods

- (void)saveGesture:(id)gesture {
	[self saveGestureToNSUserDefaults:gesture reset:NO withCompletionBlock:nil];
}

- (void)resetPasswordWithCompletionBlock:(KellerResetPasswordCompletionBlock)block {

  KellerSwipeGesture *swipeGesture = [[KellerSwipeGesture alloc] init];
  
  swipeGesture.swipeGesture = KellerUISwipeDownGesture;

  [self saveGestureToNSUserDefaults:swipeGesture reset:YES withCompletionBlock:^(BOOL successful){
  
    if (block) {
      block(successful);
    }
  }];
}

#pragma mark - Private Methods

- (NSMutableArray *)currentPassword {
  
  NSUserDefaults *prefs       = [NSUserDefaults standardUserDefaults];
  NSData *passwordGestureData = [prefs objectForKey:KellerPasswordGestureKey];
  
  NSMutableArray *passwordArray;
  
  if (passwordGestureData != nil) {
    
    NSArray *gestsArray = [NSKeyedUnarchiver unarchiveObjectWithData:passwordGestureData];
    
    if (gestsArray != nil) {
      passwordArray = [[NSMutableArray alloc] initWithArray:gestsArray];
    }
    
    NSLog(@"notesData isn't nil");
    
  } else {
    
    passwordArray = [NSMutableArray new];
  }
  
  return passwordArray;
}

- (void)saveGestureToNSUserDefaults:(id)gesture reset:(BOOL)resetFlag withCompletionBlock:(KellerResetPasswordCompletionBlock)block {

  NSUserDefaults *prefs         = [NSUserDefaults standardUserDefaults];
  NSMutableArray *passwordArray = [self currentPassword];
  
  if (resetFlag) {
    [passwordArray removeAllObjects];
  }
  
  [passwordArray addObject:gesture];
  
  NSLog(@"count of passwordArray: %lu", (unsigned long)[passwordArray count]);
  
  NSData *finalData = [NSKeyedArchiver archivedDataWithRootObject:passwordArray];
  
  [prefs setObject:finalData forKey:KellerPasswordGestureKey];
  
  if ([prefs synchronize]) {
    
    if (_delegateFlags.delegateSaveGestureDidSucceed) {
      [_delegate saveGestureDidSucceedWithGesture:gesture];
    }
    
    if (block) {
      block(YES);
    }
    
  } else {
    
    if (_delegateFlags.delegateSaveGestureDidFail) {
      [_delegate saveGestureDidFailWithGesture:gesture];
    }
    
    if (block) {
      block(NO);
    }
  }
}

@end
