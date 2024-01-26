;; funções que permitem escrever e ler em ficheiros e tratar da interação com o utilizador
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
            (ecase opcao
                (1 
                    (progn 
                        (modo-hvc)
                        (iniciar)
                ))
                (2
                    (progn
                        (modo-cvc)
                        (iniciar)
                ))
                (0 
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

;; Jogador 1: -1 | Jogador 2: -2

(defun jogar (estado tempo)
"Devolve uma lista com o tabuleiro em que deverá ser feita a próxima jogada."
    ;; ??? esta no enunciado no ponto 3.2, ultimo paragrafo
)

(defun modo-hvc ()
"Executa o modo de jogo Humano vs Computador."
    (let* (
            (iniciante (opcao-iniciante))
            (tempo-limite (opcao-tempo))
            (profund-max (opcao-profund-max))
        )
        (progn
            (escrever-log 'log-inicio '("Humano vs CPU" iniciante tempo-limite profund-max))
            (ecase iniciante
                ('1 (hvc tempo-limite profund-max -1))
                ('2 (hvc tempo-limite profund-max -2))
            )
        )
    )
)

(defun modo-cvc ()
"Executa o modo de jogo Computador vs Computador."
    (let ((tempo-limite (opcao-tempo)))
        (progn
            (escrever-log 'log-inicio '("CPU vs CPU" nil tempo-limite))
            (cvc tempo-limite profund-max -1)
            (log-fim)
        ) 
    )
)


(defun hvc (tempo-limite prodund-max jogador &optional (no-atual ())) ;; add fn construir no ao optional 
"Executa o decorrer do jogo Humano vs CPU."

)

(defun cvc (tempo-limite prodund-max jogador &optional (no-atual ())) ;; add fn construir no ao optional 
"Executa o decorrer do jogo CPU vs CPU."

)

(defun opcao-iniciante ()
"Recebe do utilizador a opcao de quem inicia o jogo."
    (progn
        (menu-iniciante)
        (let ((opcao (read)))
            (ecase opcao
                ('1 'humano)
                ('2 'cpu)
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
            (ecase tempo
                ((and (>= tempo 1000) (<= tempo 5000)) 
                    tempo
                )
                ('0 (opcao-iniciante))
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
            (ecase profund-max 
                ((>= profund-max 0) 
                    profund-max
                )
                ('0 (opcao-tempo))
                (otherwise (progn (format t "Escolha uma opcao valida!") (opcao-profund-max)))
            )
        )
    )
)

(defun opcao-linha ()
"Recebe do Humano a opcao de linha para a jogada."
    (progn
        (format t "~%~% Linha >> ")
        (let ((linha (read)))
            (ecase linha
                ((and (>= linha 1) (<= linha 10)) 
                    linha
                )
                ('0
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
            (ecase coluna
                ((and (>= coluna 1) (<= coluna 10)) 
                    coluna
                )
                ('0
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
        (format t "~%|        - Jogo do Cavalo -        |")
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

(defun profund-max-menu ()
"Mostra uma mensagem para escolher a profundidade maxima."
    (progn
        (format t "~%o                                             o")
        (format t "~%|      - Defina a profundidade maxima -       |")
        (format t "~%|                                             |")
        (format t "~%|                0 - Voltar                   |")
        (format t "~%o                                             o")
        (format t "~%~%>> ")
    )
)

(defun menu-jogada ()
"Mostra o menu de jogada do Humano."
    (format t "~% Defina as coordenadas para a sua jogada.")
)


;; ============= ESTATISTICAS =============

(defun escrever-log (fn dados)
"Output de registos estatisticos do jogo."
    (progn    
        (with-open-file (stream (concatenate 'string (diretorio) "log.dat") :direction :output :if-does-not-exist :create :if-exists :append)
            (funcall fn stream dados)
            (finish-output stream)
            (close stream)
        )
        (funcall fn t dados)
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
            (format stream "~%|                  Modo de Jogo: ~a                |" modo)
            (if (iniciante)
                (format stream "~%|                  1.º a jogar: ~a                 |" iniciante)
                continue
            )
            (format stream "~%|          Tempo limite da jogada CPU: ~a ms       |" tempo-limite)
            (format stream "~%|                                                  |")
            (format stream "~%o                                                  o")
            (format stream "~%~%")
        )
    )
)

(defun log-jogada (stream dados)
"Output de dados da jogada."
    (let* (
            (no-atual ())
            (jogada ())
            (linha ())
            (coluna ())
            (jogador ())
            (nos-analisados ())
            (num-cortes ())
            (tempo-jogada ())
            (tabuleiro-atual ())
           )
        (progn
            ();; tabuleiro
            (format stream "~% O Jogador ~a jogou na posicao (~a, ~a)." jogador linha coluna)
            (format stream "~% Nos analisados: ~a" nos-analisados)
            (format stream "~% Numero de cortes: ~a" num-cortes)
            (format stream "~% Duracao da jogada: ~a" tempo-jogada)
            (format stream "~%~%")
        )
    )
)

(defun log-fim (stream no)
"Mostra o resultado do jogo."
    (progn
        (format stream "~%o                                                  o")
        (format stream "~%|                - Jogo do Cavalo -                |")
        (format stream "~%|                Partida terminada.                |")
        (format stream "~%|                                                  |")
        (format stream "~%|               ~% O vencedor é: ~a!               |")
        (format stream "~%|                                                  |")
        (format stream "~%|              ~% Jogador 1: ~a pontos             |")
        (format stream "~%|              ~% Jogador 2: ~a pontos             |")
        (format stream "~%|                                                  |")
        (format stream "~%o                                                  o")
        (format stream "~%~% ")
    )
)