//
//  Password.m
//  PasswordGestures
//
//  Created by Cory Wiles on 11/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KellerPasswordManager.h"

@interface KellerPasswordManager()

 /**
	* Private Methods
	*/
- (void)saveGestureToNSUserDefaults:(id)gesture;

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
  
  _delegateFlags.delegateSaveGestureDidSucceed = [_delegate respondsToSelector:@selector(saveGestureDidSucceed)];
  _delegateFlags.delegateSaveGestureDidFail    = [_delegate respondsToSelector:@selector(saveGestureDidFail)];
}

#pragma mark - Public Methods

- (void)saveGesture:(id)gesture {
	[self saveGestureToNSUserDefaults:gesture];
}

#pragma mark - Private Methods

- (void)saveGestureToNSUserDefaults:(id)gesture {
	
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
  
  [passwordArray addObject:gesture];
  
  NSLog(@"count of passwordArray: %lu", (unsigned long)[passwordArray count]);
  
  NSData *finalData = [NSKeyedArchiver archivedDataWithRootObject:passwordArray];
  
  [prefs setObject:finalData forKey:KellerPasswordGestureKey];
  
  if ([prefs synchronize]) {
    
    if (_delegateFlags.delegateSaveGestureDidSucceed) {
      [_delegate saveGestureDidSucceed];
    }

  } else {
    
    if (_delegateFlags.delegateSaveGestureDidFail) {
      [_delegate saveGestureDidFail];
    }
  }
}

@end
