//
//  ShaderType.h
//  MetalImageProcessing
//
//  Created by Colin on 2018/9/2.
//  Copyright © 2018年 Colin. All rights reserved.
//

#ifndef ShaderType_h
#define ShaderType_h
using namespace metal;

constant half3 luminanceWeighting = half3(0.2125, 0.7154, 0.0721);

struct SingleInputVertexIO
{
    float4 position [[position]];
    float2 textureCoordinate [[user(texturecoord)]];
};

struct TwoInputVertexIO
{
    float4 position [[position]];
    float2 textureCoordinate [[user(texturecoord)]];
    float2 textureCoordinate2 [[user(texturecoord2)]];
};

#endif /* ShaderType_h */
