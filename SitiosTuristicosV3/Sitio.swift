//
//  Sitio.swift
//  SitiosTuristicosV3
//
//  Created by usuario on 1/11/17.
//  Copyright © 2017 eduardo. All rights reserved.
//

import MapKit
class Sitio: NSObject, MKAnnotation {
    var id:Int?
    var title:String?
    var descriptionLocation:String?
    var thumbnail:String?
    var coordinate: CLLocationCoordinate2D
    
    init(id: Int, title: String, descriptionLocation: String?, thumbnail: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.title = title
        self.descriptionLocation = descriptionLocation
        self.thumbnail = thumbnail
        self.coordinate = coordinate
        super.init()
    }
}
