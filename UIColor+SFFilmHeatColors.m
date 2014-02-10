//
//  UIColor+SFFilmHeatColors.m
//  FilmHeat
//
//  Created by Spencer Fornaciari on 1/31/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "UIColor+SFFilmHeatColors.h"

@implementation UIColor (SFFilmHeatColors)

+ (UIColor *)seenItColor{
    return [UIColor redColor];
}

+ (UIColor *)theaterColor{
    return [UIColor blueColor];
}

+ (UIColor *)wantedColor{
    return [UIColor purpleColor];
}

+ (UIColor *)noInterestColor{
    return [UIColor grayColor];
}

+ (UIColor *)navigationBarColor {
    return [UIColor colorWithRed:255/255.f green:19/255.f blue:0/255.f alpha:1];
}

@end