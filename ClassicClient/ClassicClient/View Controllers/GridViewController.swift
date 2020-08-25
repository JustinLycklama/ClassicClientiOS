//
//  GridViewController.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-08-24.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

open class GridViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    private let StandardCellIdentifier = "Cell"
    private let StandardHeaderIdentifier = "Header"

    
    private let numColumns = 2
    
    private let padding: CGFloat = 20
    private let margin: CGFloat = 15
    
    public var headerHeight = 25
    
    private var collection: UICollectionView?
    
    private var cellSize: CGSize = .zero
        
    open override func viewDidLoad() {
        super.viewDidLoad()

        
        determineCellSize()
        
        
        let layout = UICollectionViewFlowLayout()
        
    
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
                
        collectionView.backgroundColor = .red
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: StandardCellIdentifier)
        
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: "?", withReuseIdentifier: StandardHeaderIdentifier)
        
        view.addSubview(collectionView)
        view.constrainSubviewToBounds(collectionView)
        
        collection =  collectionView
    }
    
    private func determineCellSize() {        
        let collectionSize = view.frame.size
        let usableWidth: CGFloat = collectionSize.width - (2 * margin) - (padding * (CGFloat(numColumns) - 1))
        
        if (usableWidth <= 0) {
            cellSize = .zero
            return
        }
        
        let cellWidth = usableWidth / CGFloat(numColumns)
        
        cellSize = CGSize(width: cellWidth, height: cellWidth)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        determineCellSize()
        
        collection?.reloadData()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: headerHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: "?", withReuseIdentifier: StandardHeaderIdentifier, for: indexPath)
        
        header.backgroundColor = .green
        
        return header
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandardCellIdentifier, for: indexPath)
        
        cell.backgroundColor = .blue
        
        return cell
    }
}
