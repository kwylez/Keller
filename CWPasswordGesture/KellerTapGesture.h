//
//  TapGesture.h
//  PasswordGestures
//
//  Created by Cory Wiles on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KellerConstants.h"

@interface KellerTapGesture : NSObject <NSCoding>

@property KellerUIGestureType tapGesture;

- (BOOL)isEqualToTapGesture:(KellerTapGesture *)aTapGesture;

@end
