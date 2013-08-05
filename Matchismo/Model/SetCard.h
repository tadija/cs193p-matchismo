//
//  SetCard.h
//  Matchismo
//
//  Created by Marko Tadić on 8.7.13..
//  Copyright (c) 2013. tadija. All rights reserved.
//

#import "Card.h"

typedef enum {
    SetCardSymbolDiamond = 1,
    SetCardSymbolSquiggle = 2,
    SetCardSymbolOval = 3
} SetCardSymbol;

typedef enum {
    SetCardShadingSolid = 1,
    SetCardShadingStriped = 2,
    SetCardShadingOpen = 3
} SetCardShading;

typedef enum {
    SetCardColorRed = 1,
    SetCardColorGreen = 2,
    SetCardColorPurple = 3
} SetCardColor;

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (nonatomic) SetCardSymbol symbol;
@property (nonatomic) SetCardShading shading;
@property (nonatomic) SetCardColor color;

+ (NSArray *)validNumbers;
+ (NSArray *)validSymbols;
+ (NSArray *)validShadings;
+ (NSArray *)validColors;

@end
