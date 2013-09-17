//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Marko Tadić on 7/4/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardView.h"
#import "PlayingCardCollectionViewCell.h"
#import "SetCardCollectionViewCell.h"

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

- (void)setCardsLeft:(NSUInteger)cardsLeft
{
    _cardsLeft = cardsLeft;
    
    // set label for cards left in the deck
    NSString *cardsLeftString = [[NSString alloc] init];
    if (cardsLeft > 0) {
        cardsLeftString = [NSString stringWithFormat:@"Cards in deck: %d (swipe right to deal more cards)", self.game.cardsInDeck];
    } else {
        cardsLeftString = @"There are no more cards in the deck...";
    }
    self.cardsLeftLabel.text = cardsLeftString;
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
    [self updateCell:cell usingCard:card animated:NO];
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

#define DISABLED_ALPHA 0.3
#define ENABLED_ALPHA 1.0
- (void)updateUI:(NSInteger)flippedCardIndex
{
    // draw all the cards
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card animated:(indexPath.item == flippedCardIndex && !card.isUnplayable)];
    }
    
    // update game specific UI
    [self updateCustomUI:flippedCardIndex];
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animated:(BOOL)animated
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

- (IBAction)dealMoreCards:(UISwipeGestureRecognizer *)sender
{
    // deal new cards if deck is not empty
    if (self.game.cardsInDeck > 0) {
        // get indexes of dealt cards
        NSIndexSet *newCardIndexes = [self.game dealCards:self.game.matchCount];
        NSMutableArray *newCardIndexPaths = [[NSMutableArray alloc] init];
        // and create indexPaths foreach
        [newCardIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            [newCardIndexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
        }];
        // then add them to cardCollectionView and scroll to new cards when complete
        [self.cardCollectionView performBatchUpdates:^{
            [self.cardCollectionView insertItemsAtIndexPaths:newCardIndexPaths];
        } completion:^(BOOL finished) {
            [self.cardCollectionView scrollToItemAtIndexPath:[newCardIndexPaths lastObject] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }];
        // hint penalty if set exists
        [self.game findHintAndHighlightCards:NO];
        // finally, update the UI
        [self updateUI:-1];
    } else if (![self.game findHintAndHighlightCards:NO]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GAME OVER!"
                                                        message:@"No more cards in deck, \nno more hints to show..."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)showHintIfAvailable:(UIButton *)sender
{
    BOOL hintAvailable = [self.game findHintAndHighlightCards:YES];
    
    if (hintAvailable) {
        // highlight hint cards
        for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
            NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
            Card *card = (Card *)[self.game cardAtIndex:indexPath.item];
            CardView *cardView = nil;
            if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
                cardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
            } else if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
                cardView = ((SetCardCollectionViewCell *)cell).setCardView;
            }
            [UIView transitionWithView:cardView
                              duration:0.2
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                cardView.hint = card.hint;
                            }
                            completion:NULL];
        }
        // update score (hint penalty)
        self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.game.score];
    
    // if no hint available
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No hint available!"
                                                        message:@"Swipe right to deal more cards..."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)restartGame
{
    // abstract
    @throw [NSException exceptionWithName:@"customRestartGame" reason:@"Method not implemented (abstract)" userInfo:nil];
}

@end
