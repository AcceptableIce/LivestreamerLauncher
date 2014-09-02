//
//  ChannelListCollectionViewItem.swift
//  LivestreamerLauncher
//
//  Created by Jake on 9/1/14.
//  Copyright (c) 2014 Acceptable Ice Development. All rights reserved.
//

import Cocoa
import Foundation

class ChannelListCollectionViewItem: NSView {
    
    
    override func mouseDown(theEvent: NSEvent!) {
        let collectionView: NSCollectionView = self.superview as NSCollectionView;
        let index = find(collectionView.subviews as Array, self);
        let channel:Channel = collectionView.content[index!] as Channel;
        println(channel.name + " | " + channel.url);
        let task = NSTask();
        task.launchPath = "/usr/local/bin/livestreamer";
        task.arguments = [channel.url, "best"];
        task.launch();
    }
}