//
//  SelfSizeTableView.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2024-02-12.
//  Copyright © 2024 Justin Lycklama. All rights reserved.
//

import UIKit

open class SelfSizedTableView: UITableView {
    
    var onContentSizeUpdate: ((CGSize) -> Void)?
    
    open override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
            onContentSizeUpdate?(contentSize)
        }
    }

    open override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }

    open override var intrinsicContentSize: CGSize {
        setNeedsLayout()
        layoutIfNeeded()
        return CGSize(width: contentSize.width, height: contentSize.height)
    }
}
