//
//  Settings.h
//  Matchismo
//
//  Created by Marko Tadić on 7/17/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (strong, nonatomic) NSString *gameDescription;
@property (strong, nonatomic) NSString *difficulty;

@property (nonatomic, readonly) int flipCost;
@property (nonatomic, readonly) int mismatchPenalty;
@property (nonatomic, readonly) int matchBonus;
@property (nonatomic, readonly) int setBonus;

+ (NSString *)defaultDifficulty;
+ (NSArray *)validDifficulties;

// designated initializer
- (id)initGame:(NSString *)gameDescription WithDifficulty:(NSString *)difficulty;

@end
