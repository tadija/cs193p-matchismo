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

// all of the following methods must be overriden by concrete subclasses
@property (strong, nonatomic) CardMatchingGame *game; // abstract
- (void)updateCardsUI; // abstract
- (NSAttributedString *)parseFlipInfoFromString:(NSString *)info; // abstract

@end
