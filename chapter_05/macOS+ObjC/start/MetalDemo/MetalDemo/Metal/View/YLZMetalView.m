//
//  YLZMetalView.m
//  MetalDemo
//
//  Created by Colin on 2018/7/21.
//  Copyright © 2018年 Colin. All rights reserved.
//

#import "YLZMetalView.h"
#import "YLZShaderTypes.h"

@import Metal;
@import QuartzCore.CAMetalLayer;

@interface YLZMetalView ()

@property (nonatomic, strong) id<MTLDevice>       device;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic, strong) CAMetalLayer       *metalLayer;

@property (nonatomic, strong) id<MTLRenderPipelineState> pipelineState;

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
    
    [self setupPipeline];
}

- (void)setupPipeline {
    id<MTLLibrary> library = [self.device newDefaultLibrary];
    id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertexShader"];
    id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"fragmentShader"];
    
    MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
    pipelineDescriptor.vertexFunction = vertexFunction;
    pipelineDescriptor.fragmentFunction = fragmentFunction;
    pipelineDescriptor.colorAttachments[0].pixelFormat = self.metalLayer.pixelFormat;
    
    NSError *error = nil;
    self.pipelineState = [self.device newRenderPipelineStateWithDescriptor:pipelineDescriptor
                                                                     error:&error];
    NSAssert(!error, @"compile MTLRenderPipelineState object error");
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
    
    static const YLZVertex vertices[] =
    {
        { .position = {  0.5, -0.5 }, .color = { 1, 0, 0, 1 } },
        { .position = { -0.5, -0.5 }, .color = { 0, 1, 0, 1 } },
        { .position = {  0.0,  0.5 }, .color = { 0, 0, 1, 1 } }
    };
    [commandEncoder setRenderPipelineState:self.pipelineState];
    [commandEncoder setVertexBytes:vertices
                            length:sizeof(vertices)
                           atIndex:YLZVertexInputIndexVertices];
    [commandEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3];
    
    [commandEncoder endEncoding];
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

@end
