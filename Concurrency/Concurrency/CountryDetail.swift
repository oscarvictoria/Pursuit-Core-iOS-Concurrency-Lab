//
//  CountryDetail.swift
//  Concurrency
//
//  Created by Oscar Victoria Gonzalez  on 12/9/19.
//  Copyright © 2019 Oscar Victoria Gonzalez . All rights reserved.
//

import UIKit

class CountryDetail: UIViewController {
    
var detailCountry: Country?
    
@IBOutlet weak var detailCountryFlag: UIImageView!
@IBOutlet weak var detailNameLabel: UILabel!
@IBOutlet weak var detailCapitalLabel: UILabel!
@IBOutlet weak var detailPopulationLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        guard let theCountries = detailCountry else {
            fatalError("error")
        }
        let imageURL = "https://www.countryflags.io/\(theCountries.alpha2Code)/flat/64.png"
        detailNameLabel.text = theCountries.name
        detailCapitalLabel.text = theCountries.capital
        detailPopulationLabel.text = theCountries.population.description
        ImageClient.fetchImage(for: imageURL) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("error \(error)")
            case .success(let image):
                DispatchQueue.main.async {
                    self?.detailCountryFlag.image = image
                }
            }
        }
    }

    

}
