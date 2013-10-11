//
//  KellerConstants.h
//  CWPasswordGesture
//
//  Created by Cory D. Wiles on 10/7/13.
//  Copyright (c) 2013 Cory D. Wiles. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM (NSInteger, KellerUIGestureType)  {
  KellerUIPanGesture,
  KellerUITapGesture,
  KellerUIRotateGesture,
  KellerUIPinchGesture,
  KellerUISwipeDownGesture,
  KellerUISwipeUpGesture,
  KellerUISwipeLeftGesture,
  KellerUISwipeRightGesture,
  KellerUILongPressGesture,
};

extern NSString * const KellerPasswordGestureKey;
extern NSString * const KellerRotateGestureIsRightKey;
extern NSString * const KellerRotateGestureIsRotateGestureKey;
extern NSString * const KellerPinchGestureIsZoomKey;
extern NSString * const KellerPinchGestureScaleKey;
extern NSString * const KellerPinchGestureVelocity;
extern NSString * const KellerPinchGestureIsPinchGestureKey;
extern NSString * const KellerPanGestureIsPanGestureKey;
extern NSString * const KellerPanGestureNumberOfTouches;
extern NSString * const KellerTapGestureIsTapGestureKey;
extern NSString * const KellerSwipeGestureIsSwipeGestureKey;
extern NSString * const KellerLongPressGestureisLongPressGestureKey;
extern NSString * const KellerLongPressGestureNumberOfSecondsKey;
extern NSString * const KellerLoginKey;

