    //
//  SetPasswordGestureViewController.m
//  PasswordGestures
//
//  Created by Cory Wiles on 11/30/10.
//  Copyright 2010 Wiles, LLC. All rights reserved.
//

#import "KellerSetPasswordViewController.h"

static CGSize const pointSize = (CGSize){44.0f, 44.0f};

@interface KellerSetPasswordViewController()

@property (nonatomic, strong) NSMutableArray *previousLocations;

- (void)handleRotationGesture:(UIRotationGestureRecognizer *)gesture;
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)gesture;
- (void)handleTapGesture:(UITapGestureRecognizer *)gesture;
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture;
- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)gesture;
- (void)handleSwipeRightGesture:(UISwipeGestureRecognizer *)gesture;
- (void)handleSwipeUpGesture:(UISwipeGestureRecognizer *)gesture;
- (void)handleSwipeDownGesture:(UISwipeGestureRecognizer *)gesture;
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture;
- (void)incrementNumOfSeconds;
- (BOOL)arePasswordsEqualed;

@end

@implementation KellerSetPasswordViewController

@synthesize confirming = _confirming;

- (void)dealloc {

  _passwordManager.delegate = nil;
  
  [self.timer invalidate];
  
  _timer = nil;
}

- (id)init {
  
  self = [super init];
  
  if (self) {

    _passwordManager = [KellerPasswordManager sharedManager];
    
    _passwordManager.delegate = self;
    
    _previousLocations    = [NSMutableArray new];
    _confirmPasswordArray = [NSMutableArray new];
    _passwordGestures     = [NSMutableArray new];
  }
  
  return self;
}

- (void)loadView {
  
  UIView *mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  
	mainView.backgroundColor = [UIColor blackColor];
	
	self.view = mainView;

  self.view.multipleTouchEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
  
  _confirming = NO;
  
  [self.confirmPasswordArray removeAllObjects];
  [self.passwordGestures removeAllObjects];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
  
  UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                    target:self action:@selector(cancelSettingPassword)];
  self.navigationItem.leftBarButtonItem = cancelButtonItem;
  
  UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" 
                                                                     style:UIBarButtonItemStyleDone 
                                                                    target:self 
                                                                    action:@selector(confirmingPasswordAction)];
  
  self.navigationItem.rightBarButtonItem         = doneButtonItem;
  self.navigationItem.rightBarButtonItem.enabled = NO;
  
  self.numSeconds = 0 ;

	/**
	 * Rotation Gesture
	 */

	UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self 
                                                                                              action:@selector(handleRotationGesture:)];
  
  rotationGesture.delegate             = self;
  rotationGesture.cancelsTouchesInView = NO;
	
	[self.view addGestureRecognizer:rotationGesture];
	
	/**
	 * Pinch Gesture
	 */

	UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handlePinchGesture:)];
  
  pinchGesture.delegate             = self;
	pinchGesture.cancelsTouchesInView = NO;

	[self.view addGestureRecognizer:pinchGesture];
	
	/**
	 * Tap Gesture
	 */
	
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(handleTapGesture:)];
  
	tapGesture.numberOfTapsRequired    = 1;
	tapGesture.numberOfTouchesRequired = 1;
  tapGesture.delegate                = self;
  tapGesture.cancelsTouchesInView    = NO;
	
	[self.view addGestureRecognizer:tapGesture];
	
	/**
	 * Swipe Gesture - Right
	 */

	UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self 
                                                                                          action:@selector(handleSwipeRightGesture:)];
  
	rightSwipeGesture.direction							  = UISwipeGestureRecognizerDirectionRight;
	rightSwipeGesture.numberOfTouchesRequired = 1;
  rightSwipeGesture.delegate                = self;
  rightSwipeGesture.cancelsTouchesInView    = NO;
	
	[self.view addGestureRecognizer:rightSwipeGesture];

	
	/**
	 * Swipe Gesture - Left
	 */

	UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(handleSwipeLeftGesture:)];
	
	leftSwipeGesture.direction							 = UISwipeGestureRecognizerDirectionLeft;
	leftSwipeGesture.numberOfTouchesRequired = 1;
  leftSwipeGesture.delegate                = self;
  leftSwipeGesture.cancelsTouchesInView    = NO;
	
	[self.view addGestureRecognizer:leftSwipeGesture];
	
	/**
	 * Swipe Gesture - Down
	 */

	UISwipeGestureRecognizer *downSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self 
                                                                                         action:@selector(handleSwipeDownGesture:)];
	
	downSwipeGesture.direction							 = UISwipeGestureRecognizerDirectionDown;
	downSwipeGesture.numberOfTouchesRequired = 1;
  downSwipeGesture.delegate                = self;
  downSwipeGesture.cancelsTouchesInView    = NO;
	
	[self.view addGestureRecognizer:downSwipeGesture];
	
	/**
	 * Swipe Gesture - Up
	 */

	UISwipeGestureRecognizer *upSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self 
                                                                                       action:@selector(handleSwipeUpGesture:)];
	
	upSwipeGesture.direction							 = UISwipeGestureRecognizerDirectionUp;
	upSwipeGesture.numberOfTouchesRequired = 1;
  upSwipeGesture.delegate                = self;
  upSwipeGesture.cancelsTouchesInView    = NO;
	
	[self.view addGestureRecognizer:upSwipeGesture];
	
	/**
	 * Pan Gesture
	 */

	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self 
                                                                               action:@selector(handlePanGesture:)];
	
	panGesture.minimumNumberOfTouches = 2;
	panGesture.maximumNumberOfTouches = 4;
  panGesture.delegate               = self;
  panGesture.cancelsTouchesInView   = NO;
	
	[self.view addGestureRecognizer:panGesture];
	
	/**
	 * Long Press Gesture
	 */

	UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                                                                 action:@selector(handleLongPressGesture:)];
	
	longPressGesture.minimumPressDuration = 1.0f;
	longPressGesture.delegate             = self;
  longPressGesture.cancelsTouchesInView = NO;

	[self.view addGestureRecognizer:longPressGesture];
}

- (void)viewWillDisappear:(BOOL)animated {
  
  [super viewWillDisappear:animated];
  
  [self.previousLocations removeAllObjects];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (BOOL)isConfirming {
  return _confirming;
}

#pragma mark - Delegate Methods

- (void)handleRotationGesture:(UIRotationGestureRecognizer *)gesture {
  
  self.navigationItem.rightBarButtonItem.enabled = YES;
	
	static CGFloat finalRotation = 0.0f;
	static CGFloat previousPoint = 0.0f;
	BOOL isRight;
	
  if (gesture.state == UIGestureRecognizerStateEnded){
    
    finalRotation = gesture.rotation;
		
		NSLog(@"rotation: %f", gesture.rotation * (180 / M_PI));
    
    isRight = ((gesture.rotation * (180 / M_PI)) - (previousPoint * (180 / M_PI))) >= 0 ? YES : NO;
    
    KellerRotateGesture *rotateGesture = [[KellerRotateGesture alloc] init];
    
    rotateGesture.isRightRotation = isRight;
    rotateGesture.rotateGesture   = KellerUIRotateGesture;
    
    [self saveGesture:rotateGesture confirming:[self isConfirming]];
    
  } else if (gesture.state == UIGestureRecognizerStateBegan) {
    
		previousPoint    = gesture.rotation;
    gesture.rotation = finalRotation;
		
		NSLog(@"rotatin start: %f", previousPoint * (180 / M_PI));
  }
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)gesture {
  
  self.navigationItem.rightBarButtonItem.enabled = YES;
  
	if (gesture.state == UIGestureRecognizerStateEnded) {
		
		NSLog(@"final result: %f", gesture.scale);
    
    KellerPinchGesture *pinchGesture = [[KellerPinchGesture alloc] init];
    
    pinchGesture.gestureVelocity = gesture.velocity;
    pinchGesture.gestureScale    = gesture.scale;
    pinchGesture.pinchGesture    = KellerUIPinchGesture;
		
		if (gesture.scale > 1.0) {
			
      NSLog(@"zoom out");
      
      pinchGesture.isZoomOut = YES;

		} else {
      
      NSLog(@"zoom in");
      
      pinchGesture.isZoomOut = NO;
		}
    
    [self saveGesture:pinchGesture confirming:[self isConfirming]];
    
	} else if (gesture.state == UIGestureRecognizerStateBegan) {

    NSLog(@"start result: %f", gesture.scale);
	}
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
  
	NSLog(@"i am tap gesture");
  
  self.navigationItem.rightBarButtonItem.enabled = YES;
	
  KellerTapGesture *tapGesture = [[KellerTapGesture alloc] init];
  
  tapGesture.tapGesture = KellerUITapGesture;
  
  [self saveGesture:tapGesture confirming:[self isConfirming]];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
	
  NSLog(@"pan gesture");
  
  self.navigationItem.rightBarButtonItem.enabled = YES;
  
  if (gesture.state == UIGestureRecognizerStateEnded) {
    
    KellerPanGesture *panGesture = [[KellerPanGesture alloc] init];
    
    panGesture.panGesture      = KellerUIPanGesture;
    panGesture.numberOfTouches = gesture.numberOfTouches;
    
    [self saveGesture:panGesture confirming:[self isConfirming]];
  }
}

- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)gesture {
	
  NSLog(@"left gesture swipe");
  
  self.navigationItem.rightBarButtonItem.enabled = YES;
  
  KellerSwipeGesture *swipeGesture = [[KellerSwipeGesture alloc] init];
  
  swipeGesture.swipeGesture = KellerUISwipeLeftGesture;
  
  [self saveGesture:swipeGesture confirming:[self isConfirming]];
}

- (void)handleSwipeRightGesture:(UISwipeGestureRecognizer *)gesture {
	
  NSLog(@"right gesture swipe");
  
  self.navigationItem.rightBarButtonItem.enabled = YES;
  
  KellerSwipeGesture *swipeGesture = [[KellerSwipeGesture alloc] init];
  
  swipeGesture.swipeGesture = KellerUISwipeRightGesture;
  
  [self saveGesture:swipeGesture confirming:[self isConfirming]];
}

- (void)handleSwipeDownGesture:(UISwipeGestureRecognizer *)gesture {
	
  NSLog(@"swipe gesture down");
  
  self.navigationItem.rightBarButtonItem.enabled = YES;
  
  KellerSwipeGesture *swipeGesture = [[KellerSwipeGesture alloc] init];
  
  swipeGesture.swipeGesture = KellerUISwipeDownGesture;
  
  [self saveGesture:swipeGesture confirming:[self isConfirming]];
}

- (void)handleSwipeUpGesture:(UISwipeGestureRecognizer *)gesture {
  
  NSLog(@"swipe gesture up");

  self.navigationItem.rightBarButtonItem.enabled = YES;

  KellerSwipeGesture *swipeGesture = [[KellerSwipeGesture alloc] init];
  
  swipeGesture.swipeGesture = KellerUISwipeUpGesture;
  
  [self saveGesture:swipeGesture confirming:[self isConfirming]];
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture {

	NSLog(@"long press gesture");
  
  self.navigationItem.rightBarButtonItem.enabled = YES;
  
	if (gesture.state == UIGestureRecognizerStateEnded) {
  
    KellerLongPressGesture *longPressGesture = [[KellerLongPressGesture alloc] init];
    
    longPressGesture.longPressGesture = KellerUILongPressGesture;
    longPressGesture.numberOfSeconds  = self.numSeconds;
    
    NSLog(@"number of seconds: %d", self.numSeconds);
    
    [self saveGesture:longPressGesture confirming:[self isConfirming]];
    
    [self.timer invalidate];

    self.timer = nil;
    
	} else if (gesture.state == UIGestureRecognizerStateBegan) {
  
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(incrementNumOfSeconds)
                                                userInfo:nil
                                                 repeats:YES];
	}
}

#pragma mark - Private Methods

- (void)incrementNumOfSeconds {
  self.numSeconds = self.numSeconds++;
}

- (BOOL)arePasswordsEqualed {
  
  /**
   * Debug arrays
   */

  for (id cp in self.confirmPasswordArray) {
    NSLog(@"cp: %@", cp);
  }
  
  for (id ip in self.passwordGestures) {
    NSLog(@"ip: %@", ip);
  }

  /**
   * End debug arrays
   */

  /**
   * @todo
   * need address this potential bug. If you don't confirm the password then hit done 
   * what happens is they become equal because the arrays are both empty
   */
  
  if ([self.confirmPasswordArray isEqualToArray:self.passwordGestures]) {
    NSLog(@"is equal");
    return YES;
  } else {
    NSLog(@"it is NOT equal");
    return NO;
  }
}

#pragma mark - Custom Methods

- (void)finishedSettingPassword {

  /**
   * If the passwords are equal then iterate and save it to nsuserdefaults
   */

  if ([self arePasswordsEqualed] && [self isConfirming]) {
    
    for (id gesture in self.passwordGestures) {
      [self.passwordManager saveGesture:gesture];
    }

  } else {

    _confirming = NO;
    
    [self.passwordGestures removeAllObjects];
    [self.confirmPasswordArray removeAllObjects];
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" 
                                                                       style:UIBarButtonItemStyleDone 
                                                                      target:self 
                                                                      action:@selector(confirmingPasswordAction)];
    
    self.navigationItem.rightBarButtonItem         = doneButtonItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
  }
}

- (void)confirmingPasswordAction {
  
  _confirming = YES;
  
  UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                                  target:self 
                                                                                  action:@selector(finishedSettingPassword)];
  
  self.navigationItem.rightBarButtonItem = doneButtonItem;
}

- (void)saveGesture:(id)gesture confirming:(BOOL)confirming {
  
  if (confirming) {
    NSLog(@"is confirming");
    [self.confirmPasswordArray addObject:gesture];
  } else {
    NSLog(@"is not confirming:");
    [self.passwordGestures addObject:gesture];
  }
}

- (void)cancelSettingPassword {

  NSUserDefaults *prefs       = [NSUserDefaults standardUserDefaults];
  NSData *passwordGestureData = nil;
  
  [prefs setObject:passwordGestureData forKey:KellerPasswordGestureKey];
  
  [prefs synchronize];
  
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Gesture Delegate Protocol Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.previousLocations removeAllObjects];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  
//  CGPoint touchLocation = [[touches anyObject] locationInView:self.view];
  
//  NSLog(@"touchesMoved: %@", NSStringFromCGPoint(touchLocation));
//
//  [self.previousLocations addObject:[NSValue valueWithCGPoint:touchLocation]];
  
  for (UITouch *touch in touches) {
  
    NSString *touchKey = [NSString stringWithFormat:@"%d", (int) touch];
    
    NSLog(@"touchKey: %@", touchKey);
    
    CGPoint touchLocation = [touch locationInView:self.view];
    
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(touchLocation.x, touchLocation.y, pointSize.width, pointSize.height)];
    
    pointView.alpha           = 0.2f;
    pointView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:pointView];
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                       pointView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                       [UIView animateWithDuration:0.4f
                                        animations:^{
                                          pointView.alpha = 0.0f;
                                        }
                                        completion:^(BOOL finished){
                                          [pointView removeFromSuperview];
                                        }];
                     }];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

  CGPoint touchLocation = [[touches anyObject] locationInView:self.view];
  
  NSLog(@"touchesEnded: %@", NSStringFromCGPoint(touchLocation));
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint touchLocation = [[touches anyObject] locationInView:self.view];
  
  NSLog(@"touchesCancelled: %@", NSStringFromCGPoint(touchLocation));
}

#pragma mark - PasswordGestureDelegate Methods

- (void)saveGestureDidSucceed {
  NSLog(@"did save successfully");
}

- (void)saveGestureDidFail {
  NSLog(@"did not save successfully");
}

@end
