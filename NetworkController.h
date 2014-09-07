//
//  NetworkController.h
//  Film Heat
//
//  Created by Spencer Fornaciari on 4/25/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TranslationController.h"


@interface NetworkController : NSObject

+(void)movieSearchWithTitle:(NSString *)title andCallback:(void (^)(NSArray *results))completion;

+(NSArray *)movieSearchWithTitle:(NSString *)title;
+(void)searchMoviesWithTitle:(NSString *)title;

@end
