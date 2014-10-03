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

@property (nonatomic, getter=isVsComputer) BOOL vsComputer;
@property (nonatomic, strong) Player *currentPlayer;
@property (nonatomic, strong) Player *playerOne;
@property (nonatomic, strong) Player *playerTwo;

- (void)setPlayerOneToken:(NSString *)token;
- (void)changePlayer;

@end
