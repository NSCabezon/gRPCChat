# gRPC

## Swift

First we need to install the needed dependencies.

With homebrew just run on your terminal:

```swift
brew install swift-protobuf grpc-swift
```


Maybe you need to export the path to protoc-grpc-swift-plugin before generating the files.

```bash
export PATH=$PATH:{{path_to_binary}}
```


After having the needed dependencies. To generate swift files use the following command:

```swift
protoc --swift_out=<<output_path>> <<input_file>>
```
