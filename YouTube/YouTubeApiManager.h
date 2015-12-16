//
//  YouTubeApiRequest.h
//  YouTube
//
//  Created by Vamsi Krishna on 23/11/15.
//  Copyright © 2015 Vamsi Krishna. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString* const SearchResultKindPath ;
FOUNDATION_EXPORT NSString* const SearchResultIDPath ;
FOUNDATION_EXPORT NSString* const SearchResultTitlePath ;
FOUNDATION_EXPORT NSString* const SearchResultDefaultURLPath ;
FOUNDATION_EXPORT NSString* const SearchResultChannelTitlePath ;
FOUNDATION_EXPORT NSString* const SearchResultDescriptionPath ;

@interface YouTubeApiManager : NSObject

+(void)getVideosForQueryString:(NSString*)query successHandler:(void (^)(NSData*,NSString*))successHandler errorHandler:(void (^)(NSError*, NSHTTPURLResponse*,NSString*))errorHandler;

+(void)getRelatedVideosForVideoId:(NSString*)videoId successHandler:(void (^)(NSData*))successHandler errorHandler:(void (^)(NSError*, NSHTTPURLResponse*))errorHandler;

+(void)getPopularVideoswithSuccessHandler:(void (^)(NSData*))successHandler errorHandler:(void (^)(NSError*, NSHTTPURLResponse*))errorHandler;
@end
