//
//  Shaders.metal
//  MetalDemo
//
//  Created by Colin on 2018/7/28.
//  Copyright © 2018年 Colin. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#import "YLZShaderTypes.h"

typedef struct
{
    float4 position [[position]];
    float4 color;
} RasterizerData;

vertex RasterizerData vertexShader(constant YLZVertex *vertices [[buffer(YLZVertexInputIndexVertices)]],
                                     uint vid [[vertex_id]]) {
    RasterizerData outVertex;
    
    outVertex.position = vector_float4(vertices[vid].position, 0.0, 1.0);
    outVertex.color = vertices[vid].color;
    
    return outVertex;
}

fragment float4 fragmentShader(RasterizerData inVertex [[stage_in]]) {
    return inVertex.color;
}
