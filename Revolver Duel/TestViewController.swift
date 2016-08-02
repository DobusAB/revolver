import MultipeerConnectivity
import UIKit


class TestViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID!
    
    @IBOutlet var chatView: UITextView!
    @IBOutlet var messageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        print( UIDevice.currentDevice().name )
        //self.session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .Required)
        self.session = MCSession(peer: self.peerID)
        self.session.delegate = self
        
        // create the browser viewcontroller with a unique service name
        self.browser = MCBrowserViewController(serviceType: "LCOC-Chat", session: self.session)
        self.browser.delegate = self
        
        // tell the assistant to start advertising our fabulous chat
        self.assistant = MCAdvertiserAssistant(serviceType:"LCOC-Chat", discoveryInfo:nil, session:self.session)
        self.assistant.start()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showBrowser(sender: UIButton) {
        self.presentViewController(self.browser, animated: true, completion: nil)
    }
    
    @IBAction func sendChat(sender: UIButton) {
        if self.session.connectedPeers.count > 0 {
            if let msg = self.messageField.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                // 3
                do {
                    try self.session.sendData(msg, toPeers: self.session.connectedPeers, withMode: MCSessionSendDataMode.Unreliable)
                } catch let error as NSError {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    presentViewController(ac, animated: true, completion: nil)
                }
            }
        }
        //-----------------this might ne3ed to be UNCOMMENTED!!!
        //self.updateChat(self.messageField.text!, fromPeer: self.peerID)
        self.messageField.text = ""
    }
    
    func updateChat(text : String, fromPeer peerID: MCPeerID) {
        // Appends some text to the chat view
        print("Incoming msg: \(text)")
        // If this peer ID is the local device's peer ID, then show the name
        // as "Me"
        var name : String
        switch peerID {
        case self.peerID:
            name = "Me"
        default:
            name = peerID.displayName
        }
        // Add the name to the message and display it
        let message = "\(name): \(text)\n"
        self.chatView.text = self.chatView.text + message
    }
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func browserViewController(browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
        return true
    }
    //---------------------------------------Session
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        // Called when a peer sends an NSData to us
        
        // This needs to run on the main queue
        dispatch_async(dispatch_get_main_queue()) {
            print("Incoming data:::")
            //let msg = NSString(data: data, encoding: NSUTF8StringEncoding)
            let msg = String(data: data, encoding: NSUTF8StringEncoding)!
            
            self.updateChat(msg, fromPeer: peerID)
        }
    }
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        switch state {
        case MCSessionState.Connected:
            print("Connected: \(peerID.displayName)")
            
        case MCSessionState.Connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.NotConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    // The following methods do nothing, but the MCSessionDelegate protocol
    // requires that we implement them.
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
    }
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        
    }
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
}
}