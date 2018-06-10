//
//  infoTableViewController.swift
//  deputadosAP12
//
//  Created by Lucas de Brito on 07/06/2018.
//  Copyright © 2018 Lucas de Brito. All rights reserved.
//

import UIKit


class infoTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var itens = ["O QUE FAZ UM DEPUTADO FEDERAL?","QUAIS SÃO AS ATRIBUIÇÕES DO CARGO?","COMO ELES SÃO ELEITOS?", "QUEM PODE SER DEPUTADO FEDERAL?","QUANTO GANHA UM DEPUTADO FEDERAL?"]
    var index:Int?
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// MARK: - Navigation

extension infoTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        self.performSegue(withIdentifier: "infoSegue", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoSegue"{
            let controller = segue.destination as! infoDetailViewController
            controller.index = index
            let infoButton = UIBarButtonItem()
            infoButton.title = "Informações"
            navigationItem.backBarButtonItem = infoButton
        }
    }
}

// MARK: - Table View Data Source

extension infoTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itens.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "infoCell")
        
        cell.textLabel?.text = itens[indexPath.row].lowercased().capitalizingFirstLetter()
        
        return cell
    }
}
