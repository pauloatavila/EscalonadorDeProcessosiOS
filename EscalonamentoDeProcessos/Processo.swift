//
//  Processo.swift
//  EscalonamentoDeProcessos
//
//  Created by Paulo Sérgio Atavila Júnior on 23/10/17.
//  Copyright © 2017 Paulo Atavila. All rights reserved.
//

import Foundation

class Processo{
    var nome:String
    var tempoBurst:Int
    var tempoBurstRestante:Int
    var memoria:Int
    var armazenamentoInicial:Int
    var armazenamentoFinal:Int
    var status:Int //0: em execucao, 1: pronto (para ser executado), 2: bloqueado, 3: finalizado
    var prioridade:Int //1, 2, 3, 4 : menor -> maior
    var ioBound:[Int] //momentos que o processo pede entrada e saida
    var tempoIO:Int //tempo que esta esperando por entrada e saida
    var tempoEspera:Int
    var tempoChegada:Int
    var color:String
    
    init(nome:String, tempoBurst:Int, tempoBurstRestante:Int, memoria:Int, armazenamentoInicial:Int, armazenamentoFinal:Int, status:Int, prioridade:Int, ioBound:[Int], tempoIO:Int, tempoEspera:Int, tempoChegada:Int, color:String) {
        self.nome = nome
        self.tempoBurst = tempoBurst
        self.tempoBurstRestante = tempoBurstRestante
        self.memoria = memoria
        self.armazenamentoInicial = armazenamentoInicial
        self.armazenamentoFinal = armazenamentoFinal
        self.status = status
        self.prioridade = prioridade
        self.ioBound = ioBound
        self.tempoIO = tempoIO
        self.tempoEspera = tempoEspera
        self.tempoChegada = tempoChegada
        self.color = color
    }
}

class ProcessoDAO{
    static func getList() -> [Processo]{
        return [
            Processo(nome: "P1", tempoBurst: 3, tempoBurstRestante: 3, memoria: 12, armazenamentoInicial: 0, armazenamentoFinal: 0, status: 1, prioridade: 4, ioBound: [2], tempoIO: 0, tempoEspera: 0, tempoChegada: 0, color:"642069"),
            Processo(nome: "P2", tempoBurst: 5, tempoBurstRestante: 5, memoria: 20, armazenamentoInicial: 0, armazenamentoFinal: 0, status: 1, prioridade: 3, ioBound: [4], tempoIO: 0, tempoEspera: 0, tempoChegada: 1, color:"3EC218"),
            Processo(nome: "P3", tempoBurst: 4, tempoBurstRestante: 4, memoria: 18, armazenamentoInicial: 0, armazenamentoFinal: 0, status: 1, prioridade: 4, ioBound: [], tempoIO: 0, tempoEspera: 0, tempoChegada: 1, color:"4AA4C3"),
            Processo(nome: "P4", tempoBurst: 2, tempoBurstRestante: 2, memoria: 13, armazenamentoInicial: 0, armazenamentoFinal: 0, status: 1, prioridade: 1, ioBound: [], tempoIO: 0, tempoEspera: 0, tempoChegada: 1, color:"215EEB"),
            Processo(nome: "P5", tempoBurst: 7, tempoBurstRestante: 7, memoria: 9, armazenamentoInicial: 0, armazenamentoFinal: 0, status: 1, prioridade: 3, ioBound: [], tempoIO: 0, tempoEspera: 0, tempoChegada: 2, color:"A23022"),
            Processo(nome: "P6", tempoBurst: 8, tempoBurstRestante: 8, memoria: 31, armazenamentoInicial: 0, armazenamentoFinal: 0, status: 1, prioridade: 4, ioBound: [3, 5], tempoIO: 0, tempoEspera: 0, tempoChegada: 3, color:"3D3A16"),
            Processo(nome: "P7", tempoBurst: 5, tempoBurstRestante: 5, memoria: 22, armazenamentoInicial: 0, armazenamentoFinal: 0, status: 1, prioridade: 4, ioBound: [], tempoIO: 0, tempoEspera: 0, tempoChegada: 3, color:"AC2D74"),
            Processo(nome: "P8", tempoBurst: 4, tempoBurstRestante: 4, memoria: 6, armazenamentoInicial: 0, armazenamentoFinal: 0, status: 1, prioridade: 2, ioBound: [2], tempoIO: 0, tempoEspera: 0, tempoChegada: 5, color:"989234"),
            Processo(nome: "P9", tempoBurst: 3, tempoBurstRestante: 3, memoria: 10, armazenamentoInicial: 0, armazenamentoFinal: 0, status: 1, prioridade: 1, ioBound: [], tempoIO: 0, tempoEspera: 0, tempoChegada: 6, color:"611C1F"),
            Processo(nome: "P10", tempoBurst: 2, tempoBurstRestante: 2, memoria: 15, armazenamentoInicial: 0, armazenamentoFinal: 0, status: 1, prioridade: 4, ioBound: [], tempoIO: 0, tempoEspera: 0, tempoChegada: 7, color:"4F6924")
        ]
    }
}


