//
//  AppDelegate.swift
//  LivestreamerLauncher
//
//  Created by Jake on 8/28/14.
//  Copyright (c) 2014 Acceptable Ice Development. All rights reserved.
//

import Cocoa
import Foundation

class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet weak var window: NSWindow!;
    @IBOutlet weak var ChannelWindow: NSWindow!;
    @IBOutlet weak var CollectionView: NSCollectionView!;
    
        
    dynamic var GameListing: [Game] = [];
    dynamic var ChannelListing: [Channel] = [];
    
    dynamic var SelectedGameName: String = "";
    
    var SelectedGame: Game = Game(name: "None", image: NSImage());
    
    let clientID = "howolmg1qppcvh2nnq195mvjb3q9y77";
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication!) -> Bool {
        return true;
    }
    
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        refreshGameListing();
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }
    
    @IBAction func onRefreshGameListingTriggered(sender: AnyObject) {
        refreshGameListing();
    }
    
    @IBAction func onRefreshChannelListingTriggered(sender: AnyObject) {
        refreshChannelListing(SelectedGame);
    }
    
    @IBAction func onBackButtonTriggered(sender: AnyObject) {
        window.orderFront(nil);
        window.makeKeyWindow();
        ChannelWindow.orderOut(nil);

    }

    
    func refreshGameListing() {
        GameListing = [];
    
        let urlPath = "https://api.twitch.tv/kraken/games/top?client_id=" + clientID;
        var err: NSError?;
        let rawData:String = NSString.stringWithContentsOfURL(NSURL.URLWithString(urlPath), encoding: NSUTF8StringEncoding, error: &err);
        
        var list: NSDictionary = NSJSONSerialization.JSONObjectWithData(rawData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary;
      
        if let topList: NSArray? = list["top"] as? NSArray {
            for value in topList! {
                if let game = value as? NSDictionary {
                    if let gameData = game["game"] as? NSDictionary {
                        let name: String = gameData["name"] as String
                        println(name);
                        var imgUrl: String = "";
                        if let imgData = gameData["box"] as? NSDictionary {
                            imgUrl = imgData["medium"] as String;
                        }
                        var img: NSImage = NSImage(data: NSData(contentsOfURL: NSURL.URLWithString(imgUrl), options: nil, error: nil));
                        GameListing.append(Game(name: name, image: img));
                    }
                }
            }
        }
    }
    
    func refreshChannelListing(game: Game) {
        ChannelListing = [];
        println("Finding channels for " + game.name);
        let urlPath = "https://api.twitch.tv/kraken/streams?limit=20&offset=0&game=" + game.name.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil) + "&on_site=1?client_id=" + clientID;
        var err: NSError?;
        let rawData:String = NSString.stringWithContentsOfURL(NSURL.URLWithString(urlPath), encoding: NSUTF8StringEncoding, error: &err);
        
        var list: NSDictionary = NSJSONSerialization.JSONObjectWithData(rawData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary;
        
        if let streamList: NSArray? = list["streams"] as? NSArray {
            for value in streamList! {
                if let channelData = value as? NSDictionary {
                    if let channel = channelData["channel"] as? NSDictionary {
                        let displayName = channel["display_name"] as String;
                        var imgUrl: String = "";
                        if let imgData = channelData["preview"] as? NSDictionary {
                            imgUrl = imgData["medium"] as String;
                        }
                        var img: NSImage = NSImage(data: NSData(contentsOfURL: NSURL.URLWithString(imgUrl), options: nil, error: nil));
                        var url: String = channel["url"] as String;
                        ChannelListing.append(Channel(name: displayName, image: img, url: url));
                    }
                }
            }
        }
    }
}

class Game: NSObject {
    var name: String;
    weak var image: NSImage?;
    
    init(name: String, image: NSImage) {
        self.name = name;
        self.image = image;
    }
}

class Channel: NSObject {
    var name: String;
    weak var image: NSImage?;
    var url: String;
    
    init(name: String, image: NSImage, url: String) {
        self.name = name;
        self.image = image;
        self.url = url;
    }
}
