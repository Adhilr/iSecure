//
//  WelcomeController.swift
//  iSecure
//
//  Created by R.M.K CET on 13/06/17.
//  Copyright © 2017 RMKCET. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseDatabase

class WelcomeController: UIViewController, UITableViewDelegate , UITableViewDataSource{
    
    
    @IBOutlet weak var tableview: UITableView!
    var ref:DatabaseReference!
    var dataIndex:[String]=[]
    var list:[String]=[]
    var count = 0
    var i=0
    //var refHandle:UInt!
    var userId:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        userId = (Auth.auth().currentUser?.uid)!
        ref.child("data").child(userId).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let dic = snapshot.value as? [String : AnyObject] {
                self.count=dic.count
                for (i,j) in dic {
                    self.dataIndex.append(i)
                    for (ik,k) in (j as? [String : String])!{
                        self.list.append(k)
                        print(ik)
                        DispatchQueue.main.async(execute: {
                            self.tableview.reloadData();
                        })

                    }
                }
            }
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return count
    }
    
    @IBAction func Signout(_ sender: Any) {
        
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "signout", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = list[indexPath.row] as String
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        ref.child("data").child(userId).child(dataIndex[i]).removeValue(completionBlock: { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        })
        self.performSegue(withIdentifier: "Edit", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "Edit") {
            DispatchQueue.main.async(){
                let viewController:AddFieldController = segue.destination as! AddFieldController
                viewController.te?.text = self.list[self.i]
            }
            // pass data to next view
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        ref.child("data").child(userId).child(dataIndex[i]).removeValue(completionBlock: { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        })
        list.remove(at: indexPath.row)
        dataIndex.remove(at: indexPath.row)
        count-=1
        tableView.deleteRows(at:[indexPath],with: .automatic)
        tableView.reloadData()
        
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake
        {
            performSegue(withIdentifier: "shake", sender: self)
        }
    }
    
    
    
};


