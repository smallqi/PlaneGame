1. 图层移动时发生闪现问题：
最上层图层转移时，应先移动到下层在转移

2. 碰撞检测发生穿透问题：
办法1:保证子弹速度小于子弹长度，增加帧数
办法2:让碰撞体大小随着子弹速度的变快而变大
办法3:移动前和移动后的点形成射线，检测碰撞，可适用于不同方向的检测

3. 视图已被移除时死亡动画尚未播完：
办法1:延迟移除执行  [performSelector: withObject: afterDelay:];
办法2:创建多一个死亡动画播放队列，在每帧中检查队列元素动画是否播放完毕->移除视图

4. gethit动画和fly动画不能很好衔接：
表现为：顺序播放的话hit动画未播完被fly动画插入，没有效果。延迟播放fly，则可能在下一帧时已经死亡后播放fly
办法1:gethit动画在一帧时间内播放，在下一帧开始前播放fly。理论可行，但运行后视觉效果体现不出hit

5. 所有敌机都同一时刻发射子弹：
办法1:为飞机添加多一个自身的frames属性，用来控制自身的子弹发射频率

设计问题：
正常的MVC模式下,hero,enemy类应该设计成纯粹的数据和方法集合，作为model。在view上多增一个hero,enemy的Imageview作为视图。在c里面新建hero model，根据model的数据来控制view的显示。即是，一切视图都由c根据model来负责生成。m于v没有交互。
我在书写时，觉得为每个hero又建多一个没有什么功能的view很没必要，就view和model融在一起，把hero看成一个拥有数据的视图的整体。我想着尽量减少c里面的代码，把尽量多的控制让对象自己完成。在真正书写时，发现并不能太如愿。c代码基本不变，因为两者间的行为需要交互太多的信息，你需要把大量的controller的信息传递到类方法里去，这种的代价其实感觉和直接在c里写差不多。
由于工程较小，没有涉及太多的后期维护，所以感觉起来两种实现方式没有太多差别。讲道理的话，第一种的维护应该好一点，就是所以逻辑全部集中在了c里面。第二种的类的耦合性可能比较高，虽然c看起来简洁一点，但是维护好想也不一定比较难吧。把视图和数据看成一整个个体，该怎样就在里面怎样了。
1. 功能应该在作为类方法还是c里去判断：
1）飞机移动，出界判断
2）飞机开枪
3）飞机死亡：在脚本上的话，会选择在飞机里面自动判断，并通知起c脚本更新。ios上，则在c里面判断。
有一种极端叫做一个main函数搞定一切，类不需要方法，只需要属性就可以了。感觉好像是结构体的面向过程编程？
