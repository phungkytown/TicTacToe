//
//  Game.m
//  TicTacToe
//
//  Created by Hai Phung on 10/3/14.
//  Copyright (c) 2014 Hai Phung. All rights reserved.
//

#import "Game.h"
#import "Player.h"

@implementation Game

- (void)setPlayerOneToken:(NSInteger)token {
    self.playerOne.token = token;

    // Go ahead and set player two's token.
    if (token == X) {
        self.playerTwo.token = O;
    } else {
        self.playerTwo.token = X;
    }
}

- (void)changePlayer {
    if (self.currentPlayer == self.playerOne) {
        self.currentPlayer = self.playerTwo;
    } else {
        self.currentPlayer = self.playerOne;
    }
}

#pragma mark - Accessors

- (Player *)playerOne {
    if (!_playerOne) {
        _playerOne = [[Player alloc] init];
    }
    return _playerOne;
}

- (Player *)playerTwo {
    if (!_playerTwo) {
        _playerTwo = [[Player alloc] init];
    }
    return _playerTwo;
}

@end
