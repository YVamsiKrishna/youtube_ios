//
//  SearchResultsTableViewCell.m
//  YouTube
//
//  Created by Vamsi Krishna on 24/11/15.
//  Copyright © 2015 Vamsi Krishna. All rights reserved.
//

#import "SearchResultsTableViewCell.h"

@interface SearchResultsTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *thumbnailLoadingIndicator;

@end

@implementation SearchResultsTableViewCell

-(void)setupCellWithThumbnailURL:(NSString*)urlString title:(NSString*)titleString description:(NSString*)descriptionString
{
    __weak typeof(self) weakSelf = self ;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        [weakSelf fetchThumbnailImage:urlString];
    });
    
    self.titleLabel.text = titleString ;
    self.descriptionTextView.text = descriptionString ;
}

-(void)fetchThumbnailImage:(NSString*)imageURL
{
    NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    __weak typeof(self) weakSelf = self ;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.thumbnailLoadingIndicator stopAnimating] ;
        weakSelf.thumbnailImageView.image = [UIImage imageWithData:imageData];
    });
}

@end
