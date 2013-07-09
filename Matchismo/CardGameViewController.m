//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Marko Tadić on 7/4/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "GameResult.h"

@interface CardGameViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeControl;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) GameResult *gameResult;
@end

@implementation CardGameViewController

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    return _gameResult;
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                          usingDeck:[[PlayingCardDeck alloc] init]
                                                      andMatchCount:2];
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

#define CARD_BACK_INSET 5

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
        // set card back image
        UIImage *cardBackImage = [UIImage imageNamed:@"redCardBack.jpg"];
        [cardButton setImage:(card.isFaceUp ? nil : cardBackImage) forState:UIControlStateNormal];
        [cardButton setImageEdgeInsets:UIEdgeInsetsMake(CARD_BACK_INSET, CARD_BACK_INSET, CARD_BACK_INSET, CARD_BACK_INSET)];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    // set history slider (which sets lastFlipInfoLabel)
    self.historySlider.maximumValue = [self.game.allFlipsInfo count] - 1;
    self.historySlider.value = [self.game.allFlipsInfo count] - 1;
    [self historySlide:self.historySlider];
}

- (IBAction)historySlide:(UISlider *)sender
{
    self.lastFlipInfoLabel.text = self.game.allFlipsInfo[(int)sender.value];
    self.lastFlipInfoLabel.alpha = (sender.value < sender.maximumValue ? 0.5 : 1.0);
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
    self.gameResult.score = self.game.score;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    self.gameModeControl.enabled = self.flipCount > 0 ? NO : YES;
}

- (IBAction)dealNewCards:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Re-deal all cards" message:@"Do you want to start a new game?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // start a new game
    if (buttonIndex == 1) {
        self.game = nil;
        self.gameResult = nil;
        self.flipCount = 0;
        //[self setGameMode:self.gameModeControl];
        [self updateUI];
    }
}

@end
