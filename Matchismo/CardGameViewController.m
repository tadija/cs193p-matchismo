//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Marko Tadić on 7/4/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import "CardGameViewController.h"
#import "GameResult.h"

@interface CardGameViewController () <UIAlertViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) GameResult *gameResult;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipInfoLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@end

@implementation CardGameViewController

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.startingCardCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    // abstract
}

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

#pragma mark - Updating the UI

- (void)viewDidLoad
{
    [self updateUI];
}

- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }
    
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

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        [self.game flipCardAtIndex:indexPath.item];
        self.flipCount++;
        self.gameResult.score = self.game.score;
        [self updateUI];
    }
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
