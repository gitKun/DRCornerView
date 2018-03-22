# DRCornerView
处理视图圆角

第一版位置:

[给视图添加圆角的轻量级方法](https://www.jianshu.com/p/feb471fd00da)

第一版存在的问题:
 
1. 不能自动给`AutoLayout`出来`view`正确添加圆角;
2. 反复的添加和移除做圆角处理的`shapeLayer`,存在一定的性能损耗;
3. 部分`API`设计的不够理想;

现在给出了修改后的第二版:

1. 现在你不需要再为获取`xib`或者约束出来的`view`的`bounds`而头疼了,`UIView+DRCorner`已经不在需要你传入`bounds`了;
2. 同样的现在不会存在反复添加和移除实现圆角化的`shapeLayer`了;
3. 你可以直接创建出来一个控制圆角显示的`DRCornerModel`实例,来控制圆角的各个属性:如`cornerRadius`等,然后直接调用`UIView`的拓展方法`-dr_cornerWithCornerModel:`方法进行圆角化处理;

具体效果在`截图`文件夹下已经给出;


这里给出第一版中说过的另类的实现方法:
创建一个`UIView`的子类`DRCornerView`,替换`DRCornerView`的`layer`为`CAShapeLayer`,对`shapeLayer`做第一版一样的圆角处理,然后再设置这个`DRCornerView`和要圆角化的`view`保持在同一位置即可(如果被遮挡的`corberedView`有点击或者其他交互事件这时你就需要设置`DRCornerView`的`userInteractionEnabled`为`NO`,以此来将touch事件传递给`corberedView `),具体可见 [DRCornerExt](https://github.com/gitKun/DRCornerView)中的`CornerView`文件夹下的实现;


*ps:*你甚至可以重写`DRCornerView`的`-willMoveToSuperview:`方法,将`DRCornerView`设置和`superView`保持一致大小;
