//
//  MainTabBarController.swift
//  AppleMusic
//
//  Created by White on 9/21/22.
//


import UIKit
import SwiftUI

protocol MainTabBarControllerDelegate: class {
    func minimizeTrackDetailController()
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?)
}



class MainTabBarController: UITabBarController{
    
    let trackDetailView:TrackDetailView = TrackDetailView.loadFromNib()
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    let searchVC: SearchViewController = SearchViewController.LoadFromStoryboard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setTabBarAppearance()
        
        searchVC.tabBarDelegate = self
        
        var library = Library()
        library.tabBarDelegate = self
        let hostVC = UIHostingController(rootView: library)
        hostVC.tabBarItem.image = UIImage(systemName: "cloud.snow")
        hostVC.tabBarItem.title = "Library"
        SetupTrackDetailView()
       
        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = .tabBarItemLight

        
        viewControllers = [
            
            generateVC(viewController: searchVC, title: "Search", image: UIImage(systemName: "magnifyingglass.circle")),
            hostVC
            
        ]
        
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?)->UIViewController{
        let navigationVC = UINavigationController(rootViewController: viewController)
        
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        viewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }
    
    
    private func SetupTrackDetailView(){
        
         trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        view.insertSubview(trackDetailView, belowSubview: tabBar)
    
            //use autoLayout
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height )
        minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.isActive = true
//        trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    
    
    
    
    private func setTabBarAppearance(){
    let positionOnX: CGFloat = 10
    let positionOnY: CGFloat = 14
    let width = tabBar.bounds.width - positionOnX * 2
    let height = tabBar.bounds.height + positionOnY * 2

        let roundLayer = CAShapeLayer()

        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: positionOnX,
                y: tabBar.bounds.minY - positionOnY,
                width: width,
                height: height),
                cornerRadius: height/2)
        roundLayer.path = bezierPath.cgPath

        tabBar.layer.insertSublayer(roundLayer, at: 0 )

        tabBar.itemWidth = width/4
        tabBar.itemPositioning = .centered

        roundLayer.fillColor = UIColor.mainWhite.cgColor

        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = .tabBarItemLight

        }

        
    }

extension MainTabBarController: MainTabBarControllerDelegate{
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?) {
        
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
         
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 0
            self.trackDetailView.miniTrackView.alpha = 0
            self.trackDetailView.maximizedStackView.alpha = 1
        }, completion: nil)
        
        guard let viewModel = viewModel else {return}
        self.trackDetailView.set(viewModel: viewModel)
    }
    
    
    func minimizeTrackDetailController() {
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height 
        minimizedTopAnchorConstraint.isActive = true
        trackDetailView.reduceTrackImageView()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 1
            self.trackDetailView.miniTrackView.alpha = 1
            self.trackDetailView.maximizedStackView.alpha = 0
        }, completion: nil)
    }
    
}
