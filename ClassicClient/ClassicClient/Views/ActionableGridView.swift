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
                                ItemCell: UICollectionViewCell,
                                ActionCell: UICollectionViewCell>: UIView, Loadable {
    
    public var loadingView: LoadingView?
    
    private let layout = UICollectionViewFlowLayout()

    fileprivate var collectionView: UICollectionView?
    fileprivate let collectionViewDelegate: GridConfig<T, ItemCell, ActionCell>
    
    private var isUsingAutoLayout: Bool
    
    public var canPerformAction = false {
        didSet {
            collectionViewDelegate.canPerformAction = canPerformAction
            collectionView?.reloadData()
        }
    }
    
    public var spacing = Classic.style.topPadding {
        didSet {
            layout.minimumInteritemSpacing = spacing
            layout.minimumLineSpacing = spacing
        }
    }
    
    public init(actionConfig: CollectionCellConfig<Void, ActionCell>,
                itemConfig: CollectionCellConfig<T, ItemCell>,
                numberOfColumns columns: CGFloat) {
        isUsingAutoLayout = false
        collectionViewDelegate = GridColumnsLayoutDelegate(actionConfig: actionConfig,
                                                           itemConfig: itemConfig,
                                                           frame: .zero,
                                                           columns: columns)

        super.init(frame: .zero)
        
        setup()
    }
    
    public init(actionConfig: CollectionCellConfig<Void, ActionCell>,
                itemConfig: CollectionCellConfig<T, ItemCell>,
                itemWidth: CGFloat) {
        isUsingAutoLayout = false
        collectionViewDelegate = GridColumnsLayoutDelegate(actionConfig: actionConfig,
                                                           itemConfig: itemConfig,
                                                           frame: .zero,
                                                           cellWidth: itemWidth)

        super.init(frame: .zero)
        
        setup()
    }
    
    // If no columns or width are specified, the cells will be sized based on their own autolayout
    public init(actionConfig: CollectionCellConfig<Void, ActionCell>,
                itemConfig: CollectionCellConfig<T, ItemCell>) {
        isUsingAutoLayout = true
        collectionViewDelegate = GridAutoLayoutDelegate(actionConfig: actionConfig,
                                                        itemConfig: itemConfig)
        
        super.init(frame: .zero)
        
        setup()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func setItems(items: [T]) {
        collectionViewDelegate.setItems(items: items)
        collectionView?.reloadData()
    }
    
    public func setSelected(index: Int) {
        collectionView?.selectItem(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
    
    func setup() {
    
        backgroundColor = .clear
                        
        if isUsingAutoLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        let collection = AutoSizedCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView = collection
                
        collection.delegate = collectionViewDelegate as? GridDelegate
        collection.dataSource = collectionViewDelegate as? GridDelegate
        
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        
        collectionViewDelegate.registerCollection(collection)
        
        addSubview(collection)
        constrainSubviewToBounds(collection)
        
//        collection = collectionView
    }
        
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if collectionViewDelegate.resizeItems(toFrame: frame) {
            collectionView?.reloadData()
        }
    }
}

private typealias GridDelegate = UICollectionViewDelegateFlowLayout & UICollectionViewDataSource

private class GridConfig<T,
                         ItemCell: UICollectionViewCell,
                         ActionCell: UICollectionViewCell>: NSObject {

    fileprivate let StandardCellIdentifier = "Cell"
    fileprivate let ActionCellIdentifier = "ActionCell"
    
    fileprivate var items = [T]()
    
    fileprivate var actionConfig: CollectionCellConfig<Void, ActionCell>
    fileprivate var itemConfig: CollectionCellConfig<T, ItemCell>
    
    fileprivate var canPerformAction: Bool = false
    
    init(actionConfig: CollectionCellConfig<Void, ActionCell>, itemConfig: CollectionCellConfig<T, ItemCell>) {
        self.actionConfig = actionConfig
        self.itemConfig = itemConfig
    }
    
    fileprivate func setItems(items: [T]) {
        self.items = items
    }
    
    // Recalculate item size, return true if items did resize
    fileprivate func resizeItems(toFrame frame: CGRect) -> Bool { false }
    
    fileprivate func registerCollection(_ collectionView: UICollectionView) {
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: StandardCellIdentifier)
        collectionView.register(ActionCell.self, forCellWithReuseIdentifier: ActionCellIdentifier)
    }
    
    public func item(at indexPath: IndexPath) -> T {
        let index = canPerformAction ? indexPath.row - 1 : indexPath.row
        return items[index]
    }
}

private class GridColumnsLayoutDelegate<T,
                                        ItemCell: UICollectionViewCell,
                                        ActionCell: UICollectionViewCell>: GridConfig<T, ItemCell, ActionCell>, GridDelegate {
    
    private var cellSize: CGSize = .zero
    private let widthDeterminer: CellWidthDeterminer
   
    enum CellWidthDeterminer {
        case numColumns(columns: CGFloat)
        case cellWidth(width: CGFloat)
    }
        
    init(actionConfig: CollectionCellConfig<Void, ActionCell>,
         itemConfig: CollectionCellConfig<T, ItemCell>,
         frame: CGRect, cellWidth: CGFloat) {
        
        widthDeterminer = .cellWidth(width: cellWidth)
        
        super.init(actionConfig: actionConfig, itemConfig: itemConfig)
        
        determineCellSize(fromFrame: frame)
    }
    
    init(actionConfig: CollectionCellConfig<Void, ActionCell>,
         itemConfig: CollectionCellConfig<T, ItemCell>,
         frame: CGRect, columns: CGFloat) {
        
        widthDeterminer = .numColumns(columns: columns)
        
        super.init(actionConfig: actionConfig, itemConfig: itemConfig)
        
        determineCellSize(fromFrame: frame)
    }
    
    private func determineCellSize(fromFrame frame: CGRect) {
        let collectionSize = frame.size
        let margin: CGFloat = 5
        let padding: CGFloat = 4
        
        var height = frame.height - margin * 2
        
        if height < 0 {
            height = 0
        }
        
        switch widthDeterminer {
        case .cellWidth(let width):
            cellSize = CGSize(width: width, height: height)
        case .numColumns(let numColumns):
            let usableWidth: CGFloat = collectionSize.width - (2 * margin) - (padding * (CGFloat(numColumns) - 1))
            
            if (usableWidth <= 0) {
                cellSize = .zero
                return
            }
            
            var cellWidth = usableWidth / CGFloat(numColumns)
            
            if cellWidth < 0 {
                cellWidth = 0
            }
            
            cellSize = CGSize(width: cellWidth, height: height)
        }
    }
   
    override func resizeItems(toFrame frame: CGRect) -> Bool {
        determineCellSize(fromFrame: frame)
        return true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return canPerformAction ? items.count + 1 : items.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if canPerformAction && indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActionCellIdentifier, for: indexPath)
            
            if let actionCell = cell as? ActionCell {
                actionConfig.configure?((), actionCell)
            }
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandardCellIdentifier, for: indexPath)
        
        if let itemCell = cell as? ItemCell {
            itemConfig.configure?(item(at: indexPath), itemCell)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if canPerformAction && indexPath.row == 0 {
            actionConfig.performAction?(())
            return
        }
                
        itemConfig.performAction?(item(at: indexPath))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}

private class GridAutoLayoutDelegate<T,
                                     ItemCell: UICollectionViewCell,
                                     ActionCell: UICollectionViewCell>: GridConfig<T, ItemCell, ActionCell>, GridDelegate {
        
//    public var canPerformAction = false {
//
//    }
//
//    public func isPerformActionIndex(_ indexPath: IndexPath) -> Bool {
//        return canPerformAction && isPerformActionSection(indexPath.section)
//    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return canPerformAction ? items.count + 1 : items.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if canPerformAction && indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActionCellIdentifier, for: indexPath)
            
            if let actionCell = cell as? ActionCell {
                actionConfig.configure?((), actionCell)
            }
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StandardCellIdentifier, for: indexPath)
        
        if let itemCell = cell as? ItemCell {
            itemConfig.configure?(item(at: indexPath), itemCell)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if canPerformAction && indexPath.row == 0 {
            actionConfig.performAction?(())
            return
        }
                
        itemConfig.performAction?(item(at: indexPath))
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return  UIEdgeInsets( top: 5,  left: 14, bottom: 5,  right: 14)
//    }
//
}
