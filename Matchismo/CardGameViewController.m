//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Marko Tadić on 7/4/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import "CardGameViewController.h"
#import "GameResult.h"

@interface CardGameViewController () <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) GameResult *gameResult;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipInfoLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@end

@implementation CardGameViewController

#pragma mark - Properties

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    _gameResult.game = self.game.settings.gameDescription;
    _gameResult.difficulty = self.game.settings.difficulty;
    return _gameResult;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

#pragma mark - Updating the UI

- (void)viewDidLoad
{
    [self updateUI];
}

- (void)updateUI
{
    [self updateCardsUI];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    // set history slider (which sets lastFlipInfoLabel)
    self.historySlider.maximumValue = [self.game.allFlipsInfo count] - 1;
    self.historySlider.value = [self.game.allFlipsInfo count] - 1;
    [self historySlide:self.historySlider];
}

- (void)updateCardsUI
{
    // abstract
}

- (NSAttributedString *)parseFlipInfoFromString:(NSString *)info { return nil; } // abstract

#define pragma mark - Target/Action/Gestures

- (IBAction)historySlide:(UISlider *)sender
{
    NSString *flipInfo = self.game.allFlipsInfo[(int)sender.value];
    self.lastFlipInfoLabel.attributedText = [self parseFlipInfoFromString:flipInfo];
    self.lastFlipInfoLabel.alpha = (sender.value < sender.maximumValue ? 0.5 : 1.0);
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    self.gameResult.score = self.game.score;
    [self updateUI];
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
        [self updateUI];
    }
}

@end
