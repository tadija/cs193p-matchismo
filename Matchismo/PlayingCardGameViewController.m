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

//@interface PlayingCardGameViewController ()
//@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
//@end

@implementation PlayingCardGameViewController

@synthesize game = _game;

- (NSUInteger)startingCardCount
{
    return 20;
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

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                          usingDeck:[[PlayingCardDeck alloc] init]
                                                      andMatchCount:2
                                                       withSettings:[[Settings alloc] initGame:@"Match" WithDifficulty:[SettingsViewController getSavedDifficulty]]];
    return _game;
}

#define CARD_BACK_INSET 6

//- (void)updateCardsUI
//{
//    for (UIButton *cardButton in self.cardButtons) {
//        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
//        cardButton.selected = card.isFaceUp;
//        cardButton.enabled = !card.isUnplayable;
//        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
//        
//        [cardButton setTitle:card.contents forState:UIControlStateSelected];
//        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
//        UIImage *cardBackImage = [UIImage imageNamed:@"redCardBack.jpg"];
//        [cardButton setImage:(card.isFaceUp ? nil : cardBackImage) forState:UIControlStateNormal];
//        [cardButton setImageEdgeInsets:UIEdgeInsetsMake(CARD_BACK_INSET, CARD_BACK_INSET, CARD_BACK_INSET, CARD_BACK_INSET)];
//    }
//}
//
- (NSAttributedString *)parseFlipInfoFromString:(NSString *)info
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\{(.+?)\\}" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *newString = [regex stringByReplacingMatchesInString:info options:0 range:NSMakeRange(0, [info length]) withTemplate:@"$1"];
    
    return [[NSAttributedString alloc] initWithString:newString];
}

@end