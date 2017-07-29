//
//  FirstQuestionViewController.swift
//  iSecure
//
//  Created by R.M.K CET on 08/07/17.
//  Copyright © 2017 RMKCET. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class FirstQuestionViewController: UIViewController {

    @IBOutlet weak var question: UITextField!
    @IBOutlet weak var answer: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func save(_ sender: Any) {
        let user = (Auth.auth().currentUser?.uid)
        let ref = Database.database().reference()
        let q:String = question.text!
        let ans:String = answer.text!
        ref.child("question").child(user!).childByAutoId().setValue(["Question":q,"Answer":ans])
        performSegue(withIdentifier: "start", sender: nil)
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
