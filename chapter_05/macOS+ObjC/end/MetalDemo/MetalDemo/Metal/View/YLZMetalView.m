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

@property (nonatomic, strong) id<MTLBuffer> vertexBuffer;
@property (nonatomic, strong) id<MTLTexture> texture;

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
    
    [self setupBuffers];
    [self setupPipeline];
    [self setupTexture];
}

- (void)setupBuffers {
    static const YLZVertex vertices[] =
    {
        { .position = { -1.0, -1.0 }, .textureCoordinate = { 0, 1 } },
        { .position = { -1.0,  1.0 }, .textureCoordinate = { 0, 0 } },
        { .position = {  1.0, -1.0 }, .textureCoordinate = { 1, 1 } },
        { .position = {  1.0,  1.0 }, .textureCoordinate = { 1, 0 } }
    };
    
    self.vertexBuffer = [self.device newBufferWithBytes:vertices
                                                 length:sizeof(vertices)
                                                options:MTLResourceCPUCacheModeDefaultCache];
}

- (void)setupTexture {
    NSImage *image = [NSImage imageNamed:@"lena"];
    self.texture = [self newTextureWithImage:image];
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
    
    [commandEncoder setVertexBuffer:self.vertexBuffer offset:0 atIndex:0];
    [commandEncoder setFragmentTexture:self.texture atIndex:YLZTextureIndexBaseColor];
    [commandEncoder setRenderPipelineState:self.pipelineState];
    [commandEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:4];
    
    [commandEncoder endEncoding];
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

- (id<MTLTexture>)newTextureWithImage:(NSImage *)image {
    NSRect rect = NSMakeRect(0, 0, image.size.width, image.size.height);
    CGImageRef imageRef = [image CGImageForProposedRect:&rect context:nil hints:nil];
    
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    uint8_t *rawData = (uint8_t *)calloc(height * width * 4, sizeof(uint8_t));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef bitmapContext = CGBitmapContextCreate(rawData, width, height,
                                                       bitsPerComponent, bytesPerRow, colorSpace,
                                                       kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(bitmapContext, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(bitmapContext);
    
    MTLTextureDescriptor *textureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatRGBA8Unorm
                                                                                                 width:width
                                                                                                height:height
                                                                                             mipmapped:NO];
    id<MTLTexture> texture = [self.device newTextureWithDescriptor:textureDescriptor];
    
    MTLRegion region = MTLRegionMake2D(0, 0, width, height);
    [texture replaceRegion:region mipmapLevel:0 withBytes:rawData bytesPerRow:bytesPerRow];
    
    free(rawData);
    
    return texture;
}
@end
