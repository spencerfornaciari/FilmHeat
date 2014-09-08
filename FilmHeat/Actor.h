//
//  Actor.h
//  Film Heat
//
//  Created by Spencer Fornaciari on 9/7/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character, Film;

@interface Actor : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Film *film;
@property (nonatomic, retain) NSOrderedSet *characters;
@end

@interface Actor (CoreDataGeneratedAccessors)

- (void)insertObject:(Character *)value inCharactersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCharactersAtIndex:(NSUInteger)idx;
- (void)insertCharacters:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCharactersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCharactersAtIndex:(NSUInteger)idx withObject:(Character *)value;
- (void)replaceCharactersAtIndexes:(NSIndexSet *)indexes withCharacters:(NSArray *)values;
- (void)addCharactersObject:(Character *)value;
- (void)removeCharactersObject:(Character *)value;
- (void)addCharacters:(NSOrderedSet *)values;
- (void)removeCharacters:(NSOrderedSet *)values;

@end
