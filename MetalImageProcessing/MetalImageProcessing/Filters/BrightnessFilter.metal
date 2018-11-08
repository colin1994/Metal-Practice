//
//  BrightnessFilter.metal
//  MetalImageProcessing
//
//  Created by Colin on 2018/10/28.
//  Copyright © 2018年 Colin. All rights reserved.
//

#include <metal_stdlib>
#import "ShaderType.h"

using namespace metal;

typedef struct
{
    float brightness;
} BrightnessUniform;

fragment half4 brightnessFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                                  texture2d<half> inputTexture [[texture(0)]],
                                  constant BrightnessUniform& uniform [[ buffer(1) ]])
{
    constexpr sampler quadSampler;
    half4 color = inputTexture.sample(quadSampler, fragmentInput.textureCoordinate);
    
    return half4(color.rgb + uniform.brightness, color.a);
}
