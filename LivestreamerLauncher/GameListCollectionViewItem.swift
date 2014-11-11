//
//  GameListCollectionView.swift
//  LivestreamerLauncher
//
//  Created by May on 9/1/14.
//  Copyright (c) 2014 Corvimae Development. All rights reserved.
//

import Cocoa
import Foundation

class GameListCollectionViewItem: NSView {
    
    @IBOutlet weak var channelViewWindow: NSWindow!;

    var gameWindowController: NSWindowController = NSWindowController(windowNibName: "GameView");
    override func mouseDown(theEvent: NSEvent!) {
        let collectionView: NSCollectionView = self.superview as NSCollectionView;
        let index = find(collectionView.subviews as Array, self);
        let game:Game = collectionView.content[index!] as Game;
        var appDelegate = NSApplication.sharedApplication().delegate as AppDelegate;
        appDelegate.SelectedGame = game;
        appDelegate.SelectedGameName = game.name;
        
        appDelegate.refreshChannelListing(game);
        
        appDelegate.ChannelWindow.orderFront(nil);
        appDelegate.ChannelWindow.makeKeyWindow();
        appDelegate.window.orderOut(nil);

        println(appDelegate.window);
        
      
        
        
        
    }
}
