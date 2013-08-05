//
//  CardView.m
//  Matchismo
//
//  Created by Marko Tadić on 6.8.13.
//  Copyright (c) 2013. tadija. All rights reserved.
//

#import "CardView.h"

@implementation CardView

#pragma mark - Initialization

- (void)setup
{
    // Initialization that can't wait until viewDidLoad
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization
        [self setup];
    }

    return self;
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void)setPenalty:(BOOL)penalty
{
    _penalty = penalty;
    [self setNeedsDisplay];
}

@end
