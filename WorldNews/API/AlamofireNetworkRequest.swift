//
//  AlamofireNetworkRequest.swift
//  WorldNews
//
//  Created by Alex Mosunov on 19.01.2022.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    static func sendRequest(url: String, completion: @escaping (_ result: Result<[ArticleModel], Error>)->()) {
            
            guard let url = URL(string: url) else { return }
            AF.request(url, method: .get).validate().responseJSON { (response) in
                
                switch response.result {
                    
                case .success(let value):
                    let articlesArray = ArticleModel.getArray(from: value) ?? []
                    completion(.success(articlesArray))
             
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
        }
}
