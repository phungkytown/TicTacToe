//
//  Player.m
//  TicTacToe
//
//  Created by Hai Phung on 10/3/14.
//  Copyright (c) 2014 Hai Phung. All rights reserved.
//

#import "Player.h"

@implementation Player

- (void)addMove:(id)move {
    [self.moves addObject:move];
}

#pragma mark - Accessors

- (NSMutableArray *)moves {
    if (!_moves) {
        _moves = [NSMutableArray array];
    }
    return _moves;
}

@end
