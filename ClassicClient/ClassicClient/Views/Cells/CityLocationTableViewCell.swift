//
//  CityLocationTableViewCell.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-23.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

protocol LocationMapSelectionDelegate {
    func presentMapForLocation(location: Location)
}

class CityLocationTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
        
    @IBOutlet var mapButton: UIButton!
    
    var delegate: LocationMapSelectionDelegate?
    var location: Location?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.font = CCStyle.fontWithSize(size: 18)
        addressLabel.font = CCStyle.fontWithSize(size: 14)
        
        mapButton.addTarget(self, action: #selector(mapButtonPress), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setLocation(location: Location) {
        self.location = location
        
        nameLabel.text = location.locationName
        addressLabel.text = location.address
        
    }
    
    @objc func mapButtonPress() {
        if let delegate = delegate,
            let location = location {
            delegate.presentMapForLocation(location: location)
        }
    }
    
}
