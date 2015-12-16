//
//  SearchViewController.m
//  YouTube
//
//  Created by Vamsi Krishna on 23/11/15.
//  Copyright © 2015 Vamsi Krishna. All rights reserved.
//

#import "SearchViewController.h"
#import "YouTubeApiManager.h"
#import "NSURL+YouTubeAdditions.h"
#import "SearchResultsTableViewCell.h"
#import "VideoViewController.h"

@interface SearchViewController () <UISearchBarDelegate, UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searchActivityIndicator;
@property (strong, nonatomic) NSArray* searchResults ;
@property (weak, nonatomic) IBOutlet UITableView *searchResultsTableView;
@property (strong,nonatomic) NSString* previousQuery ;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchResults = [NSArray new];
    [self.searchResultsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchResultsTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"SearchResultsTableViewCell"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.searchBar becomeFirstResponder];
}


-(void)updateSearchResults:(NSData*)data forQuery:(NSString*)query{
    self.previousQuery = query ;
    NSError* error ;
    id response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error] ;
    if([response isKindOfClass:[NSDictionary class]] && !error){
        NSDictionary* responseDict = (NSDictionary*)response ;
        NSArray* itemsArray = [responseDict objectForKey:@"items"] ;
        self.searchResults = itemsArray ;
        for(NSDictionary* dict in itemsArray){
            NSLog(@"item:\n%@\n%@\n\n",dict,[dict valueForKeyPath:SearchResultKindPath]) ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchActivityIndicator stopAnimating];
            [self.searchResultsTableView reloadData];
        });
    }
    
}

#pragma mark - Search Bar Delegate	

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    __weak typeof(self) weakSelf = self;
    if([searchBar.text isEqualToString:self.previousQuery]){
        return;
    }
    [YouTubeApiManager getVideosForQueryString:searchBar.text
                     successHandler:^(NSData* data, NSString* query)
                        {
                            [weakSelf updateSearchResults:data forQuery:query] ;
                        }
                         errorHandler:nil] ;
    [self.searchActivityIndicator startAnimating];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        self.previousQuery = @"" ;
        self.searchResults = [NSArray new];
    }
}

- (void)cancelButtonClicked
{
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultsTableViewCell" forIndexPath:indexPath] ;
    NSDictionary* dataAtIndexPath = self.searchResults[indexPath.row] ;
    
    [cell setupCellWithThumbnailURL:[dataAtIndexPath valueForKeyPath:SearchResultDefaultURLPath] title:[dataAtIndexPath valueForKeyPath:SearchResultTitlePath] description:[dataAtIndexPath valueForKeyPath:SearchResultDescriptionPath]];
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoViewController* videoViewController = [[VideoViewController alloc] initWithVideoDictionary:self.searchResults[indexPath.row]];
    [self.navigationController pushViewController:videoViewController animated:YES];
}
@end
