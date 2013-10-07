//
//  PanGesture.m
//  PasswordGestures
//
//  Created by Cory Wiles on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KellerPanGesture.h"


@implementation KellerPanGesture

@synthesize panGesture;
@synthesize numberOfTouches;

- (void)encodeWithCoder:(NSCoder *)aCoder {
  
  [aCoder encodeInt:self.panGesture forKey:KellerPanGestureIsPanGestureKey];
  [aCoder encodeInt:self.numberOfTouches forKey:KellerPanGestureNumberOfTouches];
}

- (id)initWithCoder:(NSCoder *)decoder {
  
	if (self = [super init]) {
    
    self.panGesture      = [decoder decodeIntForKey:KellerPanGestureIsPanGestureKey];
    self.numberOfTouches = [decoder decodeIntForKey:KellerPanGestureNumberOfTouches];
	}
	
	return self;
}

- (BOOL)isEqualToPanGesture:(KellerPanGesture *)aPanGesture {
  
  if (self == aPanGesture)
    return YES;

  if (panGesture != [aPanGesture panGesture])
    return NO;

  if (numberOfTouches != [aPanGesture numberOfTouches])
    return NO;
  
  return YES;
}

- (BOOL)isEqual:(id)other{
  
  if(other == self)
    return YES;
  
  if(!other || ![other isKindOfClass:[self class]])
    return NO;
  
  return [self isEqualToPanGesture:other];  
}

- (unsigned)hash {
  return panGesture ^ numberOfTouches;
}

@end
