//
//  NetworkController.m
//  Film Heat
//
//  Created by Spencer Fornaciari on 4/25/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "NetworkController.h"

@implementation NetworkController

+(void)movieSearchWithTitle:(NSString *)title andCallback:(void (^)(NSArray *results))completion {
    
    //Returns the top ten movies with a given search title
    
    NSString *titleSearchString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=%@&q=%@&page_limit=10", kROTTEN_TOMATOES_API_KEY, title];
    
    NSURL *titleUrl = [NSURL URLWithString:titleSearchString];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:titleUrl];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSArray *array = [dictionary objectForKey:@"movies"];
        
        completion(array);
        
//        for (NSDictionary *movieDictionary in array) {
//            NSLog(@"Title: %@", [movieDictionary objectForKey:@"title"]);
//        }
        
    }];
    
    [dataTask resume];
}

+(NSArray *)movieSearchWithTitle:(NSString *)title {
    
    //Returns the top ten movies with a given search title
    
    NSString *titleSearchString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=%@&q=%@&page_limit=10", kROTTEN_TOMATOES_API_KEY, title];
    
    NSURL *titleUrl = [NSURL URLWithString:titleSearchString];
    NSData *data = [NSData dataWithContentsOfURL:titleUrl];
    
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSArray *array = [TranslationController convertDictionaryArrayToFilmArray: [dictionary objectForKey:@"movies"]];

    return array;
}

+(void)searchMoviesWithTitle:(NSString *)title {
    
    //Returns the top ten movies with a given search title
    
    NSString *titleSearchString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=%@&q=%@&page_limit=10", kROTTEN_TOMATOES_API_KEY, title];
    
    NSURL *titleUrl = [NSURL URLWithString:titleSearchString];
    NSData *data = [NSData dataWithContentsOfURL:titleUrl];
    
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    [TranslationController convertDictionaryArrayToFilmArray: [dictionary objectForKey:@"movies"]];

}

@end
