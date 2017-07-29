//
//  SignUpViewController.swift
//  iSecure
//
//  Created by R.M.K CET on 08/07/17.
//  Copyright © 2017 RMKCET. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class SignUpViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirm: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clear(){
        password.text=""
        confirm.text=""
    }
    @IBAction func signup(_ sender: Any) {
        if confirm.text == password.text{
        Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: { (user,error) in
            if error != nil{
                print(error!.localizedDescription)
                let alert = UIAlertController(title: "Warning", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Log In", style: UIAlertActionStyle.default, handler: {
                    action in self.performSegue(withIdentifier: "logAgain", sender: nil)
                }))
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: {
                    action in self.clear()
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            else{
                Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!, completion: { (user,error) in
                    if error != nil{
                        print(error!.localizedDescription)
                        
                    }
                    else{
                            self.performSegue(withIdentifier: "FirstQuestion", sender: nil)
                        
                        
                        }
                        
                        
                    })
                
            }
            
        })
        }
        else{
            let alert = UIAlertController(title: "Warning", message: "Passwords Mismatched", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: {
                action in self.clear()
            }))
            
            self.present(alert, animated: true, completion: nil)
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
