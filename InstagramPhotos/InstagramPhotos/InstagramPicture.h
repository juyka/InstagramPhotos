//
//  IntagramUser.h
//  InstagramPhotos
//
//  Created by Настя on 05/03/15.
//  Copyright (c) 2015 Nastya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramPicture : NSObject

@property (nonatomic) NSString *mediaID;
@property (nonatomic) NSString *imageURL;
@property (nonatomic) NSString *caption;
@property (nonatomic) NSNumber *likesCount;

@end
