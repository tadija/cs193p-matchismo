//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Marko Tadić on 7/4/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingCard.h"
#import "SetCard.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) Deck *deck;
@property (nonatomic, readwrite) NSUInteger matchCount;
@property (nonatomic, readwrite) int score;
@property (nonatomic) NSMutableString *flipInfo;
@property (nonatomic, readwrite) NSMutableArray *allFlipsInfo;
@end

@implementation CardMatchingGame

// designated initializer
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

#pragma mark - Properties

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSUInteger)cardsInGame
{
    return [self.cards count];
}

- (NSUInteger)cardsInDeck
{
    return [self.deck cardsLeft];
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

#pragma mark - Game

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];

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
    
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {

            // if there aren't any other cards take flip cost and show info
            if ([otherCards count] == 0) {
                self.score -= self.settings.flipCost;
                self.flipInfo = [NSString stringWithFormat:@"Flipped up %@", card.contents];
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
                        self.flipInfo = [NSString stringWithFormat:@"Matched %@ and %@", card.contents, otherCard.contents];
                    // do stuff for miss match
                    } else {
                        otherCard.penalty = YES;
                        card.penalty = YES;
                        self.score -= self.settings.mismatchPenalty;
                        self.flipInfo = [NSString stringWithFormat:@"%@ and %@ mismatch!", card.contents, otherCard.contents];
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
            self.flipInfo = [NSString stringWithFormat:@"Flipped down %@", card.contents];
        }
        // and add flip info to allFlipsInfo
        [self.allFlipsInfo addObject:self.flipInfo];
        // in any case flip card
        card.faceUp = !card.isFaceUp;
    }
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

- (NSIndexSet *)findUnplayableCards
{
    NSMutableIndexSet *unplayableCardIndexes = [[NSMutableIndexSet alloc] init];
    
    for (Card *card in self.cards) {
        if (card.isUnplayable) {
            [unplayableCardIndexes addIndex:[self.cards indexOfObject:card]];
        }
    }
    
    return unplayableCardIndexes;
}

- (void)deleteCardsAtIndexes:(NSIndexSet *)indexes
{
    [self.cards removeObjectsAtIndexes:indexes];
}

- (BOOL)findHintAndHighlightCards:(BOOL)highlight
{
    BOOL hintExists = NO;
    
    // remove hint from all cards
    for (Card *card in self.cards) {
        card.hint = NO;
    }
    
    // iterate all playable cards in the game
    for (Card *cardToCheck in self.cards) {
        
        if (!cardToCheck.isUnplayable) {
            
            // create array of all other playable cards
            NSMutableArray *allOtherCards = [self.cards mutableCopy];
            [allOtherCards removeObjectsAtIndexes:[self findUnplayableCards]];
            [allOtherCards removeObject:cardToCheck];            
        
            // iterate all other playable cards in the game
            for (int i = 0; i < [allOtherCards count]; i++) {
                
                // if cardToCheck is PlayingCard check for match
                if ([cardToCheck isKindOfClass:[PlayingCard class]]) {
                    // create all combinations of other card
                    NSMutableArray *otherCards = [[NSMutableArray alloc] initWithCapacity:1];
                    otherCards[0] = (PlayingCard *)allOtherCards[i];
                    // check for match in every combination
                    int score = [cardToCheck match:otherCards];
                    if (score) {
                        // set hint to cards which make match
                        if (highlight) {
                            cardToCheck.hint = YES;
                            for (Card *otherCard in otherCards) {
                                otherCard.hint = YES;
                            }
                        }
                        // set score penalty and return true
                        self.score -= self.settings.hintPenalty;
                        hintExists = YES;
                        goto hintFound;
                    }

                // if cardToCheck is SetCard check for set
                } else if ([cardToCheck isKindOfClass:[SetCard class]]) {
                    // create all combinations of two other cards
                    for (int j = i + 1; j < [allOtherCards count] - 1; j++) {
                        NSMutableArray *otherCards = [[NSMutableArray alloc] initWithCapacity:2];
                        otherCards[0] = (SetCard *)allOtherCards[i];
                        otherCards[1] = (SetCard *)allOtherCards[j];
                        // check for set in every combination
                        int score = [cardToCheck match:otherCards];
                        if (score) {
                            // set hint to cards which make set
                            if (highlight) {
                                cardToCheck.hint = YES;
                                for (Card *otherCard in otherCards) {
                                    otherCard.hint = YES;
                                }
                            }
                            // set score penalty and return true
                            self.score -= self.settings.hintPenalty;
                            hintExists = YES;
                            goto hintFound;
                        }
                    }
                }
            }
        }
    }
    
    hintFound:;
    return hintExists;
}

@end
