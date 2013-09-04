//
//  SettingsViewController.m
//  Matchismo
//
//  Created by Marko Tadić on 7/17/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import "SettingsViewController.h"
#import "Settings.h"

@interface SettingsViewController ()
@property (strong, nonatomic) Settings *settings;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultyPicker;
@property (weak, nonatomic) IBOutlet UITextView *display;
@end

@implementation SettingsViewController

@synthesize difficulty = _difficulty;

#pragma mark - Properties

- (Settings *)settings
{
    if (!_settings) _settings = [[Settings alloc] initGame:@"Unknown" WithDifficulty:self.difficulty];
    return _settings;
}

- (NSString *)difficulty
{
    if (!_difficulty) _difficulty = [SettingsViewController getSavedDifficulty];
    return _difficulty;
}

#define DIFFICULTY_KEY @"Settings_difficulty"

- (void)setDifficulty:(NSString *)difficulty
{
    [[NSUserDefaults standardUserDefaults] setValue:difficulty forKey:DIFFICULTY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.settings = [[Settings alloc] initGame:@"Unknown" WithDifficulty:difficulty];
    _difficulty = difficulty;
    [self updateUI];
}

+ (NSString *)getSavedDifficulty
{
    NSString *defaultDifficulty = [Settings defaultDifficulty];
    NSString *savedDifficulty = [[NSUserDefaults standardUserDefaults] stringForKey:DIFFICULTY_KEY];

    return (!savedDifficulty) ? defaultDifficulty : savedDifficulty;
}

#pragma mark - View Controller Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

#pragma mark - UI stuff

- (IBAction)changeDifficulty:(UISegmentedControl *)sender
{
    [self setDifficulty:[sender titleForSegmentAtIndex:[sender selectedSegmentIndex]]];
}

- (void)updateUI
{
    self.difficultyPicker.selectedSegmentIndex = [[Settings validDifficulties] indexOfObject:self.settings.difficulty];
    
    NSMutableAttributedString *completeString = [[NSMutableAttributedString alloc] init];
    [completeString appendAttributedString:[self createAttributedStringWith:[NSString stringWithFormat:@"Flip: -%d \n", self.settings.flipCost]
                                                                   andColor:[UIColor colorWithRed:1 green:0.25 blue:0.25 alpha:1]]];
    [completeString appendAttributedString:[self createAttributedStringWith:[NSString stringWithFormat:@"Mismatch: -%d \n", self.settings.mismatchPenalty]
                                                                   andColor:[UIColor colorWithRed:1 green:0.25 blue:0.25 alpha:1]]];
    [completeString appendAttributedString:[self createAttributedStringWith:[NSString stringWithFormat:@"Match: %d \n", self.settings.matchBonus]
                                                                   andColor:[UIColor colorWithRed:0.5 green:1 blue:0 alpha:1]]];
    [completeString appendAttributedString:[self createAttributedStringWith:[NSString stringWithFormat:@"Set: %d \n", self.settings.setBonus]
                                                                   andColor:[UIColor colorWithRed:0.5 green:1 blue:0 alpha:1]]];
    
    NSMutableParagraphStyle *attributedStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedStyle setAlignment:NSTextAlignmentCenter];
    [completeString addAttribute:NSParagraphStyleAttributeName value:attributedStyle range:NSMakeRange(0, [completeString length])];
    
    self.display.attributedText = completeString;
}

- (NSAttributedString *)createAttributedStringWith:(NSString *)string andColor:(UIColor *)color
{
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:40], NSForegroundColorAttributeName: color };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    
    return attributedString;
}

@end
