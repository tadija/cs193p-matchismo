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

@end

@implementation CardGameViewController

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.game.cardsInGame;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = [NSString stringWithFormat:@"%@Card", self.game.settings.gameDescription];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
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

- (void)viewWillAppear:(BOOL)animated
{
    [self updateUI];
}

- (void)updateUI
{
    NSMutableArray *unplayableCardIndexPaths = [[NSMutableArray alloc] init];
    
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        if (card.isUnplayable) {
            [unplayableCardIndexPaths addObject:indexPath];
        }
        [self updateCell:cell usingCard:card];
    }
    
    if ([unplayableCardIndexPaths count]) {
        [self updateCellsWithIndexPaths:unplayableCardIndexPaths];
    }
    
    [self updateCustomUI];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    // set history slider (which sets lastFlipInfoLabel)
    self.historySlider.maximumValue = [self.game.allFlipsInfo count] - 1;
    self.historySlider.value = [self.game.allFlipsInfo count] - 1;
    //[self historySlide:self.historySlider];
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    // abstract
    @throw [NSException exceptionWithName:@"updateCell usingCard" reason:@"Method not implemented (abstract)" userInfo:nil];
}

- (void)updateCellsWithIndexPaths:(NSMutableArray *)indexPaths
{
    // abstract
    @throw [NSException exceptionWithName:@"updateCellsWithIndexPaths" reason:@"Method not implemented (abstract)" userInfo:nil];
}

- (void)updateCustomUI
{
    // abstract
    @throw [NSException exceptionWithName:@"updateCustomUI" reason:@"Method not implemented (abstract)" userInfo:nil];
}

- (NSAttributedString *)parseFlipInfoFromString:(NSString *)info
{
    // abstract
    @throw [NSException exceptionWithName:@"parseFlipInfoFromString" reason:@"Method not implemented (abstract)" userInfo:nil];
}

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

- (IBAction)restartGame:(id)sender
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
        [self.cardCollectionView reloadData];
        [self updateUI];
    }
}

@end
