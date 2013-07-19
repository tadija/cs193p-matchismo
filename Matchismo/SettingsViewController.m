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
@property (weak, nonatomic) IBOutlet UILabel *flipLabel;
@property (weak, nonatomic) IBOutlet UILabel *mismatchLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchLabel;
@property (weak, nonatomic) IBOutlet UILabel *setLabel;
@end

@implementation SettingsViewController

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

@synthesize difficulty = _difficulty;

#define DIFFICULTY_KEY @"Settings_difficulty"

+ (NSString *)getSavedDifficulty
{
    NSString *defaultDifficulty = [Settings defaultDifficulty];
    NSString *savedDifficulty = [[NSUserDefaults standardUserDefaults] stringForKey:DIFFICULTY_KEY];

    return (!savedDifficulty) ? defaultDifficulty : savedDifficulty;
}

- (void)setDifficulty:(NSString *)difficulty
{
    [[NSUserDefaults standardUserDefaults] setValue:difficulty forKey:DIFFICULTY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.settings = [[Settings alloc] initGame:@"Unknown" WithDifficulty:difficulty];
    _difficulty = difficulty;
    [self updateUI];
}

- (IBAction)changeDifficulty:(UISegmentedControl *)sender
{
    [self setDifficulty:[sender titleForSegmentAtIndex:[sender selectedSegmentIndex]]];
}

- (void)updateUI
{
    self.difficultyPicker.selectedSegmentIndex = [[Settings validDifficulties] indexOfObject:self.settings.difficulty];
    self.flipLabel.text = [NSString stringWithFormat:@"Flip: -%d", self.settings.flipCost];
    self.mismatchLabel.text = [NSString stringWithFormat:@"Mismatch: -%d", self.settings.mismatchPenalty];
    self.matchLabel.text = [NSString stringWithFormat:@"Match: %d", self.settings.matchBonus];
    self.setLabel.text = [NSString stringWithFormat:@"Set: %d", self.settings.setBonus];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

@end
