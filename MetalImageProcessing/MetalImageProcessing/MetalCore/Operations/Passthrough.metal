//
//  Passthrough.metal
//  MetalImageProcessing
//
//  Created by Colin on 2018/9/2.
//  Copyright © 2018年 Colin. All rights reserved.
//

#include <metal_stdlib>
#include "ShaderType.h"
using namespace metal;

vertex SingleInputVertexIO oneInputVertex(device packed_float2 *position [[buffer(0)]],
                                          device packed_float2 *texturecoord [[buffer(1)]],
                                          uint vid [[vertex_id]])
{
    SingleInputVertexIO outputVertices;
    
    outputVertices.position = float4(position[vid], 0, 1.0);
    outputVertices.textureCoordinate = texturecoord[vid];
    
    return outputVertices;
}

fragment half4 passthroughFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                                   texture2d<half> inputTexture [[texture(0)]])
{
    constexpr sampler quadSampler;
    half4 color = inputTexture.sample(quadSampler, fragmentInput.textureCoordinate);
    
    return color;
}

vertex TwoInputVertexIO twoInputVertex(device packed_float2 *position [[buffer(0)]],
                                       device packed_float2 *texturecoord [[buffer(1)]],
                                       device packed_float2 *texturecoord2 [[buffer(2)]],
                                       uint vid [[vertex_id]])
{
    TwoInputVertexIO outputVertices;
    
    outputVertices.position = float4(position[vid], 0, 1.0);
    outputVertices.textureCoordinate = texturecoord[vid];
    outputVertices.textureCoordinate2 = texturecoord2[vid];
    
    return outputVertices;
}
