//
//  Poop.m
//  Rainy Poops
//
//  Created by Chan Hee Park on 7/6/14.
//  Copyright (c) 2014 Chan Park. All rights reserved.
//

#import "Poop.h"

@implementation Poop
- (id)init {
    self = [super initWithImageNamed:@"poop.png"];
    self.isDropping = NO;
    
    self.zPosition = 50;
    self.name = @"poop";
    self.size = CGSizeMake(poopSize_x, poopSize_y);
    
    return self;
}



@end
