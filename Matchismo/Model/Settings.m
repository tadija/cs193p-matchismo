//
//  Settings.m
//  Matchismo
//
//  Created by Marko Tadić on 7/17/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import "Settings.h"

@interface Settings()
@property (nonatomic, readwrite) int flipCost;
@property (nonatomic, readwrite) int mismatchPenalty;
@property (nonatomic, readwrite) int matchBonus;
@property (nonatomic, readwrite) int setBonus;

- (void)setPointsForDifficulty:(NSString *)difficulty;
@end

@implementation Settings

+ (NSArray *)validDifficulties
{
    return @[@"Easy", @"Normal", @"Hard"];
}

+ (NSString *)defaultDifficulty
{
    return [self validDifficulties][1];
}

- (id)initGame:(NSString *)gameDescription WithDifficulty:(NSString *)difficulty
{
    self = [super init];
    
    if (self) {
        self.gameDescription = gameDescription;
        self.difficulty = difficulty;
    }
    
    return self;
}

- (void)setDifficulty:(NSString *)difficulty
{
    if ([[Settings validDifficulties] containsObject:difficulty]) {
        _difficulty = difficulty;
    } else {
        _difficulty = [Settings defaultDifficulty];
    }
    [self setPointsForDifficulty:self.difficulty];
}

- (void)setPointsForDifficulty:(NSString *)difficulty
{
    if ([difficulty isEqualToString:@"Easy"]) {
        self.flipCost = 0;
        self.mismatchPenalty = 1;
        self.matchBonus = 6;
        self.setBonus = 8;
    } else if ([difficulty isEqualToString:@"Normal"]) {
        self.flipCost = 1;
        self.mismatchPenalty = 2;
        self.matchBonus = 4;
        self.setBonus = 6;
    } else if ([difficulty isEqualToString:@"Hard"]) {
        self.flipCost = 2;
        self.mismatchPenalty = 4;
        self.matchBonus = 2;
        self.setBonus = 4;
    }
}

@end
