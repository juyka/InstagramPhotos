//
//  PhotoTableViewCell.h
//  InstagramPhotos
//
//  Created by Настя on 03/03/15.
//  Copyright (c) 2015 Nastya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *caption;

@end
