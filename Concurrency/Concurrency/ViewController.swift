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
@IBOutlet weak var searchBar: UISearchBar!
    
    var theCountries = [Country]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    var searchQuery = "" {
        didSet {
            CountryAPIClient.getCountries { (result) in
                    switch result {
                    case .failure(let error):
                        print("failure: \(error)")
                    case .success(let countries):
                        self.theCountries = countries.filter{$0.name.lowercased().contains(self.searchQuery.lowercased())}
                    }
                }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
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

    func filterCountry(for searchText: String) {
        guard !searchText.isEmpty else { return }
       CountryAPIClient.getCountries { (result) in
           switch result {
           case .failure(let error):
               print("failure: \(error)")
           case .success(let countries):
            self.theCountries = countries.filter{$0.name.lowercased().contains(searchText.lowercased())}
           }
       }
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

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else { return }
        filterCountry(for: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            loadCountries()
            return
        }
        searchQuery = searchText
    }
}
