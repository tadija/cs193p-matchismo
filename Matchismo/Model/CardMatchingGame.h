//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Marko Tadić on 7/4/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import "Deck.h"
#import "Settings.h"

@interface CardMatchingGame : NSObject

@property (strong, nonatomic) Settings *settings;
@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) NSUInteger matchCount;
@property (nonatomic, readonly) NSUInteger cardsInGame;
@property (nonatomic, readonly) NSUInteger cardsInDeck;
@property (nonatomic, readonly) NSMutableArray *allFlipsInfo;

// designated initializer
- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
          andMatchCount:(NSUInteger)matchCount
           withSettings:(Settings *)settings;

- (Card *)cardAtIndex:(NSUInteger)index;
- (void)flipCardAtIndex:(NSUInteger)index;
- (NSIndexSet *)findUnplayableCards;
- (void)deleteCardsAtIndexes:(NSIndexSet *)indexes;
- (NSIndexSet *)dealCards:(NSUInteger)numberOfCards;
- (BOOL)findHintAndHighlightCards:(BOOL)highlight;

@end