//
//  tableStuff.swift
//  HackUNO2020
//
//  Created by Christopher Phillips on 3/8/20.
//  Copyright © 2020 Lion275. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController{
    
    var cities : [CityResult] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cities = results;
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CityTableViewCell";
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CustomCell else {
            fatalError("oops");
        }
        let city = cities[indexPath.row];
        var cityName = city.cityName;
        if(cityName == "SAN DIEGO"){
            cityName = "San_Diego";
        } else if(cityName == "EL PASO"){
            cityName = "El_Paso";
        } else if(cityName == "CHICAGO"){
            cityName = "Chicago";
        }else if(cityName == "AUGUSTA"){
            cityName = "Agusta";
        }else if(cityName == "SCOTTSDALE"){
            cityName = "Scottsdale";
        }else if(cityName == "PHILADELPHIA"){
            cityName = "Philadelphia";
        }else if(cityName == "MINNEAPOLIS"){
            cityName = "Minneapolis";
        }else if(cityName == "AUSTIN"){
            cityName = "Austin";
        }else if(cityName == "ATLANTA"){
            cityName = "Atlanta";
        }else if(cityName == "OMAHA"){
            cityName = "Omaha";
        }else if(cityName == "MIAMI"){
            cityName = "Miami";
        }
        //cell.cityImageView.image = UIImage(named: cityName);
        cell.cityLabel.text = city.cityName;
        cell.scoreLabel.text = String(city.score);
        return cell;
    }
    
    func loadResults(){
        
    }
}

class CustomCell: UITableViewCell{
    
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
}
