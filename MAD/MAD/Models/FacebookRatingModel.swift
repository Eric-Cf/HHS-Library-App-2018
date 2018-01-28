//
//  FacebookRatingModel.swift
//  MAD
//
//  Created by David McAllister on 1/27/18.
//  Copyright © 2018 Eric C. All rights reserved.
//

import Foundation

class FacebookReviewModel
{
    var bookModel: BookModel
    var userID: String
    var score: Double
    var userName: String
    var userImage: UIImage
    
    init(bookModel: BookModel, userID: String, score: Double)
    {
        self.bookModel = bookModel
        self.userID = userID
        self.score = score
        userName = ""
        userImage = #imageLiteral(resourceName: "loadingBacksplash")
        userName = self.getName(id: userID)
        updatePicture()
    }
    
    func getName(id: String) -> String {
        
        //var titleAsNum = Int(id)
        var name: String = ""
            
        
            if let token = FBSDKAccessToken.current()
            {
                print("Token")
                //print(token)
                print(token.tokenString)
                
                let params = ["fields": "name"]
                FBSDKGraphRequest(graphPath: id, parameters: params).start { (connection, result, error) -> Void in
                    //print(result)
                    
                    if let result = result as? [String:Any]
                    {
                        if let dataDict = result["name"] as? String
                        {
                            //print("Name: " + dataDict)
                            name = dataDict
                        }
                    }
                    
                    
                }
            }
        return name
    }
    
    func updatePicture()
    {
        if let url = URL(string: "https://graph.facebook.com/" + userID + "/picture?type=large") {
            
            self.downloadCoverImage(url: url)
            
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadCoverImage(url: URL) {
        //print("Download Started")
        
        var found: Bool = false;
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            //print(response?.suggestedFilename ?? url.lastPathComponent)
            //print("Download Finished")
            DispatchQueue.main.async() {
                let temp: UIImage? = UIImage(data: data)
                if(temp != nil && Double((temp?.size.height)!)>20.0)
                {
                    
                    self.userImage = temp!
                    found = true;
                }
                else
                {
                    
                }
                //print(String(describing: temp?.size.height))
                
            }
        }
        if(found == false)
        {
            //self.coverImageView.image = #imageLiteral(resourceName: "loadingBacksplash")
        }
    }
    
    
    
    
    
    
    
    
    
}
