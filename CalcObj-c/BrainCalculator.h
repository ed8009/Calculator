//
//  BrainCalculator.h
//  CalcObj-c
//
//  Created by Wizard on 01.03.16.
//  Copyright © 2016 ed8009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface BrainCalculator : NSObject

+ (id)sharedMyManager;
- (void)appendOperand:(NSString *)digit;
- (void)appendOperate:(NSString *)digit;
- (void)setRusult;
- (void)backSpace;
- (NSString *)setDisplay;


@end
