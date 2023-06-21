//
//  ViewController.swift
//  CoreModuleDemo
//
//  Created by Mina Atef on 12/06/2023.
//

import UIKit
import TFCore

class ViewController: UIViewController {
    @IBOutlet weak var usersTableView: UITableView!
    var viewModel: UserViewModelProtocol = UserViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getUserData()
        observeOnUserData()
    }
    
    func observeOnUserData() {
        viewModel.users.observe {[weak self] users in
            guard let self else {return}
            DispatchQueue.main.async {
                self.usersTableView.reloadData()
            }
        }
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.textLabel?.text = viewModel.users.value[indexPath.row].name
        return cell
    }
    
}

