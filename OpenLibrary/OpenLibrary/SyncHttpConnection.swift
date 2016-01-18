//
//  SyncHttpConnection.swift
//  OpenLibrary
//
//  Created by JUAN ANDRÉS CÁRDENAS DIAZ on 16/01/16.
//  Copyright © 2016 JUAN ANDRÉS CÁRDENAS DIAZ. All rights reserved.
//

import UIKit


class SyncHttpConnection {

    
    func sendByGet(stringUrl : String, keyValueParameters: NSDictionary?) -> NSData? {
        
        
        var data : NSData? = nil
        
        if keyValueParameters == nil {
            
            print("Url Request: \(stringUrl)")
            
            let urls = NSURL(string: stringUrl)
            data = NSData(contentsOfURL: urls!)
            
        }
        else{
            
            let urlComponents = NSURLComponents(string: stringUrl)!
            urlComponents.queryItems = []
            
            for (keyParam, valueParam) in keyValueParameters! {
                
                
                let strKeyParam = keyParam as! String
                //print("key: \(strKeyParam)")
                let strValueParam = valueParam as! String
                //print("value: \(strValueParam)")
                
                urlComponents.queryItems!.append(NSURLQueryItem(name: strKeyParam, value: strValueParam))
                
            }
            
            print("Url Request: \(urlComponents.URL!)")
            data = NSData(contentsOfURL: urlComponents.URL!)
            
        }
        
        
        return data
        
    }
    
    
    
    func downloadImage(imageURLString: String) -> (image: UIImage?, success: Bool) {
        guard let url = NSURL(string: imageURLString),
            let data = NSData(contentsOfURL: url),
            let image = UIImage(data: data)
            else {
                
                return (image: nil, success: false)
        }
        
        //print(">>>SyncHttpConnection >>downloadImage() >>Image lenght: \(data.length)")
        
        return (image: image, success: true)
    }
    
}

