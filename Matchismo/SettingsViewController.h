//
//  SettingsViewController.h
//  Matchismo
//
//  Created by Marko Tadić on 7/17/13.
//  Copyright (c) 2013 tadija. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (strong, nonatomic, readonly) NSString *difficulty;

+ (NSString *)getSavedDifficulty;

@end
