//
//  YLZMetalView.m
//  MetalDemo
//
//  Created by Colin on 2018/7/21.
//  Copyright © 2018年 Colin. All rights reserved.
//

#import "YLZMetalView.h"
@import Metal;
@import QuartzCore.CAMetalLayer;

@interface YLZMetalView ()

@property (nonatomic, strong) id<MTLDevice>       device;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic, strong) CAMetalLayer       *metalLayer;

@end

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

- (void)viewDidMoveToWindow {
    [super viewDidMoveToWindow];
    [self render];
}

#pragma mark - Private
- (void)commonInit {
    self.device = MTLCreateSystemDefaultDevice();
    self.commandQueue = [self.device newCommandQueue];

    self.metalLayer = [CAMetalLayer new];
    self.metalLayer.device = self.device;
    self.layer = self.metalLayer;
}

- (void)render {
    id<CAMetalDrawable> drawable = [self.metalLayer nextDrawable];
    if (!drawable) {
        return;
    }
    
    MTLRenderPassDescriptor *renderPassDescripor = [MTLRenderPassDescriptor renderPassDescriptor];
    renderPassDescripor.colorAttachments[0].clearColor = MTLClearColorMake(0.48, 0.74, 0.92, 1);
    renderPassDescripor.colorAttachments[0].texture = drawable.texture;
    renderPassDescripor.colorAttachments[0].loadAction = MTLLoadActionClear;
    renderPassDescripor.colorAttachments[0].storeAction = MTLStoreActionStore;

    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescripor];
    [commandEncoder endEncoding];
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

@end
