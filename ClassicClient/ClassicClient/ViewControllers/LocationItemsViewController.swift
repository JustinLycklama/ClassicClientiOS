//
//  LocationItemsViewController.swift
//  ClassicClient
//
//  Created by Justin Lycklama on 2020-03-19.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import UIKit

class LocationItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ItemUpdateDelegate, SignatureDelegate {

    struct Constants {
        static let DefaultCell = "defaultCell"
    }
    
    private let transition = VHPresentFromViewTransition()
    
    let tableview = UITableView.init(frame: .zero, style: .plain)
    let loadingView = LoadingView()
    
    let location: Location
    
    var items: [Item]?
    
    init(forLocation location: Location) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Order Items"
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.DefaultCell)
                    
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableview)
        self.view.constrainSubviewToBounds(tableview)
        
        tableview.reloadData()
        
        let barButton = UIBarButtonItem(title: "Sign", style: .plain, target: self, action: #selector(sign))
        navigationItem.setRightBarButton(barButton, animated: false)
        
        self.addChild(loadingView)
        self.view.addSubview(loadingView.view)
        self.view.constrainSubviewToBounds(loadingView.view)
        self.view.bringSubviewToFront(loadingView.view)
        
        loadingView.setLoading(true)
        ItemViewModel.sharedInstance.getItems(forLocationId: location.id) { [weak self] (result: Result<Item>) in
            self?.loadingView.setLoading(false)
            switch result {
            case .success(let items):
                self?.items = items
                break
            case .error(let err):
                self?.loadingView.setError(error: err)
                break
            }
            
            self?.tableview.reloadData()
        }
    }
    
    @objc func sign() {
        let signatureVC = SignatureViewController()
        signatureVC.modalPresentationStyle = .fullScreen
        signatureVC.delegate = self
        
        navigationController?.present(signatureVC, animated: true, completion: nil)
    }
    
    // MARK: Tableview Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.DefaultCell, for: indexPath) as! ItemTableViewCell
        
        let item = items![indexPath.row]
        cell.setItem(item: item)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items![indexPath.row]
        let editorVC = ItemQuantityViewController(withItem: item)
                    
        editorVC.delegate = self
        
//        navigationController?.pushViewController(editorVC, animated: true)
        
        let navCont = UINavigationController(rootViewController: editorVC)
        navCont.modalPresentationStyle = .overCurrentContext
        navCont.transitioningDelegate = self
        
        editorVC.navigationItem.setLeftBarButton(UIBarButtonItem.init(title: "Close",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(LocationItemsViewController.cancel)),
                                           animated: true)
        
        transition.fromView = self.tableview.cellForRow(at: indexPath)
        transition.viewContainer = self.tableview
        
        self.navigationController?.present(navCont, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: ItemUpdateDelegate
    func itemUpdated(item: Item) {

        navigationController?.popViewController(animated: true)
        
        guard let indexOfItem = self.items?.firstIndex(of: item),
        let coordinator = transitionCoordinator else {
            return
        }
        
        let indexPath = IndexPath(row: indexOfItem, section: 0)
        tableview.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
        
        coordinator.animate(alongsideTransition: nil) { [weak self] _ in
            guard let self = self else {
               return
            }

            self.items?[indexOfItem] = item

            self.tableview.reloadRows(at: [indexPath], with: .fade)
            self.tableview.deselectRow(at: indexPath, animated: true)
            
        }
    }
    
    // MARK: SignatureDelegate
    func save() {
        // Saving doesn't do anything yet
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancel() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}


extension LocationItemsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
