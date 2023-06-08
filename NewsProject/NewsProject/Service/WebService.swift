//
//  WebService.swift
//  NewsProject
//
//  Created by Zehra Coşkun on 23.05.2023.
//

import Foundation

class WebService {
    
    func newsDownload (url: URL, completion : @escaping ([News]?) -> () ) {
        URLSession.shared.dataTask(with: url) { Data, URLResponse, Error in
            if let Error = Error {
                print(Error.localizedDescription)
                completion(nil)
            } else if let Data = Data {
                let newsArr = try? JSONDecoder().decode([News].self, from: Data)
                if let newsArr = newsArr {
                    completion(newsArr)
                }
            }
        }.resume()
    }
}
