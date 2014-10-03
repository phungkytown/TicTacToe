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
@property (weak, nonatomic) IBOutlet UILabel *xGamePiece;
@property (weak, nonatomic) IBOutlet UILabel *oGamePiece;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetGameBoard];
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

- (void)resetGameBoard {
    self.navigationItem.title = @"TicTactoe";

    for (UILabel *label in self.gameBoardLabels) {
        label.text = @"";
    }
}

- (void)startNewGame {
    self.game = nil;
    [self resetGameBoard];
    [self setupGame];
}

- (void)markGameBoardLabel:(UILabel *)gameBoardLabel {
    // Set the attributes of the label
    gameBoardLabel.text = self.game.currentPlayer.token;

    if ([self.game.currentPlayer.token isEqualToString:@"X"]) {
        gameBoardLabel.textColor = [UIColor blueColor];
    } else {
        gameBoardLabel.textColor = [UIColor redColor];
    }

    // Add the move to the current player's array
    [self.game.currentPlayer addMove:@(gameBoardLabel.tag)];

    // Check for a winner.
    NSString *winner = [self.game whoWon];
    if (winner) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Game Over" message:[NSString stringWithFormat:@"%@ wins!", self.game.currentPlayer.token] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Start New Game" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self startNewGame];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self.game changePlayer];
        self.navigationItem.title = [NSString stringWithFormat:@"%@'s Turn", self.game.currentPlayer.token];
    }
}

#pragma mark - Actions

- (IBAction)onLabelTapped:(UITapGestureRecognizer *)tapGesture {
    CGPoint tapLocation = [tapGesture locationInView:self.view];

    UILabel *labelFound = [self findLabelUsingPoint:tapLocation];
    if (labelFound) {
        [self markGameBoardLabel:labelFound];
    }
}

- (IBAction)onLabelDrag:(UIPanGestureRecognizer *)panGesture {
    CGPoint panLocation = [panGesture locationInView:self.view];

    UILabel *gamePiece;
    if ([self.game.currentPlayer.token isEqualToString:@"X"]) {
        gamePiece = self.xGamePiece;
    } else {
        gamePiece = self.oGamePiece;
    }

    gamePiece.center = panLocation;

    if (panGesture.state == UIGestureRecognizerStateEnded) {
        UILabel *labelFound = [self findLabelUsingPoint:panLocation];
        if (labelFound) {
            [self markGameBoardLabel:labelFound];
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
