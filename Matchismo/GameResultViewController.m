//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Marko Tadić on 7/5/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"

@interface GameResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *display;
@property (nonatomic) SEL sortSelector;
@end

@implementation GameResultViewController

- (void)updateUI
{
    NSMutableAttributedString *displayText = [[NSMutableAttributedString alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    for (GameResult *result in [[GameResult allGameResults] sortedArrayUsingSelector:self.sortSelector]) { // sorted        
        NSString *normalString = [NSString stringWithFormat:@"Date: %@ | Duration: %0g\n", [formatter stringFromDate:result.end], round(result.duration)];
        NSString *boldString = [NSString stringWithFormat:@"%@ | Score: %d | Difficulty: %@\n\n", result.game, result.score, result.difficulty];
        
        UIColor *color = ([result.game isEqual: @"Match"]) ? [UIColor colorWithRed:0.5 green:1 blue:0 alpha:1] : [UIColor colorWithRed:0.4 green:0.8 blue:1 alpha:1];
        
        [displayText appendAttributedString:[self createAttributedStringWith:normalString andColor:color bold:NO]];
        [displayText appendAttributedString:[self createAttributedStringWith:boldString andColor:color bold:YES]];
    }
    
    self.display.attributedText = displayText;
}

- (NSAttributedString *)createAttributedStringWith:(NSString *)string andColor:(UIColor *)color bold:(BOOL)isBold
{
    NSDictionary *attributes = [[NSDictionary alloc] init];
    
    if (isBold) {
        attributes = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName: color };
    } else {
        attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName: [UIColor whiteColor] };
    }
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    
    return attributedString;
}

#pragma mark - View Controller Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

#pragma mark - Sorting

@synthesize sortSelector = _sortSelector;  // because we implement BOTH setter and getter

// return default sort selector if none set (by score)
- (SEL)sortSelector
{
    if (!_sortSelector) _sortSelector = @selector(compareEndDateToGameResult:);
    return _sortSelector;
}

// update the UI when changing the sort selector
- (void)setSortSelector:(SEL)sortSelector
{
    _sortSelector = sortSelector;
    [self updateUI];
}

- (IBAction)changeSorting:(UISegmentedControl *)sender
{
    NSInteger idx = [sender selectedSegmentIndex];
    if (idx == 0) {
        self.sortSelector = @selector(compareEndDateToGameResult:);
    } else if (idx == 1) {
        self.sortSelector = @selector(compareScoreToGameResult:);
    } else if (idx == 2) {
        self.sortSelector = @selector(compareDurationToGameResult:);
    }
}


#pragma mark - (Unused) Initialization before viewDidLoad

- (void)setup
{
    // initialization that can't wait until viewDidLoad
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup];
    return self;
}

@end
