//
//  YLZMetalView.m
//  MetalDemo
//
//  Created by Colin on 2018/7/21.
//  Copyright © 2018年 Colin. All rights reserved.
//

#import "YLZMetalView.h"

@implementation YLZMetalView

#pragma mark - Life Cycle
- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Private
- (void)commonInit {
    
}

@end
