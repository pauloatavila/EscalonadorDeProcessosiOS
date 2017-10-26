//
//  ViewController.swift
//  EscalonamentoDeProcessos
//
//  Created by Paulo Sérgio Atavila Júnior on 21/10/17.
//  Copyright © 2017 Paulo Atavila. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var memoriaLabel: UILabel!
    @IBOutlet weak var SOLabel: UILabel!
    @IBOutlet weak var porcentagemSOLabel: UILabel!
    @IBOutlet weak var aplicacoesLabel: UILabel!
    @IBOutlet weak var porcentagemAplicacoesLabel: UILabel!
    @IBOutlet weak var livreLabel: UILabel!
    @IBOutlet weak var porcentagemLivreLabel: UILabel!
    @IBOutlet weak var soView: UIView!
    @IBOutlet weak var SoViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var aplicacoesView: UIView!
    @IBOutlet weak var aplicacoesViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var livreView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var proximaPagina: UIButton!
    @IBAction func proximaPaginaCollection(_ sender: Any) {
        t0Label.text = "\(Int(t0Label.text!)!+8)"
        t1Label.text = "\(Int(t1Label.text!)!+8)"
        t2Label.text = "\(Int(t2Label.text!)!+8)"
        t3Label.text = "\(Int(t3Label.text!)!+8)"
        t4Label.text = "\(Int(t4Label.text!)!+8)"
        t5Label.text = "\(Int(t5Label.text!)!+8)"
        t6Label.text = "\(Int(t6Label.text!)!+8)"
        t7Label.text = "\(Int(t7Label.text!)!+8)"
        
        paginaCollection += 1
        atualizaTimeLine()
    }
    @IBOutlet weak var anteriorpagina: UIButton!
    @IBAction func anteriorPaginaCollection(_ sender: Any) {
        t0Label.text = "\(Int(t0Label.text!)!-8)"
        t1Label.text = "\(Int(t1Label.text!)!-8)"
        t2Label.text = "\(Int(t2Label.text!)!-8)"
        t3Label.text = "\(Int(t3Label.text!)!-8)"
        t4Label.text = "\(Int(t4Label.text!)!-8)"
        t5Label.text = "\(Int(t5Label.text!)!-8)"
        t6Label.text = "\(Int(t6Label.text!)!-8)"
        t7Label.text = "\(Int(t7Label.text!)!-8)"
        
        paginaCollection -= 1
        atualizaTimeLine()
    }
    @IBOutlet weak var t0Label: UILabel!
    @IBOutlet weak var t1Label: UILabel!
    @IBOutlet weak var t2Label: UILabel!
    @IBOutlet weak var t3Label: UILabel!
    @IBOutlet weak var t4Label: UILabel!
    @IBOutlet weak var t5Label: UILabel!
    @IBOutlet weak var t6Label: UILabel!
    @IBOutlet weak var t7Label: UILabel!
    @IBOutlet weak var logTextView: UITextView!
    @IBOutlet weak var proximoPassoBtt: UIBarButtonItem!
    @IBAction func proximoPasso(_ sender: Any) {
        executaProcesso()
        zerarBtt.isEnabled = true
        if numProcessosRestantes == 0 {
            proximoPassoBtt.isEnabled = false
            paraOFimBtt.isEnabled = false
            print("Fim da Execução")
            let alert = UIAlertController(title: "Fim do Escalonamento", message: "Tempo médio de espera dos processos: \(Float(somaDeTempos)/Float(numDeSomas)) u.t.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        if proximaPagina.isEnabled {
            proximaPaginaCollection((Any).self)
        }
    }
    @IBOutlet weak var paraOFimBtt: UIBarButtonItem!
    @IBAction func paraOFim(_ sender: Any) {
        
        if timerImage.isHidden != true {
            fecharInfo((Any).self)
        }
        
        zerar((Any).self)
        
        while numProcessosRestantes > 0 {
            executaProcesso()
        }
        let alert = UIAlertController(title: "Fim do Escalonamento", message: "Tempo médio de espera dos processos: \(Float(somaDeTempos)/Float(numDeSomas)) u.t.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        proximoPassoBtt.isEnabled = false
        paraOFimBtt.isEnabled = false
        zerarBtt.isEnabled = true
    }
    @IBOutlet weak var zerarBtt: UIBarButtonItem!
    @IBAction func zerar(_ sender: Any) {
        
        paginaCollection = 1
        
        ListaProcessos = ProcessoDAO.getList()
        
        configuracaoInicial()
        
        //Alteracao dos valores das variaveis DEFINE
        memoriaTotal = 100
        memoriaSO = 9
        memoriaRestante = memoriaTotal - memoriaSO
        numProcessosRestantes = ListaProcessos.count
        
        //Chamada de atualizacao INICIAL
        atualizaMemoriaViews()
        
        atualizaTimeLine()
        
        
        zerarBtt.isEnabled = false
        proximoPassoBtt.isEnabled = true
        paraOFimBtt.isEnabled = true
        
        logTextView.text = "LOG\nInicialização do Sistema Operacional\nMemória disponível: \(memoriaTotal)K\nNúmero de processos a serem executados: \(ListaProcessos.count)\n\n=============\n"
        
        t0Label.text = "0"
        t1Label.text = "1"
        t2Label.text = "2"
        t3Label.text = "3"
        t4Label.text = "4"
        t5Label.text = "5"
        t6Label.text = "6"
        t7Label.text = "7"
        logTextView.textColor = UIColor.white
        proximaPagina.isEnabled = false
        anteriorpagina.isEnabled = false
        tableViewFilas.reloadData()
    }
    
    //TableView Connections
    @IBOutlet weak var infoTableLabel: UILabel!
    @IBOutlet weak var tableViewFilas: UITableView!
    @IBOutlet weak var escolhaDeFilas: UISegmentedControl!
    @IBAction func escolhaDeFilasBtt(_ sender: Any) {
        tableViewFilas.reloadData()
    }
    
    //View de info da Table View
    @IBOutlet weak var viewXBtt: UIView!
    @IBAction func fecharInfo(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.mudaAlphaInfoView(result: 0.0)
        }) { (true) in
            UIView.animate(withDuration: 0.3, animations: {
                let height = 0
                self.infoView.frame = CGRect(x: self.infoView.frame.origin.x, y: self.infoView.frame.origin.y + 344.0, width: self.infoView.frame.width, height: CGFloat(height))
            })
        }
        escondeInfoView(result: true)
        tableViewFilas.allowsSelection = true
    }
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var processoInfoView: UIView!
    @IBOutlet weak var processoNomeInfoLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var estrela1: UIImageView!
    @IBOutlet weak var estrela2: UIImageView!
    @IBOutlet weak var estrela3: UIImageView!
    @IBOutlet weak var estrela4: UIImageView!
    @IBOutlet weak var timerImage: UIImageView!
    @IBOutlet weak var tempoEsperaLabel: UILabel!
    @IBOutlet weak var tempoTotalImage: UIImageView!
    @IBOutlet weak var tempoTotalLabel: UILabel!
    @IBOutlet weak var tempoRestanteImage: UIImageView!
    @IBOutlet weak var tempoRestanteLabel: UILabel!
    @IBOutlet weak var tempoChegadaImage: UIImageView!
    @IBOutlet weak var tempoChegadaLabel: UILabel!
    @IBOutlet weak var memoriaImage: UIImageView!
    @IBOutlet weak var memoriaInfoLabel: UILabel!
    @IBOutlet weak var endInicialLabel: UILabel!
    @IBOutlet weak var endFinalLabel: UILabel!
    @IBOutlet weak var ioImage: UIImageView!
    @IBOutlet weak var ioLabel: UILabel!
    
    
    //Variaveis DEFINE
    var memoriaTotal = 0
    var memoriaSO = 0
    var memoriaRestante = 0
    var processosCollection:[ProcessoView] = []
    var processosPage:[ProcessoView] = []
    var celulasPraZerar = 0
    var carregandoCelulas = 0
    var paginaCollection = 1
    var ListaProcessos = [Processo]()
    var fila1:[Processo] = []
    var fila2:[Processo] = []
    var fila3:[Processo] = []
    var fila4:[Processo] = []
    var filaBloqueados:[Processo] = []
    var tempoDeBloqueado = 3
    //Tempo restante das filas quando estao executando
    var tempRestF2 = 0
    var tempRestF3 = 0
    var tempRestF4 = 0
    var numProcessosRestantes = 0
    
    //variavais q era da ExecutaProcessos
    var tempoAtual = 0 //clock de 1 em 1 unidade de tempo
    var aSerEncaminhado:[Processo] = []
    
    var filaProcessosSemMemoria:[Processo] = []
    var jaFoiEmAlgumaFila = false
    
    var somaDeTempos = 0
    var numDeSomas = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewXBtt.isHidden = true
        zerar((Any).self)
        mudaAlphaInfoView(result: 0.0)
        escondeInfoView(result: true)
        
        //Adicionando gesture
        let arrastaEsquerda = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        arrastaEsquerda.direction = UISwipeGestureRecognizerDirection.left
        self.collectionView.addGestureRecognizer(arrastaEsquerda)

        let arrastaDireita = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        arrastaDireita.direction = UISwipeGestureRecognizerDirection.right
        self.collectionView.addGestureRecognizer(arrastaDireita)
        
        let arrastaBaixo = UISwipeGestureRecognizer(target: self, action: #selector(swipeActionInfo(swipe:)))
        arrastaBaixo.direction = UISwipeGestureRecognizerDirection.down
        self.infoView.addGestureRecognizer(arrastaBaixo)

    }
    
    func escondeInfoView(result: Bool){
        viewXBtt.isHidden = result
        processoInfoView.isHidden = result
        statusView.isHidden = result
        estrela1.isHidden = result
        estrela2.isHidden = result
        estrela3.isHidden = result
        estrela4.isHidden = result
        timerImage.isHidden = result
        tempoEsperaLabel.isHidden = result
        tempoTotalImage.isHidden = result
        tempoTotalLabel.isHidden = result
        tempoRestanteImage.isHidden = result
        tempoRestanteLabel.isHidden = result
        tempoChegadaImage.isHidden = result
        tempoChegadaLabel.isHidden = result
        memoriaImage.isHidden = result
        memoriaInfoLabel.isHidden = result
        endInicialLabel.isHidden = result
        endFinalLabel.isHidden = result
        ioImage.isHidden = result
        ioLabel.isHidden = result
    }
    
    func mudaAlphaInfoView(result: CGFloat){
        viewXBtt.alpha = result
        processoInfoView.alpha = result
        statusView.alpha = result
        estrela1.alpha = result
        estrela2.alpha = result
        estrela3.alpha = result
        estrela4.alpha = result
        timerImage.alpha = result
        tempoEsperaLabel.alpha = result
        tempoTotalImage.alpha = result
        tempoTotalLabel.alpha = result
        tempoRestanteImage.alpha = result
        tempoRestanteLabel.alpha = result
        tempoChegadaImage.alpha = result
        tempoChegadaLabel.alpha = result
        memoriaImage.alpha = result
        memoriaInfoLabel.alpha = result
        endInicialLabel.alpha = result
        endFinalLabel.alpha = result
        ioImage.alpha = result
        ioLabel.alpha = result
    }
    
    func configuracaoInicial(){
        
        processosCollection.removeAll()
        processosPage.removeAll()
        tableViewFilas.reloadData()
        
        
        //Preparando informações
        tempoAtual = 0 //clock de 1 em 1 unidade de tempo
        aSerEncaminhado = []
        
        fila1.removeAll()
        fila2.removeAll()
        fila3.removeAll()
        fila4.removeAll()
        filaBloqueados.removeAll()
        
        filaProcessosSemMemoria = []
        jaFoiEmAlgumaFila = false
        
        if numProcessosRestantes > 0 {
            proximoPassoBtt.isEnabled = true
            paraOFimBtt.isEnabled = true
        }
        
        somaDeTempos = 0
        numDeSomas = 0
    }
    
    func executaProcesso(){
        
        logTextView.text = logTextView.text + "\nT\(tempoAtual)\n"
        
        jaFoiEmAlgumaFila = false
        
        aSerEncaminhado.removeAll()
        for processo in ListaProcessos{
            if processo.tempoChegada == tempoAtual { //se o processo chegar neste instante
                aSerEncaminhado.append(processo)
            }
        }
        logTextView.text = logTextView.text + "Processos que chegaram agora: \(aSerEncaminhado.count)\n"
        logTextView.text = logTextView.text + "Processos esperando memória para serem executados: \(filaProcessosSemMemoria.count)\n"
        
        //Verificacao se tem alguem esperando memoria para ser executado
        if filaProcessosSemMemoria.count > 0 {
            for processoMemoria in filaProcessosSemMemoria {
                if processoMemoria.memoria <= memoriaRestante {
                    print("----Processo \(processoMemoria.nome) saiu da fila dos SEM MEMORIA - T\(tempoAtual)")
                    let index = pegaIndex(lista: filaProcessosSemMemoria, objeto: processoMemoria)
                    filaProcessosSemMemoria.remove(at: index)
                    encaminhaFila(processo: processoMemoria)
                } else {
                    break
                    //So vai rodar se tiver memoria pro primeiro que está esperando, e assim sucetivamente
                }
            }
        }
        
        for processoEncaminhado in aSerEncaminhado {
            if processoEncaminhado.memoria <= memoriaRestante {
                encaminhaFila(processo: processoEncaminhado)
            } else {
                filaProcessosSemMemoria.append(processoEncaminhado)
                logTextView.text = logTextView.text + "NoMemory - Processo \(processoEncaminhado.nome) movido para fila de espera\n"
            }
        }
        
        if filaBloqueados.count > 0 {
            for bloc in filaBloqueados {
                if bloc.tempoIO == tempoDeBloqueado{
                    bloc.status = 1
                    switch bloc.prioridade {
                    case 1:
                        fila4.append(bloc)
                        let index = pegaIndex(lista: filaBloqueados, objeto: bloc)
                        filaBloqueados.remove(at: index)
                        break
                    case 2:
                        fila3.append(bloc)
                        let index = pegaIndex(lista: filaBloqueados, objeto: bloc)
                        filaBloqueados.remove(at: index)
                        break
                    case 3:
                        fila2.append(bloc)
                        let index = pegaIndex(lista: filaBloqueados, objeto: bloc)
                        filaBloqueados.remove(at: index)
                        break
                    case 4:
                        fila1.append(bloc)
                        let index = pegaIndex(lista: filaBloqueados, objeto: bloc)
                        filaBloqueados.remove(at: index)
                        break
                    default: break
                    }
                } else {
                    bloc.tempoIO += 1
                }
            }
        }
        
        //Chamada pra execucao com tempo restante de quantum
        if tempRestF2 > 0 {
            if fila2.count > 0{
                executaFila2()
                jaFoiEmAlgumaFila = true
            }
        } else if tempRestF3 > 0 {
            if fila3.count > 0{
                executaFila3()
                jaFoiEmAlgumaFila = true
            }
        } else if tempRestF4 > 0{
            if fila4.count > 0{
                executaFila4()
                jaFoiEmAlgumaFila = true
            }
        }
        
        //chamada pra execucao sem quantum de tempo restante
        if !jaFoiEmAlgumaFila {
            //ou seja, nenhuma fila tem quanto restante para ser executado
            if fila1.count > 0 {
                executaFila1()
                jaFoiEmAlgumaFila = true
            } else if fila2.count > 0{
                tempRestF2 = 2
                executaFila2()
                jaFoiEmAlgumaFila = true
            } else if fila3.count > 0{
                tempRestF3 = 4
                executaFila3()
                jaFoiEmAlgumaFila = true
            } else if fila4.count > 0{
                tempRestF4 = 8
                executaFila4()
                jaFoiEmAlgumaFila = true
            } else {
                logTextView.text = logTextView.text + "Nenhum processo foi executado\n"
                processosCollection.append(ProcessoView(nome: "Z", status: 0, color: "008577"))
            }
        }
        
        tempoAtual += 1
        aumentaEspera()
        
        self.atualizaTimeLine()
        self.tableViewFilas.reloadData()
        logTextView.scrollsToTop = false
        let bottom = logTextView.contentSize.height
        logTextView.setContentOffset(CGPoint(x: 0, y: bottom), animated: true)
        logTextView.textColor = UIColor.white
    }
    
    func executaFila1(){ //Fila 1 => Prioridade 4; Quantum 1
        let processoEmExecucao = fila1[0]
        print("***Executando fila 1 o processo \(processoEmExecucao.nome)")
        processoEmExecucao.status = 0
        processoEmExecucao.tempoBurstRestante -= 1
        processoEmExecucao.tempoEspera -= 1
        
        logTextView.text = logTextView.text + "Processo \(processoEmExecucao.nome) em execução\n"
        
        var foiProIO = false
        //verifica se tem Entrada e saida neste momento
        if processoEmExecucao.ioBound.count > 0 {
            let tempoProcessoAgora = processoEmExecucao.tempoBurst - processoEmExecucao.tempoBurstRestante
            var index = 0
            for temps in processoEmExecucao.ioBound{
                if temps == tempoProcessoAgora{
                    // Significa q o processo vai esperar uma entrada!
                    //Como não tem como ele subir de prioridade, quando voltar, estará na mesma prioridade
                    processoEmExecucao.status = 2
                    processoEmExecucao.ioBound.remove(at: index)
                    logTextView.text = logTextView.text + "Processo \(processoEmExecucao.nome) solicitou entrada e saída\n"
                    processosCollection.append(ProcessoView(nome: processoEmExecucao.nome, status: 2, color: processoEmExecucao.color))
                    processoEmExecucao.tempoIO = 0
                    filaBloqueados.append(processoEmExecucao)
                    fila1.removeFirst()
                    foiProIO = true
                    break
                }
                index += 1
            }
        }
        if !foiProIO {
            //verificacao se acabou
            if processoEmExecucao.tempoBurstRestante == 0 {
                processoEmExecucao.status = 3
                processosCollection.append(ProcessoView(nome: processoEmExecucao.nome, status: 1, color: processoEmExecucao.color))
                processoFinalizado(processo: processoEmExecucao)
                fila1.removeFirst()
                numProcessosRestantes -= 1
            } else {
                //Como essa é a fila 1, a prioridade é 4, então ele caiu 1 e vai pra fila de prioridade 3
                processoEmExecucao.prioridade -= 1
                processoEmExecucao.status = 1
                processosCollection.append(ProcessoView(nome: processoEmExecucao.nome, status: 0, color: processoEmExecucao.color))
                fila2.append(processoEmExecucao)
                fila1.removeFirst()
            }
        }
    }
    
    func executaFila2(){ //Fila 2 => Prioridade 3; Quantum 2
        let processoEmExecucao = fila2[0]
        print("***Executando fila 2 o processo \(processoEmExecucao.nome)")
        processoEmExecucao.status = 0
        processoEmExecucao.tempoBurstRestante -= 1
        processoEmExecucao.tempoEspera -= 1
        
        logTextView.text = logTextView.text + "Processo \(processoEmExecucao.nome) em execução\n"
        
        //verifica se tem IO neste momento
        var foiProIO = false
        if processoEmExecucao.ioBound.count > 0 {
            let tempoProcessoAgora = processoEmExecucao.tempoBurst - processoEmExecucao.tempoBurstRestante
            var index = 0
            for temps in processoEmExecucao.ioBound{
                if temps == tempoProcessoAgora{
                    foiProIO = true
                    // Significa q o processo vai esperar uma entrada ou saída! Portanto, vai subir de prioridade
                    processoEmExecucao.prioridade += 1
                    processoEmExecucao.status = 2
                    processoEmExecucao.ioBound.remove(at: index)
                    logTextView.text = logTextView.text + "Processo \(processoEmExecucao.nome) solicitou entrada e saída\n"
                    processosCollection.append(ProcessoView(nome: processoEmExecucao.nome, status: 2, color: processoEmExecucao.color))
                    processoEmExecucao.tempoIO = 0
                    filaBloqueados.append(processoEmExecucao)
                    fila2.removeFirst()
                    tempRestF2 = 0
                    break
                }
                index += 1
            }
        }
        if !foiProIO {
            //verificacao se acabou
            if processoEmExecucao.tempoBurstRestante == 0 {
                processoEmExecucao.status = 3
                processosCollection.append(ProcessoView(nome: processoEmExecucao.nome, status: 1, color: processoEmExecucao.color))
                processoFinalizado(processo: processoEmExecucao)
                tempRestF2 = 0
                fila2.removeFirst()
                numProcessosRestantes -= 1
            } else {
                //verifica se ainda da pra continuar executando ou ja vai cair de fila...
                tempRestF2 -= 1
                processosCollection.append(ProcessoView(nome: processoEmExecucao.nome, status: 0, color: processoEmExecucao.color))
                if tempRestF2 == 0 {
                    processoEmExecucao.prioridade -= 1
                    processoEmExecucao.status = 1
                    fila3.append(processoEmExecucao)
                    fila2.removeFirst()
                }
            }
        }
    }
    
    func executaFila3(){ //Fila 3 => Prioridade 2; Quantum 4
        let processoEmExecucao = fila3[0]
        print("***Executando fila 3 o processo \(processoEmExecucao.nome)")
        processoEmExecucao.status = 0
        processoEmExecucao.tempoBurstRestante -= 1
        processoEmExecucao.tempoEspera -= 1
        
        logTextView.text = logTextView.text + "Processo \(processoEmExecucao.nome) em execução\n"
        
        //verifica se tem Entrada e saida neste momento
        var foiProIO = false
        if processoEmExecucao.ioBound.count > 0 {
            let tempoProcessoAgora = processoEmExecucao.tempoBurst - processoEmExecucao.tempoBurstRestante
            var index = 0
            for temps in processoEmExecucao.ioBound{
                if temps == tempoProcessoAgora{
                    foiProIO = true
                    // Significa q o processo vai esperar uma entrada ou saída! Portanto, vai subir de prioridade
                    processoEmExecucao.prioridade += 1
                    processoEmExecucao.status = 2
                    processoEmExecucao.ioBound.remove(at: index)
                    logTextView.text = logTextView.text + "Processo \(processoEmExecucao.nome) solicitou entrada e saída\n"
                    processosCollection.append(ProcessoView(nome: processoEmExecucao.nome, status: 2, color: processoEmExecucao.color))
                    processoEmExecucao.tempoIO = 0
                    filaBloqueados.append(processoEmExecucao)
                    fila3.removeFirst()
                    tempRestF3 = 0
                    break
                }
                index += 1
            }
        }
        if !foiProIO {
            //verificacao se acabou
            if processoEmExecucao.tempoBurstRestante == 0 {
                processoEmExecucao.status = 3
                processosCollection.append(ProcessoView(nome: processoEmExecucao.nome, status: 1, color: processoEmExecucao.color))
                processoFinalizado(processo: processoEmExecucao)
                tempRestF3 = 0
                fila3.removeFirst()
                numProcessosRestantes -= 1
            } else {
                //verifica se ainda da pra continuar executando ou ja vai cair de fila...
                tempRestF3 -= 1
                processosCollection.append(ProcessoView(nome: processoEmExecucao.nome, status: 0, color: processoEmExecucao.color))
                if tempRestF3 == 0 {
                    processoEmExecucao.prioridade -= 1
                    processoEmExecucao.status = 1
                    fila4.append(processoEmExecucao)
                    fila3.removeFirst()
                }
            }
        }
    }
    
    func executaFila4(){ //Fila 4 => Prioridade 1; Quantum 8
        let processoEmExecucao = fila4[0]
        print("***Executando fila 4 o processo \(processoEmExecucao.nome)")
        processoEmExecucao.status = 0
        processoEmExecucao.tempoBurstRestante -= 1
        processoEmExecucao.tempoEspera -= 1
        
        logTextView.text = logTextView.text + "Processo \(processoEmExecucao.nome) em execução\n"
        
        //Verifica se tem IO pra agora
        var foiProIO = false
        if processoEmExecucao.ioBound.count > 0 {
            let tempoProcessoAgora = processoEmExecucao.tempoBurst - processoEmExecucao.tempoBurstRestante
            var index = 0
            for temps in processoEmExecucao.ioBound{
                if temps == tempoProcessoAgora{
                    foiProIO = true
                    // Significa q o processo vai esperar uma entrada ou saída! Portanto, vai subir de prioridade
                    processoEmExecucao.prioridade += 1
                    processoEmExecucao.status = 2
                    processoEmExecucao.ioBound.remove(at: index)
                    logTextView.text = logTextView.text + "Processo \(processoEmExecucao.nome) solicitou entrada e saída\n"
                    processosCollection.append(ProcessoView(nome: processoEmExecucao.nome, status: 2, color: processoEmExecucao.color))
                    processoEmExecucao.tempoIO = 0
                    filaBloqueados.append(processoEmExecucao)
                    fila4.removeFirst()
                    tempRestF4 = 0
                    break
                }
                index += 1
            }
        }
        if !foiProIO {
            //verificacao se acabou
            if processoEmExecucao.tempoBurstRestante == 0 {
                processoEmExecucao.status = 3
                processosCollection.append(ProcessoView(nome: processoEmExecucao.nome, status: 1, color: processoEmExecucao.color))
                processoFinalizado(processo: processoEmExecucao)
                tempRestF4 = 0
                fila4.removeFirst()
                numProcessosRestantes -= 1
            } else {
                //verifica se ainda da pra continuar executando ou ja vai cair de fila...
                tempRestF4 -= 1
                processosCollection.append(ProcessoView(nome: processoEmExecucao.nome, status: 0, color: processoEmExecucao.color))
                if tempRestF4 == 0 {
                    // Como não tem como diminuir a prioridade, ele vai apenas pro fim da fila
                    processoEmExecucao.status = 1
                    fila4.removeFirst()
                    fila4.append(processoEmExecucao)
                }
            }
        }
    }
    
    func encaminhaFila(processo:Processo){
        /*FILAS:
         Fila1 = Prioridade 4
         Fila2 = Prioridade 3
         Fila3 = Prioridade 2
         Fila4 = Prioridade 1
         */
        switch processo.prioridade {
        case 1:
            fila4.append(processo)
            logTextView.text = logTextView.text + "\(processo.nome) movido para FILA 4\n"
            print("#####Processo \(processo.nome) movido pra fila 4")
            break
        case 2:
            fila3.append(processo)
            logTextView.text = logTextView.text + "\(processo.nome) movido para FILA 3\n"
            print("#####Processo \(processo.nome) movido pra fila 3")
            break
        case 3:
            fila2.append(processo)
            logTextView.text = logTextView.text + "\(processo.nome) movido para FILA 2\n"
            print("#####Processo \(processo.nome) movido pra fila 2")
            break
        case 4:
            fila1.append(processo)
            logTextView.text = logTextView.text + "\(processo.nome) movido para FILA 1\n"
            print("#####Processo \(processo.nome) movido pra fila 1")
            break
        default: break
        }
        
        //removendo da fila geral de processos
        let index = pegaIndex(lista: ListaProcessos, objeto: processo)
        ListaProcessos.remove(at: index)
        
        //Setando os enderecos de memoria dos processos
        processo.armazenamentoInicial = (memoriaTotal-memoriaRestante)
        processo.armazenamentoFinal = processo.armazenamentoInicial + (processo.memoria - 1)
        
        //Atualizacao da memoria
        memoriaRestante -= processo.memoria
        atualizaMemoriaViews()
    }
    
    func pegaIndex(lista:[Processo], objeto: Processo) -> Int{
        var index = 0
        for proces in lista{
            if proces.nome == objeto.nome{
                return index
            }
            index += 1
        }
        return -1
    }
    
    func aumentaEspera(){
        for process in fila1 {
            process.tempoEspera += 1
        }
        for process in fila2 {
            process.tempoEspera += 1
        }
        for process in fila3 {
            process.tempoEspera += 1
        }
        for process in fila4 {
            process.tempoEspera += 1
        }
        for process in filaBloqueados {
            process.tempoEspera += 1
        }
    }
    
    func processoFinalizado(processo: Processo){
        logTextView.text = logTextView.text + "Processo \(processo.nome) finalizado\n"
        memoriaRestante += processo.memoria
        
        // soma todo o tempo de espera dele pro geral
        somaDeTempos += (processo.tempoEspera + 1)
        numDeSomas += 1
        
        // atualizando os enderecos dos processos
        for proc in fila1 {
            if proc.armazenamentoInicial > processo.armazenamentoFinal {
                proc.armazenamentoFinal -= processo.memoria
                proc.armazenamentoInicial -= processo.memoria
            }
        }
        
        for proc in fila2 {
            if proc.armazenamentoInicial > processo.armazenamentoFinal {
                proc.armazenamentoFinal -= processo.memoria
                proc.armazenamentoInicial -= processo.memoria
            }
        }
        
        for proc in fila3 {
            if proc.armazenamentoInicial > processo.armazenamentoFinal {
                proc.armazenamentoFinal -= processo.memoria
                proc.armazenamentoInicial -= processo.memoria
            }
        }
        
        for proc in fila4 {
            if proc.armazenamentoInicial > processo.armazenamentoFinal {
                proc.armazenamentoFinal -= processo.memoria
                proc.armazenamentoInicial -= processo.memoria
            }
        }
        atualizaMemoriaViews()
    }
    
    func atualizaMemoriaViews(){
        memoriaLabel.text = "Memória - \(memoriaTotal)K"
        
        SOLabel.text = "Sistema Operacional - \(memoriaSO)K"
        let porcentagemSo = (memoriaSO * 100) / memoriaTotal
        porcentagemSOLabel.text = "\(porcentagemSo)%"
        let tamanhoSo = CGFloat((700*porcentagemSo)/100)
        
        aplicacoesLabel.text = "Aplicações - \(memoriaTotal-memoriaSO-memoriaRestante)K"
        let porcentagemAplic = (memoriaTotal-memoriaSO-memoriaRestante) * 100 / memoriaTotal
        porcentagemAplicacoesLabel.text = "\(porcentagemAplic)%"
        let tamanhoAplic = CGFloat((700*porcentagemAplic)/100)
        
        livreLabel.text = "Livre - \(memoriaRestante)K"
        let porcentagemLivre = (memoriaRestante * 100) / memoriaTotal
        porcentagemLivreLabel.text = "\(porcentagemLivre)%"
        
        
        view.layoutIfNeeded()
        
//        UIView.animate(withDuration: 1) {
//            self.imageView.frame = CGRect(x: self.imageView.frame.origin.x, y: self.imageView.frame.origin.y, width: self.imageView.frame.width + 100, height: self.imageView.frame.height)
//        }
        
        
        UIView.animate(withDuration: 1.0) {
            if self.soView.frame.width != tamanhoSo {
                self.SoViewConstraint.constant = tamanhoSo
                self.soView.frame = CGRect(x: self.soView.frame.origin.x, y: self.soView.frame.origin.y, width: tamanhoSo, height: self.soView.frame.height)
            }
            if self.aplicacoesView.frame.width != tamanhoAplic{
                self.aplicacoesViewConstraint.constant = tamanhoAplic
                self.aplicacoesView.frame = CGRect(x: self.aplicacoesView.frame.origin.x, y: self.aplicacoesView.frame.origin.y, width: tamanhoAplic, height: self.aplicacoesView.frame.height)
//                self.aplicacoesView.frame = CGRect(x: 0, y: 47, width: porcentagemAplic, height: 60)
            }
//            if self.livreViewConstraint.constant != CGFloat(tamanhoLivre){
////                self.livreViewConstraint.constant = CGFloat(porcentagemLivre)
//                self.livreView.frame = CGRect(x: self.livreView.frame.origin.x, y: self.livreView.frame.origin.y, width: tamanhoLivre, height: self.livreView.frame.height)
//                print("animaLivre")
////                self.livreView.frame = CGRect(x: 0, y: 47, width: porcentagemLivre , height: 60)
//            }
        }
        
    }
    
    func atualizaTimeLine(){
        
        if paginaCollection*8+1 <= processosCollection.count{
            proximaPagina.isEnabled = true
        } else {
            proximaPagina.isEnabled = false
        }
        
        if paginaCollection != 1 {
            anteriorpagina.isEnabled = true
        } else {
            anteriorpagina.isEnabled = false
        }
        
        processosPage.removeAll()
        
        let indexInicial = (paginaCollection - 1)*8
        for index in indexInicial...indexInicial+7 {
            if index < processosCollection.count{
                processosPage.append(processosCollection[index])
            }
        }
        carregandoCelulas = 0
        celulasPraZerar = 0
        collectionView.reloadData()
        
    }
    
    @objc func swipeAction(swipe: UISwipeGestureRecognizer){
        print("****************** GESTO")
        switch swipe.direction.rawValue {
        case 1:
            if anteriorpagina.isEnabled {
                anteriorPaginaCollection((Any).self)
            }
            break
            
        case 2:
            if proximaPagina.isEnabled {
                proximaPaginaCollection((Any).self)
            }
            break
        default: break
            //do nothing
        }
    }
    
    @objc func swipeActionInfo(swipe: UISwipeGestureRecognizer){
        print("****************** GESTO INFO")
        switch swipe.direction{
        case UISwipeGestureRecognizerDirection.down:
            if infoView.frame.height == CGFloat(344) {
                fecharInfo((Any).self)
            }
            break
        default: break
            //do nothing
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //DELEGATE COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calculaNumCelulas()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollection", for: indexPath) as! ProcessoCollectionViewCell
        
        cell.statusImage.image = nil
        
        if celulasPraZerar == 0 && carregandoCelulas < processosPage.count{
            let nome = processosPage[carregandoCelulas].nome
            let status = processosPage[carregandoCelulas].status
            if nome == "Z" {
                cell.nomeProcessoLabel.text = "-"
                cell.nomeProcessoLabel.textColor = UIColor.black
                cell.processoView.isHidden = true
            } else {
                cell.nomeProcessoLabel.text = nome
                cell.nomeProcessoLabel.textColor = UIColor.white
                cell.processoView.backgroundColor = UIColor(hexString: processosPage[carregandoCelulas].color)
//                cell.processoView.tintColor = UIColor(red: CGFloat(Float(processosPage[carregandoCelulas].color[0])), green: CGFloat(processosPage[carregandoCelulas].color[1]), blue: CGFloat(processosPage[carregandoCelulas].color[2]), alpha: 1.0)
//                let cor = UIColor(
//
//                cell.processoView.backgroundColor = UIColor(red: CGFloat(r), green: g, blue: b, alpha: 0.5)
//                cell.processoView.backgroundColor = UIColor(red: CGFloat(processosPage[carregandoCelulas].color[0]), green: CGFloat(processosPage[carregandoCelulas].color[1]), blue: CGFloat(processosPage[carregandoCelulas].color[2]), alpha: 0.0)
                cell.processoView.isHidden = false
                if status == 1 { //processo concluido
                    cell.statusImage.image = UIImage(named: "concluido")
                } else if status == 2{
                    cell.statusImage.image = UIImage(named: "clock")
                }
            }
            if carregandoCelulas < processosPage.count-1 {
                if processosPage[carregandoCelulas+1].nome != processosPage[carregandoCelulas].nome{
                    celulasPraZerar = 8
                }
            }
            carregandoCelulas += 1
        } else {
            cell.nomeProcessoLabel.text = ""
            cell.processoView.isHidden = true
            celulasPraZerar -= 1
        }
        return cell
    }
    
    func calculaNumCelulas() -> Int{
        var result = 0
        var count = 0
        for processo in processosPage{
            result += 1
            if count < processosPage.count-1{
                if processo.nome != processosPage[count+1].nome{
                    result += 8
                }
            }
            count += 1
        }
        print("NUM DE CELULAS: \(result)")
        if result % 8 != 0{
            while result % 8 != 0{
                result += 1
            }
        }
        return result
    }
    
    //DELEGATE TABLEVIEW
    
    func pegaTamanhoFilas()->Int{
        
        infoTableLabel.isHidden = false
        
        switch escolhaDeFilas.selectedSegmentIndex {
        case 0: //Fila 1
            if fila1.count > 0 {
                infoTableLabel.isHidden = true
            }
            return fila1.count
        case 1: //Fila 2
            if fila2.count > 0 {
                infoTableLabel.isHidden = true
            }
            return fila2.count
        case 2: //Fila 3
            if fila3.count > 0 {
                infoTableLabel.isHidden = true
            }
            return fila3.count
        case 3: //Fila 4
            if fila4.count > 0 {
                infoTableLabel.isHidden = true
            }
            return fila4.count
        case 4: //Fila Block
            if filaBloqueados.count > 0 {
                infoTableLabel.isHidden = true
            }
            return filaBloqueados.count
        default:
            return 0
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pegaTamanhoFilas()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTable", for: indexPath) as! ListaTableViewCell
        
        var processoDaVez:Processo = Processo(nome: "", tempoBurst: 0, tempoBurstRestante: 0, memoria: 0, armazenamentoInicial: 0, armazenamentoFinal: 0, status: 0, prioridade: 0, ioBound: [], tempoIO: 0, tempoEspera: 0, tempoChegada: 0, color: "")
        var ehBlock = false
        
        switch escolhaDeFilas.selectedSegmentIndex {
        case 0: //Fila 1
            if fila1.count > 0 {
                processoDaVez = fila1[indexPath.row]
            }
            break
        case 1: //Fila 2
            if fila2.count > 0 {
                processoDaVez = fila2[indexPath.row]
            }
            break
        case 2: //Fila 3
            if fila3.count > 0 {
                processoDaVez = fila3[indexPath.row]
            }
            break
        case 3: //Fila 4
            if fila4.count > 0 {
                processoDaVez = fila4[indexPath.row]
            }
            break
        case 4: //Fila Block
            if filaBloqueados.count > 0 {
                processoDaVez = filaBloqueados[indexPath.row]
            }
            ehBlock = true
            break
        default:
            break
        }
        
        cell.processoView.backgroundColor = UIColor(hexString: processoDaVez.color)
        cell.nomeProcessoLabel.text = processoDaVez.nome
        cell.label1.text = "Burst Restante: \(processoDaVez.tempoBurstRestante)"
        cell.label2.text = "Memória: \(processoDaVez.memoria)K"
        if ehBlock{
            cell.label3.text = "Tempo Restante: \(tempoDeBloqueado-processoDaVez.tempoIO)"
        } else {
            cell.label3.text = "Tempo de Chegada: \(processoDaVez.tempoChegada)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var processoDaVez:Processo = Processo(nome: "", tempoBurst: 0, tempoBurstRestante: 0, memoria: 0, armazenamentoInicial: 0, armazenamentoFinal: 0, status: 0, prioridade: 0, ioBound: [], tempoIO: 0, tempoEspera: 0, tempoChegada: 0, color: "")
        
        switch escolhaDeFilas.selectedSegmentIndex {
        case 0: //Fila 1
            processoDaVez = fila1[indexPath.row]
            break
        case 1: //Fila 2
            processoDaVez = fila2[indexPath.row]
            break
        case 2: //Fila 3
            processoDaVez = fila3[indexPath.row]
            break
        case 3: //Fila 4
            processoDaVez = fila4[indexPath.row]
            break
        case 4: //Fila Block
            processoDaVez = filaBloqueados[indexPath.row]
            break
        default:
            break
        }
        
        processoInfoView.backgroundColor = UIColor(hexString: processoDaVez.color)
        processoNomeInfoLabel.text = processoDaVez.nome
        let status = processoDaVez.status
        switch status {
        case 0: //em execucao
            statusView.backgroundColor = UIColor(hexString: "ECCE46")
            break
        case 1: //pronto
            statusView.backgroundColor = UIColor(hexString: "437729")
            break
        case 2: //bloqueado
            statusView.backgroundColor = UIColor(hexString: "CE3824")
            break
        case 3: //finalizado
            statusView.backgroundColor = UIColor(hexString: "285B93")
            break
        default:
            break
        }
        let prioridade = processoDaVez.prioridade
        estrela1.image = UIImage(named: "comPrioridade")
        estrela2.image = UIImage(named: "comPrioridade")
        estrela3.image = UIImage(named: "comPrioridade")
        estrela4.image = UIImage(named: "comPrioridade")
        switch prioridade {
        case 3:
            estrela4.image = UIImage(named: "semPrioridade")
            break
        case 2:
            estrela4.image = UIImage(named: "semPrioridade")
            estrela3.image = UIImage(named: "semPrioridade")
            break
        case 1:
            estrela4.image = UIImage(named: "semPrioridade")
            estrela3.image = UIImage(named: "semPrioridade")
            estrela2.image = UIImage(named: "semPrioridade")
            break
        default:
            break
        }
        tempoEsperaLabel.text = "\(processoDaVez.tempoEspera)"
        tempoTotalLabel.text = "Tempo total de Burst: \(processoDaVez.tempoBurst)"
        tempoRestanteLabel.text = "Tempo restante de Burst: \(processoDaVez.tempoBurstRestante)"
        tempoChegadaLabel.text = "Chegou no instante \(processoDaVez.tempoChegada)"
        memoriaInfoLabel.text = "Espaço de memória necessário: \(processoDaVez.memoria)K"
        endInicialLabel.text = "Endereço inicial: \(processoDaVez.armazenamentoInicial)"
        endFinalLabel.text = "Final: \(processoDaVez.armazenamentoFinal)"
        if processoDaVez.ioBound.count == 0 {
            ioLabel.text = "Nenhuma entrada e saída"
        } else {
            ioLabel.text = "Entrada e saída: \(processoDaVez.ioBound)"
        }
        

        escondeInfoView(result: false) //faz o hide ficar false
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            let height = 344
            self.infoView.frame = CGRect(x: self.infoView.frame.origin.x, y: self.infoView.frame.origin.y - CGFloat(height), width: self.infoView.frame.width, height: CGFloat(height))
        }) { (true) in
            UIView.animate(withDuration: 0.3, animations: {
                self.mudaAlphaInfoView(result: 1.0)
            })
        }
        tableViewFilas.deselectRow(at: indexPath, animated: true)
        tableViewFilas.allowsSelection = false
    }


}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

