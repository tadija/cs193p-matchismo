//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Marko Tadić on 7/4/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import "CardGameViewController.h"
//#import "GameResult.h"

@interface CardGameViewController () <UICollectionViewDataSource>
@property (strong, nonatomic) GameResult *gameResult;
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

#pragma mark - Updating the UI

- (void)viewDidLoad
{
    [self updateUI:-1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateUI:-1];
}

- (void)updateUI:(NSInteger)flippedCardIndex
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }
    
    [self updateCustomUI:flippedCardIndex];
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    // abstract
    @throw [NSException exceptionWithName:@"updateCell usingCard" reason:@"Method not implemented (abstract)" userInfo:nil];
}

- (void)updateCustomUI:(NSInteger)flippedCardIndex
{
    // abstract
    @throw [NSException exceptionWithName:@"updateCustomUI" reason:@"Method not implemented (abstract)" userInfo:nil];
}

#define pragma mark - Target/Action/Gestures

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        [self.game flipCardAtIndex:indexPath.item];
        self.gameResult.score = self.game.score;
        [self updateUI:indexPath.item];
    }
}

- (IBAction)restartGame
{
    // abstract
    @throw [NSException exceptionWithName:@"customRestartGame" reason:@"Method not implemented (abstract)" userInfo:nil];
}

@end
