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
@property (nonatomic, weak) IBOutlet UILabel *xGamePiece;
@property (nonatomic, weak) IBOutlet UILabel *oGamePiece;
@property (nonatomic, weak) IBOutlet UIButton *playComputerButton;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetGameBoard];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!self.game) {
        [self setupGame];
    }
}

#pragma mark - Helper Methods

- (void)setupGame {
    // Initialize an instance of a new game
    self.game = [[Game alloc] init];

    // Let the user play as X or O.
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Play as X or O?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *xTokenAction = [UIAlertAction actionWithTitle:@"X" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.game setPlayerOneToken:@"X"];
        self.game.currentPlayer = self.game.playerOne;
        self.navigationItem.title = [NSString stringWithFormat:@"%@'s Turn", self.game.currentPlayer.token];
        [self switchGamePiece];
    }];
    UIAlertAction *oTokenAction = [UIAlertAction actionWithTitle:@"O" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.game setPlayerOneToken:@"O"];
        self.game.currentPlayer = self.game.playerOne;
        self.navigationItem.title = [NSString stringWithFormat:@"%@'s Turn", self.game.currentPlayer.token];
        self.oGamePiece.hidden = NO;
        [self switchGamePiece];
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
        label.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
    }
    self.xGamePiece.hidden = YES;
    self.oGamePiece.hidden = YES;
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
        gameBoardLabel.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:78.0/255.0 blue:109.0/255.0 alpha:1.0];
    } else {
        gameBoardLabel.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:97.0/255.0 blue:99.0/255.0 alpha:1.0];
    }

    // Add the move to the current player's array
    [self.game addPlayerMove:@(gameBoardLabel.tag)];

    // Check for a winner.
    NSString *winner = [self.game whoWon];
    if (winner) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Game Over" message:winner preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Start New Game" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self startNewGame];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self.game nextTurn];
        [self switchGamePiece];
        self.navigationItem.title = [NSString stringWithFormat:@"%@'s Turn", self.game.currentPlayer.token];
    }
}

- (void)switchGamePiece {
    if (self.game.currentPlayer == self.game.playerOne) {
        self.xGamePiece.hidden = NO;
        self.oGamePiece.hidden = YES;
    } else {
        self.xGamePiece.hidden = YES;
        self.oGamePiece.hidden = NO;
    }
}

#pragma mark - Actions

- (IBAction)onLabelTapped:(UITapGestureRecognizer *)tapGesture {
    CGPoint tapLocation = [tapGesture locationInView:self.view];

    UILabel *labelFound = [self findLabelUsingPoint:tapLocation];
    if (labelFound && (labelFound.text.length == 0)) {
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
        if (labelFound && (labelFound.text.length == 0)) {
            [self markGameBoardLabel:labelFound];
        }
    }
}

@end
