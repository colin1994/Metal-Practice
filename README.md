# Metal-Practice

> 这是我的小专栏 [iOS 图像处理](https://xiaozhuanlan.com/colin) 对应的源码。欢迎订阅，配合教程看效果更佳~
>
> 顺手给个星星哦～



# Metal，启程

从 2014 年，Apple 正式推出 Metal 到现在，这个 Metal 系列教程，酝酿了很久，却迟迟没有进展。

直到 **WWDC 2018，Apple 宣布 iOS 12 将弃用 OpenGL / CL**，我想，这或许是个机会。

> Apps built using OpenGL ES will continue to run in iOS 12, but Open GL ES is deprecated in iOS 12. Games and graphics-intensive apps that previously used OpenGL ES should now adopt Metal.

![](https://diycode.b0.upaiyun.com/photo/2018/de088c47205fd04fc8d9e11748813b10.jpeg)



这个系列会回顾整理之前学习的内容，有序输出。算是对自己的一个交代，同时也希望，能帮助到那些想要学习 Metal 却不知道怎么下手的朋友。



那么，**什么是 Metal** ？

> Render advanced 3D graphics and perform data-parallel computations using the GPU.

总结来说，**Metal 能让你尽可能的发挥 GPU 强大的渲染、运算的能力。**

这里，我不做过多的阐述，如果你对图像处理，游戏编程感兴趣，又或者你只是认可这项技术，相信它是未来，值得投资学习。那么，我想这个系列不会让你失望。



这个系列的文章，**是教程、实践，而不是文档**。

我会尽可能，在实现功能的过程中，穿插介绍各个知识点。而不是一股脑的全部输出。

不然可能看了四五篇，发现自己还是什么都做不了，还是不懂之前学到的具体是什么。

然后，就不了了之了。

Metal 系列的实战教程，会循序渐进，穿插详细介绍各个用到的 Metal 对象。

由于 Metal（iOS 8 + A7），MetalKit（iOS 9 + A7）的软／硬件限制，以及不同读者的需求，之后的配套 Demo，会同时包含 iOS+Swift 和 macOS+ObjC 两种，文章以 iOS+Swift 进行演示。并且尽可能不用 MetalKit，功能都自己实现（避免一些实现细节被屏蔽了，以及降低系统版本限制）。当然，也会有专门的文章，介绍 MetalKit 相关。

另外，每节 Demo 都有 start ／ end 两份代码，建议阅读完后，自己根据 start 基础工程，完成本节新的内容。该系列 Demo 主要是为了学习 Metal，所以一些语法特性，代码／文件结构，容错，封装等，不会去细究。

每篇文章争取控制在 15 分钟的阅读量，细分知识点，便于随时阅读，学习。



另外，之后的实战，会侧重于**图像处理**，比如**滤镜，画笔，马赛克，增高，相机，AR 贴图**等。开发过程中，也会结合系统的其他框架，比如 **Core Image、ARKit、Core ML、Vision** 等，做一些好玩的事情。

> PS：
> 订阅后的朋友，可以加我微信：wxidlongze，拉你进群。交流，扯淡，学习资源分享～
>  最后，源码在文末～

------



## 目录


### 基础概念：

**[一。Metal 概述](https://xiaozhuanlan.com/topic/3420765198)**

> Metal 是什么，Metal 能做什么，为什么要用 Metal。



**[二。Metal 框架一览](https://xiaozhuanlan.com/topic/1287954630)**

>Metal 进行图像处理的整体框架。宏观介绍渲染管线。



### 基础实践：

**[三。清屏](https://xiaozhuanlan.com/topic/9870134265)**

> 最最最最简单的一个基础工程。介绍整体的显示渲染流程。

![](https://diycode.b0.upaiyun.com/photo/2018/4677bca4a9633908b463e670646d434c.png)



**[四。绘制一个三角形](https://xiaozhuanlan.com/topic/6503719284)**

> 堪称图形界的 Hello World。会较为完整的过一遍渲染管线。
>
> 涉及的内容包括：**渲染管线的配置，着色器的编写，顶点数据的提交，图元的绘制**。
>
> 麻雀虽小，五脏俱全。

![img](https://diycode.b0.upaiyun.com/photo/2018/68788a0103eac111ea445b0dcf02fa58.png)



**[五。Buffer & Texture](https://xiaozhuanlan.com/topic/0459813726)**

> 实现基础图像的渲染，即在屏幕上，显示一张我们指定的图片。主要关心非基础图元的绘制，Metal 里面的数据、资源的管理方式，图像解码的一些基础知识。介绍 MTLBuffer 以及 MTLTexture 相关内容。
>

![img](https://diycode.b0.upaiyun.com/photo/2018/ac2b226808a57f0acb725a46dde09759.png)



**[六。GPUImage 3 浅析、基础框架搭建](https://xiaozhuanlan.com/topic/2514387096)**

> 浅析一下 GPUImage 3 的设计，然后基于此，剥离出一些代码，形成基础框架，实现视图封装，也为之后的效果处理提供支持。

![GPUImage](https://camo.githubusercontent.com/68ce8767f20b6a40f2a695c56396d30234363431/687474703a2f2f73756e7365746c616b65736f6674776172652e636f6d2f73697465732f64656661756c742f66696c65732f475055496d6167654c6f676f2e706e67)



**[七。颜色滤镜](https://xiaozhuanlan.com/topic/3654810792)**

> 介绍颜色滤镜常见的两种实现方式：**shader** 和 **lookup table**，并实现饱和度、亮度滤镜，以及常见的阿宝色滤镜。
>
> 同时会分析对应算法的原理。



![](https://diycode.b0.upaiyun.com/photo/2019/f794ad7337d2885699c4d189694e7cf2.gif)





**[八。风格化滤镜(上)](https://xiaozhuanlan.com/topic/3105827964)**

> 上篇我们介绍了简单的颜色滤镜，即独立像素点变换，按照一定规律，修改当前像素点的色值。每个像素点都是独立的，不相互依赖。相对的，其他几类，我们可以统一归类为风格化滤镜，这类滤镜有一个显著的特点：当前点的最终色值，需要依赖其他位置点的色值，来共同决定。
> 这一篇中，会介绍这么两个滤镜 Zoom Blur 和 Toon 的具体实现。
>
> 以及**系统提供的景深信息**等。



![img](https://diycode.b0.upaiyun.com/photo/2018/5d29ead45b570276f7bda57e2fb755df.gif)





![img](https://diycode.b0.upaiyun.com/photo/2018/20c51bfbfaaf5e981a0e77e89a121c45.png)





**[九。风格化滤镜(下)](https://xiaozhuanlan.com/topic/5823149607)**

> 介绍 Toon 效果的具体实现。
> 介绍下更复杂的滤镜，比如之前很火的风格转换，以及借助 Core ML 模型的一些方式。
>



![](https://diycode.b0.upaiyun.com/photo/2019/865ffdd0b6a05851f5b427f15a1c16c1.gif)



![img](https://diycode.b0.upaiyun.com/photo/2018/e0c8acd368f9b02b24ad6e506dce3298.png)





**[十。增高 & MTLHeap](https://xiaozhuanlan.com/topic/4896073512)**

> MTLHeap：An abstract memory pool from which you can create resources.
> 就是一块预先分配好的内存区域，然后这块区域用来干什么，完全是由开发者来控制的，可以随意复用。
> 这次，我们同样是实现一个新的效果，增高。并分析使用 MTLHeap 带来的优势。
>



![](https://diycode.b0.upaiyun.com/photo/2019/549354ade142cf72430238b496aa28d9.gif)






**[十一。抠图换背景 & Mask](https://xiaozhuanlan.com/topic/7256094831)**

> Mask 的使用场景，以及抠图换背景的具体实现。
>



![](https://diycode.b0.upaiyun.com/photo/2019/bb418cdccaa0dce9318e6beaa349312f.gif)





To be continued ~



------

具体源码，可以在我的 Github 上找到：[Metal-Practice](https://github.com/colin1994/Metal-Practice)，顺手给个星星哦～