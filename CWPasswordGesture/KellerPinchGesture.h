//
//  PinchGesture.h
//  PasswordGestures
//
//  Created by Cory Wiles on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KellerConstants.h"

@interface KellerPinchGesture : NSObject <NSCoding>

@property (nonatomic) BOOL isZoomOut;
@property (nonatomic, assign) CGFloat gestureScale;
@property (nonatomic, assign) CGFloat gestureVelocity;
@property KellerUIGestureType pinchGesture;

- (BOOL)isEqualToPinchGesture:(KellerPinchGesture *)aPinchGesture;

@end
