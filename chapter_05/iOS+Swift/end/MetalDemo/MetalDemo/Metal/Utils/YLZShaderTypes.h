//
//  YLZShaderTypes.h
//  MetalDemo
//
//  Created by Colin on 2018/7/28.
//  Copyright © 2018年 Colin. All rights reserved.
//

#ifndef YLZShaderTypes_h
#define YLZShaderTypes_h

#include <simd/simd.h>

// Buffer index values shared between shader and C code to ensure Metal shader buffer inputs match
//   Metal API buffer set calls
typedef enum YLZVertexInputIndex
{
    YLZVertexInputIndexVertices = 0,
    YLZVertexInputIndexCount    = 1,
} YLZVertexInputIndex;

// Texture index values shared between shader and C code to ensure Metal shader buffer inputs match
//   Metal API texture set calls
typedef enum YLZTextureIndex
{
    YLZTextureIndexBaseColor = 0,
} YLZTextureIndex;

//  This structure defines the layout of each vertex in the array of vertices set as an input to our
//    Metal vertex shader.  Since this header is shared between our .metal shader and C code,
//    we can be sure that the layout of the vertex array in our C code matches the layout that
//    our .metal vertex shader expects
typedef struct
{
    vector_float2 position;
    vector_float2 textureCoordinate;
} YLZVertex;

#endif /* YLZShaderTypes_h */
