//
//  GameListingConnection.swift
//  LivestreamerLauncher
//
//  Created by Jake on 8/28/14.
//  Copyright (c) 2014 Acceptable Ice Development. All rights reserved.
//

import Foundation

class TwitchAPIConnection: NSURLConnectionDataDelegate {
    static var Data;
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        self.data.appendData(data);
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var err:NSError;
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary;
        updateGameList(jsonResult);
    }
    
    func updateGameList(list: NSDictionary) {
        println("Updating list");
        // this is so trash
        if let topList: NSArray? = list["top"] as? NSArray {
            for value in topList! {
                if let game = value as? NSDictionary {
                    if let gameData = game["game"] as? NSDictionary {
                        let name: String = gameData["name"] as String
                        println(name);
                        GameList.addObject(Game(name: name));
                    }
                }
            }
        }
        println(GameList.count);
    }
    
}