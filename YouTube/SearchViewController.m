//
//  SearchViewController.m
//  YouTube
//
//  Created by Vamsi Krishna on 23/11/15.
//  Copyright © 2015 Vamsi Krishna. All rights reserved.
//

#import "SearchViewController.h"
#import "YouTubeApiManager.h"

@interface SearchViewController () <UISearchBarDelegate, UISearchControllerDelegate, UITableViewDataSource>
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)updateSearchResults:(NSData*) data{
    NSString* results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    NSLog(@"%@",results) ;
}

#pragma mark - Search Bar Delegate	

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    __weak typeof(self) weakSelf = self;
    [YouTubeApiManager getVideosForQueryString:searchBar.text
                     successHandler:^(NSData* data)
                        {
                            [weakSelf updateSearchResults:data] ;
                        }
                         errorHandler:nil] ;
}


#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc] init] ;
}

@end
