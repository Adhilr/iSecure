//
//  ViewController.swift
//  iSecure
//
//  Created by R.M.K CET on 14/06/17.
//  Copyright © 2017 RMKCET. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

import LocalAuthentication
class ViewController: UIViewController {

    
    
    @IBOutlet weak var ima: UIImageView!
    @IBOutlet weak var ans: UITextField!
    var asnwer:String=""
    @IBOutlet weak var quest: UILabel!
    
    var listQ:[String] = []
    var listA:[String] = []
    var count=0
    @IBOutlet weak var bg: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        ans.text = ""
        ima=UIImageView(image: #imageLiteral(resourceName: "Image-1"))
        bg=UIImageView(image: #imageLiteral(resourceName: "Image"))
        // Do any additional setup after loading the view, typically from a nib.
       
        if(Auth.auth().currentUser?.uid == nil){
            performSegue(withIdentifier: "SignInSegue", sender: nil)
        }
        else{
            let ref = Database.database().reference()
            let userId = (Auth.auth().currentUser?.uid)!
            ref.child("question").child(userId).observeSingleEvent(of: .value, with: {
                (snapshot) in
                    if let dic = snapshot.value as? [String : AnyObject] {
                        self.count=dic.count
                        var ran=Int(arc4random_uniform(UInt32(self.count)))
                        if(ran==self.count){
                            ran=0
                        }
                        var k=0
                        for (_,j) in dic{
                            if(k==ran){
                                self.asnwer = (j["Answer"] as? String)!
                                self.quest.text = (j["Question"] as? String)!
            
                            }
                            self.listA.append((j["Answer"] as? String)!)
                            self.listQ.append((j["Question"] as? String)!)
                            k+=1
                        }
                        
                    }
            })
        }
    }
    
    @IBAction func enter(_ sender: Any) {
        if ans.text == asnwer{
            print(asnwer)
            print(ans.text ?? "def")
            performSegue(withIdentifier: "Enter", sender: self)
        }
        else{
            let alert = UIAlertController(title: "Alert", message: "Wrong Answer.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            var ran = Int(arc4random_uniform(UInt32(count)))
            if ran == count{
                ran=0
            }
            self.quest.text = self.listQ[ran]
            self.asnwer = self.listA[ran]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "Enter") {
            // pass data to next view
        }
        if (segue.identifier == "SignInSegue") {
            DispatchQueue.main.async {
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
                self.show(vc, sender: self)
            }
        }
    }
}
