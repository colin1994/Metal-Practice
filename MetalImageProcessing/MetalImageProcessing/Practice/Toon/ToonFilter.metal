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
    float MagTol;
    float Quantize;
} ZoomBlurUniform;

fragment half4 toonFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                            texture2d<half> inputTexture [[texture(0)]],
                            constant ZoomBlurUniform& uniforms [[ buffer(1) ]])
{
    
    float ResS = 512.;
    float ResT = 512.;

    float MagTol = uniforms.MagTol;
    float Quantize = uniforms.Quantize;
    
    constexpr sampler quadSampler;
    half3 irgb = inputTexture.sample(quadSampler, fragmentInput.textureCoordinate).rgb;
    float2 stp0 = float2(1./ResS, 0.);
    float2 st0p = float2(0., 1./ResT);
    float2 stpp = float2(1./ResS, 1./ResT);
    float2 stpm = float2(1./ResS, -1./ResT);
    
    const half3 W = half3(0.2125, 0.7154, 0.0721);
    float im1m1 =    dot(inputTexture.sample(quadSampler, fragmentInput.textureCoordinate-stpp).rgb, W);
    float ip1p1 = dot(inputTexture.sample(quadSampler, fragmentInput.textureCoordinate+stpp).rgb, W);
    float im1p1 = dot(inputTexture.sample(quadSampler, fragmentInput.textureCoordinate-stpm).rgb, W);
    float ip1m1 = dot(inputTexture.sample(quadSampler, fragmentInput.textureCoordinate+stpm).rgb, W);
    float im10 =     dot(inputTexture.sample(quadSampler, fragmentInput.textureCoordinate-stp0).rgb, W);
    float ip10 =     dot(inputTexture.sample(quadSampler, fragmentInput.textureCoordinate+stp0).rgb, W);
    float i0m1 =     dot(inputTexture.sample(quadSampler, fragmentInput.textureCoordinate-st0p).rgb, W);
    float i0p1 =     dot(inputTexture.sample(quadSampler, fragmentInput.textureCoordinate+st0p).rgb, W);
    
    //H and V sobel filters
    float h = -1.*im1p1 - 2.*i0p1 - 1.*ip1p1 + 1.*im1m1 + 2.*i0m1 + 1.*ip1m1;
    float v = -1.*im1m1 - 2.*im10 - 1.*im1p1 + 1.*ip1m1 + 2.*ip10 + 1.*ip1p1;
    float mag = length(float2(h, v));
    
    if (mag > MagTol) {
        return half4(0., 0., 0., 1.);
    } else {
        irgb.rgb *= Quantize;
        irgb.rgb += half3(.5,.5,.5);
        int3 intrgb = int3(irgb.rgb);
        irgb.rgb = half3(intrgb)/Quantize;
        return half4(irgb, 1.);
    }
}
