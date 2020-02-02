# Track-Car
**Track-Car** makes it easy to add tracking functionalities to your iOS app! 

## Features
- [x] Use Combine framework for location handling
- [x] Use Decodable protocol for JSON parsing
- [x] Support Landscape mode
- [x] Dark mode

## Demo
![](https://github.com/ram2386/Track-Car/blob/master/Track%20car.gif)

## Requirements
 - iOS 13.0+
 - Xcode 11.0+
 - Swift 5.0+
 
## Installation
### Manually

Just download the project, drag and drop the "TrackCar" folder in your application.

## Usage
1. Create the LocationService and implement in your view controller
```
class YourViewController: {
    let locationService = LocationService()    
}
```

2. Subscribe the PassthroughSubject subject which send the location at 1 second interval
```
   cancelSubject = locationService.locationSubject
              .receive(on: DispatchQueue.main)
              .sink(receiveCompletion: { (completion) in
              switch completion {
                  case .failure(let error):
                      ....
                  case .finished:
                      break
              }
              }) { [weak self] (item) in
                  self?.updateCarLocation(model: item)
              }
    
    locationService.setupTimerPublisher()
```

And cancel the subscription when it no longer need.

3. Implement the updateLocationOnMap method of LocationService class where you need to pass the refernce of your MapView, location and MKAnnotation 
```
func updateCarLocation(model: CarModel) {
 self.locationService?.updateLocationOnMap(model: model, myAnnotation: myAnnotation, mapView: mapView)
}
```

## Roadmap
### Features

- [ ] Add CocoaPods
- [ ] Adding the 
 
### Improvements/To Do
- [ ] Apply the smooth animation while moving the car on the map
