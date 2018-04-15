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
    
    // MARK: - Properties(dados do deputado selecionado)
    var foto = String()
    var nome = String()
    var partido = String()
    var estado = String()
    var situacao = String()
    var dataInicioMandato = String()
    var dicionarioDeputado:[String:Any] = [:]
    
    var selectedIndex = Int()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

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
extension NomesTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listaCompleta.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let nomeCompletoNaoTratado = listaCompleta[indexPath.row].lowercased().components(separatedBy: " ")
        var nomeCompletoTratado = ""
        for nome in nomeCompletoNaoTratado{
            nomeCompletoTratado.append(nome.capitalizingFirstLetter() + " ")
        }
        nomeCompletoTratado.removeLast()
        cell.textLabel?.text = nomeCompletoTratado
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        return cell
    }
}

// MARK: - Navigation

extension NomesTableViewController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let y = dict[listaCompleta[indexPath.row]]
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
            let deputadosButton = UIBarButtonItem()
            deputadosButton.title = "Deputados"
            navigationItem.backBarButtonItem = deputadosButton
        }
    }
    
}


// MARK: - Auxiliar Functions

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
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


/*
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
 
 // Configure the cell...
 
 return cell
 }
 */

/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 } else if editingStyle == .insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
