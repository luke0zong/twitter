//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Yaowei on 10/16/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var user: NSDictionary!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var displayNameLabel: UILabel!
    
    @IBOutlet weak var usernaneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadProfile()
        
    }
    
    func loadProfile(){
        
        print(user!)
        
        self.displayNameLabel.text = (self.user["name"] as! String)
        self.usernaneLabel.text = (user["screen_name"] as! String)
        // "followers_count"
        // "profile_background_image_url_https"
        // "profile_image_url_https"
        // "screen_name"
        
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
