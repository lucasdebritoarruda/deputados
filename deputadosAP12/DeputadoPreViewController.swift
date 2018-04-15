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
        seguirDeputadoOutlet.setTitle("Deixar de Seguir", for: .selected)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setando a cor da view  - Inicio
        
        if colorIndex%2 == 0{
            self.view.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 204/255, alpha: 1)
        }else{
            self.view.backgroundColor = UIColor.init(red: 204/255, green: 255/255, blue: 204/255, alpha: 1)
        }
        
        // Setando a cor da view  Fim
        
        seguirDeputadoOutlet.setTitle("Seguir", for: .normal)
        
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
        partidoEstadoDeputado.text = partido + " " + estado
        situacaoDeputado.text = situacao
        inicioMandatoDeputado.text = inicioMandato
        //Colocando Nome - Fim
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension DeputadoPreViewController{

}

