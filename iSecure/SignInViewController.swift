//
//  SignInViewController.swift
//  iSecure
//
//  Created by R.M.K CET on 08/07/17.
//  Copyright © 2017 RMKCET. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import GoogleSignIn

class SignInViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var google: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        

    }
    func clean(){
        self.email.text=""
        self.password.text=""
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sigin(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!, completion: { (user,error) in
            if error != nil{
                print(error!.localizedDescription)
                let alert = UIAlertController(title: "Warning", message: "Incorrect Email or Password", preferredStyle: UIAlertControllerStyle.alert)
                
                
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: {
                    action in self.clean()
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
            else{
                let user = (Auth.auth().currentUser?.uid)
                let ref = Database.database().reference()
                ref.child("question").child(user!).observeSingleEvent(of: .value, with: {
                    (snapshot) in
                    if let dic = snapshot.value as? [String : AnyObject] {
                        self.performSegue(withIdentifier: "logged", sender: nil)
                        print(dic)
                    }
                    self.performSegue(withIdentifier: "FirstQuestion", sender: nil)
                    })
                
                
            }
            
        })
        
        

    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error=error{
            print(error.localizedDescription)
            return
        }
        else{
            let authenication = user.authentication
            let credentials = GoogleAuthProvider.credential(withIDToken: (authenication?.idToken)!, accessToken: (authenication?.accessToken)!)
            
            Auth.auth().signIn(with: credentials, completion: { (user,error) in
                if error != nil {
                    print(error?.localizedDescription ?? "error")
                    return
                }
                else{
                    let user = (Auth.auth().currentUser?.uid)
                    let ref = Database.database().reference()
                    ref.child("question").child(user!).observeSingleEvent(of: .value, with: {
                        (snapshot) in
                        if let dic = snapshot.value as? [String : AnyObject] {
                            self.performSegue(withIdentifier: "logged", sender: nil)
                            print(dic)
                        }
                        self.performSegue(withIdentifier: "FirstQuestion", sender: nil)
                    })

                    
                    
                }

            })
            
            
            
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error=error{
            print(error.localizedDescription)
            return
        }
        try! Auth.auth().signOut()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        if (segue.identifier == "logged") {
            DispatchQueue.main.async {
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
                self.show(vc, sender: self)
            }
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
