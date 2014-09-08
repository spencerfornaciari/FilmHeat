//
//  Actor.m
//  Film Heat
//
//  Created by Spencer Fornaciari on 9/7/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "Actor.h"
#import "Character.h"
#import "Film.h"


@implementation Actor

@dynamic name;
@dynamic film;
@dynamic characters;

-(void)addNewCharacterObject:(Character *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.characters];
    [tempSet addObject:value];
    self.characters = tempSet;
}

@end
