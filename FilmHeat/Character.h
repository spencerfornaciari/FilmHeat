//
//  Character.h
//  Film Heat
//
//  Created by Spencer Fornaciari on 9/7/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actor;

@interface Character : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Actor *actor;

@end
