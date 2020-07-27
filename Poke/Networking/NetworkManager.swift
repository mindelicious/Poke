//
//  NetworkManager.swift
//  Poke
//
//  Created by Matt on 21/07/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    private let pokemonParameters: [String: Int] = [
        "limit": 100
    ]
    
    private let basicUrl: URL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
    
    func getPokemonPage(byURL url: URL?, onResult: @escaping (Result<PokemonsModel, AFError>) -> Void) {
        var urlToCall: URL = basicUrl
        if let url = url {
            urlToCall = url
        }
        
        AF.request(urlToCall, parameters: pokemonParameters).responseDecodable(of: PokemonsModel.self) { response in
            onResult(response.result)
        }
    }
    
    @discardableResult
    func getPokemonDetail(byPokemon: Int, onGetDetail: @escaping (Result<DetailPokemonModel, AFError>) -> Void) -> DataRequest {
        let basicURL = basicUrl.appendingPathComponent("\(byPokemon)")
        return AF.request(basicURL).responseDecodable(of: DetailPokemonModel.self) { response in
            onGetDetail(response.result)
        }
    }
}
