//
//  Password.h
//  PasswordGestures
//
//  Created by Cory Wiles on 11/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^KellerResetPasswordCompletionBlock)(BOOL successful);

@protocol KellerPasswordGestureDelegate<NSObject>

@required

- (void)saveGestureDidSucceedWithGesture:(id)gesture;
- (void)saveGestureDidFailWithGesture:(id)gesture;

@end

@interface KellerPasswordManager : NSObject {

  struct {
		unsigned int delegateSaveGestureDidSucceed:1;
		unsigned int delegateSaveGestureDidFail:1;
	} _delegateFlags;
}

@property (nonatomic, weak) id<KellerPasswordGestureDelegate> delegate;

+ (KellerPasswordManager *)sharedManager;
- (void)saveGesture:(id)gesture;
- (void)resetPasswordWithCompletionBlock:(KellerResetPasswordCompletionBlock)block;


@end
