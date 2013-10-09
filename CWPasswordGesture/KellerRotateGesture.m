//
//  RotateGesture.m
//  PasswordGestures
//
//  Created by Cory Wiles on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KellerRotateGesture.h"


@implementation KellerRotateGesture

@synthesize isRightRotation;
@synthesize rotateGesture;

- (id)init {
  
  if (self = [super init]) {
		self.isRightRotation = NO;
  }
  
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  
  [aCoder encodeBool:self.isRightRotation forKey:KellerRotateGestureIsRightKey];
  [aCoder encodeInt:self.rotateGesture forKey:KellerRotateGestureIsRotateGestureKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
  
	if (self = [super init]) {

		self.isRightRotation = [decoder decodeBoolForKey:KellerRotateGestureIsRightKey];
    self.rotateGesture   = [decoder decodeIntForKey:KellerRotateGestureIsRotateGestureKey];
	}
	
	return self;
}

- (BOOL)isEqual:(id)other{
  
  if (other == self)
    return YES;
  
  if (!other || ![other isKindOfClass:[self class]])
    return NO;
  
  return [self isEqualToRotateGesture:other];  
}

- (BOOL)isEqualToRotateGesture:(KellerRotateGesture *)aRotateGesture {
  
  if (self == aRotateGesture)
    return YES;
  
  if (rotateGesture != [aRotateGesture rotateGesture])
    return NO;
  
  if (isRightRotation != [aRotateGesture isRightRotation])
    return NO;
  
  return YES;
}

- (NSUInteger)hash {
  return isRightRotation ^ rotateGesture;
}

@end
