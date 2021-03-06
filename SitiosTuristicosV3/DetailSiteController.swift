//
//  DetailSiteController.swift
//  SitiosTuristicosV3
//
//  Created by Eduardo Chavez on 11/12/17.
//  Copyright © 2017 eduardo. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

class DetailSiteController: UIViewController {
    var sitio:Sitio?
    
    @IBOutlet weak var descriptionTitle: UILabel!
    
    @IBOutlet weak var descriptionDetail: UILabel!
    
    @IBOutlet weak var descriptionThumbnail: UIImageView!
    
    let BASE_IMG_URL = "http://salvadoransitesv2.us-west-2.elasticbeanstalk.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(sitio?.title ?? "error")
        descriptionTitle.text = sitio?.title
        descriptionDetail.text = sitio?.descriptionLocation
        let imagepath = BASE_IMG_URL+(sitio?.thumbnail)!
        descriptionThumbnail.sd_setImage(with: URL(string:imagepath), placeholderImage: UIImage(named: "nodisponible.png"));
        descriptionThumbnail.contentMode = .scaleAspectFit
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
