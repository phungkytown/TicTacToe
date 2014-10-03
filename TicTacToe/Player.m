//
//  Player.m
//  TicTacToe
//
//  Created by Hai Phung on 10/3/14.
//  Copyright (c) 2014 Hai Phung. All rights reserved.
//

#import "Player.h"

@interface Player ()

@property (nonatomic, strong) NSMutableArray *privateMoves;

@end

@implementation Player

- (void)addMove:(id)move {
    [self.privateMoves addObject:move];
}

#pragma mark - Accessors

- (NSArray *)moves {
    return _privateMoves;
}

- (NSMutableArray *)privateMoves {
    if (!_privateMoves) {
        _privateMoves = [NSMutableArray array];
    }
    return _privateMoves;
}



@end
