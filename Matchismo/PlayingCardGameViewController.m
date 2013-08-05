//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Marko Tadić on 7/9/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "SettingsViewController.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

@implementation PlayingCardGameViewController

@synthesize game = _game;

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:22
                                                          usingDeck:[[PlayingCardDeck alloc] init]
                                                      andMatchCount:2
                                                       withSettings:[[Settings alloc] initGame:@"Match" WithDifficulty:[SettingsViewController getSavedDifficulty]]];
    return _game;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.isFaceUp;
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

- (void)updateCellsWithIndexPaths:(NSMutableArray *)indexPaths
{
    // abstract
}

- (void)updateCustomUI
{
    // abstract
}

- (NSAttributedString *)parseFlipInfoFromString:(NSString *)info
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\{(.+?)\\}" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *newString = [regex stringByReplacingMatchesInString:info options:0 range:NSMakeRange(0, [info length]) withTemplate:@"$1"];
    
    return [[NSAttributedString alloc] initWithString:newString];
}

@end