//
//  ViewController.m
//  InstagramPhotos
//
//  Created by Настя on 03/03/15.
//  Copyright (c) 2015 Nastya. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *texField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (IBAction)search:(id)sender {
	
	[self performSegueWithIdentifier:@"PhotosSegue" sender:nil];
}

@end
