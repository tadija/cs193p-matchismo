//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Marko Tadić on 7/4/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Settings.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
          andMatchCount:(NSUInteger)matchCount
           withSettings:(Settings *)settings;

- (Card *)cardAtIndex:(NSUInteger)index;
- (void)flipCardAtIndex:(NSUInteger)index;
- (void)deleteCardsAtIndexes:(NSIndexSet *)indexes;

- (NSIndexSet *)dealCards:(NSUInteger)numberOfCards;

@property (nonatomic, readonly) int score;
@property (strong, nonatomic) Settings *settings;
@property (nonatomic, readonly) NSUInteger cardsInGame;
@property (nonatomic, readonly) NSUInteger cardsInDeck;

@property (nonatomic, readonly) NSMutableArray *allFlipsInfo;

@end