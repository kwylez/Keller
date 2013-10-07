//
//  RotateGesture.h
//  PasswordGestures
//
//  Created by Cory Wiles on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KellerConstants.h"

@interface KellerRotateGesture : NSObject <NSCoding>

@property (nonatomic) BOOL isRightRotation;
@property (nonatomic, assign) KellerUIGestureType rotateGesture;

- (BOOL)isEqualToRotateGesture:(KellerRotateGesture *)aRotateGesture;

@end
