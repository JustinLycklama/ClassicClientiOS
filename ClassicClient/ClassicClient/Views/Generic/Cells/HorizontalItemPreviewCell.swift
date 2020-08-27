//
//  HorizontalItemPreviewCell.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-08-11.
//

import UIKit

public class HorizontalItemPreviewCell: UICollectionViewCell {

    @IBOutlet var roundedBackground: UIView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        roundedBackground.layer.cornerRadius = WreathedDetailView.CornerRaduis
        
        
    }

}
