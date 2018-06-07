//
//  IniciaisTableViewController.swift
//  deputadosAP12
//
//  Created by Lucas de Brito on 08/04/2018.
//  Copyright © 2018 Lucas de Brito. All rights reserved.
//

import UIKit
import Alamofire

class IniciaisTableViewController: UITableViewController {
    
    // MARK: - Properties
    var links = ["https://dadosabertos.camara.leg.br/api/v2/deputados?pagina=1&ordenarPor=nome&itens=100",
                 "https://dadosabertos.camara.leg.br/api/v2/deputados?pagina=2&ordenarPor=nome&itens=100",
                 "https://dadosabertos.camara.leg.br/api/v2/deputados?pagina=3&ordenarPor=nome&itens=100",
                 "https://dadosabertos.camara.leg.br/api/v2/deputados?pagina=4&ordenarPor=nome&itens=100",
                 "https://dadosabertos.camara.leg.br/api/v2/deputados?pagina=5&ordenarPor=nome&itens=100",
                 "https://dadosabertos.camara.leg.br/api/v2/deputados?pagina=6&ordenarPor=nome&itens=100"]
    
    var itens = ["A - B - C","C - D - E - F - G - H","H - I - J - K - L","L - M - N - O - P","R - S - T - U - V - W","W - X - Y - Z"]
    var listaComNomes:[String] = [ ]
    var listaComIds:[Int] = [ ]
    var idComNome: [String:Int] = [:]

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}




    // MARK: - Table view data source
extension IniciaisTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itens.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = itens[indexPath.row]
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        return cell
    }
    
}

    // MARK: - Navigation
extension IniciaisTableViewController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let x = tableView.cellForRow(at: indexPath)?.textLabel?.text
        let y = UserDefaults.standard.object(forKey: x!)
        if let lista = y as? [String]{
            self.listaComNomes = lista
            let z = UserDefaults.standard.object(forKey: UserDefaults.Keys.dicionarioIdNome) as! Data
            self.idComNome = NSKeyedUnarchiver.unarchiveObject(with: z) as! Dictionary<String, Int>
            self.performSegue(withIdentifier: "SegueLista", sender: self)
        }else{
            tableView.allowsSelection = false
            downloadNameList(link: links[indexPath.row]) { nomes,ids in
                self.listaComNomes = nomes
                self.saveToUserDefaults(row: indexPath.row)
                var dict = [String:Int]()
                for(index,element) in self.listaComNomes.enumerated(){
                    dict[element] = ids[index]
                }
                dict.forEach({ (k,v) in
                    self.idComNome[k] = v
                })
                let encondedDict: Data = NSKeyedArchiver.archivedData(withRootObject: self.idComNome)
                UserDefaults.standard.set(encondedDict, forKey: UserDefaults.Keys.dicionarioIdNome)
                self.performSegue(withIdentifier: "SegueLista", sender: self)
                tableView.allowsSelection = true
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueLista"{
            let controller = segue.destination as! NomesTableViewController
            controller.listaCompleta = listaComNomes
            controller.dict = idComNome
            let iniciaisButton = UIBarButtonItem()
            iniciaisButton.title = "Iniciais"
            navigationItem.backBarButtonItem = iniciaisButton
        }
    }
    
}

    // MARK: - Auxiliar functions
extension IniciaisTableViewController{
    
    func downloadNameList(link: String,
                          completion: @escaping ([String],[Int]) -> Void){
        
        let url = URL(string:link)
        
        Alamofire.request(url!)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    return
                }
                print(response.value)
                guard let responseJSON = response.result.value as? [String: Any],
                    let results = responseJSON["dados"] as? [[String: Any]],
                    let firstObject = results.first,
                    let dadosDeputados = firstObject["nome"] as? String else {
                        print("Invalid tag information received from the service")
                        return
                }
                
                let nomes = results.flatMap({ dict in
                    return dict["nome"] as? String
                })
                
                let ids = results.flatMap({ dict in
                    return dict["id"] as? Int
                })
                completion(nomes,ids)
        }
    }
    
    func saveToUserDefaults(row:Int){
        if row == 0{
            UserDefaults.standard.set(self.listaComNomes, forKey: UserDefaults.Keys.abc)
        }
        if row == 1{
            UserDefaults.standard.set(self.listaComNomes, forKey: UserDefaults.Keys.cdefgh)
        }
        if row == 2{
            UserDefaults.standard.set(self.listaComNomes, forKey: UserDefaults.Keys.hijkl)
        }
        if row == 3{
            UserDefaults.standard.set(self.listaComNomes, forKey: UserDefaults.Keys.lmnop)
        }
        if row == 4{
            UserDefaults.standard.set(self.listaComNomes, forKey: UserDefaults.Keys.rstuvw)
        }
        if row == 5{
            UserDefaults.standard.set(self.listaComNomes, forKey: UserDefaults.Keys.wxyz)
        }
    }
    
    func retrieveFromUserDefaults(row:Int,
                                  completion: @escaping (([String])->Void)){
        if row == 0{
            let x = UserDefaults.standard.object(forKey: UserDefaults.Keys.abc)
            if let lista = x as? [String]{
                completion(lista)
            }
        }
        if row == 1{
            let x = UserDefaults.standard.object(forKey: UserDefaults.Keys.cdefgh)
            if let lista = x as? [String]{
                completion(lista)
            }
        }
        if row == 2{
            let x = UserDefaults.standard.object(forKey: UserDefaults.Keys.hijkl)
            if let lista = x as? [String]{
                completion(lista)
            }
        }
        if row == 3{
            let x = UserDefaults.standard.object(forKey: UserDefaults.Keys.lmnop)
            if let lista = x as? [String]{
                completion(lista)
            }
        }
        if row == 4{
            let x = UserDefaults.standard.object(forKey: UserDefaults.Keys.rstuvw)
            if let lista = x as? [String]{
                completion(lista)
            }
        }
        if row == 5{
            let x = UserDefaults.standard.object(forKey: UserDefaults.Keys.wxyz)
            if let lista = x as? [String]{
                completion(lista)
            }
        }
    }

}
    // MARK: - UserDefaults Keys
extension UserDefaults{
    enum Keys{
        static let abc = "A - B - C"
        static let cdefgh = "C - D - E - F - G - H"
        static let hijkl = "H - I - J - K - L"
        static let lmnop = "L - M - N - O - P"
        static let rstuvw = "R - S - T - U - V - W"
        static let wxyz = "W - X - Y - Z"
        static let dicionarioIdNome = "dicionarioIdNome"
        static let seguidos = "seguidos"
        static let followedPictures = "followedPictures"
    }
}


