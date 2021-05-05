//
//  FeedViewController.swift
//  parsetagram
//
//  Created by Jeffy Touth on 5/3/21.
//

import UIKit
import Parse
class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    var posts = [PFObject]()
    var queryLimit = 50
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPosts(_:)), for: UIControl.Event.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = self.queryLimit
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.posts.reverse()
                self.tableView.reloadData()
                print("Found posts.")
            }
        }
    }
    
    @objc func refreshPosts(_ refreshControl: UIRefreshControl) {
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = self.queryLimit
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.posts.reverse()
                self.tableView.reloadData()
            }
        }
        
        self.tableView.reloadData()
        
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        let post = posts[indexPath.row]
        
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username
        
        cell.captionLabel.text = post["caption"] as? String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        print(url)
        cell.photoView.af.setImage(withURL: url)
        
        return cell
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
