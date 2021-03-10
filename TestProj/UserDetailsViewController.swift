//
//  UserDetailsViewController.swift
//  TestProj
//
//  Created by Igor Zharii on 02.03.2021.
//

import UIKit
import Alamofire

class UserDetailsViewController: UIViewController {
    static let identifier = "UserDetailsVC"
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var reposTableView: UITableView!
    
    var user: User?
    
    var allRepos = [SearchRepo]()
    var displayedRepos = [SearchRepo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "GitHub Searcher"

        setupViews()
        fetchRepos()
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func fetchRepos() {
        if let reposUrl = user?.reposUrl {
            AF.request(reposUrl)
                .validate()
                .response { response in
                    print(response.debugDescription)
                    self.allRepos.removeAll()
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    do {
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let repos = try decoder.decode([SearchRepo].self, from: data)
                        self.allRepos = repos
                        self.displayedRepos = repos
                        self.reposTableView.reloadData()
                    } catch let error {
                        print("Parsing error: \(error)")
                    }
                }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            displayedRepos.removeAll()
            if text.isEmpty {
                displayedRepos = allRepos
                reposTableView.reloadData()
                return
            }
            let newArray = allRepos.filter {
                $0.name.range(of: text, options: .caseInsensitive) != nil
            }
            
            displayedRepos = newArray
            reposTableView.reloadData()
        }
    }
    
    
    func setupViews() {
        if let user = user {
            if let url = URL(string: user.avatarUrl) {
                avatarImageView.downloadAndSetImage(url: url)
            }
            usernameLabel.text = user.login
            emailLabel.text = user.email ?? "No Email"
            locationLabel.text = user.location ?? "No Location"
            joinDateLabel.text = String(user.createdAt.prefix(10))
            followersLabel.text = String(user.followers) + " Followers"
            followingLabel.text = "Following " + String(user.following)
            bioLabel.text = user.bio ?? "No Bio"
        }
    }
}

extension UserDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.identifier) as! RepositoryTableViewCell
        cell.repoNameLabel.text = displayedRepos[indexPath.row].name
        cell.forksLabel.text = "\(displayedRepos[indexPath.row].forksCount) Forks"
        cell.starsLabel.text = "\(displayedRepos[indexPath.row].stargazersCount) Stars"
        return cell
    }
    
    
}
