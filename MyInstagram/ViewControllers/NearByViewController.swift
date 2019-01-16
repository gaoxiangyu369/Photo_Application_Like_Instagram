//
//  NearByViewController.swift
//  MyInstagram
//
//  Created by Liang Zhang on 2/10/18.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit
import YPImagePicker
import MultipeerConnectivity

class NearByViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var displayTableView: UITableView!
    
    var peerID: MCPeerID!
    var mcSession : MCSession!
    var mcAdvertiseAssistant : MCAdvertiserAssistant!
    
    var selectedItems = [YPMediaItem]()
    
    var sentImageSet = [UIImage]()
    var recImageSet = [UIImage]()
    
    @IBAction func sharing(_ sender: UIBarButtonItem) {
        self.showPicker()
    }
    
    @IBAction func reload(_ sender: UIBarButtonItem) {
        displayTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayTableView.reloadData()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        
        displayTableView.delegate = self
        displayTableView.dataSource = self
        
        self.setupConnection()
        
        let nib = UINib(nibName: "BlueTTableViewCell", bundle: nil)
        displayTableView.register(nib, forCellReuseIdentifier: "BlueTCell")
        
    }
    
    
    @objc func showPicker() {
        var config = YPImagePickerConfiguration()
        
        config.library.mediaType = .photo
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = .library
        config.screens = [.library]
        config.showsCrop = .rectangle(ratio: 1/1.0)
        
        config.library.maxNumberOfItems = 9
        
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                return
            }
            _ = items.map { print("phote \($0)") }
            
            for i in items{
                switch i{
                case .photo(let photo):
                    self.sentImageSet.append(photo.image)
                case .video( _):
                    print("Fatal Error, no video selected!!!")
                }
            }
            picker.dismiss(animated: true, completion: nil)
            self.prepareSendData()
        }
        present(picker, animated: true, completion: nil)
    }
    
    // MCsession functions
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.recImageSet.append(UIImage.init(data: data, scale: 0.5)!)
            print("image received!!!!!!!!!!!!!!!!!!!!!!!")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func setupConnection() {
        if mcSession.connectedPeers.count == 0{
            
            let connectActionSheet = UIAlertController(title: "No connection", message: "You haven't connect to anyone yet", preferredStyle: .alert)
            
            connectActionSheet.addAction(UIAlertAction(title: "Connect", style: .default, handler: {(action: UIAlertAction) in
                
                self.mcAdvertiseAssistant = MCAdvertiserAssistant(serviceType: "doesnt-mater", discoveryInfo: nil, session: self.mcSession)
                self.mcAdvertiseAssistant.start()
                
                let mcBrowser = MCBrowserViewController(serviceType: "doesnt-mater", session: self.mcSession)
                mcBrowser.delegate = self
                self.present(mcBrowser,animated: true, completion: nil)
            }))
            
            connectActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(connectActionSheet,animated: true, completion: nil)
        }
    }
    
    func prepareSendData() {
        
        for image in self.sentImageSet{
            let imageData = UIImageJPEGRepresentation(image, 0.5)
            
            do {
                try self.mcSession.send(imageData!, toPeers: self.mcSession.connectedPeers , with: .reliable)
                
            }catch{
                print("Error sending image data across bluetooth\n")
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recImageSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = displayTableView.dequeueReusableCell(withIdentifier: "BlueTCell") as! BlueTTableViewCell
        let img = recImageSet[indexPath.row]
        
        cell.postImg.image = img
        return cell
    }
    
}
