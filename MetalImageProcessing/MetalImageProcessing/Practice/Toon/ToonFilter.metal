//
//  ToonFilter.metal
//  MetalImageProcessing
//
//  Created by Colin on 2018/11/28.
//  Copyright © 2018 Colin. All rights reserved.
//

#include <metal_stdlib>
#import "ShaderType.h"
using namespace metal;

typedef struct
{
    float magTol;
    float quantize;
} ZoomBlurUniform;

fragment half4 toonFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                            texture2d<half> inputTexture [[texture(0)]],
                            constant ZoomBlurUniform& uniforms [[ buffer(1) ]])
{
    constexpr sampler quadSampler;
    float2 texCoord = fragmentInput.textureCoordinate;
    half4 originColor = inputTexture.sample(quadSampler, texCoord);
    
    // Sobel Operator
    float2 resolution = float2(inputTexture.get_width(), inputTexture.get_height());

    float2 stp0 = float2(1./resolution.x, 0.);
    float2 st0p = float2(0., 1./resolution.y);
    float2 stpp = float2(1./resolution.x, 1./resolution.y);
    float2 stpm = float2(1./resolution.x, -1./resolution.y);
    
    float im1m1 = dot(inputTexture.sample(quadSampler, texCoord-stpp).rgb, luminanceWeighting);
    float ip1p1 = dot(inputTexture.sample(quadSampler, texCoord+stpp).rgb, luminanceWeighting);
    float im1p1 = dot(inputTexture.sample(quadSampler, texCoord-stpm).rgb, luminanceWeighting);
    float ip1m1 = dot(inputTexture.sample(quadSampler, texCoord+stpm).rgb, luminanceWeighting);
    float im10 = dot(inputTexture.sample(quadSampler, texCoord-stp0).rgb, luminanceWeighting);
    float ip10 = dot(inputTexture.sample(quadSampler, texCoord+stp0).rgb, luminanceWeighting);
    float i0m1 = dot(inputTexture.sample(quadSampler, texCoord-st0p).rgb, luminanceWeighting);
    float i0p1 = dot(inputTexture.sample(quadSampler, texCoord+st0p).rgb, luminanceWeighting);
    
    float Gx = -1.*im1p1 - 2.*i0p1 - 1.*ip1p1 + 1.*im1m1 + 2.*i0m1 + 1.*ip1m1;
    float Gy = -1.*im1m1 - 2.*im10 - 1.*im1p1 + 1.*ip1m1 + 2.*ip10 + 1.*ip1p1;
    float GValue = length(float2(Gx, Gy));
    
    if (GValue > uniforms.magTol) {
        return half4(0., 0., 0., 1.);
    } else {
        // Color Quantization
        originColor.rgb *= uniforms.quantize;
        originColor.rgb += half3(.5, .5, .5);
        int3 intrgb = int3(originColor.rgb);
        originColor.rgb = half3(intrgb) / uniforms.quantize;
        return half4(originColor.rgb, 1.);
    }
}
