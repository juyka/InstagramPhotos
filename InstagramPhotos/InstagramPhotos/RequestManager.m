//
//  RequestManager.m
//  InstagramPhotos
//
//  Created by Настя on 05/03/15.
//  Copyright (c) 2015 Nastya. All rights reserved.
//

#import "RequestManager.h"
#import "InstagramPicture.h"
#import <AFNetworking.h>

@interface RequestManager ()

@property (nonatomic) AFHTTPRequestOperationManager *oparationManager;
@property (nonatomic) NSString *clientID;
@property (nonatomic) NSMutableArray *pictures;
@property (nonatomic, copy) void (^block)(NSArray *);

@end

@implementation RequestManager

+ (instancetype)manager {
	
	static RequestManager *manager;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		
		manager = [[self alloc] init];
		manager.oparationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.instagram.com/"]];
		manager.clientID = @"7ff6cda2a4ea4646bcc649e1b1099a9d";
	});
	
	return manager;
}

- (void)recentMedia:(NSString *)userName withBlock:(void(^)(NSArray*))block {
	
	self.block = block;
	self.pictures = NSMutableArray.new;

	NSString *urlString = @"/v1/users/search";
	NSDictionary *parameters = @{@"q": userName, @"client_id": self.clientID};
	
	[self.oparationManager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		NSArray *data = [responseObject objectForKey:@"data"];
		NSString *userID = [data.firstObject objectForKey:@"id"];
		
		[self loadMedia:userID withMaxID:nil];
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

- (void)loadMedia:(NSString *)userID withMaxID:(NSString *)maxID {
	
	NSString *urlString = [NSString stringWithFormat:@"/v1/users/%@/media/recent/", userID];
	NSMutableDictionary *parameters = @{@"count": @"20", @"client_id": self.clientID}.mutableCopy;
	[parameters setValue:maxID forKey:@"max_id"];
	
	[self.oparationManager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSArray *data = responseObject[@"data"];
		
		for (id object in data) {
			InstagramPicture *picture = InstagramPicture.new;
			
			NSString *type = object[@"type"];
			if ([type isEqualToString:@"image"]) {
				
				picture.mediaID = [object objectForKey:@"id"];
				id image = [[object objectForKey:@"images"] objectForKey:@"standard_resolution"];
				picture.imageURL = [image objectForKey:@"url"];
				id caption = [object objectForKey:@"caption"];
				
				if (caption != (id)[NSNull null]) {
					picture.caption = [caption objectForKey:@"text"];
				}
				
				picture.likesCount = [[object objectForKey:@"likes"] objectForKey:@"count"];
				[self.pictures addObject:picture];
			}
		}
		
		id pagination = responseObject[@"pagination"];
		NSString *nextMaxID = pagination[@"next_max_id"];
		
		if (nextMaxID) {
			[self loadMedia:userID withMaxID:nextMaxID];
		} else {
			[self findMostPopular];
		}

	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Не удалось получить данные"
														message:@"Проверьте не является ли данный аккаунт приватным"
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
	}];
}

- (void)findMostPopular {
	
	NSArray *sortedPictures = [self.pictures sortedArrayUsingComparator:^NSComparisonResult(InstagramPicture *first, InstagramPicture *second) {
		return [second.likesCount compare:first.likesCount];
	}];
	
	self.block([sortedPictures subarrayWithRange:NSMakeRange(0, MIN(3, sortedPictures.count))]);
}

@end
