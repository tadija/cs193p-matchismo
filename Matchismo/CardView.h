//
//  CardView.h
//  Matchismo
//
//  Created by Marko Tadić on 6.8.13.
//  Copyright (c) 2013. tadija. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, getter = isUnplayable) BOOL unplayable;
@property (nonatomic, getter = isPenalty) BOOL penalty;
@property (nonatomic, getter = isHint) BOOL hint;

@end
