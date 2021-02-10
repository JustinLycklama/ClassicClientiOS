//
//  ActionableGridView.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2021-02-09.
//

import UIKit

public struct CollectionCellConfig<Type, Cell> {
    let configure: ((Type, Cell) -> Void)?
    let performAction: ((Type) -> Void)?
    let swipeActions: [SwipeActionConfig<Type>]
    
    public init(swipeActions: [SwipeActionConfig<Type>] = [],
                configure: ((Type, Cell) -> Void)? = nil,
                performAction: ((Type) -> Void)?) {
        self.configure = configure
        self.performAction = performAction
        self.swipeActions = swipeActions
    }
}

public class ActionableGridView<T,
                                ItemCell: UICollectionViewCell>: UIView, Loadable, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    public var loadingView: LoadingView?

    private let StandardCellIdentifier = "Cell"
    
    private var collectionView: UICollectionView?
            
    private var items: [T] = []
    
    private var itemConfig: CollectionCellConfig<T, ItemCell>
    
    public init(itemConfig: CollectionCellConfig<T, ItemCell>) {
        self.itemConfig = itemConfig
        super.init(frame: .zero)
        
        setup()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func setItems(items: [T]) {
        self.items = items
        collectionView?.reloadData()
    }
    
    
//    open override func viewDidLoad() {
//        super.viewDidLoad()
    func setup() {
    
        backgroundColor = .clear
        
//        determineCellSize()
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collection = AutoSizedCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView = collection
        
        collection.delegate = self
        collection.dataSource = self
        
        collection.backgroundColor = .clear

        collection.register(ItemCell.self, forCellWithReuseIdentifier: StandardCellIdentifier)
//        collection.register(ItemCell.self, forCellWithReuseIdentifier: StandardCellIdentifier)
        
        
//        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: "Any", withReuseIdentifier: StandardHeaderIdentifier)
        
        addSubview(collection)
        constrainSubviewToBounds(collection)
        
//        collection = collectionView
    }
    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: 0, height: headerHeight)
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return cellSize
//    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
//    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: "Any", withReuseIdentifier: StandardHeaderIdentifier, for: indexPath)
//
//        header.backgroundColor = .green
//
//        return header
//    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandardCellIdentifier, for: indexPath)
        
        if let itemCell = cell as? ItemCell {
            itemConfig.configure?(items[indexPath.row], itemCell)
        }
        
        return cell
    }
}
