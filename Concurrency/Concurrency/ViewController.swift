//
//  ViewController.swift
//  Concurrency
//
//  Created by Oscar Victoria Gonzalez  on 12/6/19.
//  Copyright © 2019 Oscar Victoria Gonzalez . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var theCountries = [Country]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadCountries()
    }
    
    func loadCountries() {
        CountryAPIClient.getCountries { (result) in
            switch result {
            case .failure(let error):
                print("failure: \(error)")
            case .success(let countries):
                self.theCountries = countries
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let countryDVC = segue.destination as? CountryDetail,
            let indexPath = tableView.indexPathForSelectedRow else {
                fatalError("error")
        }
        let someCountry = theCountries[indexPath.row]
        countryDVC.detailCountry = someCountry
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        theCountries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as? CountryCell else {
            fatalError("error")
        }
        
        let country = theCountries[indexPath.row]
        cell.configured(for: country)
        return cell
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 190
    }
}
