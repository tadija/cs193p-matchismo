//
//  SetCard.m
//  Matchismo
//
//  Created by Marko Tadić on 8/7/13.
//  Copyright (c) 2013. tadija. All rights reserved.
//

#import "SetCard.h"

@interface SetCard()
- (BOOL)checkForSet:(NSArray *)array;
@end

@implementation SetCard

- (BOOL)checkForSet:(NSArray *)array // of three objects
{
    BOOL isSet = false;
    
    if (array && [array count] == 3) {
        NSSet *set = [NSSet setWithArray:array];
        if ([set count] == 1 || [set count] == 3) {
            // all are identical, or all are different
            isSet = true;
        }
    }
    
    return isSet;
}

#define SET_SCORE 6

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    // check if otherCards are SetCard class
    NSMutableArray *otherSetCards = [[NSMutableArray alloc] initWithCapacity:[otherCards count]];
    for (id otherCard in otherCards) {
        if ([otherCard isKindOfClass:[SetCard class]]) {
            SetCard *otherSetCard = (SetCard *)otherCard;
            [otherSetCards addObject:otherSetCard];
        }
    }
    
    // do matching only with 3 open cards
    if ([otherSetCards count] == 2) {
        SetCard *setCard1 = self;
        SetCard *setCard2 = otherSetCards[0];
        SetCard *setCard3 = otherSetCards[1];
        
        NSArray *numbers = @[setCard1.number, setCard2.number, setCard3.number];
        NSArray *symbols = @[setCard1.symbol, setCard2.symbol, setCard3.symbol];
        NSArray *shadings = @[setCard1.shading, setCard2.shading, setCard3.shading];
        NSArray *colors = @[setCard1.color, setCard2.color, setCard3.color];
        
        // check for set on all properties
        if ([self checkForSet:numbers] && [self checkForSet:symbols] && [self checkForSet:shadings] && [self checkForSet:colors]) {
            score = SET_SCORE;
        }
        
    }
    
    return score;
}

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%@;%@;%@;%@", self.number, self.symbol, self.shading, self.color];
}

+ (NSArray *)validNumbers
{
    return @[@1, @2, @3];
}

- (void)setNumber:(NSNumber *)number
{
    if ([[SetCard validNumbers] containsObject:number]) {
        _number = number;
    }
}

+ (NSArray *)validSymbols
{
    return @[@"diamond", @"squiggle", @"oval"];
}

- (void)setSymbol:(NSString *)symbol
{
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

+ (NSArray *)validShadings
{
    return @[@"solid", @"striped", @"open"];
}

- (void)setShading:(NSString *)shading
{
    if ([[SetCard validShadings] containsObject:shading]) {
        _shading = shading;
    }
}

+ (NSArray *)validColors
{
    return @[@"red", @"green", @"purple"];
}

- (void)setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
}

@end
