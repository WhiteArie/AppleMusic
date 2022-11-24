//
//  NetworkService.swift
//  AppleMusic
//
//  Created by White on 9/25/22.
//

import UIKit
import Alamofire

class NetworkService {
    
    func FetchTracks(searchText: String, completion: @escaping (SearchResponse?)->Void){
        let url = "https://itunes.apple.com/search"
        let parameters = ["term":"\(searchText)",
                          "limit":"30",
                          "media":"music"]
        
        Alamofire.AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default , headers:nil).responseData { (dataResponse) in
            if let error = dataResponse.error{
                print("error received requsting data:\(error.localizedDescription)")
                completion(nil)
                return
            }
           
            
            guard let data = dataResponse.data else{return}
            let decoder = JSONDecoder()
            
            do{
                let objects = try decoder.decode(SearchResponse.self, from: data)
                print("objects: ",objects)
                 completion(objects)
                
            }catch let jsonError  {
                print("failed to decode data",jsonError)
                completion(nil)
            }
            
           
        }
    }
    
}
