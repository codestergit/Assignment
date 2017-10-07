
//
//  File.swift
//  DocTalk
//
//  Created by Wasan, Sahil on 10/7/17.
//  Copyright © 2017 Wasan, Sahil. All rights reserved.
//

import UIKit

class NetworkService {
    static func getResults(name: String, completion: @escaping (_ names: [String]) -> Void) {
        guard let url = URL(string:"https://api.github.com/search/users?q=\(name)+in:fullname&sort=followers") else {
            return
        }
        var request = URLRequest(url:url)
        request.addValue("application/vnd.github.v3.text-match+json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            do{
                guard let data = data, let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else { return }
                var results: [String] = []
                if let items = json["items"] as? [[String: Any]] {
                    for item in items {
                        if let login = item["login"] as? String {
                           results.append(login)
                        }
                    }
                    print(results)
                    completion(results)
                }
            } catch {
                print("Error Occured -> \(error)")
            }
        })
        task.resume()
    }
}

