//
//  NSURL+YouTubeAdditions.m
//  YouTube
//
//  Created by Vamsi Krishna on 23/11/15.
//  Copyright © 2015 Vamsi Krishna. All rights reserved.
//

#import "NSURL+YouTubeAdditions.h"

@implementation NSURL (YouTubeAdditions)

-(NSURL*)addQueryParameterValue:(NSObject*)value forKey:(NSString*)key{
    
    NSString* encodedValue = [[value description]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLUserAllowedCharacterSet]];
    NSString* encodedKey = [[key description]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLUserAllowedCharacterSet]];
    
    NSString* urlString = [self absoluteString] ;
    BOOL isFirstParameter = ![urlString containsString:@"?"] ;
    NSString* newURLString = [NSString stringWithFormat:@"%@%@%@=%@",urlString,isFirstParameter? @"?" : @"&", encodedKey, encodedValue] ;

    return [[NSURL alloc] initWithString:newURLString] ;
}

@end
