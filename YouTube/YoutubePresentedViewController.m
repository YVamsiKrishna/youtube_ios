//
//  YoutubeVideoViewController.m
//  YouTube
//
//  Created by VK on 15/12/15.
//  Copyright © 2015 Vamsi Krishna. All rights reserved.
//

#import "YoutubePresentedViewController.h"

@implementation YoutubePresentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

-(void)cancelButtonClicked
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
