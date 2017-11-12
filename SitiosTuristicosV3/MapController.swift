//
//  MapController.swift
//  SitiosTuristicosV3
//
//  Created by Eduardo Chavez on 11/12/17.
//  Copyright © 2017 eduardo. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import AlamofireImage

class MapController: UIViewController, MKMapViewDelegate {
    var sitio: Sitio?
    
    @IBOutlet weak var mapSelector: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var category:Category?
    
    let initialLocation = CLLocation(latitude: 13.7371443, longitude: -89.290824)

    let regionRadius: CLLocationDistance = 500000
    var points:[CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        centerMapOnLocation(location: initialLocation)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkLocationAuth()
        
        
        
        mapView.addAnnotations((category?.sitios)!)
    }
    
    
    @IBAction func selectNewStyle(_ sender: Any) {
        switch mapSelector.selectedSegmentIndex {
        case 0:
            mapView.mapType = MKMapType.standard
        case 1:
            mapView.mapType = MKMapType.satellite
        case 2:
            mapView.mapType = MKMapType.hybrid
            
        default:
            break
        }
    }
    
    
    func checkLocationAuth(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation)  {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Sitio else { return nil }
        // 3
        let identifier = "marker"
        var view: MKAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
            
            let imagepath = self.category?.categoryPin
            
            
            Alamofire.request(imagepath!).responseImage { response in
                if let picture = response.result.value {
                    view.image = picture
                } else {
                    view.image = UIImage(named: "icons8-pointer-filled.png")
                }
            }
            
    
        } else {
            // 5
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            let imagepath = self.category?.categoryPin
            
            Alamofire.request(imagepath!).responseImage { response in
                if let picture = response.result.value {
                    view.image = picture
                } else {
                    view.image = UIImage(named: "icons8-pointer-filled.png")
                }
            }
            
        }
        return view
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            sitio = view.annotation as? Sitio
            performSegue(withIdentifier: "showDetail", sender: view)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let mapViewDetail = segue.destination as?
                DetailSiteController {
                mapViewDetail.sitio = self.sitio
            }
        }
    }
    
}
