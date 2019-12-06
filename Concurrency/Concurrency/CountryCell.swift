//
//  CountryCell.swift
//  Concurrency
//
//  Created by Oscar Victoria Gonzalez  on 12/6/19.
//  Copyright © 2019 Oscar Victoria Gonzalez . All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {

    var someCountries: Country?
    
    @IBOutlet weak var countryFlagImage: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryCapitalLabel: UILabel!
    @IBOutlet weak var countryPopulationLabel: UILabel!
    

    func configured(for country: Country) {
        countryNameLabel.text = "Country - \(country.name)"
        countryCapitalLabel.text = "Capital - \(country.capital)"
        countryPopulationLabel.text = "Population - \(country.population.description)"
        
       
        }
    }
    

