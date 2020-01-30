# Track-Car
Create the application where user can track the car on the map, same like OLA and Uber application do.

Highlight of the code which I had done it.

For accomplished the functionality for moving the car same as Uber iOS application, you need to first calculate the angle between from old location and new location. Please find the below code for how to calculate it.

    func angleFromCoordinate(firstCoordinate: CLLocationCoordinate2D, 
        secondCoordinate: CLLocationCoordinate2D) -> Double {
        
        let deltaLongitude: Double = secondCoordinate.longitude - firstCoordinate.longitude
        let deltaLatitude: Double = secondCoordinate.latitude - firstCoordinate.latitude
        let angle = (Double.pi * 0.5) - atan(deltaLatitude / deltaLongitude)
        
        if (deltaLongitude > 0) {
            return angle
        } else if (deltaLongitude < 0) {
            return angle + Double.pi
        } else if (deltaLatitude < 0) {
            return Double.pi
        } else {
            return 0.0
        }
    }

Then apply the angle to the particular annotation for moving. Please find the below code for the same.

let getAngle = angleFromCoordinate(firstCoordinate: oldLocation, secondCoordinate: newLocation)

//Apply the new location for coordinate.        
myAnnotation.coordinate = newLocation;

//For getting the MKAnnotationView.
let annotationView = self.mapView.view(for: myAnnotation)

//Apply the angle for moving the car.
annotationView?.transform = CGAffineTransform(rotationAngle: CGFloat(getAngle))
