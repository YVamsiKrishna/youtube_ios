//
//  NSURL+YouTubeAdditions.h
//  YouTube
//
//  Created by Vamsi Krishna on 23/11/15.
//  Copyright © 2015 Vamsi Krishna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (YouTubeAdditions)
-(NSURL*)addQueryParameterValue:(NSObject*)value forKey:(NSString*)key ;
@end
