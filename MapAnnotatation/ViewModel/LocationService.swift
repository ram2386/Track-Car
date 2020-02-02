//
//  LocationService.swift
//  MapAnnotatation
//
//  Created by sysadmin on 30/01/20.
//  Copyright © 2020 Ramkrishna Sharma. All rights reserved.
//

import UIKit
import Combine
import MapKit

class LocationService: NSObject {

    var arrCars: [CarModel]?
    var locationSubject = PassthroughSubject<CarModel, Error>()
    var cancelLocationSubject: AnyCancellable?
    var index = 1
    let lastIndex = 350
    let truncate = Constant.Truncate.value
    
    // MARK:- Parse JSON
    func parseJSON() -> [CarModel]? {
        
        do {
            if let file = Bundle.main.url(forResource: "csvjson", withExtension: "json") {
                
                let data = try Data(contentsOf: file)
                let arrCar = try JSONDecoder().decode([CarModel].self, from: data)
                
                return arrCar
                
            } else {
                fatalError("no file found")
            }
        } catch {
            fatalError(error.localizedDescription)
        }
        
        return nil
    }
    
    func getLocationData() {
        self.arrCars = parseJSON()
    }

    
    //MARK:- Setup Timer Publisher
    func setupTimerPublisher() {
        
        //Pre-Filled the array
        getLocationData()
        
        cancelLocationSubject = Timer.publish(every: 1.0, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    break
                }
            }) { [weak self] (output) in
                
                var carItem: CarModel = CarModel(latitude: 0.0, longitude: 0.0)
                
                if let index = self?.index, index > 0 {
                                        
                    guard let item = self?.arrCars?[index] else {
                        return
                    }
                    
                    carItem = item
                    carItem.oldlatitude = self?.arrCars?[index-1].latitude ?? 0.0
                    carItem.oldlongitude = self?.arrCars?[index-1].longitude ?? 0.0
                }
                
                self?.locationSubject.send(carItem)
                self?.index += 1
                
                if let count = self?.index, count == self?.lastIndex {
                    self?.cancelLocationSubject?.cancel()
                }
            }
    }
    
    //MARK:- Utility Method
    func updateLocation(model: CarModel, myAnnotation: MapAnnotation, mapView: MKMapView) {
        
            let oldLocation = CLLocationCoordinate2DMake(model.oldlatitude.truncate(places: truncate), model.oldlongitude.truncate(places: truncate))
            let newLocation = CLLocationCoordinate2D(latitude: model.latitude.truncate(places: truncate) , longitude: model.longitude.truncate(places: truncate))

            let getAngle = self.angleFromCoordinate(firstCoordinate: oldLocation, secondCoordinate: newLocation)

            UIView.animate(withDuration: 2, delay: 0, options: .allowUserInteraction, animations: {
                myAnnotation.coordinate = newLocation
                let annotationView = mapView.view(for: myAnnotation) as! AnnotationView
                annotationView.transform = CGAffineTransform(rotationAngle: CGFloat(getAngle))
                mapView.setCenter(newLocation, animated: true)
            })
    }
        
    func angleFromCoordinate(firstCoordinate: CLLocationCoordinate2D, secondCoordinate: CLLocationCoordinate2D) -> Double {
        
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
}
