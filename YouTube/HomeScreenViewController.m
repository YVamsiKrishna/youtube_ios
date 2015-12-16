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
#import "VideoViewController.h"
#import "SearchResultsTableViewCell.h"

@interface HomeScreenViewController ()
@property (weak, nonatomic) IBOutlet UITableView *popularVideosTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSArray* popularVideosList ;
@end

@implementation HomeScreenViewController

-(void)viewDidLoad
{
    [self fetchRelatedVideos];
    
    self.popularVideosTableView.hidden = YES;
    [self.activityIndicator startAnimating];
    [self.popularVideosTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchResultsTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"SearchResultsTableViewCell"];
}

- (IBAction)navigateToSearchPage {
    SearchViewController* viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchViewController"] ;
    UINavigationController* navigatingViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigatingViewController animated:YES completion:nil] ;
}

-(void)updatePopularVideos:(NSData*)data
{
    NSString* results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    NSLog(@"%@",results) ;
    
    NSError* error ;
    id response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error] ;
    if([response isKindOfClass:[NSDictionary class]] && !error){
        NSDictionary* responseDict = (NSDictionary*)response ;
        NSArray* itemsArray = [responseDict objectForKey:@"items"] ;
        self.popularVideosList = itemsArray ;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            self.popularVideosTableView.hidden = NO ;
            [self.popularVideosTableView reloadData];
        });
    }
}

-(void)fetchRelatedVideos
{
    __weak typeof(self) weakSelf = self;
    [YouTubeApiManager getPopularVideoswithSuccessHandler:^(NSData* data)
                            {
                                [weakSelf updatePopularVideos:data] ;
                            }
                                             errorHandler:nil] ;
}

#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.popularVideosList ? self.popularVideosList.count : 0 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultsTableViewCell" forIndexPath:indexPath] ;
    NSDictionary* dataForRowAtIndexPath = self.popularVideosList[indexPath.row] ;
    
    [cell setupCellWithThumbnailURL:[dataForRowAtIndexPath valueForKeyPath:SearchResultDefaultURLPath] title:[dataForRowAtIndexPath valueForKeyPath:SearchResultTitlePath] description:[dataForRowAtIndexPath valueForKeyPath:SearchResultDescriptionPath]];

    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoViewController* videoViewController = [[VideoViewController alloc] initWithVideoDictionaryForPopular:self.popularVideosList[indexPath.row]];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:videoViewController] animated:YES completion:nil] ;
}

@end
