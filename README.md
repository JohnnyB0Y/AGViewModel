# AGViewModel
在实践 casa 的去Model化后，为了解决网络数据获取后如何处理、如何更新、如何监听变化等一系列细节问题，而设计了AGViewModel一系列模块。

- 去Model化后，几乎不需要再设计模型对象了。
- 在代码块中对数据进行打包，网络数据处理成视图直接使用的数据后打包。
- 在数据打包的同时，可以把视图的Class和size计算好一起打包。
- 在一般情况下，借助ViewManager类，TableView和CollectionView的数据源方法和代理方法几乎不用管。
- 视图持有ViewModel对象，数据直接在接收ViewModel时设置。
- 而ViewModel弱引用视图，因此控制器拿到ViewModel改变数据直接刷新界面。
- 视图也可以通过ViewModel把点击事件抛给控制器处理。
- ViewModel可以添加观察者，字典中的数据变化可以监听。
- VMManager管理整个TableView或CollectionView的数据，而VMSection管理一组Cell或Item的数据（包括头尾视图），ViewModel管理一个Cell或Item的数据。

去Model化会不会很重，其实组件化后完全可以隔离开来。每个程序员可以各显神通，互不影响。



### cocoapods 集成
```
platform :ios, '7.0'
target 'AGViewModel' do

pod 'AGViewModel'

end
```




