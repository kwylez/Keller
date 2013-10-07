//
//  SwipeGesture.h
//  PasswordGestures
//
//  Created by Cory Wiles on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KellerConstants.h"

@interface KellerSwipeGesture : NSObject <NSCoding>

@property (nonatomic, assign) KellerUIGestureType swipeGesture;

- (BOOL)isEqualToSwipeGesture:(KellerSwipeGesture *)aSwipeGesture;

@end
