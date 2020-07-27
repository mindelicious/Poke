//
//  DetailViewController.swift
//  Poke
//
//  Created by Matt on 22/07/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Alamofire

class DetailViewController: UIViewController {
    
    lazy var pokemonImageView = makeImageView()
    lazy var pokemonName = makeDetailLabel(backgroundColor: .orange, font: UIFont.boldSystemFont(ofSize: 20))
    lazy var pokemonExp = makeDetailLabel(backgroundColor: .yellow)
    lazy var pokemonHeight = makeDetailLabel(backgroundColor: .orange)
    lazy var pokemonWeight = makeDetailLabel(backgroundColor: .yellow)
    lazy var pokemonAbility = makeDetailLabel(backgroundColor: .orange)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupUI()
    }
    
    // MARK: - Handle Data
    func setaData(pokemonDetail: DetailPokemonModel) {
        
        guard let experience = pokemonDetail.baseExperience,
            let height = pokemonDetail.height,
            let weight = pokemonDetail.weight else { return }
        
        pokemonName.text = pokemonDetail.name?.capitalized
        pokemonExp.text = String(format: "experience".localized(), experience)
        pokemonHeight.text = String(format: "height".localized(), height)
        pokemonWeight.text = String(format: "weight".localized(), weight)
        pokemonAbility.text = String(format: "ability".localized(), showAbility(with: pokemonDetail))

        pokemonImageView.kf.setImage(with: pokemonDetail.sprites.frontDefault, placeholder: nil)
    }
    
    func showAbility(with pokemonAbility: DetailPokemonModel) -> String {
        let tmpArray = pokemonAbility.abilities.compactMap { ability in
            return ability.ability.name
        }
        return tmpArray.joined(separator: "\n").capitalized
    }
    
    func responseAlert() {
        let alert = UIAlertController(title: "somethings_go_wrong".localized(),
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: { [weak self] action in
            self?.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }

}

// MARK: - SetupUI & Constraints
extension DetailViewController {
    
    func setupUI() {
        [pokemonImageView, pokemonName, pokemonExp, pokemonHeight, pokemonWeight, pokemonAbility].forEach { view.addSubview($0) }
     
        pokemonImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(110)
            make.width.equalTo(110)
        }
        
        pokemonName.snp.makeConstraints { make in
            make.top.equalTo(pokemonImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        pokemonExp.snp.makeConstraints { make in
            make.top.equalTo(pokemonName.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        pokemonHeight.snp.makeConstraints { make in
            make.top.equalTo(pokemonExp.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        pokemonWeight.snp.makeConstraints { make in
            make.top.equalTo(pokemonHeight.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        pokemonAbility.snp.makeConstraints { make in
            make.top.equalTo(pokemonWeight.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
        }
    }
    
    func makeImageView() -> UIImageView {
        let pokemonView = UIImageView()
        pokemonView.layer.cornerRadius = 55
        pokemonView.backgroundColor = .white
        pokemonView.contentMode = .scaleAspectFit
        return pokemonView
    }
    
    func makePokemonName(font: UIFont?) -> UILabel {
        let pokemonName = UILabel()
        pokemonName.textAlignment = .center
        pokemonName.font = font
        pokemonName.backgroundColor = .orange
        return pokemonName
    }

    func makeDetailLabel(backgroundColor: UIColor, font: UIFont = UIFont.systemFont(ofSize: 17)) -> UILabel {
        let detailLabel = UILabel()
        detailLabel.textAlignment = .center
        detailLabel.layer.borderWidth = 1
        detailLabel.numberOfLines = 0
        detailLabel.font = font
        detailLabel.backgroundColor = backgroundColor
        return detailLabel
    }

}
