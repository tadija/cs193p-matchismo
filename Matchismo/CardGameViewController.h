//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Marko Tadić on 7/4/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (strong, nonatomic) CardMatchingGame *game; // abstract

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card; // abstract
- (void)updateCustomUI:(NSInteger)flippedCardIndex; // abstract

@end
