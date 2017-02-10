//
//  MapViewController.swift
//  On-The-Map
//
//  Created by Abdullah on 1/27/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {

    // Mark: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    
    var annotations = [MKPointAnnotation]()
    
    var studentsInfo: [StudentInformation]? {
        return (self.tabBarController as! MapTabBarController).studentsInfoList ?? nil
    }
    

    // Mark: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        constructAllAnnotations()
    }

    // Mark: - Actions & Protocol
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                // app.openURL(URL(string: toOpen)!)
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    // Mark: - Methods
    
    func constructAllAnnotations() {
        cleanMap()
        
        if let studentsInfo = studentsInfo {
            for info in studentsInfo {
                let annotation = constructAnnotation(studentInfo: info)
                
                if let annotation = annotation {
                    annotations.append(annotation)
                }
            }
            self.mapView.addAnnotations(annotations)
        }
    }
    
    func addAnnotationToMap(_ studentInfo: StudentInformation) {
//        if studentInfo.fullName != "None" {
//            if mapView.annotations.contains(where: { $0.title! == studentInfo.fullName }) {
//               mapView.removeAnnotation(mapView.removeAnnotation())
//            }
//        }
        let _ = constructAnnotation(studentInfo: studentInfo)
    }
    
    private func constructAnnotation(studentInfo: StudentInformation) -> MKPointAnnotation? {
        let lat = studentInfo.latitude, long = studentInfo.longitude
        
        if lat == nil || long == nil {
            return nil
        }
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let latDegree = CLLocationDegrees(Double(lat!))
        let longDegree = CLLocationDegrees(Double(long!))
        let coordinate = CLLocationCoordinate2D(latitude: latDegree, longitude: longDegree)
        
        let fullName = studentInfo.fullName
        let mediaURL = studentInfo.mediaURL ?? "None"
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = fullName
        annotation.subtitle = mediaURL
        
        return annotation
    }
    
    private func cleanMap() {
        if annotations.count > 0 {
            mapView.removeAnnotations(annotations)
        }
    }

}
