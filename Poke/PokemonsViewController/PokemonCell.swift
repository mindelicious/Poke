//
//  PokemonCell.swift
//  Poke
//
//  Created by Matt on 21/07/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Alamofire

class PokemonCell: UICollectionViewCell {
    
    lazy var cellView = makeCellView()
    lazy var pokemonName = makePokemonName()
    lazy var pokemonImageView = makePokemonImageView()

    var tempRequest: DataRequest?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handle Data
    func setPokemonName(pokemon: Pokemon) {
        pokemonName.text = pokemon.name?.capitalized
    }
    
    // MARK: - Networking
    func setPokemonPhoto(id: Int) {
        tempRequest = NetworkManager.shared.getPokemonDetail(byPokemon: id, onGetDetail: { [weak self] response in
            switch response {
            case .success(let pokemonPhoto):
                self?.pokemonImageView.kf.setImage(with: pokemonPhoto.sprites.frontDefault, placeholder: UIImage(named: "placeholder"))
            case .failure(_):
                self?.pokemonImageView.image = UIImage(named: "placeholder")
            }
        })
    }
    
    // MARK: - Helper Function
    override func prepareForReuse() {
        super.prepareForReuse()
        pokemonImageView.image = nil
        pokemonName.text = ""
        pokemonImageView.kf.cancelDownloadTask()
        tempRequest?.cancel()
        tempRequest = nil
    }
    
}

// MARK: - SetupUI & Constraints
extension PokemonCell {
    
    func setupUI() {
        contentView.addSubview(cellView)
        
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pokemonName.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(34)
        }
        
        pokemonImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(pokemonName.snp.top)
        }
        
    }
    
    func makeCellView() -> UIView {
        let cellView = UIView()
        cellView.backgroundColor = .yellow
        cellView.layer.borderWidth = 1
        [pokemonImageView, pokemonName].forEach { cellView.addSubview($0) }
        return cellView
    }
    
    func makePokemonName() -> UILabel {
        let titleFeed = UILabel()
        titleFeed.font = UIFont.boldSystemFont(ofSize: 18.0)
        titleFeed.textAlignment = .center
        titleFeed.backgroundColor = .orange
        return titleFeed
    }
    
    func makePokemonImageView() -> UIImageView {
        let pokemonImageView = UIImageView()
        pokemonImageView.contentMode = .scaleAspectFit
        return pokemonImageView
    }
}
