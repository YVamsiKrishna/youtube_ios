//
//  VideoViewController.m
//  YouTube
//
//  Created by Vamsi Krishna on 26/11/15.
//  Copyright © 2015 Vamsi Krishna. All rights reserved.
//

#import "VideoViewController.h"
#import <YTPlayerView.h>
#import "SearchResultsTableViewCell.h"
#import "YouTubeApiManager.h"

@interface VideoViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet YTPlayerView *ytPlayerView;
@property (weak, nonatomic) IBOutlet UILabel *ytPlayerTitle;
@property (weak, nonatomic) IBOutlet UITextView *ytPlayerDescription;

@property (weak, nonatomic) IBOutlet UITableView *relatedVideosTableView;

@property (strong, nonatomic) NSString* ytVideoId;
@property (strong, nonatomic) NSString* ytVideoTitle;
@property (strong, nonatomic) NSString* ytVideoDescription;

@property (strong, nonatomic) NSArray* relatedVideosList ;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation VideoViewController

-(instancetype)initWithVideoDictionary:(NSDictionary*)data
{
    self = [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
    self.ytVideoTitle = [data valueForKeyPath:@"snippet.title"];
    self.ytVideoId = [data valueForKeyPath:@"id.videoId"] ;
    self.ytVideoDescription = [data valueForKeyPath:@"snippet.description"];

    return self;
}

-(instancetype)initWithVideoDictionaryForPopular:(NSDictionary*)data
{
    self = [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
    self.ytVideoTitle = [data valueForKeyPath:@"snippet.title"];
    self.ytVideoId = [data valueForKeyPath:@"id"] ;
    self.ytVideoDescription = [data valueForKeyPath:@"snippet.description"];
    
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.ytPlayerTitle.text = self.ytVideoTitle ;
    self.ytPlayerDescription.text = self.ytVideoDescription ;
    NSDictionary* playerParameters = @{@"playsinline":[[NSNumber alloc] initWithInt:1]} ;
    [self.ytPlayerView loadWithVideoId:self.ytVideoId playerVars:playerParameters];
    
    [self fetchRelatedVideos];
    
    self.relatedVideosTableView.hidden = YES;
    [self.activityIndicator startAnimating];
    [self.relatedVideosTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchResultsTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"SearchResultsTableViewCell"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.ytPlayerView playVideo];
}

-(void)updateRelatedVideos:(NSData*)data
{
    NSString* results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    NSLog(@"%@",results) ;
    
    NSError* error ;
    id response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error] ;
    if([response isKindOfClass:[NSDictionary class]] && !error){
        NSDictionary* responseDict = (NSDictionary*)response ;
        NSArray* itemsArray = [responseDict objectForKey:@"items"] ;
        self.relatedVideosList = itemsArray ;
        for(NSDictionary* dict in itemsArray){
            NSLog(@"item:\n%@\n%@\n\n",dict,[dict valueForKeyPath:SearchResultKindPath]) ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            self.relatedVideosTableView.hidden = NO ;
            [self.relatedVideosTableView reloadData];
        });
    }
}

-(void)fetchRelatedVideos
{
    __weak typeof(self) weakSelf = self;
    [YouTubeApiManager getRelatedVideosForVideoId:self.ytVideoId
                                   successHandler:^(NSData* data)
     {
         [weakSelf updateRelatedVideos:data] ;
     }
                                     errorHandler:nil] ;
}

#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.relatedVideosList ? self.relatedVideosList.count : 0 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultsTableViewCell" forIndexPath:indexPath] ;
    NSDictionary* dataForRowAtIndexPath = self.relatedVideosList[indexPath.row] ;
    
    [cell setupCellWithThumbnailURL:[dataForRowAtIndexPath valueForKeyPath:SearchResultDefaultURLPath] title:[dataForRowAtIndexPath valueForKeyPath:SearchResultTitlePath] description:[dataForRowAtIndexPath valueForKeyPath:SearchResultDescriptionPath]];
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoViewController* videoViewController = [[VideoViewController alloc] initWithVideoDictionary:self.relatedVideosList[indexPath.row]];
    [self.navigationController pushViewController:videoViewController animated:YES];
}

@end
