//
//  HorizontalItemPreviewViewController.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-08-11.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

open class HorizontalItemPreviewViewController: UIViewController {
    
    private let transition = WreathedDetailTransition()
    
//    let layout: UICollectionViewLayout
    public let collectionArea = UIView()
//    public var collectionView: UICollectionView?
    
    public init() {

//        layout = HorizontalItemLayout()



        super.init(nibName: nil, bundle: nil)

    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        print("hello!")
        
        navigationController?.delegate = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
            
        let cView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)

        cView.backgroundView = nil
        cView.backgroundColor = .clear

        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
//        cView.contentSize = CGSize(width: 1000, height: 200)
        
        collectionArea.translatesAutoresizingMaskIntoConstraints = false
        
        collectionArea.addSubview(cView)
        collectionArea.constrainSubviewToBounds(cView)
                
        self.view.addSubview(collectionArea)
        view.constrainSubviewToBounds(cView)

        let views = ["cArea" : collectionArea]
        
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[cArea]-(0)-|", options: .alignAllCenterX, metrics: nil, views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=0)-[cArea(200)]-(0)-|", options: .alignAllCenterX, metrics: nil, views: views)
        
        self.view.addConstraints(horizontal)
        self.view.addConstraints(vertical)
        
        let xib = UINib(nibName: "HorizontalItemPreviewCell", bundle: Bundle(for: HorizontalItemPreviewCell.self))

        cView.register(xib, forCellWithReuseIdentifier: "cell")

        cView.dataSource = self
        cView.delegate = self
        
        cView.reloadData()

//        cView.invalidateIntrinsicContentSize()

        
//        collectionView = cView
        
    }
}

extension HorizontalItemPreviewViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
        
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = .white
        
        return cell
    }
}

extension HorizontalItemPreviewViewController: UICollectionViewDelegate {
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        transition.fromView = collectionView.cellForItem(at: indexPath)
        transition.viewContainer = collectionView
    }
}

extension HorizontalItemPreviewViewController: UICollectionViewDelegateFlowLayout {
            
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

    
    /*
     
     
     @available(iOS 6.0, *)
     optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize

     @available(iOS 6.0, *)
     optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets

     @available(iOS 6.0, *)
     optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat

     @available(iOS 6.0, *)
     optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat

     @available(iOS 6.0, *)
     optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize

     @available(iOS 6.0, *)
     optional func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
     */
}

public class HorizontalItemLayout: UICollectionViewLayout {
    
    
    // The collection view calls -prepareLayout once at its first layout as the first message to the layout instance.
    // The collection view calls -prepareLayout again after layout is invalidated and before requerying the layout information.
    // Subclasses should always call super if they override.
    public override func prepare() {
        
    }

    
    // UICollectionView calls these four methods to determine the layout information.
    // Implement -layoutAttributesForElementsInRect: to return layout attributes for for supplementary or decoration views, or to perform layout in an as-needed-on-screen fashion.
    // Additionally, all layout subclasses should implement -layoutAttributesForItemAtIndexPath: to return layout attributes instances on demand for specific index paths.
    // If the layout supports any supplementary or decoration view types, it should also implement the respective atIndexPath: methods for those types.
//    open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? // return an array layout attributes instances for all the views in the given rect

//    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        return []
//    }
//
//    open func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
//
//    open func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?

    
//    open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool // return YES to cause the collection view to requery the layout for geometry information
//
//    @available(iOS 7.0, *)
//    open func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext

    
//    @available(iOS 8.0, *)
//    open func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool
//
//    @available(iOS 8.0, *)
//    open func invalidationContext(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext

    
//    open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint // return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior
//
//    @available(iOS 7.0, *)
//    open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint // a layout can return the content offset to be applied during transition or update animations

    
    public override var collectionViewContentSize: CGSize { return CGSize(width: 250, height: 250) } // Subclasses must override this method and use it to return the width and height of the collection view’s content. These values represent the width and height of all the content, not just the content that is currently visible. The collection view uses this information to configure its own content size to facilitate scrolling.

    
//    open var developmentLayoutDirection: UIUserInterfaceLayoutDirection { get } // Default implementation returns the layout direction of the main bundle's development region; FlowLayout returns leftToRight. Subclasses may override this to specify the implementation-time layout direction of the layout.
//
//    open var flipsHorizontallyInOppositeLayoutDirection: Bool { get } // Base implementation returns false. If your subclass’s implementation overrides this property to return true, a UICollectionView showing this layout will ensure its bounds.origin is always found at the leading edge, flipping its coordinate system horizontally if necessary.
}



extension HorizontalItemPreviewViewController: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = true
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning {
        
        transition.presenting = (operation != .pop)
        return transition
    }
    
    
//    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//
//        return transition
//    }

    
//    func navigationController(
//        _ navigationController: UINavigationController,
//        animationControllerFor operation: UINavigationControllerOperation,
//        from fromVC: UIViewController,
//        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//
//        simpleOver.popStyle = (operation == .pop)
//        return simpleOver
//    }
}
