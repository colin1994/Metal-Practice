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

typedef struct
{
    float4 position [[position]];
    float2 textureCoordinate;
} RasterizerData;

#endif /* ShaderType_h */
