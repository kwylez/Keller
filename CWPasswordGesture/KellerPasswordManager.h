//
//  Password.h
//  PasswordGestures
//
//  Created by Cory Wiles on 11/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KellerRotateGesture.h"

@protocol KellerPasswordGestureDelegate<NSObject>

@required

- (void)saveGestureDidSucceed;
- (void)saveGestureDidFail;

@end

@interface KellerPasswordManager : NSObject {

  struct {
		unsigned int delegateSaveGestureDidSucceed:1;
		unsigned int delegateSaveGestureDidFail:1;
	} _delegateFlags;
}

@property (nonatomic, assign) id<KellerPasswordGestureDelegate> delegate;

+ (KellerPasswordManager *)sharedManager;
- (void)saveGesture:(id)gesture;

@end
