//
//  MainViewController.swift
//  Poke
//
//  Created by Matt on 21/07/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var collectionView = makeCollectionView()
    var toggleButton = UIBarButtonItem()
    var isListView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .yellow
        
    }
    
    @objc func butonTapped(sender: UIBarButtonItem) {
        if isListView {
            toggleButton = UIBarButtonItem(image: UIImage(named: "list"), style: .plain, target: self, action: #selector(butonTapped(sender:)))
            isListView = false
        }else {
            toggleButton = UIBarButtonItem(image: UIImage(named: "grid"), style: .plain, target: self, action: #selector(butonTapped(sender:)))
            isListView = true
        }
        navigationItem.setRightBarButton(toggleButton, animated: true)
        collectionView.reloadData()
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedCell
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        if isListView {
            return CGSize(width: width - 8, height: 120)
        } else {
            return CGSize(width: (width - 15)/2, height: (width - 15)/2)
        }
    }
    
}

extension MainViewController {
    
    func setupUI() {
        view.addSubview(collectionView)
        
        toggleButton = UIBarButtonItem(image: UIImage(named: "grid"), style: .plain, target: self, action: #selector(butonTapped(sender:)))
        self.navigationItem.setRightBarButton(toggleButton, animated: true)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: "feedCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .green
        
        return collectionView
    }
}
