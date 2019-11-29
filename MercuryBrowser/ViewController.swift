//
//  ViewController.swift
//  MercuryBrowser
//
//  Created by Russell Mirabelli on 9/29/19.
//  Copyright © 2019 Russell Mirabelli. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //    let listOfMercuryItems = ["car-image", "liquid", "thermometer"]
    
    // Create empty MercuryList of MercuryItems
    var listOfMercuryItems = MercuryList(mercury: [])
    let urlString = "https://raw.githubusercontent.com/rmirabelli/mercuryserver/master/mercury.json"
    
    // Define a MercuryList
    struct MercuryList: Codable {
        let mercury: [MercuryItem]
    }
    
    // Decode JSON code from url
    func getMercuryItems (urlString: String) {
        
        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            
            let temporaryItemList = try! JSONDecoder().decode (MercuryList.self, from: data!)
            self.listOfMercuryItems = temporaryItemList
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                }
            
        }
        
        task.resume()
        
    }
    
    // Add image from url to current MercuryCell
    func getItemImage (cell: MercuryCell, urlString: String) {
        
        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.mercuryImage.image = image
                    }
                }
            }
        
            task.resume()
        
        }
    
    // Setup
    override func viewDidLoad() {
        
        tableView.dataSource = self
        super.viewDidLoad()
        getMercuryItems(urlString: self.urlString)

    }
    
    // Set number of rows to length of list
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return listOfMercuryItems.mercury.count
        }
    
    // Populate cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Assign MercuryItem elements to immutable vars
        let name = listOfMercuryItems.mercury[indexPath.item].name
        let type = listOfMercuryItems.mercury[indexPath.item].type
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        // Send vars to corresponding cells
        if let mercuryCell = cell as? MercuryCell {
            mercuryCell.mercuryName.text = "\(name)"
            mercuryCell.mercuryType.text = "\(type)"
            getItemImage(cell: mercuryCell,
                      urlString: listOfMercuryItems.mercury[indexPath.item].url)
            
        }
        
        return cell
        
    }
}
