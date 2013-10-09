//
//  LongPressGesture.m
//  PasswordGestures
//
//  Created by Cory Wiles on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KellerLongPressGesture.h"


@implementation KellerLongPressGesture

@synthesize longPressGesture;
@synthesize numberOfSeconds;

- (void)encodeWithCoder:(NSCoder *)aCoder {
  
  [aCoder encodeFloat:self.longPressGesture forKey:KellerLongPressGestureisLongPressGestureKey];
  [aCoder encodeInt:self.numberOfSeconds forKey:KellerLongPressGestureNumberOfSecondsKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
  
	if (self = [super init]) {
    
    self.longPressGesture = [decoder decodeFloatForKey:KellerLongPressGestureisLongPressGestureKey];
    self.numberOfSeconds  = [decoder decodeIntForKey:KellerLongPressGestureNumberOfSecondsKey];
	}
	
	return self;
}

- (BOOL)isEqual:(id)other{
  
  if (other == self)
    return YES;
  
  if (!other || ![other isKindOfClass:[self class]])
    return NO;
  
  return [self isEqualToLongPressGesture:other];  
}

- (BOOL)isEqualToLongPressGesture:(KellerLongPressGesture *)aLongPressGesture {
  
  if (self == aLongPressGesture)
    return YES;
  
  if (longPressGesture != [aLongPressGesture longPressGesture])
    return NO;
  
  if (numberOfSeconds != [aLongPressGesture numberOfSeconds])
    return NO;
  
  return YES;
}

- (NSUInteger)hash {
  return longPressGesture ^ numberOfSeconds;
}

@end
