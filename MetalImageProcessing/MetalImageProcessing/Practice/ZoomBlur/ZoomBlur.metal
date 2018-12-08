//
//  ZoomBlur.metal
//  MetalImageProcessing
//
//  Created by Colin on 2018/11/27.
//  Copyright © 2018 Colin. All rights reserved.
//

#include <metal_stdlib>
#import "ShaderType.h"
using namespace metal;

typedef struct
{
    float blurSize;
} ZoomBlurUniform;

fragment half4 zoomBlurFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                                  texture2d<half> inputTexture [[texture(0)]],
                                  constant ZoomBlurUniform& uniforms [[ buffer(1) ]])
{
    constexpr sampler quadSampler;
    
    float2 blurCenter = float2(0.5, 0.5);
    float2 texCoord = fragmentInput.textureCoordinate;
    float2 samplingOffset = 1.0 / 100.0 * uniforms.blurSize * (blurCenter - texCoord);
    
    half4 fragmentColor = inputTexture.sample(quadSampler, texCoord) * 0.18;
    fragmentColor += inputTexture.sample(quadSampler, texCoord + samplingOffset) * 0.15;
    fragmentColor += inputTexture.sample(quadSampler, texCoord + (2.0 * samplingOffset)) *  0.12;
    fragmentColor += inputTexture.sample(quadSampler, texCoord + (3.0 * samplingOffset)) * 0.09;
    fragmentColor += inputTexture.sample(quadSampler, texCoord + (4.0 * samplingOffset)) * 0.05;
    fragmentColor += inputTexture.sample(quadSampler, texCoord - samplingOffset) * 0.15;
    fragmentColor += inputTexture.sample(quadSampler, texCoord - (2.0 * samplingOffset)) *  0.12;
    fragmentColor += inputTexture.sample(quadSampler, texCoord - (3.0 * samplingOffset)) * 0.09;
    fragmentColor += inputTexture.sample(quadSampler, texCoord - (4.0 * samplingOffset)) * 0.05;
    
    return fragmentColor;
}



