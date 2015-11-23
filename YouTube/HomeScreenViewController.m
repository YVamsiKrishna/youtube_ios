//
//  HomeScreenViewController.m
//  YouTube
//
//  Created by Vamsi Krishna on 20/11/15.
//  Copyright © 2015 Vamsi Krishna. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "SearchViewController.h"
#import "YouTubeApiManager.h"

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController


- (IBAction)navigateToSearchPage {
    SearchViewController* viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchViewController"] ;
    UINavigationController* navigatingViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigatingViewController animated:YES completion:nil] ;
}

@end
