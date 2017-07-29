//
//  AddFieldController.swift
//  iSecure
//
//  Created by R.M.K CET on 13/06/17.
//  Copyright © 2017 RMKCET. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase
import FirebaseAuth
class AddFieldController: UIViewController {
    
    
    
    @IBOutlet weak var ima: UIImageView!
    
    @IBOutlet weak var te: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ima=UIImageView(image: #imageLiteral(resourceName: "Image"))
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func seg(){
        performSegue(withIdentifier: "Back", sender: self)
    }
    
    @IBAction func back(_ sender: Any) {
        if(te.text != ""){
            let alert = UIAlertController(title: "Warning", message: "Data will be deleted", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
                action in self.save(Any.self)
                
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: {
                action in self.seg()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        performSegue(withIdentifier: "Back", sender: self)
    }
    
    
    @IBAction func save(_ sender: Any) {
        print("save")
        let user = (Auth.auth().currentUser?.uid)
        let ref = Database.database().reference()
        ref.child("data").child(user!).childByAutoId().setValue(["Data":te.text] )
        
        performSegue(withIdentifier: "SaveSegue", sender: self)
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
