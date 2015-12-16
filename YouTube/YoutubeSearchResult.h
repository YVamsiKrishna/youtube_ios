//
//  YoutubeSearchResult.h
//  YouTube
//
//  Created by VK on 16/12/15.
//  Copyright © 2015 Vamsi Krishna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YouTubeSearchResult : NSObject
@property (strong, nonatomic) NSString* channelId ;
@property (strong, nonatomic) NSString* channelTitle ;
@property (strong, nonatomic) NSString* thumbnailUrl ;
@property (strong, nonatomic) NSString* itemDescription ;
@end
