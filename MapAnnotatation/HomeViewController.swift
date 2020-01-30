//
//  HomeViewController.swift
//  MapAnnotatation
//
//  Copyright © 2020 Ramkrishna Sharma. All rights reserved.
//

import UIKit
import MapKit

import Combine

class HomeViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let lastIndex = 350
    let truncate = 6
    var arrPin: [CarModel]?
    var arrMapAnnotation: [MapAnnotation]?
    var index: Int = 0
    var timer: Timer?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoad()
    }
    
    //MARK:- User Method
    func initialLoad() {
        
        arrPin = parseJSON()
        
        if let carInfo: CarModel = arrPin?[0] {
            
            arrMapAnnotation = [MapAnnotation]()
            
            print(carInfo.latitude)
            
            var regionInfo = MKCoordinateRegion()
            var span = MKCoordinateSpan()
            
            span.latitudeDelta = 0.009
            span.longitudeDelta = 0.009
            
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(carInfo.latitude), longitude: CLLocationDegrees(carInfo.longitude))
                        
            let mapAnnot = MapAnnotation(coordinate: location)
            mapAnnot.title = "Title"
            mapAnnot.subtitle = "SubTitle"
            mapView.addAnnotation(mapAnnot)
            arrMapAnnotation?.append(mapAnnot)
            
            regionInfo.span = span
            regionInfo.center = location
            mapView.setRegion(regionInfo, animated: true)
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateLocation), userInfo: nil
                , repeats: true)
        }
    }
        
    //MARK:- JSON Parser
    func parseJSON() -> [CarModel]? {
        
        do {
            if let file = Bundle.main.url(forResource: "csvjson", withExtension: "json") {
                
                let data = try Data(contentsOf: file)
                let arrCar = try JSONDecoder().decode([CarModel].self, from: data)
                
                return arrCar
                
            } else {
                print("no file found")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    //MARK:- Map + User Method
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
    
    @objc func updateLocation() {
        
        if let myAnnotation: MapAnnotation = arrMapAnnotation?[0] {
            
            if index == lastIndex {
                timer?.invalidate()
            } else {
                
                if index > 0 {
                    
                    var oldLocation = CLLocationCoordinate2D()
                    var newLocation = CLLocationCoordinate2D()
                    
                    oldLocation.latitude = arrPin?[index-1].latitude.truncate(places: truncate) ?? 0.0
                    oldLocation.longitude = arrPin?[index-1].longitude.truncate(places: truncate) ?? 0.0
                    newLocation.latitude = arrPin?[index].latitude.truncate(places: truncate) ?? 0.0
                    newLocation.longitude = arrPin?[index].longitude.truncate(places: truncate) ?? 0.0
                    
                    weak var weakSelf = self
                    
                    let getAngle = angleFromCoordinate(firstCoordinate: oldLocation, secondCoordinate: newLocation)
                                        
                    UIView.animate(withDuration: 2, delay: 0, options: .allowUserInteraction, animations: {
                        myAnnotation.coordinate = newLocation
                        let annotationView = weakSelf?.mapView.view(for: myAnnotation)
                        annotationView?.transform = CGAffineTransform(rotationAngle: CGFloat(getAngle))
                        weakSelf!.mapView.setCenter(newLocation, animated: true)
                    })
                }
                
                index += 1
            }
        }
    }
}

extension HomeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        } else {
            
            let identifier: String = "CustomViewAnnotation"
            
            var annotView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? AnnotationView
            
            if let annotationView = annotView {
                return annotationView
                
            } else { // nil
                
                annotView = AnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                let pinIcon = UIImage(named: "carIcon")
                annotView?.btnInfo = UIButton()
                annotView?.frame = CGRect(x: 0, y: 0, width: pinIcon!.size.width, height: pinIcon!.size.height)
                annotView?.btnInfo?.frame = annotView?.frame ?? CGRect.zero
                annotView?.btnInfo?.setBackgroundImage(pinIcon, for: .normal)
                annotView?.addSubview(annotView?.btnInfo ?? UIButton())
                
                return annotView
            }
        }
    }
}

extension Double {
    
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
