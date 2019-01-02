# DRCornerView


> 老规矩上图

![DRLayoutCornerDemo](./截图/DRLayoutCornerDemo.gif)

![userInTableView](./截图/useInTableView.gif)


> 拿来主义虽然好用，但我更希望您能在理解原理的基础是哪个自己动手写一下

### 做出的修改


1. 修改边框的绘制逻辑：
	
	现在使用
	
	```
	[cornerPath addCurveToPoint:fPoint controlPoint1:eControlPoint controlPoint2:fControlPoint];
	```
	
	来添加绘制`RectCorner`。
	
	好处是：
	
	圆角后添加描边不需要再次计算圆角路径并且添加的描边不会再有超出添加圆角视图的`bounds`这样的BUG(这会导致很多不好的呈现效果)；
	
	可以控制每个角的圆角半径(虽然看似用处不大)；
	

2. 代码调整,支持了链式调用，测试代码如下：

  ```
  [self.cornerBGView dr_makeCornerBorder:^(DRCornerBorderStyle * _Nonnull style) {
        style.coverBGColor.equalTo(UIColor.whiteColor)
        .cornerLineWidth.equalToWidth(lineWidth)
        .cornerBorderColor.equalTo(UIColor.lightGrayColor)
        .topLeftRadius
        .topRightRadius
        .bottomRightRadius
        .bottomLeftRadius
        .equalToWidth(radius);
    }];
  ```

3. 测试用例
	
	测试用例保存在`example`文件夹中；


#### 备注：

 `coverBGColor`非必要参数，这个参数适用于添加圆角处理的view的supView的bgColor为`clearColor`时，传入你实际需要覆盖的颜色；
 
> 在`UseInTableView`中，对于`TopCorner`和`BottomCorner`的`cell`，可以采用继承的方式来写，在`UITableViewDataSource`中的`index.row == 0 || index.row == last`时返回`cornerCell`

   a 

> 在 `UIView+DRCornerBorderStyle` 中因为没有提供 `update` 方法，因此在 `-dr_style` 中可以不使用懒加载来创建`DRCornerBorderStyle`, 在 `-dr_hasMakeCornerBorderStyle` 中使用 `![self dr_style]` 替换现有的判断， 在 `- dr_makeCornerBorder:` 中省略 `[[self dr_style] cleanCache];` 和 `[self registCornerLayer];` (需要在 `-dr_refreshCornerBorderStyle` 中注册)，等。

   b

> 可以自定义一个`CALayer`的子类来实现相同的功能，这样就不需要在`UIView`的拓展中保存两个`CAShapeLayer`来分别绘制__遮挡区域__和__显示区域的描边__。

   c
   
>