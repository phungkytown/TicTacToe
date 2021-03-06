//
//  Player.h
//  TicTacToe
//
//  Created by Hai Phung on 10/3/14.
//  Copyright (c) 2014 Hai Phung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property (nonatomic) NSString *token;
@property (nonatomic, getter = isRobot) BOOL robot;
@property (nonatomic, strong, readonly) NSArray *moves;

- (void)addMove:(id)move;

@end
