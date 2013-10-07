//
//  PinchGesture.m
//  PasswordGestures
//
//  Created by Cory Wiles on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KellerPinchGesture.h"

@implementation KellerPinchGesture

- (id)init {
  
  if (self = [super init]) {

		_isZoomOut       = NO;
    _gestureScale    = 0.0f;
    _gestureVelocity = 0.0f;
  }
  
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  
  [aCoder encodeBool:self.isZoomOut forKey:KellerPinchGestureIsZoomKey];
  [aCoder encodeFloat:self.gestureScale forKey:KellerPinchGestureScaleKey];
  [aCoder encodeFloat:self.gestureVelocity forKey:KellerPinchGestureVelocity];
  [aCoder encodeInt:self.pinchGesture forKey:KellerPinchGestureIsPinchGestureKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
  
	if (self = [super init]) {

    self.isZoomOut       = [decoder decodeBoolForKey:KellerPinchGestureIsZoomKey];
    self.gestureScale    = [decoder decodeFloatForKey:KellerPinchGestureScaleKey];
    self.gestureVelocity = [decoder decodeFloatForKey:KellerPinchGestureVelocity];
    self.pinchGesture    = [decoder decodeIntForKey:KellerPinchGestureIsPinchGestureKey];
	}
	
	return self;
}

- (BOOL)isEqual:(id)other{
  
  if (other == self)
    return YES;
  
  if (!other || ![other isKindOfClass:[self class]])
    return NO;
  
  return [self isEqualToPinchGesture:other];  
}

- (BOOL)isEqualToPinchGesture:(KellerPinchGesture *)aPinchGesture {
  
  if (self == aPinchGesture)
    return YES;
  
  if (self.isZoomOut != [aPinchGesture isZoomOut])
    return NO;
  
  if (self.gestureScale != [aPinchGesture gestureScale])
    return NO;
  
  if (self.gestureVelocity != [aPinchGesture gestureVelocity])
    return NO;

  if (self.pinchGesture != [aPinchGesture pinchGesture])
    return NO;
  
  return YES;
}

- (unsigned)hash {
  return self.isZoomOut + self.gestureScale + self.gestureVelocity + self.pinchGesture;
}


@end
