//
//  TapGesture.m
//  PasswordGestures
//
//  Created by Cory Wiles on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KellerTapGesture.h"


@implementation KellerTapGesture

@synthesize tapGesture;

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeInt:self.tapGesture forKey:KellerTapGestureIsTapGestureKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
  
	if ((self = [super init])) {
    self.tapGesture = [decoder decodeIntForKey:KellerTapGestureIsTapGestureKey];
	}
	
	return self;
}

- (BOOL)isEqual:(id)other{
  
  if(other == self)
    return YES;
  
  if(!other || ![other isKindOfClass:[self class]])
    return NO;
  
  return [self isEqualToTapGesture:other];  
}

- (BOOL)isEqualToTapGesture:(KellerTapGesture *)aTapGesture {
  
  if (self == aTapGesture)
    return YES;
  
  if (tapGesture != [aTapGesture tapGesture])
    return NO;
  
  return YES;
}

- (NSUInteger)hash {
  return tapGesture;
}

@end
