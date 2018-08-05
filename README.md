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

> Metal 进行图像处理的整体框架。宏观介绍渲染管线。



### 基础实践：

**[三。清屏](https://xiaozhuanlan.com/topic/9870134265)**

> 最最最最简单的一个基础工程。介绍整体的显示渲染流程。

![](https://diycode.b0.upaiyun.com/photo/2018/4677bca4a9633908b463e670646d434c.png)



[**四。绘制一个三角形**](https://xiaozhuanlan.com/topic/6503719284)

> 堪称图形界的 Hello World。会较为完整的过一遍渲染管线。麻雀虽小，五脏俱全。

![](https://diycode.b0.upaiyun.com/photo/2018/68788a0103eac111ea445b0dcf02fa58.png)



**五。MSL 介绍**

> 介绍如何编写 Metal 着色器。以及它们是如何被加载工作的。



**六。显示图片**

> 还在纠结绘制三角形有什么用吗？
>
> 这节会教你如何加载纹理，如何显示相册导入的图片。



**七。视图封装**

> 封装一个通用的控件。支持不同 contentMode，支持缩放，最大显示像素格，长按对比。



### 案例实战：

**八。色温滤镜**

> 基础的颜色滤镜，以及如何使用 CLUT（Color Lookup Table）实现效果。



**九。多重滤镜**

> 滤镜链的实现，多个滤镜组合。



**十。增高**

> 不再是逐像素的简单处理，涉及形变。

...
**To be continued ~**

------

具体源码，可以在我的 Github 上找到：[Metal-Practice](https://github.com/colin1994/Metal-Practice)，顺手给个星星哦～