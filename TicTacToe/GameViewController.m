//
//  GameViewController.m
//  TicTacToe
//
//  Created by Hai Phung on 10/3/14.
//  Copyright (c) 2014 Hai Phung. All rights reserved.
//

#import "GameViewController.h"
#import "Game.h"
#import "Player.h"

@interface GameViewController ()

@property (nonatomic, strong) Game *game;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *gameBoardLabels;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"TicTacToe";
}

- (void)viewDidAppear:(BOOL)animated {
    [self setupGame];
}

#pragma mark - Helper Methods

- (void)setupGame {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Play as X or O?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *xTokenAction = [UIAlertAction actionWithTitle:@"X" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.game setPlayerOneToken:@"X"];
        self.game.currentPlayer = self.game.playerOne;
        self.navigationItem.title = [NSString stringWithFormat:@"%@'s Turn", self.game.currentPlayer.token];
    }];
    UIAlertAction *oTokenAction = [UIAlertAction actionWithTitle:@"O" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.game setPlayerOneToken:@"O"];
        self.game.currentPlayer = self.game.playerOne;
        self.navigationItem.title = [NSString stringWithFormat:@"%@'s Turn", self.game.currentPlayer.token];
    }];
    [alertController addAction:xTokenAction];
    [alertController addAction:oTokenAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UILabel *)findLabelUsingPoint:(CGPoint)point {
    for (UILabel *label in self.gameBoardLabels) {
        if (CGRectContainsPoint(label.frame, point)) {
            return label;
        }
    }
    return nil;
}

#pragma mark - Actions

- (IBAction)onLabelTapped:(UITapGestureRecognizer *)tapGesture {
    CGPoint tapLocation = [tapGesture locationInView:self.view];

    UILabel *labelTapped = [self findLabelUsingPoint:tapLocation];
    if (labelTapped) {
        labelTapped.text = self.game.currentPlayer.token;

        if ([self.game.currentPlayer.token isEqualToString:@"X"]) {
            labelTapped.textColor = [UIColor blueColor];
        } else {
            labelTapped.textColor = [UIColor redColor];
        }

        [self.game.currentPlayer addMove:@(labelTapped.tag)];

        NSString *winner = [self.game whoWon];
        if (winner) {
            // Show an alert
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Game Over" message:[NSString stringWithFormat:@"%@ wins!", self.game.currentPlayer.token] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Start New Game" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // Start new game
                NSLog(@"Start a new game");
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [self.game changePlayer];
        }

    }
}

#pragma mark - Accessors

// Lazy instantiation.

- (Game *)game {
    if (!_game) {
        _game = [[Game alloc] init];
    }
    return _game;
}

@end
