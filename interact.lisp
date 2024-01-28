;; Funções que permitem escrever e ler em ficheiros e tratar da interação com o utilizador
;; Autores: Nuno Martinho, João Coelho e João Barbosa
;; Ano letivo 23/24

(defun diretorio ()
  "C:/Users/joaor/OneDrive/Documentos/IPS/ESTS/LEI/3_ANO/IA/Projeto/ia-projeto2/"
  ;;"U:/Documents/LEI/AnoCorrente/IA/projeto_2/" ;altera a pasta para o novo diretorio
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
       (1
        (progn
         (modo-hvc)
         (iniciar)))
       (2
        (progn
         (modo-cvc)
         (iniciar)))
       (0
        (progn (format t "Obrigado por jogar!~%~%") (abort)))
       (t (progn (format t "Escolha uma opcao valida!") (iniciar)))))))


;; ============= INTERACAO =============

;; <no>::= (<tabuleiro> <pai> <f> pontos1 pontos2)
;; <jogada>::= (<jogador> <linha> <coluna>)
;; <solucao>::= (<no-jogada> (<nos-analisados> <n-cortes> <tempo-gasto>))
;; ((<tabuleiro> <jogada>) (<tabuleiro> <jogada>) (<tabuleiro> <jogada>) (<tabuleiro> <jogada>))


(defun modo-hvc ()
  "Executa o modo de jogo Humano vs Computador."
  (progn
   (menu-iniciante)
   (let ((iniciante (read)))
     (cond
      ((and (not (numberp iniciante)) (or (> iniciante 2) (< iniciante 0)))
        (progn (format t "Escolha uma opcao valida!") (modo-hvc)))
      ((eql iniciante 0) (iniciar))
      (t (let* ((tempo-limite (opcao-tempo))
                (profund-max (opcao-profund-max)))
           (case iniciante
             (1 (progn
                 (escrever-log #'log-inicio "Humano vs CPU" 'Humano tempo-limite profund-max)
                 (hvc tempo-limite profund-max -2)))
             (2 (progn
                 (escrever-log #'log-inicio "Humano vs CPU" 'CPU tempo-limite profund-max)
                 (hvc tempo-limite profund-max -1))))))))))

(defun modo-cvc ()
  "Executa o modo de jogo Computador vs Computador."
  (let* ((tempo-limite (opcao-tempo))
         (profund-max (opcao-profund-max)))
    (progn
     (escrever-log #'log-inicio "CPU vs CPU" nil tempo-limite profund-max)
     (cvc tempo-limite profund-max -1)
     ;;(log-fim)
     )))

;; <no>::= (<tabuleiro> <pai> <f> pontos1 pontos2) ;; f -> funcao-avaliacao
;; <jogada>::= (<jogador> <linha> <coluna>)
;; <solucao>::= (<no-jogada> (<nos-analisados> <n-cortes> <tempo-gasto>))

;; Jogador 1 (CPU): -1 | Jogador 2 (Humano): -2

(defun hvc (tempo-limite profund-max jogador &optional (no-atual (criar-no (tabuleiro-aleatorio)))) ;;todo apresentar jogadas no log.dat
  "Executa o decorrer do jogo Humano vs CPU."

  (let ((tabuleiro-atual (first no-atual)))
    (if (not (posicao-jogador2 tabuleiro-atual))

        (let* ((tabuleiro-com-jogadas (primeiras-jogadas tabuleiro-atual))
               (pos-j1 (posicao-jogador1 tabuleiro-com-jogadas))
               (pos-j2 (posicao-jogador2 tabuleiro-com-jogadas))
               (no-atualizado (criar-no tabuleiro-com-jogadas nil 0 (celula (car pos-j1) (cadr pos-j1) tabuleiro-atual) (celula (car pos-j2) (cadr pos-j2) tabuleiro-atual))))

          (progn
           (format-tabuleiro-coord tabuleiro-com-jogadas)
           (format t "~% Pontos atuais: CPU - ~a pontos | Utilizador - ~a pontos" (no-jogador1 no-atualizado) (no-jogador2 no-atualizado))
           (hvc tempo-limite profund-max jogador no-atualizado)))

        (let* ((humano-pode-mover (jogador-pode-mover tabuleiro-atual -2))
               (cpu-pode-mover (jogador-pode-mover tabuleiro-atual -1)))

          (cond
           ((and (eq humano-pode-mover nil) (eq cpu-pode-mover nil))

             (progn
              (format T "~%Nao ha mais jogadas possiveis! O jogo terminou!~%")
              (log-vencedor-hvc no-atual)))
           ((eq jogador -2) ;; jogada Humano               

                           (if (not humano-pode-mover)
                               (progn
                                (format t "~% O Utilizador nao tem mais jogadas possiveis! ~%")
                                (hvc tempo-limite profund-max -1 no-atual))

                               (let* ((posicao-selecionada (opcao-coordenadas))
                                      (tabuleiro-jogada (mover-jogador -2 tabuleiro-atual (first posicao-selecionada) (second posicao-selecionada) t)) ;; funcao colocar peca
                                        )

                                 (if tabuleiro-jogada
                                     (let ((no-solucao (criar-no (resultado-tabuleiro tabuleiro-jogada)
                                                        no-atual
                                                        (no-f no-atual)
                                                        (no-jogador1 no-atual)
                                                        (+ (resultado-pontos tabuleiro-jogada) (no-jogador2 no-atual))))
                                          )
                                      (progn
                                      ;;(format t "~%~% Jogada na posicao (~a, ~a). ~%~%" (first posicao-selecionada) (second posicao-selecionada))
                                      (escrever-log-jogada (list no-solucao) -2)
                                      (hvc tempo-limite profund-max -1 no-solucao)))

                                     (progn
                                      (format T "~%Posicao escolhida invalida!~%")
                                      (hvc tempo-limite profund-max -2 no-atual))))))
           (t ;; jogada CPU

             (if (jogador-pode-mover tabuleiro-atual -1)

                 (let ((no-solucao (negamax no-atual tempo-limite profund-max)))
                   (progn
                    (escrever-log-jogada no-solucao -1)
                    (hvc tempo-limite profund-max -2 (car no-solucao))))
                 (progn
                  (format t "~%-------------------------------------------------------------~%")
                  (format-tabuleiro-coord tabuleiro-atual)
                  (format t "~% Pontos atuais: CPU - ~a pontos | Utilizador - ~a pontos" (no-jogador1 no-atual) (no-jogador2 no-atual))
                  (format t "~% O CPU nao tem mais jogadas possiveis! ~%")
                  (format t "~%-------------------------------------------------------------~%")
                  (hvc tempo-limite profund-max -2 no-atual)))))))))


(defun cvc (tempo-limite profund-max jogador &optional (no-atual (criar-no (tabuleiro-aleatorio)))) ;; add fn construir-no ao optional 
  "Executa o decorrer do jogo CPU vs CPU."

  (let ((tabuleiro-atual (first no-atual)))
    (if (not (and (posicao-jogador2 tabuleiro-atual) (posicao-jogador1 tabuleiro-atual)))
        (let* ((tabuleiro-com-jogadas (primeiras-jogadas tabuleiro-atual))
               (pos-j1 (posicao-jogador1 tabuleiro-com-jogadas))
               (pos-j2 (posicao-jogador2 tabuleiro-com-jogadas))
               (no-atualizado (criar-no tabuleiro-com-jogadas nil 0 (celula (car pos-j1) (cadr pos-j1) tabuleiro-atual) (celula (car pos-j2) (cadr pos-j2) tabuleiro-atual))))

          (progn
           (format-tabuleiro-coord tabuleiro-com-jogadas)
           (format t "~% Pontos atuais: CPU1 - ~a pontos | CPU2 - ~a pontos" (no-jogador1 no-atualizado) (no-jogador2 no-atualizado))
           (cvc tempo-limite profund-max jogador no-atualizado)))

        (let* ((cpu1-pode-mover (jogador-pode-mover tabuleiro-atual -1))
               (cpu2-pode-mover (jogador-pode-mover tabuleiro-atual -2)))

          (cond
           ((and (eq cpu1-pode-mover nil) (eq cpu2-pode-mover nil))

             (progn
              (format T "~%Nao ha mais jogadas possiveis! O jogo terminou!~%"))
              (log-vencedor-cvc no-atual)) ;; apresentar vencedor

           ((eq jogador -1) ;; cpu 1

                           (if cpu1-pode-mover
                               (let ((no-solucao (negamax no-atual tempo-limite profund-max)))
                                 (progn
                                  (escrever-log-jogada no-solucao -1)
                                  (cvc tempo-limite profund-max -2 (car no-solucao))))
                               (progn
                                (format t "~%-------------------------------------------------------------~%")
                                (format-tabuleiro-coord tabuleiro-atual)
                                (format t "~% Pontos atuais: CPU1 - ~a pontos | CPU2 - ~a pontos" (no-jogador1 no-atual) (no-jogador2 no-atual))
                                (format t "~% CPU1 nao tem mais jogadas possiveis! ~%")
                                (format t "~%-------------------------------------------------------------~%")
                                (cvc tempo-limite profund-max -2 no-atual))))

           (t ;; jogada CPU2

             (if cpu2-pode-mover

                 (let* ((no-solucao (negamax (inverter-sinal-no no-atual 'inverter-sinal-tabuleiro) tempo-limite profund-max))
                        (inverter-sinal (inverter-sinal-no (car no-solucao) 'inverter-sinal-tabuleiro))
                        (inverter-dados (list inverter-sinal
                            (list (solucao-nos-analisados (cadr no-solucao))
                                  (solucao-numero-cortes (cadr no-solucao))
                                  (solucao-tempo-gasto (cadr no-solucao)))))
                  )
                   (progn
                    (escrever-log-jogada inverter-dados -2)
                    (cvc tempo-limite profund-max -1 inverter-sinal)))
                 (progn
                  (format t "~%-------------------------------------------------------------~%")
                  (format-tabuleiro-coord tabuleiro-atual)
                  (format t "~% Pontos atuais: CPU1 - ~a pontos | CPU2 - ~a pontos" (no-jogador1 no-atual) (no-jogador2 no-atual))
                  (format t "~% CPU2 Nao tem mais jogadas possiveis! ~%")
                  (format t "~%-------------------------------------------------------------~%")
                  (cvc tempo-limite profund-max -1 no-atual)))))))))

(defun opcao-iniciante ()
  "Recebe do utilizador a opcao de quem inicia o jogo."
  (progn
   (menu-iniciante)
   (let ((iniciante (read)))
     (cond
      ((eql iniciante 1) 'Humano)
      ((eql iniciante 2) 'CPU)
      ((eql iniciante 0) (iniciar))
      (t (progn (format t "Escolha uma opcao valida!") (opcao-iniciante)))))))

(defun opcao-tempo ()
  "Recebe do utilizador o tempo limite para o computador jogar."
  (progn
   (menu-tempo)
   (let ((tempo (read)))
     (cond
      ((and (>= tempo 1000) (<= tempo 5000))
        tempo)
      ((eql tempo 0) (iniciar))
      (t (progn (format t "Escolha uma opcao valida!") (opcao-tempo)))))))

(defun opcao-profund-max ()
  "Recebe um valor de profundidade maxima do utilizador."
  (progn
   (profund-max-menu)
   (let ((profund-max (read)))
     (cond
      ((> profund-max 0)
        profund-max)
      ((eql profund-max 0) (opcao-tempo))
      (t (progn (format t "Escolha uma opcao valida!") (opcao-profund-max)))))))

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
                        (list linha coluna))
                      (t (progn
                          (format t "~% Posicao invalida. Tente novamente!")
                          (opcao-coordenadas)))))))
           (t (progn
               (format t "~% Posicao invalida. Tente novamente!")
               (opcao-coordenadas)))))))


;; ============= MENUS =============

(defun menu-inicial ()
  "Mostra o menu inicial."
  (progn
   (format t "~%o                                                  o")
   (format t "~%|                - Jogo do Cavalo -                |")
   (format t "~%|                                                  |")
   (format t "~%|                1 - Humano vs CPU                 |")
   (format t "~%|                2 - CPU vs CPU                    |")
   (format t "~%|                                                  |")
   (format t "~%|                0 - Sair                          |")
   (format t "~%o                                                  o")
   (format t "~%~%>> ")))

(defun menu-iniciante ()
  "Mostra o menu de escolha do jogador que começa o jogo."
  (progn
   (format t "~%o                                                  o")
   (format t "~%|          - Escolha quem comeca o jogo -          |")
   (format t "~%|                                                  |")
   (format t "~%|               1 - Utilizador (peca -2)           |")
   (format t "~%|               2 - CPU (peca -1)                  |")
   (format t "~%|                                                  |")
   (format t "~%|               0 - Voltar ao inicio               |")
   (format t "~%o                                                  o")
   (format t "~%~%>> ")))

(defun menu-tempo ()
  "Mostra o menu de escolha do tempo limite para a jogada do CPU."
  (progn
   (format t "~%o                                                  o")
   (format t "~%|  - Defina o tempo limite para a jogada do CPU -  |")
   (format t "~%|           (1000 a 5000 milissegundos)            |")
   (format t "~%|                                                  |")
   (format t "~%|               0 - Voltar ao inicio               |")
   (format t "~%o                                                  o")
   (format t "~%~%>> ")))

(defun profund-max-menu ()
  "Mostra uma mensagem para escolher a profundidade maxima."
  (progn
   (format t "~%o                                                  o")
   (format t "~%|         - Defina a profundidade maxima -         |")
   (format t "~%|                                                  |")
   (format t "~%|               0 - Voltar ao inicio               |")
   (format t "~%o                                                  o")
   (format t "~%~%>> ")))

(defun menu-jogada ()
  "Mostra o menu de jogada do Humano."
  (format t "~%Defina as coordenadas (linha, coluna) para a sua jogada."))


;; ============= ESTATISTICAS =============

(defun escrever-log (fn &rest dados)
  "Output de registos estatisticos do jogo no ecra e no ficheiro."
  (funcall fn dados) ;; escrever no ecra
  (with-open-file (stream (concatenate 'string (diretorio) "log.dat") :direction :output :if-does-not-exist :create :if-exists :append)
    (funcall fn dados stream)
    (finish-output stream)
    (close stream)) ;; escrever no ficheiro log.dat
)

(defun format-estado (solucao jogador &optional (stream t))
  "Output de registos estatisticos da jogada no ecra."
  (let* ((no (car solucao))
         (tabuleiro (no-tabuleiro no))
         (pos (posicao-valor jogador tabuleiro))
         (linha (car pos))
         (coluna (cadr pos)))

    (progn
     (format stream "~%-------------------------------------------------------------~%")
     (format stream "~%")
     (format-tabuleiro-coord tabuleiro stream)
     (format stream "~% O Jogador ~a jogou na posicao (~a, ~a)." jogador linha coluna)
     (format stream "~% Pontos atuais: J1 - ~a pontos | J2 - ~a pontos" (no-jogador1 no) (no-jogador2 no))
     (format stream "~% Nos analisados: ~a" (solucao-nos-analisados (cadr solucao)))
     (format stream "~% Numero de cortes: ~a" (solucao-numero-cortes (cadr solucao)))
     (format stream "~% Duracao da jogada: ~a~%" (solucao-tempo-gasto (cadr solucao)))
     (format stream "~%-------------------------------------------------------------~%"))))

(defun escrever-log-jogada (solucao jogador)
  "Output de registos estatisticos da jogada no ficheiro."
  (format-estado solucao jogador)
  (with-open-file (stream (concatenate 'string (diretorio) "log.dat") :direction :output :if-does-not-exist :create :if-exists :append)
    (format-estado solucao jogador stream)
    (finish-output stream)
    (close stream)))

(defun log-inicio (dados &optional (stream t))
  "Output de dados iniciais do jogo."
  (let* ((modo (first dados))
         (iniciante (second dados))
         (tempo-limite (third dados)))
    (progn
     (format stream "~%o ----------------------------------------------- o")
     (format stream "~%                                                  ")
     (format stream "~%                - Jogo do Cavalo -                ")
     (format stream "~%                 Partida iniciada.                ")
     (format stream "~%                                                  ")
     (format stream "~%            Modo de Jogo: ~a                      " modo)
     (if iniciante
     (format stream "~%            1.o a jogar: ~a                       " iniciante)
         (continue))
     (format stream "~%            Tempo limite do CPU: ~a ms            " tempo-limite)
     (format stream "~%                                                  ")
     (format stream "~%o ----------------------------------------------- o")
     (format stream "~%~%"))))

(defun log-vencedor (dados &optional (stream t))
  "Output de dados finais do jogo."
  (let* ((pontos-j1 (no-jogador1 (car dados)))
         (pontos-j2 (no-jogador2 (car dados)))
         (vencedor (if (> pontos-j1 pontos-j2) -1 -2))
         (jogador1-text (second dados))
         (jogador2-text (third dados))
    )
  (progn
     (format stream "~%o ----------------------------------------------- o")
     (format stream "~%                                                  ")
     (format stream "~%                - Jogo do Cavalo -               ")
     (format stream "~%                Partida terminada.               ")
     (format stream "~%                                                 ")
     (format stream "~%             O vencedor e: ~a!                   " 
      (if (eql vencedor -1)
         jogador1-text
         jogador2-text))
     (format stream "~%                                                 ")
     (format stream "~%                  ~a: ~a pontos                  " jogador1-text pontos-j1)
     (format stream "~%                  ~a: ~a pontos                  " jogador2-text pontos-j2)
     (format stream "~%                                                 ")
     (format stream "~%o ----------------------------------------------- o")
     (format stream "~%~%")
   )))

(defun log-vencedor-hvc (no &optional (stream t))
"Output de dados do final do jogo HvC no ecra e ficheiro."
  (escrever-log 'log-vencedor no "CPU" "Utilizador" stream))

(defun log-vencedor-cvc (no &optional (stream t))
"Output de dados do final do jogo CvC no ecra e ficheiro."
  (escrever-log 'log-vencedor no "CPU1" "CPU2" stream))
