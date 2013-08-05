//
//  SetCardView.h
//  SuperCard
//
//  Created by Marko Tadić on 7/25/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"
#import "SetCard.h"

@interface SetCardView : CardView

@property (nonatomic) NSUInteger number;
@property (nonatomic) SetCardSymbol symbol;
@property (nonatomic) SetCardShading shading;
@property (nonatomic) SetCardColor color;

@end
