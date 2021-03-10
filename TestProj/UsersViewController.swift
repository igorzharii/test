//
//  UsersViewController.swift
//  TestProj
//
//  Created by Igor Zharii on 02.03.2021.
//

import UIKit
import Alamofire

class UsersViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var usersTableView: UITableView!
    
    let searchUsersUrl = "https://api.github.com/search/users"
    let userUrl = "https://api.github.com/users"
    
    var displayedUsers = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "GitHub Searcher"
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    fileprivate func handleAPILimit(_ response: AFDataResponse<Data?>, _ data: Data) {
        if response.response?.statusCode == 403 {
            do {
                let dataDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                self.showAlert(message: dataDict?["message"] as? String ?? "Error")
                return
            } catch {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func fetchUsers(name: String) {
        AF.request(searchUsersUrl, parameters: ["q": name])
            .validate()
            .response { response in
                guard let data = response.data else { return }
                self.handleAPILimit(response, data)
                let decoder = JSONDecoder()
                do {
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let users = try decoder.decode(Users.self, from: data)
                    self.displayedUsers.removeAll()
                    for user in users.items {
                        let fullUserUrl = self.userUrl + "/\(user.login)"
                            AF.request(fullUserUrl)
                                .validate()
                                .response { userResponse in
                                    guard let userData = userResponse.data else { return }
                                    self.handleAPILimit(userResponse, userData)
                                    do {
                                        let user = try decoder.decode(User.self, from: userData)
                                        self.displayedUsers.append(user)
                                        self.usersTableView.reloadData()
                                    } catch let error {
                                        print("Parsing error: \(error)")
                                    }
                                }
                    }
                } catch let error {
                    print("Parsing error: \(error)")
                }
            }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let name = textField.text {
            if name.isEmpty {
                displayedUsers.removeAll()
                usersTableView.reloadData()
            }
            fetchUsers(name: name)
        }
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier) as! UserTableViewCell
        cell.usernameLabel.text = displayedUsers[indexPath.row].login
        cell.repoLabel.text = "Repos: \(displayedUsers[indexPath.row].publicRepos)"
        if let url = URL(string: displayedUsers[indexPath.row].avatarUrl) {
            cell.userImageView.downloadAndSetImage(url: url)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: UserDetailsViewController.identifier) as! UserDetailsViewController
        vc.user = displayedUsers[indexPath.row]
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(vc, animated: true)
    }
}
