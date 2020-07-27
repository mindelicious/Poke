//
//  PokemonsViewController.swift
//  Poke
//
//  Created by Matt on 21/07/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit
import Alamofire

class PokemonsViewController: UIViewController {
    
    private lazy var collectionView = makeCollectionView()
    private lazy var containerView = makeContainerView()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    private var toggleButton = UIBarButtonItem()
    private var isListView = true
    private var pokemonsList: [Pokemon] = []
    private var pullControl = UIRefreshControl()
    private var nextPage: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        refresh()
    }
    
    // MARK: - Handle List & Grid View
    @objc func butonTapped(sender: UIBarButtonItem) {
        isListView = !isListView
        toggleButton.image = isListView ? UIImage(named: Constants.grid) : UIImage(named: Constants.list)
        
        navigationItem.setRightBarButton(toggleButton, animated: true)
        collectionView.reloadData()
    }
    
    // MARK: - Networking
    func getPokemons() {
        NetworkManager.shared.getPokemonPage(byURL: nil) { [weak self] response in
            self?.endRefreshingAfterDelay()
            switch response {
            case .success(let pokemonsModel):
                self?.pokemonsList = pokemonsModel.pokemonsList
                self?.nextPage = pokemonsModel.next
            case .failure(_):
                self?.responseAlert()
            }
            
            self?.collectionView.reloadData()
        }
    }
    
    private func endRefreshingAfterDelay() {
        guard pullControl.isRefreshing else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            self?.pullControl.endRefreshing()
        }
    }
    
    func responseAlert() {
        let alert = UIAlertController(title: "somethings_go_wrong".localized(),
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "reload_data".localized(), style: .default, handler: { [weak self] action in
            self?.getPokemons()
        }))
        self.present(alert, animated: true)
    }
    
    // MARK: - Handle refreshing
    func refresh() {
        pullControl.attributedTitle = NSAttributedString(string: "refresh".localized())
        pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
        collectionView.refreshControl = pullControl
        collectionView.addSubview(pullControl)
    }
    
    @objc private func refreshListData(_ sender: Any) {
        getPokemons()
    }
    
    // MARK: - Handle Loading Animation
    func showLoadingAnimation(show: Bool) {
        if show {
            containerView.isHidden = false
            containerView.alpha = 0.8
            activityIndicator.startAnimating()
        } else {
            containerView.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Prepare detaiVC data
    func getPokemonDetail(id: Int) {
        showLoadingAnimation(show: true)
        let pokemonFetched: (Result<DetailPokemonModel, AFError>) -> Void = { [weak self] result in
            self?.showLoadingAnimation(show: false)
            self?.gotPokemonResponse(result: result)
        }
        NetworkManager.shared.getPokemonDetail(byPokemon: id, onGetDetail: pokemonFetched)
    }
    
    func gotPokemonResponse(result: Result<DetailPokemonModel, AFError>) {
        let detailVC = DetailViewController()
        switch result {
        case .success(let detailPokemon):
            detailVC.setaData(pokemonDetail: detailPokemon)
            navigationController?.present(detailVC, animated: true, completion: nil)
        case .failure(_):
            detailVC.responseAlert()
        }
    }
    
}

// MARK: - DataSource & Delegate
extension PokemonsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.pokemonCell, for: indexPath) as! PokemonCell
        let pokemons = pokemonsList[indexPath.row]
        cell.setPokemonName(pokemon: pokemons)
        cell.setPokemonPhoto(id: indexPath.row + 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getPokemonDetail(id: indexPath.row + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        if isListView {
            return CGSize(width: width - 10, height: 120)
        } else {
            let elementWidth = (width - 15)/2
            return CGSize(width: elementWidth, height: elementWidth)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contenHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contenHeight - height {
            getNextPage()
        }
    }
    
    private func getNextPage() {
        guard let nextPage = nextPage else { return }
        
        showLoadingAnimation(show: true)
        NetworkManager.shared.getPokemonPage(byURL: nextPage, onResult: { [weak self] response in
            self?.showLoadingAnimation(show: false)
            switch response {
            case .success(let pokeModel):
                self?.nextPage = pokeModel.next
                self?.pokemonsList.append(contentsOf: pokeModel.pokemonsList)
                self?.collectionView.reloadData()
            case .failure(_):
                self?.nextPageAlert()
            }
        })
    }
    
    func nextPageAlert() {
        let alert = UIAlertController(title: "somethings_go_wrong".localized(),
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}

// MARK: - SetupUI & Constraints
extension PokemonsViewController {
    
    func setupUI() {
        [collectionView, containerView].forEach { view.addSubview($0) }
        
        toggleButton = UIBarButtonItem(image: UIImage(named: Constants.grid), style: .plain, target: self, action: #selector(butonTapped(sender:)))
        self.navigationItem.setRightBarButton(toggleButton, animated: true)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        getPokemons()
        collectionView.reloadData()
    }
    
    func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: Constants.pokemonCell)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        return collectionView
    }
    
    func makeContainerView() -> UIView {
        let containerView = UIView()
        containerView.addSubview(activityIndicator)
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        return containerView
    }
}
