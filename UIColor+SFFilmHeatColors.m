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
    return [UIColor colorWithRed:0/255.f green:122/255.f blue:255/255.f alpha:1];
}

+ (UIColor *)theaterColor{
    return [UIColor whiteColor];
}

+ (UIColor *)wantedColor{
    return [UIColor colorWithRed:255/255.f green:204/255.f blue:0/255.f alpha:1];
}

+ (UIColor *)noInterestColor{
    return [UIColor whiteColor];
}

+ (UIColor *)navigationBarColor {
    return [UIColor colorWithRed:228/255.f green:76/255.f blue:60/255.f alpha:1];
}

+ (UIColor *)filmHeatPrimaryColor {
    return [UIColor colorWithRed:228/255.f green:76/255.f blue:60/255.f alpha:1];
}


+ (UIColor *)filmHeatComplementaryColor {
    return [UIColor whiteColor];
}

+ (UIColor *)goColor {
    return [UIColor colorWithRed:76/255.f green:217/255.f blue:100/255.f alpha:1];
}

@end