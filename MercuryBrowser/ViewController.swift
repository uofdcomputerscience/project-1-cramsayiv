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
    var listOfMercuryItems = MercuryList(mercury: [])
    let urlString = "https://raw.githubusercontent.com/rmirabelli/mercuryserver/master/mercury.json"

    struct MercuryList: Codable {
        let mercury: [MercuryItem]
    }
    
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
    
    override func viewDidLoad() {
        
        tableView.dataSource = self
        super.viewDidLoad()
        getMercuryItems(urlString: self.urlString)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return listOfMercuryItems.mercury.count
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let name = listOfMercuryItems.mercury[indexPath.item].name
        let type = listOfMercuryItems.mercury[indexPath.item].type
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        if let mercuryCell = cell as? MercuryCell {
            mercuryCell.mercuryName.text = "\(name)"
            mercuryCell.mercuryType.text = "\(type)"
            getItemImage(cell: mercuryCell,
                      urlString: listOfMercuryItems.mercury[indexPath.item].url)
            
        }
        
        return cell
        
    }
}
