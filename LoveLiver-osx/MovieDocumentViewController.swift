//
//  MovieDocumentViewController.swift
//  LoveLiver
//
//  Created by BAN Jun on 2016/02/09.
//  Copyright © 2016 mzp. All rights reserved.
//

import Cocoa
import AVFoundation
import AVKit
import NorthLayout
import Ikemen


class MovieDocumentViewController: NSViewController {
    fileprivate let movieURL: URL
    fileprivate let player: AVPlayer
    fileprivate let playerItem: AVPlayerItem
    var createLivePhotoAction: ((_ customPoster: NSImage?) -> Void)?

    fileprivate let playerView: AVPlayerView = AVPlayerView() ※ { v in
        v.controlsStyle = .floating
        v.showsFrameSteppingButtons = true
    }
    fileprivate lazy var posterFrameButton: NSButton = NSButton() ※ { b in
        b.title = "Live Photo With This Frame"
        b.setButtonType(.momentaryLight)
        b.bezelStyle = .rounded
        b.target = self
        b.action = #selector(self.createLivePhotoSandbox)
    }
    
    fileprivate lazy var customPosterButton: NSButton = NSButton() ※ { b in
        b.title = "Select custom poster"
        b.setButtonType(.momentaryLight)
        b.bezelStyle = .rounded
        b.target = self
        b.action = #selector(selectCustomPoster)
    }

    init!(movieURL: URL, playerItem: AVPlayerItem, player: AVPlayer) {
        self.movieURL = movieURL
        self.playerItem = playerItem
        self.player = player
        playerView.player = player
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: 500, height: 600))

        let autolayout = view.northLayoutFormat(["p": 16], [
            "player": playerView,
            "posterButton": posterFrameButton,
            "customPosterButton": customPosterButton
            ])
        autolayout("H:|[player]|")
        autolayout("H:|-p-[posterButton]-p-|")
        autolayout("H:|-p-[customPosterButton]-p-|")
        autolayout("V:|[player]-p-[posterButton]-p-[customPosterButton]-p-|")
    }

    func movieDidLoad(_ videoSize: CGSize) {
        self.playerView.addConstraint(NSLayoutConstraint(
            item: self.playerView, attribute: .width, relatedBy: .equal,
            toItem: self.playerView, attribute: .height, multiplier: videoSize.width / videoSize.height, constant: 0))
    }

    @objc fileprivate func createLivePhotoSandbox() {
        player.pause()
        createLivePhotoAction?(nil)
    }
    
    @objc fileprivate func selectCustomPoster() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["jpg", "png", "tiff"]
        panel.begin { [unowned self] response in
            if let url = panel.url,
                let selectedImg = NSImage(contentsOf: url) {
                self.player.pause()
                self.createLivePhotoAction?(selectedImg)

            }
        }
    }
}
