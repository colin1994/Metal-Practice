//
//  SaturationFilter.metal
//  MetalImageProcessing
//
//  Created by Colin on 2018/11/3.
//  Copyright © 2018 Colin. All rights reserved.
//

#include <metal_stdlib>
#import "ShaderType.h"
using namespace metal;

typedef struct
{
    float saturation;
} SaturationUniform;

fragment half4 saturationFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                                  texture2d<half> inputTexture [[texture(0)]],
                                  constant SaturationUniform& uniform [[ buffer(1) ]])
{
    constexpr sampler quadSampler;
    half4 color = inputTexture.sample(quadSampler, fragmentInput.textureCoordinate);
    
    half luminance = dot(color.rgb, luminanceWeighting);
    
    return half4(mix(half3(luminance), color.rgb, half(uniform.saturation)), color.a);
}
