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
@property (nonatomic, weak) IBOutlet UILabel *playerOneGamePiece;
@property (nonatomic, weak) IBOutlet UILabel *playerTwoGamePiece;
@property (nonatomic, weak) IBOutlet UIButton *robotButton;

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
        [self configurePlayerOneWithToken:@"X"];
    }];
    UIAlertAction *oTokenAction = [UIAlertAction actionWithTitle:@"O" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self configurePlayerOneWithToken:@"O"];
    }];
    [alertController addAction:xTokenAction];
    [alertController addAction:oTokenAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)configurePlayerOneWithToken:(NSString *)token {
    [self.game setPlayerOneToken:token];
    self.game.currentPlayer = self.game.playerOne;
    self.navigationItem.title = [NSString stringWithFormat:@"%@'s Turn", self.game.currentPlayer.token];
    self.playerOneGamePiece.text = self.game.currentPlayer.token;

    if ([self.game.playerOne.token isEqualToString:@"X"]) {
        self.playerOneGamePiece.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:78.0/255.0 blue:109.0/255.0 alpha:1.0];
        self.playerTwoGamePiece.text = @"O";
        self.playerTwoGamePiece.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:97.0/255.0 blue:99.0/255.0 alpha:1.0];
    } else {
        self.playerOneGamePiece.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:97.0/255.0 blue:99.0/255.0 alpha:1.0];
        self.playerTwoGamePiece.text = @"X";
        self.playerTwoGamePiece.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:78.0/255.0 blue:109.0/255.0 alpha:1.0];
    }

    self.playerOneGamePiece.hidden = NO;
}

- (UILabel *)findLabelUsingPoint:(CGPoint)point {
    for (UILabel *label in self.gameBoardLabels) {
        if (CGRectContainsPoint(label.frame, point)) {
            return label;
        }
    }
    return nil;
}

- (UILabel *)findLabelByTag:(NSInteger)tag {
    for (UILabel *label in self.gameBoardLabels) {
        if (label.tag == tag) {
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
    self.playerOneGamePiece.hidden = YES;
    self.playerTwoGamePiece.hidden = YES;
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
        [self changePlayerTurn];
        self.navigationItem.title = [NSString stringWithFormat:@"%@'s Turn", self.game.currentPlayer.token];
    }
}

- (void)changePlayerTurn {
    [self.game nextTurn];
    [self switchGamePiece];
    if (self.game.currentPlayer.isRobot) {
        // Give the impression that the robot is thinking.
        // Anywhere between 1 and 5 seconds.
        [self.robotButton setTitle:@"Thinking ..." forState:UIControlStateNormal];
        NSUInteger randomSeconds = arc4random_uniform(5) + 1;
        [self performSelector:@selector(robotMakesSelection) withObject:nil afterDelay:randomSeconds];
    }

}

- (void)switchGamePiece {
    if (self.game.currentPlayer == self.game.playerOne) {
        self.playerOneGamePiece.hidden = NO;
        self.playerTwoGamePiece.hidden = YES;
    } else {
        self.playerOneGamePiece.hidden = YES;
        self.playerTwoGamePiece.hidden = NO;
    }
}

- (void)robotMakesSelection {
    NSInteger robotMove = [self.game robotMove];
    UILabel *labelFound = [self findLabelByTag:robotMove];
    if (labelFound) {
        [self markGameBoardLabel:labelFound];
        [self.robotButton setTitle:@"Robot is ON" forState:UIControlStateNormal];
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
    if (self.game.currentPlayer == self.game.playerOne) {
        gamePiece = self.playerOneGamePiece;
    } else {
        gamePiece = self.playerTwoGamePiece;
    }

    gamePiece.center = panLocation;

    if (panGesture.state == UIGestureRecognizerStateEnded) {
        UILabel *labelFound = [self findLabelUsingPoint:panLocation];
        if (labelFound && (labelFound.text.length == 0)) {
            [self markGameBoardLabel:labelFound];
        }
    }
}

- (IBAction)onRobotButtonPressed:(id)sender {
    if (self.game.playerTwo.isRobot) {
        self.game.playerTwo.robot = NO;
        [self.robotButton setTitle:@"Robot is OFF" forState:UIControlStateNormal];
        self.robotButton.backgroundColor = [UIColor darkGrayColor];
    } else {
        self.game.playerTwo.robot = YES;
        [self.robotButton setTitle:@"Robot is ON" forState:UIControlStateNormal];
        self.robotButton.backgroundColor = [UIColor colorWithRed:90.0/255.0 green:187.0/255.0 blue:181.0/255.0 alpha:1.0];
    }

    if (self.game.currentPlayer.isRobot) {
        // Give the impression that the robot is thinking.
        // Anywhere between 1 and 5 seconds.
        [self.robotButton setTitle:@"Thinking ..." forState:UIControlStateNormal];
        NSUInteger randomSeconds = arc4random_uniform(5) + 1;
        [self performSelector:@selector(robotMakesSelection) withObject:nil afterDelay:randomSeconds];
    }
}

@end
