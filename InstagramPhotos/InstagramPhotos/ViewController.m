//
//  ViewController.m
//  InstagramPhotos
//
//  Created by Настя on 03/03/15.
//  Copyright (c) 2015 Nastya. All rights reserved.
//

#import "ViewController.h"
#import "PhotosViewController.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *texField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.texField.delegate = self;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (IBAction)search:(id)sender {
	
	NSString *userName = self.texField.text;
	[self performSegueWithIdentifier:@"PhotosSegue" sender:userName];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSString *)sender {
	
	if ([segue.identifier isEqualToString:@"PhotosSegue"]) {
		PhotosViewController *controller = segue.destinationViewController;
		controller.userName = sender;
	}
}

@end
