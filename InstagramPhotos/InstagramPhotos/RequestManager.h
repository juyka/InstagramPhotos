//
//  RequestManager.h
//  InstagramPhotos
//
//  Created by Настя on 05/03/15.
//  Copyright (c) 2015 Nastya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestManager : NSObject

+ (instancetype)manager;

- (void)recentMedia;

@end
