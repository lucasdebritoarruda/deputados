//
//  NomesTableViewController.swift
//  deputadosAP12
//
//  Created by Lucas de Brito on 07/04/2018.
//  Copyright © 2018 Lucas de Brito. All rights reserved.
//

import UIKit
import Alamofire

class NomesTableViewController: UITableViewController {

    // MARK: - Properties
    var listaCompleta: [String] = []
    var dict:[String:Int] = [:]
    let searchController = UISearchController(searchResultsController:nil)
    var filteredDeputados = [String]()
    
    // MARK: - Properties(dados do deputado selecionado)
    var foto = String()
    var nome = String()
    var partido = String()
    var estado = String()
    var situacao = String()
    var dataInicioMandato = String()
    var dicionarioDeputado:[String:Any] = [:]
    var deputadosSeguidos:[String] = []
    
    var selectedIndex = Int()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Pesquise por um deputado"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private instance methods
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All"){
        filteredDeputados = listaCompleta.filter({ (deputado: String) -> Bool in
            return deputado.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool{
        return searchController.isActive && !searchBarIsEmpty()
    }

}

// MARK: - Table view data source
extension NomesTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredDeputados.count
        }
        return listaCompleta.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")

        
        if isFiltering(){
            cell.textLabel?.text = filteredDeputados[indexPath.row].lowercased().capitalized
        } else {
            cell.textLabel?.text = listaCompleta[indexPath.row].lowercased().capitalized
        }
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        return cell
    }
}

// MARK: - Navigation

extension NomesTableViewController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let y:Int?
        
        if isFiltering(){
            y = dict[filteredDeputados[indexPath.row]]
        } else {
           y = dict[listaCompleta[indexPath.row]]
        }
        
        let link = "https://dadosabertos.camara.leg.br/api/v2/deputados/" + String(describing: y!)
        
        downloadPreviewData(link: link) { (foto,nome,partido,estado,situacao,dataInicioMandato) in
            self.foto = foto
            self.nome = nome
            self.partido = partido
            self.estado = estado
            self.situacao = situacao
            self.dataInicioMandato = dataInicioMandato
            self.performSegue(withIdentifier: "SegueDeputado", sender: self)
            self.selectedIndex = indexPath.row
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueDeputado"{
            let controller = segue.destination as! DeputadoPreViewController
            controller.foto = self.foto
            controller.nomeCompletoNaoTratado = self.nome.lowercased().components(separatedBy: " ")
            controller.partido = self.partido
            controller.estado = self.estado
            controller.situacao = self.situacao
            controller.inicioMandato = self.dataInicioMandato
            controller.colorIndex = self.selectedIndex
            controller.seguido = verifyIfFollowed(nome: self.nome)
            let deputadosButton = UIBarButtonItem()
            deputadosButton.title = "Deputados"
            navigationItem.backBarButtonItem = deputadosButton
        }
    }
    
}


// MARK: - Auxiliar Functions to Download data from the API

extension NomesTableViewController{
    
    func downloadPreviewData(link:String,
                             completion:@escaping(String,String,String,String,String,String)->Void){
        let url = link
        Alamofire.request(url)
            .responseJSON { (response) in
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    return
                }
                guard let responseJSON = response.result.value as? [String:Any],
                    let results = responseJSON["dados"] as? [String:Any],
                    let dados = results["ultimoStatus"] as? [String:Any]
                else{
                        print("Invalid tag information received from the service")
                        return
                }
               // print(dados["urlFoto"])
                var x = dados["urlFoto"]!
                let foto = x as! String
                x = dados["nome"]!
                let nome = x as! String
                x = dados["siglaPartido"]!
                let partido = x as! String
                x = dados["siglaUf"]!
                let estado = x as! String
                x = dados["situacao"]!
                let situacao = x as! String
                x = dados["data"]!
                let dataInicioMandato = x  as! String
                
                completion(foto,nome,partido,estado,situacao,dataInicioMandato)
        }
    }
    
    func verifyIfFollowed(nome: String) -> Bool{
        let x = UserDefaults.standard.object(forKey: UserDefaults.Keys.seguidos)
        if let listaDeSeguidos = x as? [String]{
            if listaDeSeguidos.contains(nome){
                return true
            } else {
                return false
            }
        } else {
          return false
        }
    }
}


// MARK: - UISearchController Delegate Methods
extension NomesTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
