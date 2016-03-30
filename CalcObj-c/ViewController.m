//
//  ViewController.m
//  CalcObj-c
//
//  Created by ed8009 on 29.02.16.
//  Copyright © 2016 ed8009. All rights reserved.
//

#import "ViewController.h"
#import "BrainCalculator.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (nonatomic) BrainCalculator *sharedMyManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sharedMyManager = [BrainCalculator sharedMyManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)appendOperator:(UIButton *)sender {
    [self.sharedMyManager appendOperate:sender.currentTitle];
    self.displayLabel.text = [self.sharedMyManager setDisplay];
}

- (IBAction)appendDigit:(UIButton *)sender {
    [self.sharedMyManager appendOperand:sender.currentTitle];
    self.displayLabel.text = [self.sharedMyManager setDisplay];
}

- (IBAction)equally:(id)sender {
    [self.sharedMyManager setRusult];
    self.displayLabel.text = [self.sharedMyManager setDisplay];
}

- (IBAction)backSpace:(id)sender {
    [self.sharedMyManager backSpace];
    self.displayLabel.text = [self.sharedMyManager setDisplay];
}

@end
