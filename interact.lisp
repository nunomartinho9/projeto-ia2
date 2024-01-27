;; Funções que permitem escrever e ler em ficheiros e tratar da interação com o utilizador
;; Autores: Nuno Martinho, João Coelho e João Barbosa
;; Ano letivo 23/24

(defun diretorio ()
    "C:/Users/joaor/OneDrive/Documentos/IPS/ESTS/LEI/3_ANO/IA/Projeto/ia-projeto2/"
;;    "U:/Documents/LEI/AnoCorrente/ia/PROJETO/" ;altera a pasta para o novo diretorio
)

(compile-file (concatenate 'string (diretorio) "algoritmo.lisp"))
(compile-file (concatenate 'string (diretorio) "jogo.lisp"))
(load (concatenate 'string (diretorio) "algoritmo.lisp"))
(load (concatenate 'string (diretorio) "jogo.lisp"))


;; ============= INICIAR =============

(defun iniciar ()
"Inicializa o programa."
    (progn
        (menu-inicial)
        (let ((opcao (read)))
            (case opcao
                ('1 
                    (progn 
                        (modo-hvc)
                        (iniciar)
                ))
                ('2
                    (progn
                        (modo-cvc)
                        (iniciar)
                ))
                ('0 
                    (progn
                        (finish-output)
                        (clear-output)
                        (format t "Obrigado por jogar!~%~%")
                ))
                (otherwise (progn (format t "Escolha uma opcao valida!") (iniciar)))    
            )
        )
    )
)


;; ============= INTERACAO =============

;; <no>::= (<tabuleiro> <pai> <f> pontos1 pontos2)
;; <jogada>::= (<jogador> <linha> <coluna>)
;; <solucao>::= (<no-jogada> (<nos-analisados> <n-cortes> <tempo-gasto>))
;; ((<tabuleiro> <jogada>) (<tabuleiro> <jogada>) (<tabuleiro> <jogada>) (<tabuleiro> <jogada>))


(defun modo-hvc ()
"Executa o modo de jogo Humano vs Computador."
    (let* (
            (iniciante (opcao-iniciante))
            (tempo-limite (opcao-tempo))
            (profund-max (opcao-profund-max))
        )
        (progn
            (escrever-log 'log-inicio '("Humano vs CPU" iniciante tempo-limite profund-max))
            (case iniciante
                ('1 (hvc tempo-limite profund-max -2))
                ('2 (hvc tempo-limite profund-max -1))
            )
        )
    )
)

(defun modo-cvc ()
"Executa o modo de jogo Computador vs Computador."
    (let* (
            (tempo-limite (opcao-tempo))
            (profund-max (opcao-profund-max))
        )
        (progn
            (escrever-log 'log-inicio '("CPU vs CPU" nil tempo-limite))
            (cvc tempo-limite profund-max -1)
            (log-fim)
        ) 
    )
)

;; <no>::= (<tabuleiro> <pai> <f> pontos1 pontos2) ;; f -> funcao-avaliacao
;; <jogada>::= (<jogador> <linha> <coluna>)
;; <solucao>::= (<no-jogada> (<nos-analisados> <n-cortes> <tempo-gasto>))

;; Jogador 1 (CPU): -1 | Jogador 2 (Humano): -2

(defun hvc (tempo-limite profund-max jogador &optional (no-atual (criar-no (tabuleiro-aleatorio)))) ;; add fn construir-no ao optional 
"Executa o decorrer do jogo Humano vs CPU."
    (let* (
            (tabuleiro-atual (first no-atual))
            (humano-possiveis (length (gerar-sucessores no-atual -2)))
            (cpu-possiveis (length (gerar-sucesores no-atual -1)))
            (pontos-humano (fourth no-atual))
            (pontos-cpu (fifth no-atual))            
        )
        (cond ;;((and (eq jogadas-cpu 0) (eq jogadas-humano 0)) escrever-log 'log-fim no-atual)
              ((eq jogador -2) ;; jogada Humano
                (if (eq humano-possiveis 0)
                    (progn
                        (format t "~% Nao tem mais jogadas possiveis! ~%")
                        (hvc tempo-limite profund-max +1 no-atual)
                    )
                    (let* ((posicao-selecionada (opcao-coordenadas tabuleiro-atual))
                            (tabuleiro-jogada ()) ;; funcao colocar peca
                            (pontos-atuais-h (fourth no-atual))
                            (pontos-atuais-c (fifth no-atual))
                        )
                        (progn
                            (format t "~%~% Jogada na posicao (~a, ~a). ~%~%" (first posicao-jogada) (second posicao-jogada))
                            (escrever-ficheiro 'log-jogada '()) ;; todo - enviar dados log para funcao
                            (hvc tempo-limite profund-max +1 (criar-no tabuleiro-jogada nil pontos-atuais-h pontos-atuais-c))
                        )
                    )
                )
              )
              (t ;; jogada CPU
                ()
              )
        )
    )
)

(defun cvc (tempo-limite profund-max jogador &optional (no-atual ())) ;; add fn construir-no ao optional 
"Executa o decorrer do jogo CPU vs CPU."
    (let* (
            (tabuleiro-atual ())
            (jogadas-cpu1 (length (gerar-sucessores no-atual -1)))
            (jogadas-cpu2 (length (gerar-sucesores no-atual -2)))
        )
        (cond ;;(() escrever-log 'log-fim no-atual)
              (t ;; jogada CPU
                ()
              )
        )
    )
)

(defun opcao-iniciante ()
"Recebe do utilizador a opcao de quem inicia o jogo."
    (progn
        (menu-iniciante)
        (let ((opcao (read)))
            (case opcao
                ('1 'Humano)
                ('2 'CPU)
                ('0 (iniciar))
                (otherwise (progn (format t "Escolha uma opcao valida!") (opcao-iniciante)))    
            )
        )
    )
)

(defun opcao-tempo ()
"Recebe do utilizador o tempo limite para o computador jogar."
    (progn
        (menu-tempo)
        (let ((tempo (read)))
            (cond
                ((and (>= tempo 1000) (<= tempo 5000)) 
                    tempo
                )
                ((eq tempo 0) (opcao-iniciante))
                (otherwise (progn (format t "Escolha uma opcao valida!") (opcao-tempo)))    
            )
        )
    )
)

(defun opcao-profund-max ()
"Recebe um valor de profundidade maxima do utilizador."
    (progn 
        (profund-max-menu)
        (let ((profund-max (read)))
            (cond  
                ((> profund-max 0)
                    profund-max
                )
                ('0 (opcao-tempo))
                (t (progn (format t "Escolha uma opcao valida!") (opcao-profund-max)))
            )
        )
    )
)

(defun opcao-coordenadas ()
"Recebe do utilizador a posicao na qual ele pretende jogar."
    (progn
        (menu-jogada)
        (format t "~% Linha: ")
        (let ((linha (read)))
            (cond ((and (numberp linha) (>= linha 0) (<= linha 9))
                    (progn 
                        (format t " Coluna: ")
                        (let ((coluna (read)))
                            (cond ((and (numberp coluna) (>= coluna 0) (<= coluna 9))
                                    (list linha coluna)
                                )
                                (t (progn
                                    (format t "~% Posicao invalida. Tente novamente!")
                                    (opcao-coordenadas)
                                ))
                            )
                        )
                    )
                )
                (t (progn
                    (format t "~% Posicao invalida. Tente novamente!")
                    (opcao-coordenadas)
                ))
            )
        )
    )
)


;; ============= MENUS =============

(defun menu-inicial ()
"Mostra o menu inicial."
    (progn
        ;;(format t "~%A carregar jogo...~%")
        ;;(sleep 1)
        (format t "~%o                                                  o")
        (format t "~%|                - Jogo do Cavalo -                |")
        (format t "~%|                                                  |")
        (format t "~%|                1 - Humano vs CPU                 |")
        (format t "~%|                2 - CPU vs CPU                    |")
        (format t "~%|                                                  |")
        (format t "~%|                0 - Sair                          |")
        (format t "~%o                                                  o")
        (format t "~%~%>> ")
    )
)

(defun menu-iniciante ()
"Mostra o menu de escolha do jogador que começa o jogo."
    (progn
        (format t "~%o                                                  o")
        (format t "~%|          - Escolha quem começa o jogo -          |")
        (format t "~%|                                                  |")
        (format t "~%|                  1 - Humano                      |")
        (format t "~%|                  2 - CPU                         |")
        (format t "~%|                                                  |")
        (format t "~%|                  0 - Voltar                      |")
        (format t "~%o                                                  o")
        (format t "~%~%>> ")
    )
)

(defun menu-tempo ()
"Mostra o menu de escolha do tempo limite para a jogada do CPU."
    (progn
        (format t "~%o                                                  o")
        (format t "~%|  - Defina o tempo limite para a jogada do CPU -  |")
        (format t "~%|           (1000 a 5000 milissegundos)            |")
        (format t "~%|                                                  |")
        (format t "~%|                    0 - Voltar                    |")
        (format t "~%o                                                  o")
        (format t "~%~%>> ")
    )
)

(defun profund-max-menu ()
"Mostra uma mensagem para escolher a profundidade maxima."
    (progn
        (format t "~%o                                                  o")
        (format t "~%|         - Defina a profundidade maxima -         |")
        (format t "~%|                                                  |")
        (format t "~%|                     0 - Voltar                   |")
        (format t "~%o                                                  o")
        (format t "~%~%>> ")
    )
)

(defun menu-jogada ()
"Mostra o menu de jogada do Humano."
    (format t "~%Defina as coordenadas (linha, coluna) para a sua jogada.")
)


;; ============= ESTATISTICAS =============

(defun escrever-log (fn dados)
"Output de registos estatisticos do jogo no ecra e no ficheiro."
    (progn    
        (with-open-file (stream (concatenate 'string (diretorio) "log.dat") :direction :output :if-does-not-exist :create :if-exists :append)
            (funcall fn stream &rest dados)
            (finish-output stream)
            (close stream)
        )
        (funcall fn t dados)
    )
)

(defun escrever-ficheiro (fn dados)
"Output de registos estatisticos do jogo no ficheiro."
    (with-open-file (stream (concatenate 'string (diretorio) "log.dat") :direction :output :if-does-not-exist :create :if-exists :append)
        (funcall fn stream dados)
        (finish-output stream)
        (close stream)
    )
)

(defun duracao (hora-inicio hora-fim)
"Calcula a diferenca entre dois valores temporais."
; 1 segundo = 1000 milissegundos = 1000000 microsegundos
    (let* (
           (diferenca (- hora-fim hora-inicio))
           (segundos (float (/ diferenca 1000)))
        )
        (format nil "~ds" segundos)
    )
)

(defun log-inicio (stream dados)
"Output de dados iniciais do jogo."
    (let* ((modo (first dados))
            (iniciante (second dados))
            (tempo-limite (third dados))
        )
        (progn
            (format stream "~%o                                                  o")
            (format stream "~%|                - Jogo do Cavalo -                |")
            (format stream "~%|                 Partida iniciada.                |")
            (format stream "~%|                                                  |")
            (format stream "~%|            Modo de Jogo: ~a           |" modo)
            (if iniciante
                (format stream "~%|            1.º a jogar: ~a               |" iniciante)
                (continue)
            )
            (format stream "~%|            Tempo limite para o CPU: ~a ms        |" tempo-limite)
            (format stream "~%|                                                  |")
            (format stream "~%o                                                  o")
            (format stream "~%~%")
        )
    )
)

(defun log-jogada (stream no-atual jogada)
"Output de dados da jogada."
    (let* (
            (linha ())
            (coluna ())
            (jogador ())
            (pontos-j1 ())
            (pontos-j2 ())
            (nos-analisados ())
            (num-cortes ())
            (tempo-jogada ())
           )
        (progn
            ();; tabuleiro
            (format stream "~% O Jogador ~a jogou na posicao (~a, ~a)." jogador linha coluna)
            (format stream "~% Pontos atuais: J1 - ~a pontos | J2 - ~a pontos" pontos-j1 pontos-j2)
            (format stream "~% Nos analisados: ~a" nos-analisados)
            (format stream "~% Numero de cortes: ~a" num-cortes)
            (format stream "~% Duracao da jogada: ~a" tempo-jogada)
            (format stream "~%~%")
        )
    )
)

(defun log-fim (stream dados)
"Mostra o resultado do jogo."
    (let* (
            (pontos-j1 ())
            (pontos-j2 ())
            (vencedor ())
        )
        (progn
            (format stream "~%o                                                  o")
            (format stream "~%|                - Jogo do Cavalo -                |")
            (format stream "~%|                Partida terminada.                |")
            (format stream "~%|                                                  |")
            (format stream "~%|               ~% O vencedor é: ~a!               |" vencedor)
            (format stream "~%|                                                  |")
            (format stream "~%|              ~% Jogador 1: ~a pontos             |" pontos-j1)
            (format stream "~%|              ~% Jogador 2: ~a pontos             |" pontos-j2)
            (format stream "~%|                                                  |")
            (format stream "~%o                                                  o")
            (format stream "~%~% ")
        )
    )
)