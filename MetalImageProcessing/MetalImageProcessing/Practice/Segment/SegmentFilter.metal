//
//  SegmentFilter.metal
//  MetalImageProcessing
//
//  Created by Colin on 2019/1/13.
//  Copyright © 2019 Colin. All rights reserved.
//

#include <metal_stdlib>
#include "ShaderType.h"
using namespace metal;

typedef struct
{
    float alpha;
} SegmentUniform;

fragment half4 segmentFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                               texture2d<half> inputTexture [[texture(0)]],
                               texture2d<half> mask [[texture(1)]],
                               texture2d<half> material [[texture(2)]],
                               constant SegmentUniform& uniforms [[ buffer(1) ]])
{
    constexpr sampler quadSampler;
    constexpr sampler materialSampler(address::repeat);
    float2 inputSize = float2(inputTexture.get_width(), inputTexture.get_height());
    float2 materialSize = float2(material.get_width(), material.get_height());
    float2 materialCoord = inputSize / materialSize * fragmentInput.textureCoordinate;
    
    half4 baseColor = inputTexture.sample(quadSampler, fragmentInput.textureCoordinate);
    half4 maskColor = mask.sample(quadSampler, fragmentInput.textureCoordinate);
    half4 materialColor = material.sample(materialSampler, materialCoord);


    return half4(mix(baseColor, materialColor, (1.0 - maskColor.r) * uniforms.alpha));
}

