//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Marko Tadić on 7/9/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id)init
{
    self = [super init];
    
    if (self) {
        for (NSNumber *number in [SetCard validNumbers]) {
            for (NSNumber *symbol in [SetCard validSymbols]) {
                for (NSNumber *shading in [SetCard validShadings]) {
                    for (NSNumber *color in [SetCard validColors]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = [number intValue];
                        card.symbol = [symbol intValue];
                        card.shading = [shading intValue];
                        card.color = [color intValue];
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
        
    }
    
    return self;
}

@end
