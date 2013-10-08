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
#import "KellarPhotoViewerGridCell.h"

typedef void(^KellerFetchSampleImagesCompletionBlock)(NSArray *images);

@interface KellerPasswordReminderViewController()

@property (nonatomic, strong) NSMutableArray *galleryImages;

- (void)fetchRandomlySampleImagesFromGalleryWithCompletionBlock:(KellerFetchSampleImagesCompletionBlock)block;
- (ALAssetsLibrary *)defaultAssetsLibrary;

@end

@implementation KellerPasswordReminderViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
  
  if (!layout) {
    
    KellerPhotoViewerGridFlowLayout *flowLayout = [[KellerPhotoViewerGridFlowLayout alloc] init];
    
    layout = flowLayout;
  }
  
  self = [super initWithCollectionViewLayout:layout];
  
  if (self) {
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    _galleryImages = [NSMutableArray new];
  }
  
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  [self.collectionView setPagingEnabled:YES];
  [self.collectionView registerClass:[KellarPhotoViewerGridCell class]
          forCellWithReuseIdentifier:KellerPhotoViewerGridCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  
  [self fetchRandomlySampleImagesFromGalleryWithCompletionBlock:^(NSArray *images){
  
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

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section; {
  return [self.galleryImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
  
  KellarPhotoViewerGridCell *cell = [cv dequeueReusableCellWithReuseIdentifier:KellerPhotoViewerGridCellIdentifier
                                                                  forIndexPath:indexPath];
  
  ALAsset *asset     = (ALAsset *)[self galleryImages][indexPath.row];
  UIImage *thumbnail = [UIImage imageWithCGImage:[asset thumbnail]];

  cell.imgView.image = thumbnail;
  
  return cell;
}


#pragma mark - Private Methods

- (void)fetchRandomlySampleImagesFromGalleryWithCompletionBlock:(KellerFetchSampleImagesCompletionBlock)block {

  ALAssetsLibrary *library = [self defaultAssetsLibrary];

  dispatch_queue_t queue = dispatch_queue_create("com.kellar.imageiterator.queue", DISPATCH_QUEUE_SERIAL);
  
  dispatch_async(queue, ^{
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
      
      if (group) {
        
        if ([group valueForProperty:ALAssetsGroupPropertyName]) {
          
          NSLog(@"album: %@", [group valueForProperty:ALAssetsGroupPropertyName]);
          
          [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
            
            if (asset) {
              [self.galleryImages addObject:asset];
            }
            
            if (index == 3) {
              *stop = YES;
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

@end
