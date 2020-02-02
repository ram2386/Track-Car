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
    var arrMapAnnotation: [MapAnnotation]?
    
    var locationService: LocationService? = nil
    var canceLocationService: AnyCancellable?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoad()
    }
    
    //MARK:- User Method
    func initialLoad() {
        
        self.locationService = LocationService()
        
        arrMapAnnotation = [MapAnnotation]()
        
        var regionInfo = MKCoordinateRegion()
        var span = MKCoordinateSpan()
        
        span.latitudeDelta = Constant.Delta.defaultValue
        span.longitudeDelta = Constant.Delta.defaultValue
        
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(Constant.InititalLocation.latitue), longitude: CLLocationDegrees(Constant.InititalLocation.longitute))
                    
        let mapAnnot = MapAnnotation(coordinate: location)
        mapAnnot.title = "Title"
        mapAnnot.subtitle = "SubTitle"
        mapView.addAnnotation(mapAnnot)
        arrMapAnnotation?.append(mapAnnot)
        
        regionInfo.span = span
        regionInfo.center = location
        mapView.setRegion(regionInfo, animated: true)
        
        //Subscribe the passthrough subject
        canceLocationService = self.locationService?.locationSubject
                            .receive(on: DispatchQueue.main)
                            .sink(receiveCompletion: { (completion) in
                            switch completion {
                                case .failure(let error):
                                    print(error.localizedDescription)
                                case .finished:
                                    break
                            }
                            }) { [weak self] (carModel) in
                                self?.updateCarLocation(model: carModel)
                            }
        
        self.locationService?.setupTimerPublisher()
    }
    
    func updateCarLocation(model: CarModel) {
        
        if let myAnnotation: MapAnnotation = arrMapAnnotation?[0] {
            self.locationService?.updateLocationOnMap(model: model, myAnnotation: myAnnotation, mapView: mapView)
        }
    }
    
    deinit {
        if let _ = self.canceLocationService {
            self.canceLocationService?.cancel()
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
                
            } else {// nil
                
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
