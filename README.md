# Track-Car
Create the application where user can track the car on the map, same like OLA and Uber application do.

![](https://github.com/ram2386/Track-Car/blob/master/Track%20car.gif)

## Main features
- [x] Use Combine framework for location handling
- [x] Use Decodable protocol for JSON parsing
- [x] Dark mode
- [x] Add/delete/edit/complete tasks

## Requirements
 - iOS 13.0+
 - Xcode 11.0+
 - Swift 5.0+
 
 ## How to run

1. Clone the repo
2. Run ```pod install``` in terminal to install required pods. Make sure you have [CocoaPods](https://guides.cocoapods.org/using/getting-started.html) installed.
3. Turn on iCloud option in ```Signing & Capabilities``` and check ```CloudKit```. Turn on ```Background Modes``` and check ```Background fetch``` + ```Remote notification```.
4. Make sure to update your app group config (```Signing & Capabilities```, ```App Groups```) and id string in ```RealmManager.swift```.
5. (Optional) You might want to update or remove [Fabric](https://fabric.io/home) script located ```Build Phases```.

 ## Roadmap

### Features

- [ ] Add CocoaPods
- [ ] Adding the 
 
### Improvements/To Do
- [ ] Apply the smooth animation while moving the car on the map
