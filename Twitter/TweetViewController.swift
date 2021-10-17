//
//  TweetViewController.swift
//  Twitter
//
//  Created by Yaowei on 10/10/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetViewController: UIViewController {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tweetTextView.becomeFirstResponder()
        
        self.setProfile()
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func tweet(_ sender: Any) {
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { Error in
                print("Error post: \(Error)")
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            // TODO: alert the user about empty tweet
            let alert = UIAlertController(title: "Alert", message: "Tweet is empty", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
            
        }
    }
    
    func setProfile() {
        TwitterAPICaller.client?.getProfile(success: { (info: NSDictionary) in
            let UrlString = (info["profile_image_url_https"] as! String).replacingOccurrences(of: "normal", with: "bigger")
            let profileURL = URL(string: UrlString)
            
            let data = try? Data(contentsOf: profileURL!)
            
            if let imageData = data {
                self.profileImage.image = UIImage(data: imageData)
                // set image to round
                self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
                self.profileImage.clipsToBounds = true
            }
        }, failure: { (Error) in
            print("Error: \(Error)")
        })
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
