//
//  AutoSizeTableview.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2021-02-04.
//

import Foundation

import UIKit

class AutoSizedTableView: UITableView {
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override var intrinsicContentSize: CGSize {        
        setNeedsLayout()
        layoutIfNeeded()
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
}
