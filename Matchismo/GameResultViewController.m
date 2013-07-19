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
    NSString *displayText = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    for (GameResult *result in [[GameResult allGameResults] sortedArrayUsingSelector:self.sortSelector]) { // sorted
        displayText = [displayText stringByAppendingFormat:@"Date: %@ | Duration: %0g\nGame: %@ | Score: %d | Difficulty: %@\n\n",
                       [formatter stringFromDate:result.end], round(result.duration), result.game, result.score, result.difficulty];
    }
    self.display.textColor = [UIColor whiteColor];
    self.display.text = displayText;
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
