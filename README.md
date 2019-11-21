# YiDispatchQueue

a more convenient tool for dispatch queue

## Usage

```
_queue = [[YiDispatchQueue alloc] init];
[_queue dispatch:^{
    NSLog(@"hello, this is test queue");
}];
    
[[YiDispatchQueue concurrentDefaultQueue] dispatch:^{
    NSLog(@"hello, this is test concurrent queue");
}];
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Installation

YiDispatchQueue is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YiDispatchQueue'
```

## Author

coderyi, coderyi@foxmail.com

## License

YiDispatchQueue is available under the MIT license. See the LICENSE file for more info.
