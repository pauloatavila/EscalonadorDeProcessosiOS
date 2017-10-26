//
//  ProcessoView.swift
//  EscalonamentoDeProcessos
//
//  Created by Paulo Sérgio Atavila Júnior on 24/10/17.
//  Copyright © 2017 Paulo Atavila. All rights reserved.
//

import Foundation

class ProcessoView{
    var nome:String
    var status:Int //0 nada, 1 concluido, 2 bloqueado
    var color:String
    
    init(nome:String, status:Int, color:String) {
        self.nome = nome
        self.status = status
        self.color = color
    }
}

class ProcessoViewDAO{
    static func getList() -> [ProcessoView]{
        return [
        ]
    }
}
