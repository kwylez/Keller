//
//  CWGridCell.m
//  CWPhotoViewer
//
//  Created by Cory D. Wiles on 7/9/12.
//  Copyright (c) 2012 Cory D. Wiles. All rights reserved.
//

#import "KellarPhotoViewerGridCell.h"

NSString * const KellerPhotoViewerGridCellIdentifier = @"THUMBNAIL_CELL";

@implementation KellarPhotoViewerGridCell

- (id)initWithFrame:(CGRect)frame {

  self = [super initWithFrame:frame];

  if (self) {

    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];

    [self.contentView addSubview:self.imgView];

    self.contentView.layer.borderWidth = 1.0f;
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
  }

  return self;
}

- (void)setSelected:(BOOL)selected {

  [super setSelected:selected];
  
  if (selected) {

    self.contentView.layer.borderColor = [UIColor blueColor].CGColor;
    self.contentView.layer.borderWidth = 3.0f;

    self.imgView.alpha = 0.7f;

  } else {
    
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentView.layer.borderWidth = 1.0f;
    
    self.imgView.alpha = 1.0f;
  }
  
  [self.contentView setNeedsDisplay];
}

- (void)prepareForReuse {
  [super prepareForReuse];
}

@end
