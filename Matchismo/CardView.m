//
//  CardView.m
//  Matchismo
//
//  Created by Marko Tadić on 6.8.13.
//  Copyright (c) 2013. tadija. All rights reserved.
//

#import "CardView.h"

@implementation CardView

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

#pragma mark - Properties

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void)setUnplayable:(BOOL)unplayable
{
    _unplayable = unplayable;
    [self setNeedsDisplay];
}

- (void)setPenalty:(BOOL)penalty
{
    _penalty = penalty;
    [self setNeedsDisplay];
}

- (void)setHint:(BOOL)hint
{
    _hint = hint;
    [self setNeedsDisplay];
}

@end
