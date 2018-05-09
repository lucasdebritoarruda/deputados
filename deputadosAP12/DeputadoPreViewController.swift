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
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var whitePanel: UIView!
    @IBOutlet weak var blurView: UIView!
    
    
    
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
        
        //Efeito blur na imagem do background - inicio
        if !UIAccessibilityIsReduceTransparencyEnabled(){
            blurView.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.blurView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            blurEffectView.alpha = 0.6
            blurView.addSubview(blurEffectView)
        } else {
            blurView.alpha = 0
        }
        //Efeito blur na imagem do background - Fim
        
        //Transformando whitePanel em greyPanel - Inicio
        whitePanel.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 0.8)
        //Transformando whitePanel em greyPanel - Fim
        
        // Colocando Foto - inicio
        let url = URL(string:foto)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.sync {
                self.fotoDeputado.image = UIImage(data: data!)
            }
        }
        fotoDeputado.layer.cornerRadius = fotoDeputado.layer.frame.height/2
        fotoDeputado.layer.masksToBounds = true
        fotoDeputado.layer.borderWidth = 3.0
        fotoDeputado.layer.borderColor = UIColor.white.cgColor
        fotoDeputado.layer.backgroundColor = UIColor.white.cgColor
        // Colocando Foto - fim
        
        //Colocando Nome - Inicio
        var nomeCompletoTratado = ""
        for nome in nomeCompletoNaoTratado{
            nomeCompletoTratado.append(nome.capitalizingFirstLetter() + " ")
        }
        nomeCompletoTratado.removeLast()
        nomeDeputado.text = nomeCompletoTratado
        //Colocando Nome - Fim
        
        inicioMandatoDeputado.text = fixedData(data: inicioMandato)
        partidoEstadoDeputado.text = partido + " " + estado
        situacaoDeputado.text = situacao
        backGroundImage.image = UIImage(named:estado+".jpg")
        whitePanel.layer.cornerRadius = 12
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
            salvandoFotoDeputado()
        } else {
            var listaDeSeguidos: [String] = []
            listaDeSeguidos.append((nomeDeputado.text?.uppercased())!)
            print(listaDeSeguidos)
            UserDefaults.standard.set(listaDeSeguidos, forKey: UserDefaults.Keys.seguidos)
            salvandoFotoDeputado()
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
    
    func salvandoFotoDeputado(){
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        if documentsPath.count > 0{
            let documentsDirectory = documentsPath[0]
            let savePath = documentsDirectory + "/" + (nomeDeputado.text?.uppercased())! + ".jpg"
            
            do{
                try UIImageJPEGRepresentation(fotoDeputado.image!, 1)?.write(to: URL(fileURLWithPath: savePath))
            } catch {
                print("Erro Salvando imagem!")
            }
        }
    }
    
    func fixedData(data:String) -> String{
        var x = data.components(separatedBy: "-")
        x.reverse()
        var y = ""
        for parte in x {
            y.append(parte)
            y.append("/")
        }
        y.removeLast()
        
        return y
    }
}

