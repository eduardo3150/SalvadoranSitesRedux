//
//  ViewController.swift
//  SitiosTuristicosV3
//
//  Created by usuario on 25/10/17.
//  Copyright © 2017 eduardo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation
import SDWebImage
import MapKit


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var categoriesCollection: UICollectionView!

    var categoriesList:[Category] = [Category]();
    var category:Category?
    
    let cellIdentifier : String = "cellIdentifierCategory"
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoriesCollection.dataSource = self
        self.categoriesCollection.delegate = self
        
        self.refresh()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.layoutIfNeeded()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        categoriesCollection.addSubview(refreshControl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(){
        print("Refresh content")
        
        Alamofire.request("https://gitlab.com/snippets/1682272/raw").responseJSON { response in
            
            switch response.result{
                
            case.success:
                self.parse(data: JSON(response.result.value!));
                
            case.failure(let error):
                print(error)
                self.refreshControl.endRefreshing();
            }
        }
        
    }
    
    func parse(data:JSON) {
        self.categoriesList.removeAll();
        
        for item in data.arrayValue{
            let category:Category=Category()
            var sitesList: [Sitio] = [Sitio]()
            
            category.id = item["id"].int!
            category.category = item["categoria"].string!
            category.thumbnail = item["thumbnail"].string!
            category.categoryPin = item["category_pin"].string!
            print(category.category ?? "error")
            for site in item["sitios"].arrayValue {
                let sitio : Sitio = Sitio(
                    id : site["id"].int!,
                    title: site["nombre"].string!,
                    descriptionLocation : site["descripcion"].string!,
                    thumbnail : site["thumbnail"].string!,
                    coordinate : CLLocationCoordinate2D(latitude: Double(site["latitud"].string!)!,
                                                        longitude: Double(site["longitud"].string!)!)
                )
                
                sitesList.append(sitio)
            }
            category.sitios = sitesList
            self.categoriesList.append(category)
            
        }
        
        self.categoriesCollection.reloadData()
        
        self.refreshControl.endRefreshing()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoriesList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! CategoryCell
        
        cell.categoryTitle.text = self.categoriesList[indexPath.item].category;
        
        let imagepath = self.categoriesList[indexPath.item].thumbnail!
        cell.categoryThumbnail.sd_setImage(with: URL(string:imagepath), placeholderImage: UIImage(named: "nodisponible.png"));
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tmpCategory = categoriesList[indexPath.row]
        category = tmpCategory
        
        self.performSegue(withIdentifier: "showCategory", sender: indexPath)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCategory" {
            if let mapViewController = segue.destination as?
                MapController {
                    mapViewController.category = self.category
            }
        }
    }
}
