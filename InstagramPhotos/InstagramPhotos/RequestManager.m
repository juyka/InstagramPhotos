//
//  RequestManager.m
//  InstagramPhotos
//
//  Created by Настя on 05/03/15.
//  Copyright (c) 2015 Nastya. All rights reserved.
//

#import "RequestManager.h"
#import <AFOAuth2Manager.h>

@interface RequestManager ()

@property (nonatomic) AFHTTPRequestOperationManager *oparationManager;
@property (nonatomic) NSString *clientID;
@property (nonatomic) NSMutableArray *mediaIdentifiers;
@end

@implementation RequestManager

+ (instancetype)manager {
	
	static RequestManager *manager;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		
		manager = [[self alloc] init];
		manager.oparationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.instagram.com/"]];
		manager.clientID = @"c4f9de4ec589414c8eefaec79cba0e9d";
		manager.mediaIdentifiers = NSMutableArray.new;
	});
	
	return manager;
}

- (void)recentMedia {
	
	NSString *urlString = @"/v1/users/search";
	
	NSDictionary *parameters = @{
								 @"q": @"akorolevskaia",
								 @"client_id": self.clientID};
	
	[self.oparationManager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		NSArray *data = [responseObject objectForKey:@"data"];
		NSString *userID = [data.firstObject objectForKey:@"id"];
		
		[self loadMedia:userID withMaxID:nil];
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}


- (void)loadMedia:(NSString *)userID withMaxID:(NSString *)maxID {
	
	NSString *urlString =[NSString stringWithFormat:@"/v1/users/%@/media/recent/", userID];
	
	NSMutableDictionary *parameters = @{
								 @"count": @"30",
								 @"client_id": self.clientID}.mutableCopy;
	
	if (maxID) {
		[parameters setObject:maxID forKey:@"max_id"];
	}
	
	[self.oparationManager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSArray *data = [responseObject objectForKey:@"data"];
		
		
		for (id object in data) {
			NSString *mediaID = [object objectForKey:@"id"];
			NSString *type = [object objectForKey:@"type"];
			if (mediaID && [type isEqualToString:@"image"]) {
				[self.mediaIdentifiers addObject:mediaID];
			}
		}
		
		id pagination = [responseObject objectForKey:@"pagination"];
		NSString *nextMaxID = [pagination objectForKey:@"next_max_id"];
		if (nextMaxID) {
			[self loadMedia:userID withMaxID:nextMaxID];
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

@end
