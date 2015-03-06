//
//  PhotosViewController.m
//  InstagramPhotos
//
//  Created by Настя on 03/03/15.
//  Copyright (c) 2015 Nastya. All rights reserved.
//

#import "PhotosViewController.h"
#import "RequestManager.h"
#import "PhotoTableViewCell.h"
#import "InstagramPicture.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface PhotosViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property ( nonatomic) NSArray *dataSource;
@end

@implementation PhotosViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	__weak typeof(self) weakSelf = self;
	[[RequestManager manager] recentMedia:self.userName withBlock:^(NSArray *array) {
		weakSelf.dataSource = array;
		[weakSelf.tableView reloadData];
	}];
	
}
- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	self.tableView.rowHeight = MIN(self.tableView.frame.size.width, self.tableView.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	
	InstagramPicture *picture = self.dataSource[indexPath.row];
	NSURL *url = [NSURL URLWithString:picture.imageURL];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	UIImage *placeholder = [UIImage imageNamed:@"placeholder"];
 
	__weak PhotoTableViewCell *weakCell = cell;
 
	[cell.photoImageView setImageWithURLRequest:request
						  placeholderImage:placeholder
								   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
									   
									   weakCell.photoImageView.image = image;
									   [weakCell setNeedsLayout];
									   
								   } failure:nil];
	cell.caption.text = picture.caption;
	cell.rating.text = [NSString stringWithFormat:@"\u2665 %@", picture.likesCount];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataSource.count;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

	BOOL shoudNavBarHide = ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait);
	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		
	} completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		
		[[self navigationController] setNavigationBarHidden:shoudNavBarHide animated:YES];
	}];
}

@end
