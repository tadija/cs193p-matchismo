//
//  SetCardCollectionViewCell.h
//  Matchismo
//
//  Created by Marko Tadić on 7/24/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetCardView.h"

@interface SetCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet SetCardView *setCardView;
@end
