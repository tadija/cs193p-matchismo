//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Marko Tadić on 9/7/13.
//  Copyright (c) 2013. tadija. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SettingsViewController.h"
#import "SetCard.h"
#import "SetCardCollectionViewCell.h"

@interface SetCardGameViewController()
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@end

@implementation SetCardGameViewController

@synthesize game = _game;

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:12
                                                          usingDeck:[[SetCardDeck alloc] init]
                                                      andMatchCount:3
                                                       withSettings:[[Settings alloc] initGame:@"Set" WithDifficulty:[SettingsViewController getSavedDifficulty]]];
    return _game;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            setCardView.number = setCard.number;
            setCardView.symbol = setCard.symbol;
            setCardView.shading = setCard.shading;
            setCardView.color = setCard.color;
            setCardView.faceUp = setCard.isFaceUp;
            setCardView.penalty = setCard.isPenalty;
        }
    }
}

- (void)updateCellsWithIndexPaths:(NSMutableArray *)indexPaths
{    
    NSMutableIndexSet *unplayableCardIndexes = [[NSMutableIndexSet alloc] init];
    for (NSIndexPath *indexPath in indexPaths)
    {
        [unplayableCardIndexes addIndex:indexPath.item];
    }
    
    [self.cardCollectionView performBatchUpdates:^{
        [self.game deleteCardsAtIndexes:unplayableCardIndexes];
        [self.cardCollectionView deleteItemsAtIndexPaths:indexPaths];
    } completion:nil];
}

- (void)updateCustomUI
{
    if (!self.game.cardsInDeck) {
        self.dealButton.enabled = NO;
        self.dealButton.alpha = 0.3;
    }
}

#define DEAL_CARDS_COUNT 3
- (IBAction)dealMoreCards:(UIButton *)sender
{
    NSIndexSet *newCardIndexes = [self.game dealCards:DEAL_CARDS_COUNT];
    NSMutableArray *newCardIndexPaths = [[NSMutableArray alloc] init];
    
    [newCardIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [newCardIndexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
    }];
    
    [self.cardCollectionView performBatchUpdates:^{
        [self.cardCollectionView insertItemsAtIndexPaths:newCardIndexPaths];
    } completion:^(BOOL finished) {
        [self.cardCollectionView scrollToItemAtIndexPath:[newCardIndexPaths lastObject] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }];
    
    [self updateCustomUI];
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

#pragma mark Helper methods

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
