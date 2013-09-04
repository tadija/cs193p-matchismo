//
//  SetCard.m
//  Matchismo
//
//  Created by Marko Tadić on 8/7/13.
//  Copyright (c) 2013. tadija. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

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
        
        NSArray *numbers = @[@(setCard1.number), @(setCard2.number), @(setCard3.number)];
        NSArray *symbols = @[@(setCard1.symbol), @(setCard2.symbol), @(setCard3.symbol)];
        NSArray *shadings = @[@(setCard1.shading), @(setCard2.shading), @(setCard3.shading)];
        NSArray *colors = @[@(setCard1.color), @(setCard2.color), @(setCard3.color)];
        
        // check for set on all properties
        if ([self checkForSet:numbers] && [self checkForSet:symbols] && [self checkForSet:shadings] && [self checkForSet:colors]) {
            score += SET_SCORE;
        }
        
    }
    
    return score;
}

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

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%d;%d;%d;%d", self.number, self.symbol, self.shading, self.color];
}

+ (NSArray *)validNumbers
{
    return @[@1, @2, @3];
}

- (void)setNumber:(NSUInteger)number
{
    _number = [[SetCard validNumbers] containsObject:@(number)] ? number : 0;
}

+ (NSArray *)validSymbols
{
    return @[@(SetCardSymbolDiamond), @(SetCardSymbolSquiggle), @(SetCardSymbolOval)];
}

- (void)setSymbol:(SetCardSymbol)symbol
{
    _symbol = [[SetCard validSymbols] containsObject:@(symbol)] ? symbol : 0;
}

+ (NSArray *)validShadings
{
    return @[@(SetCardShadingSolid), @(SetCardShadingStriped), @(SetCardShadingOpen)];
}

- (void)setShading:(SetCardShading)shading
{
    _shading = [[SetCard validShadings] containsObject:@(shading)] ? shading : 0;
}

+ (NSArray *)validColors
{
    return @[@(SetCardColorRed), @(SetCardColorGreen), @(SetCardColorPurple)];
}

- (void)setColor:(SetCardColor)color
{
    _color = [[SetCard validColors] containsObject:@(color)] ? color : 0;
}

@end
