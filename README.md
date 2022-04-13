# gRPC

## Server

## Android

## Swift

First we need to install the needed dependencies.

With homebrew just run on your terminal:

```swift
brew install swift-protobuf grpc-swift
```

After having the needed dependencies. To generate swift files use the following command:

```swift
protoc --swift_out=<<output_path>> <<input_file>>
```

