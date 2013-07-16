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

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck andMatchCount:(NSUInteger)matchCount
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
                break;
            } else {
                self.cards[i] = card;
            }
        }
        self.matchCount = matchCount;
    }
    
    return self;
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

#define FLIP_COST 1
#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4
#define MATCH_THREE_BONUS 6

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
                    [otherCards addObject:otherCard];
                }
            }
            // if there aren't any other cards take flip cost and show info
            if ([otherCards count] == 0) {
                self.score -= FLIP_COST;
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
                        self.score += matchScore * MATCH_BONUS;
                        self.flipInfo = [NSString stringWithFormat:@"Matched {%@} and {%@} for %d points!", card.contents, otherCard.contents, matchScore * MATCH_BONUS];
                    // do stuff for miss match
                    } else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.flipInfo = [NSString stringWithFormat:@"{%@} and {%@} don't match! (-%d penalty)", card.contents, otherCard.contents, MISMATCH_PENALTY];
                    }
                }
                // do stuff for 3-card match game
                else if (self.matchCount == 3) {
                    self.score -= FLIP_COST;                    
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
                    self.score += matchScore * MATCH_THREE_BONUS;
                    self.flipInfo = [NSString stringWithFormat:@"Matched {%@} {%@} {%@} for %d points!", card.contents, otherCard1.contents, otherCard2.contents, matchScore * MATCH_THREE_BONUS];
                } else {
                    otherCard1.faceUp = NO;
                    otherCard2.faceUp = NO;
                    card.faceUp = NO; // check this
                    self.score -= MISMATCH_PENALTY;
                    self.flipInfo = [NSString stringWithFormat:@"{%@} {%@} {%@} don't match! (-%d penalty)", card.contents, otherCard1.contents, otherCard2.contents, MISMATCH_PENALTY];
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

@end
