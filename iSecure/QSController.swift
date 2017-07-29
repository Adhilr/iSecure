//
//  QSController.swift
//  iSecure
//
//  Created by R.M.K CET on 13/06/17.
//  Copyright © 2017 RMKCET. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase
import FirebaseAuth

class QSController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var userId:String!
    var count=0
    var listQ:[String]=[]
    var listA:[String]=[]
    var dataIndex:[String]=[]
    var i=0
    var ref:DatabaseReference!
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        userId = (Auth.auth().currentUser?.uid)!
        ref.child("question").child(userId).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let dic = snapshot.value as? [String : AnyObject] {
                self.count=dic.count
                for (i,j) in dic {
                    self.dataIndex.append(i)
                    self.listQ.append((j["Question"] as? String)!)
                    self.listA.append((j["Answer"] as? String)!)
                    self.tableview.reloadData()
                }
            }
        })
    }
    
    @IBAction func addQs(_ sender: Any) {
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return listQ.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "qscell")! as UITableViewCell
        cell.textLabel?.text = listQ[indexPath.row] as String
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        ref.child("question").child(userId).child(dataIndex[indexPath.row]).removeValue(completionBlock: {
            (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
   
        })
        dataIndex.remove(at: indexPath.row)
        listQ.remove(at: indexPath.row)
        listA.remove(at: indexPath.row)
        tableView.deleteRows(at:[indexPath],with: .automatic)
        tableView.reloadData()
        
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
