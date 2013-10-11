//
//  PasswordReminderViewController.m
//  PasswordGestures
//
//  Created by Cory Wiles on 12/28/10.
//  Copyright 2010 Wiles, LLC. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

#import "KellerPasswordReminderViewController.h"
#import "KellerPhotoViewerGridFlowLayout.h"
#import "KellerPhotoViewerGridCell.h"
#import "KellerPasswordManager.h"

typedef void(^KellerFetchSampleImagesCompletionBlock)(NSArray *images);
typedef void(^KellerFetchAssetForUrlSuccessBlock)(ALAsset *asset);
typedef void(^KellerFetchAssetForUrlErrorBlock)(NSError *);

static NSString * const REMINDER_IMAGES_KEYPATH      = @"reminderImages";
static NSString * const REMINDER_IMAGES_DEFAULTS_KEY = @"REMINDER_IMAGES_DEFAULTS_KEY";

@interface KellerPasswordReminderViewController()

@property (nonatomic, strong) NSMutableArray *galleryImages;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, assign) BOOL allowSelection;
@property (nonatomic, strong) NSMutableDictionary *reminderImages;
@property (nonatomic, copy) NSDictionary *savedReminderImages;

- (void)fetchRandomlySampleImagesFromGalleryWithCompletionBlock:(KellerFetchSampleImagesCompletionBlock)block;
- (ALAssetsLibrary *)defaultAssetsLibrary;
- (void)cancel:(id)sender;
- (void)save:(id)sender;
- (void)reset:(id)sender;
- (void)fetchAssetForUrl:(NSURL *)url
                 success:(KellerFetchAssetForUrlSuccessBlock)successBlock
                   error:(KellerFetchAssetForUrlErrorBlock)errorBlock;

@end

@implementation KellerPasswordReminderViewController

@synthesize reset = _reset;

- (void)dealloc {

  NSLog(@"dealloc is called");
  
  [self removeObserver:self forKeyPath:REMINDER_IMAGES_KEYPATH context:NULL];
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
  
  if (!layout) {
    
    KellerPhotoViewerGridFlowLayout *flowLayout = [[KellerPhotoViewerGridFlowLayout alloc] init];
    
    layout = flowLayout;
  }
  
  self = [super initWithCollectionViewLayout:layout];
  
  if (self) {
    
    self.clearsSelectionOnViewWillAppear        = YES;
    self.collectionView.backgroundColor         = [UIColor whiteColor];
    self.collectionView.allowsMultipleSelection = YES;
    
    self.title = NSLocalizedString(@"Reminder", nil);
    
    _galleryImages  = [NSMutableArray new];
    _allowSelection = YES;
    _reminderImages = [NSMutableDictionary new];
    _reset          = NO;
    
    [self addObserver:self
           forKeyPath:REMINDER_IMAGES_KEYPATH
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:NULL];
  }
  
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];

  [self.collectionView registerClass:[KellerPhotoViewerGridCell class]
          forCellWithReuseIdentifier:KellerPhotoViewerGridCellIdentifier];
  
  UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                    target:self
                                                                                    action:@selector(cancel:)];
  self.navigationItem.leftBarButtonItem = cancelButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  
  NSLog(@"isReset?: %@", @(self.reset));
  
  NSString *doneButtonTitle = self.reset ? @"Reset" : @"Save";
  
  SEL sel = self.reset ? @selector(reset:) : @selector(save:);
  
  UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:sel];
  
  self.navigationItem.rightBarButtonItem         = doneButtonItem;
  self.navigationItem.rightBarButtonItem.enabled = NO;
  
  [self fetchRandomlySampleImagesFromGalleryWithCompletionBlock:^(NSArray *images){
    
    [self.loadingView stopAnimating];
    [self.loadingView removeFromSuperview];
    
    if ([images count]) {
      [self.collectionView reloadData];
    }
  }];
}

- (void)viewWillDisappear:(BOOL)animated {

  [super viewWillDisappear:animated];
  
  NSLog(@"willDisappear");
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

#pragma mark - CollectionView Methods

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section; {
  return [self.galleryImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
  
  KellerPhotoViewerGridCell *cell = [cv dequeueReusableCellWithReuseIdentifier:KellerPhotoViewerGridCellIdentifier
                                                                  forIndexPath:indexPath];
  
  ALAsset *asset     = (ALAsset *)[self galleryImages][indexPath.row];
  UIImage *thumbnail = [UIImage imageWithCGImage:[asset thumbnail]];
  
  cell.imgView.image = thumbnail;
  
  return cell;
}

- (BOOL)collectionView:(UICollectionView *)view shouldSelectItemAtIndexPath:(NSIndexPath *)path {
  
  if ([self.reminderImages count] < 3) {

    ALAsset *asset        = (ALAsset *)[self galleryImages][path.row];
    NSString *indexString = [NSString stringWithFormat:@"%ld", (long)path.row];

    NSInteger reminderImageIndex = [[self.reminderImages allKeys] indexOfObject:indexString];
    
    if (reminderImageIndex == NSNotFound && self.allowSelection) {

      [self willChangeValueForKey:REMINDER_IMAGES_KEYPATH];
      [self.reminderImages setObject:[asset valueForProperty:ALAssetPropertyAssetURL] forKey:indexString];
      [self didChangeValueForKey:REMINDER_IMAGES_KEYPATH];
    }
    
    return self.allowSelection;
  }

  return NO;
}

- (BOOL)collectionView:(UICollectionView *)view shouldDeselectItemAtIndexPath:(NSIndexPath *)path {

  NSString *indexString        = [NSString stringWithFormat:@"%ld", (long)path.row];
  NSInteger reminderImageIndex = [[self.reminderImages allKeys] indexOfObject:indexString];
  
  if (reminderImageIndex != NSNotFound) {

    [self willChangeValueForKey:REMINDER_IMAGES_KEYPATH];
    [self.reminderImages removeObjectForKey:indexString];
    [self didChangeValueForKey:REMINDER_IMAGES_KEYPATH];
  }
  
  return self.allowSelection;
}

#pragma mark - Private Methods

- (void)fetchRandomlySampleImagesFromGalleryWithCompletionBlock:(KellerFetchSampleImagesCompletionBlock)block {
  
  /**
   * Unfortunately without caching this takes a bit of time. Enough that we
   * need to notifiy the user.
   */
  
  self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  
  self.loadingView.center           = self.view.center;
  self.loadingView.hidesWhenStopped = YES;
  
  [self.loadingView startAnimating];
  
  [self.view addSubview:self.loadingView];
  
  ALAssetsLibrary *library = [self defaultAssetsLibrary];
  
  dispatch_queue_t queue = dispatch_queue_create("com.kellar.imageiterator.queue", DISPATCH_QUEUE_SERIAL);
  
  dispatch_async(queue, ^{
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
      
      if (group) {
        
        if ([group valueForProperty:ALAssetsGroupPropertyName]) {
          
          NSLog(@"album: %@", [group valueForProperty:ALAssetsGroupPropertyName]);
          
          /**
           * Need to get 10 random indices from array.
           * @todo
           * Find a better way to do this.
           */
          
          NSIndexSet* (^randomImageIndexSet)(NSInteger numberOfPhotos) = ^ NSIndexSet*(NSInteger numberOfPhotos) {
            
            NSInteger INDICE_LIMIT = self.reset ? 7 : 10;
            
            NSMutableIndexSet *indices = [NSMutableIndexSet new];
            
            for (int i = 0; i < INDICE_LIMIT; i++) {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshorten-64-to-32"
              NSUInteger r = arc4random_uniform(numberOfPhotos);
#pragma clang diagnostic pop
              
              [indices addIndex:r];
            }
            
            return indices;
          };
          
          [group enumerateAssetsAtIndexes:randomImageIndexSet([group numberOfAssets])
                                  options:NSSortConcurrent
                               usingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop){
                                 
                                 if (asset) {
                                   [self.galleryImages addObject:asset];
                                 }
          }];
          
          NSData *data         = [[NSUserDefaults standardUserDefaults] objectForKey:REMINDER_IMAGES_DEFAULTS_KEY];

          self.savedReminderImages = [NSKeyedUnarchiver unarchiveObjectWithData:data];

          if (self.reset) {

            [self.savedReminderImages enumerateKeysAndObjectsUsingBlock:^(id key, NSURL *url, BOOL *stop){
              
              [self fetchAssetForUrl:url
                             success:^(ALAsset *asset){
                               [self.galleryImages addObject:asset];
                             }
                               error:^(NSError *error){
                                 NSLog(@"failed getting asset: %@", error);
                               }];
            }];
          }
          
          if (block) {
            block(self.galleryImages);
          }
        }
      }
      
    } failureBlock:^(NSError *error) {
      
      NSLog(@"error loading assets: %@", [error localizedDescription]);
    }];
  });
}

- (ALAssetsLibrary *)defaultAssetsLibrary {
  
  static dispatch_once_t pred     = 0;
  static ALAssetsLibrary *library = nil;
  
  dispatch_once(&pred, ^{
    library = [[ALAssetsLibrary alloc] init];
  });
  
  return library;
}

- (void)cancel:(id)__unused sender {
  
  void (^completionBlock)(void) = ^{
    NSLog(@"completion block as finished");
  };
  
  [self dismissViewControllerAnimated:YES completion:completionBlock];
}

- (void)save:(id)__unused sender {

  void (^completionBlock)(void) = ^{

    NSLog(@"completion block as finished");

    NSData *reminderImageData = [NSKeyedArchiver archivedDataWithRootObject:self.reminderImages];

    [[NSUserDefaults standardUserDefaults] setObject:reminderImageData
                                              forKey:REMINDER_IMAGES_DEFAULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
  };
  
  [self dismissViewControllerAnimated:YES completion:completionBlock];
}

- (void)fetchAssetForUrl:(NSURL *)url
                 success:(KellerFetchAssetForUrlSuccessBlock)successBlock
                   error:(KellerFetchAssetForUrlErrorBlock)errorBlock {

  ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
    
    if (successBlock) {
      successBlock(myasset);
    }
    
    if (errorBlock) {
      errorBlock(nil);
    }
  };

  ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *error) {
    
    if (successBlock) {
      successBlock(nil);
    }
    
    if (errorBlock) {
      errorBlock(error);
    }
  };
  
  if (url) {

    ALAssetsLibrary *assetslibrary = [self defaultAssetsLibrary];

    [assetslibrary assetForURL:url
                   resultBlock:resultblock
                  failureBlock:failureblock];
    }
}

- (void)reset:(id)__unused sender {

  NSLog(@"reset password");
  
  // compare images asset urls

  NSMutableArray *intermediate = [NSMutableArray arrayWithArray:self.reminderImages.allValues];

  [intermediate removeObjectsInArray:self.savedReminderImages.allValues];
  
  NSUInteger difference = [intermediate count];

  if (difference > 0) {

    NSLog(@"not the same");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed", nil)
                                                        message:NSLocalizedString(@"Reset Doesn't Match", nil)
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
    
  } else {
    
    NSLog(@"the same");
    
    
    void (^completionBlock)(void) = ^{

      NSLog(@"completion block as finished after resetting");
      
      self.savedReminderImages = nil;
      self.reminderImages      = nil;
      
      __block NSString *message;
      __block UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Reset", nil)
                                                                  message:nil
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil, nil];
      
      [[KellerPasswordManager sharedManager] resetPasswordWithCompletionBlock:^(BOOL successful){
      
        if (successful) {
          message = NSLocalizedString(@"Password has been reset", nil);
        } else {
          message = NSLocalizedString(@"Password failed to reset", nil);
        }
        
        alertView.message = message;
        
        [alertView show];
      }];
    };
    
    [self dismissViewControllerAnimated:YES completion:completionBlock];
  }
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  if ([keyPath isEqual:REMINDER_IMAGES_KEYPATH]) {
    
    NSLog(@"observered: %@", self.reminderImages);

    if ([self.reminderImages.allKeys count] > 3) {

      NSLog(@"count is GREATER than 3");

      /**
       * This really isn't called
       */
      
      self.allowSelection = NO;

    } else {

      NSLog(@"count is LESS than 3");

      self.navigationItem.rightBarButtonItem.enabled = NO;
      
      self.allowSelection = YES;
    }
    
    if ([self.reminderImages.allKeys count] == 3) {
      self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
  } else {
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}


@end
