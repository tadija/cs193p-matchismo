//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Marko Tadić on 7/4/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "GameResult.h"

@interface CardGameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *cardsLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) NSMutableArray *multiplayerScores; // of NSNumber
@property (nonatomic) int currentPlayer;

@property (strong, nonatomic) CardMatchingGame *game; // abstract

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animated:(BOOL)animated; // abstract
- (void)updateCustomUI:(NSInteger)flippedCardIndex; // abstract
- (IBAction)restartGame; // abstract

- (void)updateUI:(NSInteger)flippedCardIndex;

@end
