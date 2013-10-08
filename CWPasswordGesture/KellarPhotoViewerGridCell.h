//
//  CWGridCell.h
//  CWPhotoViewer
//
//  Created by Cory D. Wiles on 7/9/12.
//  Copyright (c) 2012 Cory D. Wiles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

extern NSString * const KellerPhotoViewerGridCellIdentifier;

@interface KellarPhotoViewerGridCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imgView;

@end
