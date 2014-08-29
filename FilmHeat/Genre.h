//
//  Genre.h
//  Film Heat
//
//  Created by Spencer Fornaciari on 8/29/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Genre : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSManagedObject *film;

@end
