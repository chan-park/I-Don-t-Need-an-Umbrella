//
//  common.h
//  Rainy Poops
//
//  Created by Chan Hee Park on 7/6/14.
//  Copyright (c) 2014 Chan Park. All rights reserved.
//

#ifndef Rainy_Poops_common_h
#define Rainy_Poops_common_h

static int poopSize_x = 15;
static int poopSize_y = 25;
static const uint32_t poopCategory = 0x1 << 1;
static const uint32_t groundCategory = 0x1 << 2;
static const uint32_t playerCategory = 0x1 << 3;
static const uint32_t boundaryCategory = 0x1 << 4;
static const int groundLevel = 120;
//static const float speed = 18;
static const float speed = 25;
static const float friction = 110;

//static const float friction = 60;
static const float gravity = -1.2;


#endif
