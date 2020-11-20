# Reddit Client PoC

## MVVM-based Reddit Client PoC app for iOS (iPhone / iPad) in Swift

This project contains the codebase for an MVVM-based Reddit Client PoC app for iOS (iPhone / iPad) in Swift. It relies on Combine framework to support data-bindings, and IoC with property wrappers. Also it implements a view-first navigation.

The structure of the project is as follow:

- UI Layer
  - iOS UI (Storyboards, Views/ViewControllers, and other UI components)

- Application Layer
  - ViewModels, CompositionRoot for DI, and non platform-specific components
  
- Domain Layer
  - Services and models

- Infraestructure Layer
  - Network, Persistence, Extensions and Utils classes

## Screenshots

![Reddit Test on iPad](ipad.png)
![Reddit Test on iPhone 1](iphone1.png)
![Reddit Test on iPhone 2](iphone2.png)
