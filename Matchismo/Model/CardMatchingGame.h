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

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;
@property (strong, nonatomic) Settings *settings;

@property (nonatomic, readonly) NSMutableArray *allFlipsInfo;

@end