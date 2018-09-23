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

vertex RasterizerData passthroughVertex(device packed_float2 *position [[buffer(0)]],
                                        device packed_float2 *texturecoord [[buffer(1)]],
                                        uint vid [[vertex_id]]) {
    RasterizerData outVertex;
    
    outVertex.position = float4(position[vid], 0, 1.0);
    outVertex.textureCoordinate = texturecoord[vid];
    
    return outVertex;
}

fragment half4 passthroughFragment(RasterizerData inVertex [[stage_in]],
                               texture2d<half> tex2d [[texture(0)]]) {
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);
    return half4(tex2d.sample(textureSampler, inVertex.textureCoordinate));
}
