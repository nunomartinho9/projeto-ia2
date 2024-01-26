;; funções que permitem escrever e ler em ficheiros e tratar da interação com o utilizador 

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
    (modo-jogo)
)


;; ============= NAVEGACAO =============

(defun jogar (estado tempo)
"Devolve uma lista com o tabuleiro em que deverá ser feita a próxima jogada."
    ;; ??? esta no enunciado no ponto 3.2, ultimo paragrafo
)

(defun modo-jogo ()
"Recebe a opcao de modo de jogo selecionada pelo utilizador."
    (progn
        (menu-inicial)
        (let ((opcao (read)))
            (case opcao
                (1 
                    (progn 
                        (let* ((iniciante (opcao-iniciante))
                                (tempo-limite (opcao-tempo))
                            )
                            ()) ;; inserir funcao modo Humano vs CPU
                        (modo-jogo)
                ))
                (2
                    (progn
                        (let* ((iniciante (opcao-iniciante))
                                (tempo-limite (opcao-tempo))
                            )
                            ()) ;; inserir funcao modo CPU vs CPU
                        (modo-jogo)
                ))
                (0 
                    (progn
                        (finish-output)
                        (clear-output)
                        (format t "Obrigado por jogar!~%~%")
                ))

                (otherwise (progn (format t "Escolha uma opcao valida!") (modo-jogo)))    
            )
        )
    )
)

(defun opcao-iniciante (voltar)
"Recebe a opcao do modo de jogo do menu."
    (progn
        (menu-iniciante)
        (let ((opcao (read)))
            (case opcao
                (1 
                    'humano
                )
                (2
                    'cpu
                )
                (0
                    (voltar)
                )
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
            (case opcao
                ((and (>= tempo 1000) (<= tempo 5000)) 
                    tempo
                )
                (0
                    (opcao-iniciante)
                )
                (otherwise (progn (format t "Escolha uma opcao valida!") (opcao-tempo)))    
            )
        )
    )
)

(defun opcao-linha ()
"Recebe do Humano a opcao de linha para a jogada."
    (progn
        (format t "~%~% Linha >> ")
        (let ((linha (read)))
            (case opcao
                ((and (>= linha 1) (<= linha 10)) 
                    linha
                )
                (0
                    (opcao-iniciante)
                )
                (otherwise (progn (format t "Escolha uma linha valida!") (opcao-linha)))    
            )
        )
    )
)

(defun opcao-coluna ()
"Recebe do Humano a opcao de coluna para a jogada."
    (progn
        (format t "~%~% Coluna >> ")
        (let ((coluna (read)))
            (case opcao
                ((and (>= coluna 1) (<= coluna 10)) 
                    coluna
                )
                (0
                    (opcao-iniciante)
                )
                (otherwise (progn (format t "Escolha uma coluna valida!") (opcao-coluna)))    
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
        (format t "~%o                                  o")
        (format t "~%|      - Problema do Cavalo -      |")
        (format t "~%|                                  |")
        (format t "~%|        1 - Humano vs CPU         |")
        (format t "~%|        2 - CPU vs CPU            |")
        (format t "~%|                                  |")
        (format t "~%|        0 - Sair                  |")
        (format t "~%o                                  o")
        (format t "~%~%>> ")
    )
)

(defun menu-iniciante ()
"Mostra o menu de escolha do jogador que começa o jogo."
    (progn
        (format t "~%o                                  o")
        (format t "~%|  - Escolha quem começa o jogo -  |")
        (format t "~%|                                  |")
        (format t "~%|          1 - Humano              |")
        (format t "~%|          2 - CPU                 |")
        (format t "~%|                                  |")
        (format t "~%|          0 - Voltar              |")
        (format t "~%o                                  o")
        (format t "~%~%>> ")
    )
)

(defun menu-tempo ()
"Mostra o menu de escolha do tempo limite para a jogada do CPU."
    (progn
        (format t "~%o                                                  o")
        (format t "~%|  - Defina o tempo limite para a jogada do CPU -  |")
        (format t "~%|                (em milissegundos)                |")
        (format t "~%|                                                  |")
        (format t "~%|                    0 - Voltar                    |")
        (format t "~%o                                                  o")
        (format t "~%~%>> ")
    )
)

(defun menu-jogada ()
"Mostra o menu de jogada do Humano."
    (format t "~% Defina as coordenadas para a sua jogada:")
)

(defun menu-fim (vencedor)
"Mostra o resultado do jogo."
    (progn
        (format t "~% Partida terminada!")
        (format t "~% O vencedor é: ~a" vencedor)
        (format t "~%~% Todos os detalhes da partida estão registados em log.dat.")
    )
)


;; ============= ESTATISTICAS =============

(defun ficheiro-log (fn dados)
"Output de registos estatisticos do jogo e de cada jogada do mesmo."
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

(defun estatisticas-jogo (stream dados)
"Output de dados iniciais do jogo."
    (let* ((modo (first dados))
            (iniciante (second dados))
            (tempo-limite (third dados))
        )
        (progn 
            (format stream "~%~a" (get-decoded-time))
            (format stream "~%Modo de Jogo: ~a" modo)
            (format stream "~%Primeiro a jogar: ~a" iniciante)
            (format stream "~%Tempo limite da jogada CPU: ~a" tempo-limite)
        ))
)

(defun estatisticas-jogada (stream dados)
"Output de dados da jogada."
    (let* (
            (nos-analisados ())
            (num-cortes ())
            (tempo-jogada ())
            (tabuleiro-atual ())
           )
        (progn
            ()
        )
    )
)