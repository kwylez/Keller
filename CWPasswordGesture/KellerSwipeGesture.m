//
//  SwipeGesture.m
//  PasswordGestures
//
//  Created by Cory Wiles on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KellerSwipeGesture.h"


@implementation KellerSwipeGesture

@synthesize swipeGesture;

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeFloat:self.swipeGesture forKey:KellerSwipeGestureIsSwipeGestureKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
  
	if (self = [super init]) {
    self.swipeGesture = [decoder decodeFloatForKey:KellerSwipeGestureIsSwipeGestureKey];
	}
	
	return self;
}

- (BOOL)isEqual:(id)other{
  
  if (other == self)
    return YES;
  
  if (!other || ![other isKindOfClass:[self class]])
    return NO;
  
  return [self isEqualToSwipeGesture:other];  
}

- (BOOL)isEqualToSwipeGesture:(KellerSwipeGesture *)aSwipeGesture {
  
  if (self == aSwipeGesture)
    return YES;
  
  if (swipeGesture != [aSwipeGesture swipeGesture])
    return NO;
  
  return YES;
}

- (NSUInteger)hash {
  return swipeGesture;
}

@end
