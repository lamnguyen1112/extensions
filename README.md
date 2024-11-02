#  Core Extension

### How to create own cocoapods libarry
> [Create own cocoapods with tutorials](https://medium.com/@jeantimex/create-your-own-cocoapods-library-da589d5cd270#:~:text=Implement%20the%20pod,-It's%20time%20to&text=In%20the%20project%20navigator%2C%20right,shown%20in%20the%20screenshot%20below.)

### How to distribute new pod version
Using the URL of your repo on your server, add your repo using

> pod repo add core-specs https://github.com/lamnguyen1112/specs.git

Save your Podspec and add to the repo

> pod repo push core-specs ~/../CoreExtension.podspec

Test pod in project

add line to pod file to get specs pod 

> source 'https://github.com/lamnguyen1112/specs.git'

using swiftlint plugin
https://swiftpackageindex.com/GayleDunham/SwiftLintPlugin

