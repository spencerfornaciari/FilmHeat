//
//  SearchDisplayDataController.h
//  Film Heat
//
//  Created by Spencer Fornaciari on 4/18/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchDisplayDataController : NSObject <UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSMutableArray *searchArray;

@end
