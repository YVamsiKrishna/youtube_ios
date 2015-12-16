//
//  YouTubeApiRequest.m
//  YouTube
//
//  Created by Vamsi Krishna on 23/11/15.
//  Copyright © 2015 Vamsi Krishna. All rights reserved.
//

#import "YouTubeApiManager.h"
#import "NSURL+YouTubeAdditions.h"

NSString* const SearchResultKindPath = @"id.kind";
NSString* const SearchResultVideoIDPath = @"id.videoId";
NSString* const SearchResultChannelIDPath = @"id.channelId";
NSString* const SearchResultTitlePath = @"snippet.title";
NSString* const SearchResultDefaultURLPath = @"snippet.thumbnails.default.url";
NSString* const SearchResultChannelTitlePath = @"channelTitle";
NSString* const SearchResultDescriptionPath = @"snippet.description";

static NSString *const apiKey = @"AIzaSyD_eXDG2J1h-CLewl-f-ThDXNQxW2M2NFI" ;

static NSString *const baseSearchURL = @"https://www.googleapis.com/youtube/v3/search" ;
static NSString *const baseVideoURL = @"https://www.googleapis.com/youtube/v3/videos" ;


@implementation YouTubeApiManager

+(void)getVideosForQueryString:(NSString *)query
      successHandler:(void (^)(NSData*,NSString*))successHandler
        errorHandler:(void (^)(NSError*, NSHTTPURLResponse*,NSString*))errorHandler
{
    
    NSURL* url = [[NSURL alloc] initWithString:baseSearchURL] ;
    url = [url addQueryParameterValue:@"id,snippet" forKey:@"part"] ;
    url = [url addQueryParameterValue:query forKey:@"q"] ;
    url = [url addQueryParameterValue:apiKey forKey:@"key"];

    NSLog(@"%@",url.absoluteString);
    
    [self sendRequestWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(response || data){
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response ;
            if(httpResponse.statusCode == 200 && successHandler){
                successHandler(data,query) ;
            }else if(errorHandler){
                NSLog(@"YoutubeAPI: %@",httpResponse);
                errorHandler(error,httpResponse,query);
            }
        }
    }] ;
}


+(void)getRelatedVideosForVideoId:(NSString*)videoId successHandler:(void (^)(NSData*))successHandler errorHandler:(void (^)(NSError*, NSHTTPURLResponse*))errorHandler
{
    NSURL* url = [[NSURL alloc] initWithString:baseSearchURL] ;
    url = [url addQueryParameterValue:@"id,snippet" forKey:@"part"] ;
    url = [url addQueryParameterValue:@"video" forKey:@"type"] ;
    url = [url addQueryParameterValue:videoId forKey:@"relatedToVideoId"] ;
    url = [url addQueryParameterValue:apiKey forKey:@"key"];
    
    NSLog(@"%@",url.absoluteString);
    
    [self sendRequestWithURL:url completionHandler:
                                      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                          NSLog(@"GOT REPSONSE, %@",data);
                                          if(response || data){
                                              NSString* results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
                                              NSLog(@"%@",results) ;
                                              NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response ;
                                              if(httpResponse.statusCode == 200 && successHandler){
                                                  successHandler(data) ;
                                              }else if(errorHandler){
                                                  NSLog(@"YoutubeAPI: %@",httpResponse);
                                                  errorHandler(error,httpResponse);
                                              }
                                          }
                                      }] ;
}

+(void)getPopularVideoswithSuccessHandler:(void (^)(NSData*))successHandler errorHandler:(void (^)(NSError*, NSHTTPURLResponse*))errorHandler
{
    NSURL* url = [[NSURL alloc] initWithString:baseVideoURL] ;
    url = [url addQueryParameterValue:@"id,snippet" forKey:@"part"] ;
    url = [url addQueryParameterValue:@"mostPopular" forKey:@"chart"] ;
    url = [url addQueryParameterValue:apiKey forKey:@"key"];
    
    NSLog(@"%@",url.absoluteString);
    
    [self sendRequestWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                          NSLog(@"GOT REPSONSE, %@",data);
                                          if(response || data){
                                              NSString* results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
                                              NSLog(@"%@",results) ;
                                              NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response ;
                                              if(httpResponse.statusCode == 200 && successHandler){
                                                  successHandler(data) ;
                                              }else if(errorHandler){
                                                  NSLog(@"YoutubeAPI: %@",httpResponse);
                                                  errorHandler(error,httpResponse);
                                              }
                                          }
                                      }] ;

}


+(void)sendRequestWithURL:(NSURL*)url completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler
{
    NSURLSessionConfiguration* nsURLSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration] ;
    [nsURLSessionConfiguration allowsCellularAccess] ;
    NSURLSession* nsurlSession = [NSURLSession sessionWithConfiguration:nsURLSessionConfiguration];
    NSURLSessionDataTask* dataTask = [nsurlSession dataTaskWithURL:url
                                                 completionHandler:completionHandler];
    [dataTask resume];
}
@end
