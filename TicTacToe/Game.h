//
//  Game.h
//  TicTacToe
//
//  Created by Hai Phung on 10/3/14.
//  Copyright (c) 2014 Hai Phung. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Player;

@interface Game : NSObject

@property (nonatomic, strong) Player *currentPlayer;
@property (nonatomic, strong) Player *playerOne;
@property (nonatomic, strong) Player *playerTwo;
@property (nonatomic) NSTimeInterval secondsPerTurn;


- (void)setPlayerOneToken:(NSString *)token;
- (void)nextTurn;
- (void)addPlayerMove:(id)move;
- (NSString *)whoWon;
- (NSInteger)robotMove;

@end
