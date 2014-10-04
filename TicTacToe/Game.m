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

- (void)setPlayerOneToken:(NSString *)token {
    self.playerOne.token = token;

    // Go ahead and set player two's token.
    if ([token isEqualToString:@"X"]) {
        self.playerTwo.token = @"O";
    } else {
        self.playerTwo.token = @"X";
    }
}

- (void)nextTurn {
    if (self.currentPlayer == self.playerOne) {
        self.currentPlayer = self.playerTwo;
    } else {
        self.currentPlayer = self.playerOne;
    }
}

-(void)addPlayerMove:(id)move {
    [self.totalMoves addObject:move];
    [self.currentPlayer addMove:move];
}

- (NSString *)whoWon {
    if (([self.currentPlayer.moves containsObject:@(1)] && [self.currentPlayer.moves containsObject:@(2)] && [self.currentPlayer.moves containsObject:@(3)]) ||
        ([self.currentPlayer.moves containsObject:@(4)] && [self.currentPlayer.moves containsObject:@(5)] && [self.currentPlayer.moves containsObject:@(6)]) ||
        ([self.currentPlayer.moves containsObject:@(7)] && [self.currentPlayer.moves containsObject:@(8)] && [self.currentPlayer.moves containsObject:@(9)])) {
        return [NSString stringWithFormat:@"%@ wins!", self.currentPlayer.token];
    }

    else if (([self.currentPlayer.moves containsObject:@(1)] && [self.currentPlayer.moves containsObject:@(4)] && [self.currentPlayer.moves containsObject:@(7)]) ||
             ([self.currentPlayer.moves containsObject:@(2)] && [self.currentPlayer.moves containsObject:@(5)] && [self.currentPlayer.moves containsObject:@(8)]) ||
             ([self.currentPlayer.moves containsObject:@(3)] && [self.currentPlayer.moves containsObject:@(6)] && [self.currentPlayer.moves containsObject:@(9)])) {
        return [NSString stringWithFormat:@"%@ wins!", self.currentPlayer.token];
    }

    else if (([self.currentPlayer.moves containsObject:@(1)] && [self.currentPlayer.moves containsObject:@(5)] && [self.currentPlayer.moves containsObject:@(9)]) ||
             ([self.currentPlayer.moves containsObject:@(3)] && [self.currentPlayer.moves containsObject:@(5)] && [self.currentPlayer.moves containsObject:@(7)])) {
        return [NSString stringWithFormat:@"%@ wins!", self.currentPlayer.token];
    }

    if ([self.totalMoves count] == 9) {
        return @"Draw";
    }
    
    return nil;
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

- (NSMutableArray *)totalMoves {
    if (!_totalMoves) {
        _totalMoves = [NSMutableArray array];
    }
    return _totalMoves;
}

@end
