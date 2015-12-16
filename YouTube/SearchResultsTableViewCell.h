//
//  SearchResultsTableViewCell.h
//  YouTube
//
//  Created by Vamsi Krishna on 24/11/15.
//  Copyright © 2015 Vamsi Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsTableViewCell : UITableViewCell

- (void)setupCellWithThumbnailURL:(NSString*)urlString title:(NSString*)titleString description:(NSString*)descriptionString;
@end
