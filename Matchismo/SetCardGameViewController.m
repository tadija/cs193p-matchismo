//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Marko Tadić on 9/7/13.
//  Copyright (c) 2013. tadija. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "CardMatchingGame.h"
#import "SetCardDeck.h"
#import "SettingsViewController.h"

@interface SetCardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation SetCardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                          usingDeck:[[SetCardDeck alloc] init]
                                                      andMatchCount:3
                                                       withSettings:[[Settings alloc] initGame:@"Set" WithDifficulty:[SettingsViewController getSavedDifficulty]]];
    return _game;
}

- (void)updateCardsUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.hidden = card.isUnplayable;
        
        if (cardButton.selected) {
            if (card.isPenalty) {
                [cardButton setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.1]];
            } else {
                [cardButton setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
            }
        } else {
            [cardButton setBackgroundColor:[UIColor whiteColor]];
        }
        
        NSAttributedString *cardContents = [self cardContentsWithString:card.contents];
        [cardButton setAttributedTitle:cardContents forState:UIControlStateNormal];
        [cardButton setAttributedTitle:cardContents forState:UIControlStateSelected];
    }
}

- (NSAttributedString *)parseFlipInfoFromString:(NSString *)info
{
    NSMutableAttributedString *attributedInfo = [[NSMutableAttributedString alloc] initWithString:info];
    [attributedInfo addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:13],
                                     NSForegroundColorAttributeName : [UIColor whiteColor] }
                            range:NSMakeRange(0, [attributedInfo length])];
    
    // looking for { ... }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\{(.+?)\\}" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:info options:0 range:NSMakeRange(0, [info length])];
    // change NSMutableAttributedString for each match
    for (int i = 1; i <= numberOfMatches; i++) {
        NSRange matchRange = [regex rangeOfFirstMatchInString:[attributedInfo string] options:0 range:NSMakeRange(0, [[attributedInfo string] length])];
        if (!NSEqualRanges(matchRange, NSMakeRange(NSNotFound, 0))) {
            NSString *matchString = [[attributedInfo string] substringWithRange:NSMakeRange(matchRange.location + 1, matchRange.length - 2)];
            [attributedInfo replaceCharactersInRange:matchRange withAttributedString:[self cardContentsWithString:matchString]];
        }
    }
    
    // set alignment and return final NSAttributedString
    NSMutableParagraphStyle *attributedStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedStyle setAlignment:NSTextAlignmentCenter];
    [attributedInfo addAttribute:NSParagraphStyleAttributeName value:attributedStyle range:NSMakeRange(0, [attributedInfo length])];
    return attributedInfo;
}

- (NSAttributedString *)cardContentsWithString:(NSString *)string
{
    NSArray *arr = [string componentsSeparatedByString:@";"];
    NSString *text = [self textWithSymbol:arr[1] andNumber:arr[0]];
    NSDictionary *attributes = [self attributesWithShading:arr[2] andColor:arr[3]];
    
    NSAttributedString *cardContents = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
    return cardContents;
}

- (NSString *)textWithSymbol:(NSString *)symbol andNumber:(NSNumber *)number
{
    NSDictionary *symbols = @{ @"diamond" : @"▲", @"squiggle" : @"■", @"oval" : @"●" };
    
    NSString *content = @"";
    for (int i = 1; i <= [number integerValue]; i++) {
        content = [content stringByAppendingString:[symbols objectForKey:symbol]];
    }
    
    return content;
}

- (NSDictionary *)attributesWithShading:(NSString *)shading andColor:(NSString *)color
{
    NSDictionary *colors = @{ @"red" : [UIColor redColor], @"green" : [UIColor greenColor], @"purple" : [UIColor purpleColor] };
    
    UIColor *solidColor = [colors objectForKey:color];
    UIColor *stripedColor = [[colors objectForKey:color] colorWithAlphaComponent:0.1];
    UIColor *openColor = [UIColor whiteColor];
    NSDictionary *shadings = @{ @"solid" : solidColor, @"striped" : stripedColor, @"open" : openColor };
    
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:18],
                                  NSStrokeWidthAttributeName: ([shading isEqualToString:@"solid"]) ? @0 : @-5,
                                  NSStrokeColorAttributeName: solidColor,
                                  NSForegroundColorAttributeName: [shadings objectForKey:shading]
                                };
    
    return attributes;
}

@end
