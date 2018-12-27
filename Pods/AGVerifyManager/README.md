# AGVerifyManager
### 思路描述
- 参考了 Masonry 的链式语法，使用起来非常优雅并且非常适合验证多个数据。
- 因为用户需要验证的数据是变化且各不相同的，所以把变化隔离开来，独立封装。
- 验证的时候需要集中处理，所以用代码块统一了起来。

### cocoapods 集成
```
platform :ios, '7.0'
target 'AGVerifyManagerDemo' do

pod 'AGVerifyManager'

end
```

### 使用说明
```objective-c
/**
     - 创建遵守<AGVerifyManagerVerifiable>协议的验证器类
     - 实现<AGVerifyManagerVerifiable>协议方法
     - 具体可参考 Demo
     - 下面是使用过程
     */
	
    // 1. 判断用户输入文字限制
    ATTextLimitVerifier *usernameVerifier = [ATTextLimitVerifier new];
    usernameVerifier.minLimit = 2;
    usernameVerifier.maxLimit = 7;
    usernameVerifier.maxLimitMsg =
    [NSString stringWithFormat:@"文字不能超过%@个字符！", @(usernameVerifier.maxLimit)];
    
    // 2. 判断文字是否包含 emoji 😈
    ATEmojiVerifier *emojiVerifier = [ATEmojiVerifier new];
    emojiVerifier.errorMsg = @"请输入非表情字符！";
    
    // 3. 判断文字是否包含空格
    ATWhiteSpaceVerifier *whiteSpaceVerifier = [ATWhiteSpaceVerifier new];
    
    // 4. 准备验证
    __weak typeof(self) weakSelf = self;
    [self.verifyManager ag_prepareVerify:^(id<AGVerifyManagerVerifying>  _Nonnull start) {
        
        __strong typeof(weakSelf) self = weakSelf;
        start
        .verifyObj(usernameVerifier, self.nameTextField.text) // 用法一：传入验证器和需要验证的数据
        .verifyObj(emojiVerifier, self.nameTextField.text)
        .verifyObjMsg(whiteSpaceVerifier, self.nameTextField.text, @"文字不能包含空格！") // 用法二：传入验证器、数据、提示的内容
        .verifyObj(self, self.nameTextField); // 文本框闪烁
        
    } completion:^(AGVerifyError * _Nullable firstError, NSArray<AGVerifyError *> * _Nullable errors) {
        
        __strong typeof(weakSelf) self = weakSelf;
        if ( firstError ) {
            // 验证不通过
            self.resultLabel.textColor = [UIColor redColor];
            self.resultLabel.text = firstError.msg;
            
            // 文本框闪烁
            [errors enumerateObjectsUsingBlock:^(AGVerifyError * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                // 根据你自身业务来处理
                if ( obj.verifyObj == self.nameTextField ) {
                    // 取色
                    UIColor *color;
                    if ( obj.code == 100 ) {
                        color = [UIColor redColor];
                    }
                    else if ( obj.code == 200 ) {
                        color = [UIColor purpleColor];
                    }
                    // 动画
                    [UIView animateWithDuration:0.15 animations:^{
                        self.nameTextField.backgroundColor = color;
                    } completion:^(BOOL finished) {
                        self.nameTextField.backgroundColor = [UIColor whiteColor];
                    }];
                }
                
            }];
            
        }
        else {
            // TODO
            self.resultLabel.textColor = [UIColor greenColor];
            self.resultLabel.text = @"验证通过！";
            self.nameTextField.backgroundColor = [UIColor whiteColor];
        }
        
    }];
    
    
    // 5. 执行验证
    [self.verifyManager ag_executeVerify];

```


