//
//  SecurityController.swift
//  iSecure
//
//  Created by R.M.K CET on 13/06/17.
//  Copyright © 2017 RMKCET. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseDatabase

class SecurityController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var ans: UITextField!
    
    @IBOutlet weak var question: UITextField!
    
    
    @IBAction func Save(_ sender: Any) {
        let user = (Auth.auth().currentUser?.uid)
        let ref = Database.database().reference()
        let q = question.text
        let a = ans.text
        ref.child("question").child(user!).childByAutoId().setValue(["Question":q,"Answer":a])
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake
        {
            performSegue(withIdentifier: "shake", sender: self)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
