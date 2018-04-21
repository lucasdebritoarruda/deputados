//
//  DeputadoPreViewController.swift
//  deputadosAP12
//
//  Created by Lucas de Brito on 12/04/2018.
//  Copyright © 2018 Lucas de Brito. All rights reserved.
//

import UIKit

class DeputadoPreViewController: UIViewController {
    
    // MARK: - Properties
    var foto = ""
    var nomeCompletoNaoTratado: [String] = []
    var partido = ""
    var estado = ""
    var situacao = ""
    var inicioMandato = ""
    var seguido: Bool?
    
    var colorIndex = Int()
    
    // MARK: - Outlets
    @IBOutlet weak var fotoDeputado: UIImageView!
    @IBOutlet weak var nomeDeputado: UILabel!
    @IBOutlet weak var partidoEstadoDeputado: UILabel!
    @IBOutlet weak var situacaoDeputado: UILabel!
    @IBOutlet weak var inicioMandatoDeputado: UILabel!
    @IBOutlet weak var seguirDeputadoOutlet: UIButton!
    
    
    // MARK: - Actions
    @IBAction func seguirDeputadoAction(_ sender: Any) {
        if seguido!{
            removeFromFollowed()
            seguido = false
            seguirDeputadoOutlet.setTitle("Seguir", for: .normal)
        } else {
            addToFollowed()
            seguido = true
            seguirDeputadoOutlet.setTitle("Deixar de Seguir", for: .normal)
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(seguido!)
        
        if seguido!{
            seguirDeputadoOutlet.setTitle("Deixar de Seguir", for: .normal)
        } else {
            seguirDeputadoOutlet.setTitle("Seguir", for: .normal)
        }
        
        // Setando a cor da view  - Inicio
        
        if colorIndex%2 == 0{
            self.view.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 204/255, alpha: 1)
        }else{
            self.view.backgroundColor = UIColor.init(red: 204/255, green: 255/255, blue: 204/255, alpha: 1)
        }
        
        // Setando a cor da view  Fim
        
        // Colocando Foto - inicio
        let url = URL(string:foto)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.sync {
                self.fotoDeputado.image = UIImage(data: data!)
            }
        }
        fotoDeputado.layer.cornerRadius = fotoDeputado.frame.height/2
        fotoDeputado.layer.masksToBounds = true
        // Colocando Foto - fim
        
        //Colocando Nome - Inicio
        var nomeCompletoTratado = ""
        for nome in nomeCompletoNaoTratado{
            nomeCompletoTratado.append(nome.capitalizingFirstLetter() + " ")
        }
        nomeCompletoTratado.removeLast()
        nomeDeputado.text = nomeCompletoTratado
        //Colocando Nome - Fim
        
        partidoEstadoDeputado.text = partido + " " + estado
        situacaoDeputado.text = situacao
        inicioMandatoDeputado.text = inicioMandato
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Auxiliar Functions
extension DeputadoPreViewController{
    func addToFollowed(){
        let x = UserDefaults.standard.object(forKey: UserDefaults.Keys.seguidos)
        if var listaDeSeguidos = x as? [String]{
            listaDeSeguidos.append((nomeDeputado.text?.uppercased())!)
            var listaDeSeguidosOrdenada = listaDeSeguidos
            listaDeSeguidosOrdenada = listaDeSeguidosOrdenada.sorted { $0 < $1 }
            print(listaDeSeguidosOrdenada)
            UserDefaults.standard.set(listaDeSeguidosOrdenada, forKey: UserDefaults.Keys.seguidos)
        } else {
            var listaDeSeguidos: [String] = []
            listaDeSeguidos.append((nomeDeputado.text?.uppercased())!)
            print(listaDeSeguidos)
            UserDefaults.standard.set(listaDeSeguidos, forKey: UserDefaults.Keys.seguidos)
        }
    }
    
    func removeFromFollowed(){
        let x = UserDefaults.standard.object(forKey: UserDefaults.Keys.seguidos)
        if var listaDeSeguidos = x as? [String]{
            listaDeSeguidos = listaDeSeguidos.filter({ $0 != (nomeDeputado.text?.uppercased())! })
            print(listaDeSeguidos)
            UserDefaults.standard.set(listaDeSeguidos, forKey: UserDefaults.Keys.seguidos)
        }
    }
}

