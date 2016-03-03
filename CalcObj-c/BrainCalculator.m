//
//  BrainCalculator.m
//  CalcObj-c
//
//  Created by Wizard on 01.03.16.
//  Copyright © 2016 ed8009. All rights reserved.
//

#import "BrainCalculator.h"

@interface BrainCalculator ()

@property (nonatomic) NSMutableArray<NSNumber*> *operandStack;
@property (nonatomic) NSMutableArray<NSString *> *operateStack;

@property (nonatomic) NSMutableArray<NSMutableString *> *historyDisplay;

@property (nonatomic) BOOL userIsInTheMiddleOfTypingANumber;
@property (nonatomic) BOOL userSetPoint;
@property (nonatomic) BOOL userHasPressedButtonEqually;

@property (nonatomic) NSUInteger countZero;

@end

@implementation BrainCalculator


+ (instancetype)sharedMyManager {
    static BrainCalculator *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[[self class] alloc] init];
        
    });
    return sharedMyManager;
}

- (id)init {
    
    if (self = [super init]){
        
        self.historyDisplay = [[NSMutableArray alloc] init];
        self.operandStack   = [[NSMutableArray alloc] init];
        self.operateStack   = [[NSMutableArray alloc] init];
        
        self.userHasPressedButtonEqually = false;
        self.userIsInTheMiddleOfTypingANumber = false;
        self.userSetPoint = false;
        self.countZero = 0;

    }
    return self;
}

- (void)appendOperand:(NSString *)digit{
    
    //If press the button equally
    if (self.userHasPressedButtonEqually) {
        
        [self startDisplay];
        self.userHasPressedButtonEqually = false;
        
    }
    
    
    if (self.userIsInTheMiddleOfTypingANumber) {
        
        //Do not miss the extra point
        if ([digit isEqualToString:@"."] && ([self.operandStack.lastObject.description rangeOfString:@"."].location != NSNotFound || [self.historyDisplay.lastObject isEqualToString:@"."])){
            
            return;
        }
        
        //Verification of the fact that there was only one point
        if ([digit isEqualToString:@"."] && self.userSetPoint == false && [self.operandStack.lastObject.description rangeOfString:@"."].location == NSNotFound){
            
            [self.historyDisplay addObject:[NSMutableString stringWithFormat:@"."]];
            self.userSetPoint = true;
            
            return;
        }

        //destroy leading zeros
        if ([digit isEqualToString:@"0"] && ([self.historyDisplay.firstObject isEqualToString:@"0"] || [self.historyDisplay.firstObject isEqualToString:@"-0"] )) {
            
            return;
        }
        
        //If zero is in the leading position, then replace it with the number entered
        if (![digit isEqualToString:@"."] && self.userSetPoint == false && (self.operandStack.lastObject == 0 || self.operandStack.lastObject == -0)){
            
            [self.operandStack replaceObjectAtIndex:self.operandStack.count-1 withObject:[NSNumber numberWithInteger: digit.integerValue]];

            return;
        }

        //If the user put a point
        if (self.userSetPoint == true){
            
            if (![digit isEqualToString:@"0"]){
        
                NSMutableString *zero = [NSMutableString stringWithFormat:@"%@",digit];
            
                for (int i = 0; i < self.countZero; i++) {
                    
                    zero = [NSMutableString stringWithFormat:@"0%@", zero];

                }

                zero = [NSMutableString stringWithFormat:@"%@.%@",self.operandStack.lastObject,zero];
                
                NSNumber *aDouble = [NSNumber numberWithDouble:zero.doubleValue];
                
                
                [self.operandStack replaceObjectAtIndex:self.operandStack.count-1 withObject:aDouble];

                self.userSetPoint = false;
                
            }
            
        }
        else{
            
            //count the number imposed of zeros and take them into account when rewriting number
            
            NSMutableString *zero = [NSMutableString stringWithFormat:@"%@",digit];
            
            for (int i = 0; i < self.countZero; i++) {
                
                zero = [NSMutableString stringWithFormat:@"%@0", zero];

            }
            
            
            zero = [NSMutableString stringWithFormat:@"%@%@",self.operandStack.lastObject,zero];
            
            NSNumber *aDouble = [NSNumber numberWithDouble:zero.doubleValue];
            
            [self.operandStack replaceObjectAtIndex:self.operandStack.count-1 withObject:aDouble];



        }
        
        
        //count the number imposed of zeros
        
            if ([digit isEqualToString:@"0"] && ([self.operandStack.lastObject.description rangeOfString:@"."].location != NSNotFound || self.userSetPoint == true)) {
                
                self.countZero++;
                
            }
            else{
                
                self.countZero = 0;
            }
        

            [self.historyDisplay addObject:[NSMutableString stringWithFormat:@"%@",digit]];
            
        
    }
    else{ //Enter the first digit
        
        if ([digit isEqualToString:@"."]) {
            
            [self.operandStack addObject:[NSNumber numberWithInt:0]];
            [self.historyDisplay addObject:[NSMutableString stringWithFormat:@"0"]];

            self.userSetPoint = true;
     
        }
        else{
            
            NSNumber *num = [NSNumber numberWithInteger: digit.integerValue];
            [self.operandStack addObject:num];
        }

        [self.historyDisplay addObject:[NSMutableString stringWithFormat:@"%@",digit]];
        self.userIsInTheMiddleOfTypingANumber = true;

    }
    
}

- (void)appendOperate:(NSString *)digit{
    

    if ([self.operateStack containsObject:self.historyDisplay.lastObject] || self.historyDisplay.count == 0) {
        
        return;
    }
    
    if (self.userHasPressedButtonEqually) {
        self.userHasPressedButtonEqually = false;
    }
    
    if (self.userIsInTheMiddleOfTypingANumber){
        
        self.userIsInTheMiddleOfTypingANumber = false;
        self.userSetPoint = false;
        
    }
    
    [self.operateStack addObject:digit];
    [self.historyDisplay addObject:[NSMutableString stringWithFormat:@"%@",digit]];
    


}


- (NSString *)setDisplay{
    
    NSMutableString *result = [[NSMutableString alloc] init];
    
    for (int i = 0; i < self.historyDisplay.count; i++) {
        
        if ([self.operateStack containsObject:[self.historyDisplay objectAtIndex:i]]) {
            
            result = [NSMutableString stringWithFormat:@"%@ %@ ", result, [self.historyDisplay objectAtIndex:i]];

        }
        else{
            
            result = [NSMutableString stringWithFormat:@"%@%@", result, [self.historyDisplay objectAtIndex:i]];

        }
        
    }
    
    if (result.length > 0) {
        return result;
    }
    else{
        
        return @"0";

    }
}


- (void)setRusult{
    

    
    if (self.historyDisplay.count > 0) {
    
        if (self.operateStack.count > 0 && [self.operateStack containsObject:self.historyDisplay.lastObject] ) {

            [self.operateStack removeLastObject];
            [self.historyDisplay removeLastObject];

        }
        
        [self recursivePassageOnStacks:(int)self.operateStack.count-1];
        
        self.userHasPressedButtonEqually = true;
    }
    
}


- (void)recursivePassageOnStacks:(int )i{

    if (self.operandStack.count > 1) {
        
        NSMutableString *firstOperator = [[NSMutableString alloc] init];
        NSMutableString *secondOperator = [[NSMutableString alloc] init];

            firstOperator = [NSMutableString stringWithFormat:@"%@",[self.operateStack objectAtIndex:i]];
            
            if (i > 0) {
                
                secondOperator = [NSMutableString stringWithFormat:@"%@",[self.operateStack objectAtIndex:i - 1]];
            }
            
            if ([secondOperator isEqualToString:@"×"] || [secondOperator isEqualToString:@"÷"]) {
                
                
                NSUInteger id = self.operandStack.count - 2;
                
                NSNumber * number = [self computing:[self.operandStack objectAtIndex:id] operand2:[self.operandStack objectAtIndex:id - 1] operation:secondOperator];
                
                [self.operandStack removeObjectAtIndex:self.operandStack.count-2];
                [self.operandStack removeObjectAtIndex:self.operandStack.count-2];
                [self.operateStack removeObjectAtIndex:self.operateStack.count-2];
                
                [self.operandStack insertObject:number atIndex:self.operandStack.count-1];

            }
            else{

                NSUInteger id = self.operandStack.count - 1;
                
                NSNumber * number = [self computing:[self.operandStack objectAtIndex:id] operand2:[self.operandStack objectAtIndex:id - 1] operation:firstOperator];
                
                [self.operandStack removeLastObject];
                [self.operandStack removeLastObject];
                [self.operateStack removeLastObject];
                
                [self.operandStack addObject:number];
            }
        
        [self recursivePassageOnStacks:--i];
        
        
    }
    else{
        
        [self.historyDisplay removeAllObjects];
        [self.historyDisplay addObject:[NSMutableString stringWithFormat:@"%@",self.operandStack.firstObject]];
    }
}


- (void)backSpace{


    if (self.historyDisplay.count > 1) {
        
        //--- If you see zero
        if ([self.historyDisplay.lastObject isEqualToString:@"0"] && ([self.operandStack.lastObject.description rangeOfString:@"."].location != NSNotFound || self.userSetPoint == true)){


            [self.historyDisplay removeLastObject];
            self.countZero--;
            
            return;
            
        }
        
        self.userSetPoint = false;
        
        
        //--- Remove point
        if ([self.historyDisplay.lastObject isEqualToString:@"."]) {
            
            [self.historyDisplay removeLastObject];
            return;
        }
        
        
        
        //--- If the last element in the story is not the operator
        
        if (![self.operateStack containsObject:[self.historyDisplay lastObject]]){
            
            //--- If the last number is a single digit
            if (self.operandStack.lastObject.description.length == 1) {
                
                [self.operandStack removeLastObject];
                self.userIsInTheMiddleOfTypingANumber = false;
                
                
            }else {
                
                NSString *str = self.operandStack.lastObject.description;

                NSString *number = [str substringToIndex:str.length - 1];
                
                NSMutableString *zeroNumber = [NSMutableString stringWithFormat:@"%@", number];
                
                //--- Count the number of remote zeros
                if ([[zeroNumber substringFromIndex:zeroNumber.length - 1] isEqualToString:@"0"] && [str rangeOfString:@"."].location != NSNotFound) {
                    
                
                    while (zeroNumber.length > 0 && [[zeroNumber substringFromIndex:zeroNumber.length - 1] isEqualToString:@"0"]) {
                        
                        zeroNumber = [NSMutableString stringWithFormat:@"%@",[zeroNumber substringToIndex:zeroNumber.length - 1]];
                        
                        self.countZero++;
                        
                    }
                    
                    //--- If the zeros were immediately after the point, put a point before a new digit entered
                    
                    if (zeroNumber.length > 0 && [[zeroNumber substringFromIndex:zeroNumber.length - 1] isEqualToString:@"."]) {
                        self.userSetPoint = true;
                    }
                    
                }
                
                //--- If you have reached a minus, remove it out of the stacks
                if ([number isEqualToString:@"-"]){
                    [self.operandStack removeLastObject];
                    [self.historyDisplay removeLastObject];
  
                    self.userIsInTheMiddleOfTypingANumber = false;
                    
                }else{
                    
                    NSNumber *aDouble = [NSNumber numberWithDouble:number.doubleValue];

                    [self.operandStack replaceObjectAtIndex:self.operandStack.count-1 withObject:aDouble];

                    
                }
            }
            
        } else{
            
            [self.historyDisplay removeLastObject];
            
            self.userIsInTheMiddleOfTypingANumber = true;
            
            return;
        }
        
        
        [self.historyDisplay removeLastObject];
        
        //--- If the point is at the end of historyDisplay
        
        if ([self.historyDisplay.lastObject isEqualToString:@"."]) {

            self.userSetPoint = true;
            return;
        }
        
        
        //--- If the operand stack is empty, then remove all stacks, and translate the display start-up setting
        if (self.operandStack.count == 0){
            
            [self startDisplay];
        }
        
    } else {
        
        [self startDisplay];
    }



}


- (void) startDisplay{
    [self.operandStack removeAllObjects];
    [self.operateStack removeAllObjects];

    [self.historyDisplay removeAllObjects];
    
    self.userIsInTheMiddleOfTypingANumber = false;
}

- (NSNumber *)computing:(NSNumber *)operand1 operand2:(NSNumber *)operand2 operation:(NSString *)operation{
    
    double num1 = operand1.doubleValue;
    double num2 = operand2.doubleValue;
    
    if ([operation isEqualToString:@"×"]) {
        
        return [NSNumber numberWithDouble:num1 * num2];
        
    }
    else if ([operation isEqualToString:@"÷"]) {
        
        return [NSNumber numberWithDouble:num2 / num1];

    }
    else if ([operation isEqualToString:@"+"]) {
        
        return [NSNumber numberWithDouble:num1 + num2];

    }
    else if ([operation isEqualToString:@"−"]) {
        
        return [NSNumber numberWithDouble:num2 - num1];

    }
    else{
        
        return nil;
    }
}




@end
