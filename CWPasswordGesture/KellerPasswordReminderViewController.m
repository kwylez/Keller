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

typedef void(^KellerFetchSampleImagesCompletionBlock)(NSArray *images);

static NSString * const REMINDER_IMAGES_KEYPATH = @"reminderImages";

@interface KellerPasswordReminderViewController()

@property (nonatomic, strong) NSMutableArray *galleryImages;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, assign) BOOL allowSelection;
@property (nonatomic, strong) NSMutableDictionary *reminderImages;

- (void)fetchRandomlySampleImagesFromGalleryWithCompletionBlock:(KellerFetchSampleImagesCompletionBlock)block;
- (ALAssetsLibrary *)defaultAssetsLibrary;

@end

@implementation KellerPasswordReminderViewController

- (void)dealloc {
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
}

- (void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  
  [self fetchRandomlySampleImagesFromGalleryWithCompletionBlock:^(NSArray *images){
    
    [self.loadingView stopAnimating];
    [self.loadingView removeFromSuperview];
    
    if ([images count]) {
      [self.collectionView reloadData];
    }
  }];
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
    UIImage *thumbnail    = [UIImage imageWithCGImage:[asset thumbnail]];
    NSString *indexString = [NSString stringWithFormat:@"%ld", (long)path.row];

    NSInteger reminderImageIndex = [[self.reminderImages allKeys] indexOfObject:indexString];
    
    if (reminderImageIndex == NSNotFound && self.allowSelection) {

      [self willChangeValueForKey:REMINDER_IMAGES_KEYPATH];
      [self.reminderImages setObject:thumbnail forKey:indexString];
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
            
            static NSInteger INDICE_LIMIT = 10;
            
            NSMutableIndexSet *indices = [NSMutableIndexSet new];
            
            for (int i = 0; i <= INDICE_LIMIT; i++) {
              
              NSUInteger r = arc4random_uniform(numberOfPhotos);
              
              [indices addIndex:r];
            }
            
            return indices;
          };
          
          [group enumerateAssetsAtIndexes:randomImageIndexSet([group numberOfAssets])
                                  options:NSEnumerationConcurrent
                               usingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop){
                                 
                                 if (asset) {
                                   [self.galleryImages addObject:asset];
                                 }
                               }];
          
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

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  if ([keyPath isEqual:REMINDER_IMAGES_KEYPATH]) {
    
    NSLog(@"observered: %@", self.reminderImages);
    
    if ([self.reminderImages.allKeys count] > 3) {

      NSLog(@"count is GREATER than 3");
      
      self.allowSelection = NO;

    } else {

      NSLog(@"count is LESS than 3");
      
      self.allowSelection = YES;
    }
    
  } else {
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}


@end
