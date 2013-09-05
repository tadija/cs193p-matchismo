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

@interface PlayingCardGameViewController() <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lastFlipDescriptionLabel;
@property (nonatomic) NSUInteger cardCount;
@end

@implementation PlayingCardGameViewController

@synthesize game = _game;

- (NSUInteger)cardCount
{
    return (!_cardCount) ? 24 : _cardCount;
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardCount
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

- (void)updateCustomUI:(NSInteger)flippedCardIndex
{
    NSString *flipInfo = [self.game.allFlipsInfo lastObject];
    self.lastFlipDescriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:flipInfo];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.game.score];
}

- (IBAction)restartGame
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restart game" message:@"How many cards do you want?"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.placeholder = @"Enter a number (2-52)";
    textField.text = [NSString stringWithFormat:@"%d", self.cardCount];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // start new game with entered card count
    if (buttonIndex == 1) {
        NSUInteger numberOfCards = [[alertView textFieldAtIndex:0].text intValue];
        self.cardCount = numberOfCards;
        self.game = nil;
        [self.cardCollectionView reloadData];
        [self updateCustomUI:-1];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSUInteger numberOfCards = [[alertView textFieldAtIndex:0].text intValue];
    
    return (numberOfCards >= 2 && numberOfCards <= 52) ? YES : NO;
}

@end