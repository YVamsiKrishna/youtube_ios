//
//  YouTubeApiRequest.m
//  YouTube
//
//  Created by Vamsi Krishna on 23/11/15.
//  Copyright © 2015 Vamsi Krishna. All rights reserved.
//

#import "YouTubeApiManager.h"
#import "NSURL+YouTubeAdditions.h"

static NSString *const apiKey = @"AIzaSyD_eXDG2J1h-CLewl-f-ThDXNQxW2M2NFI" ;
static NSString *const baseURL = @"https://www.googleapis.com/youtube/v3/" ;
static NSString *const baseSearchURL = @"https://www.googleapis.com/youtube/v3/search" ;

@implementation YouTubeApiManager

+(void)getVideosForQueryString:(NSString *)query
      successHandler:(void (^)(NSData*))successHandler
        errorHandler:(void (^)(NSError*, NSHTTPURLResponse*))errorHandler
{
    
    NSURL* url = [[NSURL alloc] initWithString:baseSearchURL] ;
    url = [url addQueryParameterValue:@"id,snippet" forKey:@"part"] ;
    url = [url addQueryParameterValue:query forKey:@"q"] ;
    url = [url addQueryParameterValue:apiKey forKey:@"key"];

    NSLog(@"%@",url.absoluteString);
    NSURLSessionConfiguration* nsURLSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration] ;
    [nsURLSessionConfiguration allowsCellularAccess] ;
    NSURLSession* nsurlSession = [NSURLSession sessionWithConfiguration:nsURLSessionConfiguration];
    NSURLSessionDataTask* dataTask = [nsurlSession dataTaskWithURL:url
                                                 completionHandler:
    ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(response || data){
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response ;
            NSString* results = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
            NSLog(@"%@",results) ;
            NSLog(@"%@",httpResponse) ;
            if(httpResponse.statusCode == 200 && successHandler){
                successHandler(data) ;
            }else if(errorHandler){
                errorHandler(error,httpResponse);
            }
        }
    }] ;
    [dataTask resume];
}

@end
