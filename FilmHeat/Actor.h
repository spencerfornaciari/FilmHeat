//
//  Actor.h
//  Film Heat
//
//  Created by Spencer Fornaciari on 8/29/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Film;

@interface Actor : NSManagedObject

@property (nonatomic, retain) NSString * character;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Film *film;

@end
