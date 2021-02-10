//
//  AutoSizeCollectionView.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2021-02-09.
//

import Foundation

class AutoSizedCollectionView: UICollectionView {
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
