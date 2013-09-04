//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Marko Tadić on 7/5/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@interface PlayingCardView : CardView

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

@end
