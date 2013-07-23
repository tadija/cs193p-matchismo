//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Marko Tadić on 23.7.13..
//  Copyright (c) 2013. tadija. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@end
