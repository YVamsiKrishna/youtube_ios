//
//  VideoViewController.h
//  YouTube
//
//  Created by Vamsi Krishna on 26/11/15.
//  Copyright © 2015 Vamsi Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YoutubePresentedViewController.h"

@interface VideoViewController : YoutubePresentedViewController
-(instancetype)initWithVideoDictionary:(NSDictionary*)data;
-(instancetype)initWithVideoDictionaryForPopular:(NSDictionary*)data;
@end
