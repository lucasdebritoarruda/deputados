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
    //RECEBER ID DO DEPUTADO PARA FAZER CALCULO DA COR DE FUNDO
    
    // MARK: - Outlets
    @IBOutlet weak var fotoDeputado: UIImageView!
    @IBOutlet weak var nomeDeputado: UILabel!
    @IBOutlet weak var partidoEstadoDeputado: UILabel!
    @IBOutlet weak var situacaoDeputado: UILabel!
    @IBOutlet weak var inicioMandatoDeputado: UILabel!
    @IBOutlet weak var seguirDeputadoOutlet: UIButton!
    
    
    // MARK: - Actions
    @IBAction func seguirDeputadoAction(_ sender: Any) {
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension DeputadoPreViewController{
    
}
