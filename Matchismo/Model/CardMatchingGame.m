//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Marko Tadić on 7/4/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) Deck *deck;
@property (nonatomic) int score;
@property (nonatomic) NSUInteger matchCount;
@property (nonatomic) NSMutableString *flipInfo;
@property (nonatomic, readwrite) NSMutableArray *allFlipsInfo;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck andMatchCount:(NSUInteger)matchCount withSettings:(Settings *)settings
{
    self = [super init];
    
    if (self) {
        self.deck = deck;
        for (int i = 0; i < count; i++) {
            Card *card = [self.deck drawRandomCard];
            if (!card) {
                self = nil;
                break;
            } else {
                self.cards[i] = card;
            }
        }
        self.matchCount = matchCount;
        self.settings = settings;
    }
    
    return self;
}

- (NSUInteger)cardsInGame
{
    return [self.cards count];
}

- (NSUInteger)cardsInDeck
{
    return [self.deck cardsLeft];
}

- (NSIndexSet *)dealCards:(NSUInteger)numberOfCards
{
    NSMutableIndexSet *newCardIndexes = [[NSMutableIndexSet alloc] init];
    
    for (int i = 0; i < numberOfCards; i++) {
        Card *card = [self.deck drawRandomCard];
        if (card) {
            [self.cards addObject:card];
            [newCardIndexes addIndex:[self.cards indexOfObject:card]];
        }
    }
    
    return newCardIndexes;
}

- (NSString *)flipInfo
{
    if (!_flipInfo) _flipInfo = [[NSMutableString alloc] init];
    return _flipInfo;
}

- (NSMutableArray *)allFlipsInfo
{
    if (!_allFlipsInfo) _allFlipsInfo = [[NSMutableArray alloc] initWithObjects:@"Flip up any card!", nil];
    return _allFlipsInfo;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            // add all other faceup and playable cards to array
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    if (otherCard.isPenalty) {
                        otherCard.faceUp = NO;
                        otherCard.penalty = NO;
                    } else {
                        [otherCards addObject:otherCard];
                    }
                }
            }
            // if there aren't any other cards take flip cost and show info
            if ([otherCards count] == 0) {
                self.score -= self.settings.flipCost;
                self.flipInfo = [NSString stringWithFormat:@"Flipped up {%@}", card.contents];
                // if there is one
            } else if ([otherCards count] == 1) {
                Card *otherCard = [otherCards lastObject];
                // do stuff for 2-card match game
                if (self.matchCount == 2) {
                    int matchScore = [card match:otherCards];
                    if (matchScore) {
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * self.settings.matchBonus;
                        self.flipInfo = [NSString stringWithFormat:@"Matched {%@} and {%@} for %d points!", card.contents, otherCard.contents, matchScore * self.settings.matchBonus];
                    // do stuff for miss match
                    } else {
                        otherCard.penalty = YES;
                        card.penalty = YES;
                        self.score -= self.settings.mismatchPenalty;
                        self.flipInfo = [NSString stringWithFormat:@"{%@} and {%@} don't match! (-%d penalty)", card.contents, otherCard.contents, self.settings.mismatchPenalty];
                    }
                }
                // do stuff for 3-card match game
                else if (self.matchCount == 3) {
                    self.score -= self.settings.flipCost;
                    self.flipInfo = [NSString stringWithFormat:@"Flipped up {%@}", card.contents];
                }
            }
            // if there is two other cards (this is only for 3-card match game)
            else if ([otherCards count] == 2 && self.matchCount == 3) {
                Card *otherCard1 = otherCards[0];
                Card *otherCard2 = otherCards[1];
                int matchScore = [card match:otherCards];
                if (matchScore) {
                    otherCard1.unplayable = YES;
                    otherCard2.unplayable = YES;
                    card.unplayable = YES;
                    //[self.cards removeObjectsInArray:@[card, otherCard1, otherCard2]];
                    self.score += matchScore * self.settings.setBonus;
                    self.flipInfo = [NSString stringWithFormat:@"Matched {%@} {%@} {%@} for %d points!", card.contents, otherCard1.contents, otherCard2.contents, matchScore * self.settings.setBonus];
                } else {
                    otherCard1.penalty = YES;
                    otherCard2.penalty = YES;
                    card.penalty = YES;
                    self.score -= self.settings.mismatchPenalty;
                    self.flipInfo = [NSString stringWithFormat:@"{%@} {%@} {%@} don't match! (-%d penalty)", card.contents, otherCard1.contents, otherCard2.contents, self.settings.mismatchPenalty];
                }
            }
        }
        else { // if it's a flip down
            self.flipInfo = [NSString stringWithFormat:@"Flipped down {%@}", card.contents];
        }
        // and add flip info to allFlipsInfo
        [self.allFlipsInfo addObject:self.flipInfo];
        // in any case flip card
        card.faceUp = !card.isFaceUp;
    }
}

- (void)deleteCardsAtIndexes:(NSIndexSet *)indexes
{
    [self.cards removeObjectsAtIndexes:indexes];
}

@end
