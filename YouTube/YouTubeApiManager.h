//
//  YouTubeApiRequest.h
//  YouTube
//
//  Created by Vamsi Krishna on 23/11/15.
//  Copyright © 2015 Vamsi Krishna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YouTubeApiManager : NSObject

+(void)getVideosForQueryString:(NSString*)query successHandler:(void (^)(NSData*))successHandler errorHandler:(void (^)(NSError*, NSHTTPURLResponse*))errorHandler;
@end
