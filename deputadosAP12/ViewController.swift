//
//  ViewController.swift
//  deputadosAP12
//
//  Created by Lucas de Brito on 07/04/2018.
//  Copyright © 2018 Lucas de Brito. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    var deputadosSeguidos: [String] = []
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.tableFooterView = UIView()
        
        let x = UserDefaults.standard.object(forKey: UserDefaults.Keys.seguidos)
        
        if let listaDeSeguidos = x as? [String]{
            
            deputadosSeguidos = listaDeSeguidos
            
            tableView.reloadData()
            
        }
        
        showTableViewPlaceHolder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


// MARK: - TableView DataSource and Delegate Methods
extension ViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deputadosSeguidos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")

        cell.textLabel?.text = deputadosSeguidos[indexPath.row].lowercased().capitalized
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deputadosSeguidos = deputadosSeguidos.filter({ $0 != tableView.cellForRow(at: indexPath)?.textLabel?.text?.uppercased() })
            UserDefaults.standard.set(deputadosSeguidos, forKey: UserDefaults.Keys.seguidos)
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            showTableViewPlaceHolder()
        }
    }
    
}
// MARK: - Auxiliar Functions
extension ViewController{
    
    func showTableViewPlaceHolder(){
        if tableView.numberOfRows(inSection: 0) == 0{
            let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            
            let messageLabel = UILabel(frame: rect)
            
            messageLabel.text = "Você não está seguindo nenhum deputado no momento. Toque no icone + para adicioná-los."
            
            messageLabel.textColor = UIColor.black
            
            messageLabel.numberOfLines = 0
            
            messageLabel.textAlignment = .center
            
            messageLabel.sizeToFit()
            
            self.tableView.backgroundView = messageLabel

            tableView.separatorStyle = .none
        } else {
            
            tableView.separatorStyle = .singleLine
            
            tableView.backgroundView = nil
            
        }
    } 
    
}

// MARK: - Navigation

extension ViewController{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "deputadoDetalhes", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}


// MARK: - Auxiliar Classes
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}




