//
//  PhotosViewController.m
//  InstagramPhotos
//
//  Created by Настя on 03/03/15.
//  Copyright (c) 2015 Nastya. All rights reserved.
//

#import "PhotosViewController.h"
#import "RequestManager.h"

@interface PhotosViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[[RequestManager manager] recentMedia];
	
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
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return 3;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
	BOOL shoudNavBarHide = ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait);
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	
	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		
	} completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		
		[[self navigationController] setNavigationBarHidden:shoudNavBarHide animated:YES];
	}];
}

@end
