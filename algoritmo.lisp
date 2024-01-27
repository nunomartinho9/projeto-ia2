;;  Autores: Nuno Martinho e Joao Coelho e João Barbosa.

;; ============= ESTRUTURAS =============
;; <no>::= (<tabuleiro> <pai> <f> <d> pontos1 pontos2)
;;<jogada>::= (<jogador> <linha> <coluna>)
;; <solucao>::= (<caminho-solucao> <n-abertos> <n-fechados>)


;; ============= ALGORITMOS =============

;; (negamax (no-teste) 5000)
(defun negamax (no
                tempo-limite
                &optional
                (cor 1)                                             ;; começar com no max
                (d-maximo 50)                                       ;; profundidade default e' 50
                (alfa most-negative-fixnum)                         ;; comecar o alfa a -infinito
                (beta most-positive-fixnum)                         ;; comecar o beta a +infinito
                (tempo-inicial (get-universal-time))                ;; tempo que comeca o algoritmo
                (nos-analisados 1)                                  ;; nos analisados
                (numero-cortes 0)                                   ;; numero de cortes
                (fn-expandir-no 'usar-operadores)                   ;; funcao geral para expandir o no
                (peca-jogador1 -1)                                  ;; peca do jogador 1 (max)
                (fn-selecionar-problema 'resultado-tabuleiro)       ;; funcao geral para ir buscar o tabuleiro do resulado
                (fn-selecionar-pontos 'resultado-pontos)            ;; funcao geral para ir buscar os pontos do resulado
                (fn-inverter-sinal-jogo 'inverter-sinal-tabuleiro)) ;; funcao geral para inverter o tabuleiro (proprio para o negamax)
  "Executa o algoritmo negamax para um no"
  (let* ((lista-expandidos (ordenar-negamax (gerar-sucessores
                                              no
                                              cor
                                              fn-expandir-no
                                              peca-jogador1
                                              fn-selecionar-problema
                                              fn-selecionar-pontos)
                                            cor))
         (tempo-decorrido (obter-tempo-gasto tempo-inicial))) ;; obter quanto tempo passou
    (cond
     ((or (= d-maximo 0) (= (length lista-expandidos) 0) (>= tempo-decorrido (/ tempo-limite 1000))) ;; se e' profundidade maxima, se e' no folha, se passou do tempo limite
       (criar-no-solucao (if (= cor 1) no (inverter-sinal-no no fn-inverter-sinal-jogo)) ;; verificar se o no era min se sim, inverter o sinal
                         nos-analisados numero-cortes tempo-inicial)) ;; devolve o no com a jogada
     (T
       (negamax-aux         ;;aplicar o auxiliar do negamax para os sucessores
         no
         lista-expandidos
         tempo-limite
         cor
         d-maximo
         alfa
         beta
         tempo-inicial
         nos-analisados
         numero-cortes
         fn-inverter-sinal-jogo)))))
;; ============= AUXILIARES NEGAMAX =============
(defun negamax-aux (no-pai
                     sucessores
                     tempo-limite
                     cor
                     d-maximo
                     alfa
                     beta
                     tempo-inicial
                     nos-analisados
                     numero-cortes
                     fn-inverter-sinal-jogo)
  "Negamax Auxiliar"
  (cond
   ((= (length sucessores) 1) ;; so tem 1 no
     (negamax                 ;; inverter negamax
       (inverter-sinal-no (car sucessores) fn-inverter-sinal-jogo)
       tempo-limite
       (- cor)
       (1- d-maximo)
       (- beta)
       (- alfa)
       tempo-inicial
       (1+ nos-analisados)
       numero-cortes))
   (T
     (let* ((solucao (negamax (inverter-sinal-no (car sucessores) fn-inverter-sinal-jogo)
                              tempo-limite
                              (- cor)
                              (1- d-maximo)
                              (- beta)
                              (- alfa)
                              tempo-inicial
                              (1+ nos-analisados)
                              numero-cortes))

            (no-solucao (car solucao)) ;; vai buscar o no de uma solucao encontrada
            (melhor-valor (max-no-f no-solucao no-pai)) ;; compara os valores de f e guarda o no com o f mais alto
            (novo-alfa (max alfa (no-f melhor-valor)))  ;; atualiza o alfa
            (nos-analisados-solucao (solucao-nos-analisados (cadr solucao)))  ;; nos analisados da solucao
            (numero-cortes-solucao (solucao-numero-cortes (cadr solucao))))   ;; numero de cortes da solucao
       (if (>= novo-alfa beta) ;;corte
           (criar-no-solucao no-pai nos-analisados-solucao (1+ numero-cortes-solucao) tempo-inicial)
           
           ;;nao tem corte
           (negamax-aux no-pai 
                        (cdr sucessores) 
                        tempo-limite 
                        cor 
                        d-maximo 
                        novo-alfa 
                        beta 
                        tempo-inicial 
                        nos-analisados-solucao 
                        numero-cortes-solucao
                        fn-inverter-sinal-jogo)
           
           )))))

(defun ordenar-negamax (lista-nos cor)
  "Ordena uma lista executando o algoritmo quicksort"
  (if (null lista-nos)
      nil
      (let* ((comparador (if (= cor 1) #'> #'<))
             (pivot (car lista-nos))
             (menores (lista-por-condicao (complement comparador) pivot (cdr lista-nos)))
             (maiores (lista-por-condicao comparador pivot (cdr lista-nos))))
        (append (ordenar-negamax maiores cor) (list pivot) (ordenar-negamax menores cor)))))

(defun lista-por-condicao (condicao pivot lista-nos)
  "Auxiliar quicksort para valores de acordo com a condição"
  (if (null lista-nos)
      nil
      (let ((valor (funcall 'no-f (car lista-nos))))
        (if (funcall condicao valor (no-f pivot))
            (cons (car lista-nos) (lista-por-condicao condicao pivot (cdr lista-nos)))
            (lista-por-condicao condicao pivot (cdr lista-nos))))))


;; Exemplo de uso:
;; (ordenar-negamax lista-de-nos cor)


;; ============= FUNCOES RELATIVAS AOS NOS =============
;; <no>::= (<tabuleiro> <pai> <f> pontos1 pontos2)

#| ((94 25 54 89 21 8 36 14 41 96)
     (78 47 56 23 5 49 13 12 26 60)
     (0 27 17 83 34 93 74 52 45 80)
     (69 9 77 95 55 39 91 73 57 30)
     (24 15 22 86 1 11 68 79 76 72)
     (81 48 32 2 64 16 50 37 29 71)
     (99 51 6 18 53 28 7 63 10 88)
     (59 42 46 85 90 75 87 43 20 31)
     (3 61 58 44 65 82 19 4 35 62)
     (33 70 84 40 66 38 92 67 98 97)) |#

(defun no-teste ()
  '(((94 25 54 NIL 21 8 36 14 41 -1)
     (78 47 56 23 5 49 13 12 26 60)
     (0 27 17 83 34 93 74 52 45 80)
     (NIL 9 77 95 55 39 91 73 57 30)
     (24 15 22 86 1 11 68 79 76 72)
     (81 48 32 2 64 16 50 37 29 71)
     (99 51 6 18 53 28 7 63 10 88)
     (59 42 46 85 90 75 87 43 20 31)
     (3 61 58 44 65 82 19 4 35 62)
     (33 70 84 40 66 38 92 67 -2 97))
    nil ;; pai
    0 ;; f
    96 ;; p1
    98 ;; p2
  ))


(defun criar-no (tabuleiro &optional (pai nil) (f 0) (pontos1 0) (pontos2 0))
  "Recebe um tabuleiro, e apartir dele cria um no com a estrutura definida."
  (list tabuleiro pai f pontos1 pontos2))

;; (gerar-sucessores (no-teste) 1 'usar-operadores jogador-1 jogador-2 'resultado-tabuleiro 'resultado-pontos)
(defun gerar-sucessores (no-atual cor fn-expandir-no peca-jogador1 fn-selecionar-problema fn-selecionar-pontos)
  "Recebe um no e a funcao de expansao de nos, 
  (a funcao passada normalmente vai ser a usar-operadores que ira gerar uma lista das proximas jogadas)
  depois essa lista de tabuleiros sera convertida para uma lista de nos."

  ;;(let ((jogador (if (= cor 1) peca-jogador1 peca-jogador2)))

    (mapcar #'(lambda (resultado)
                (let* ((pontos1 (if (= cor 1)
                                    (+ (no-jogador1 no-atual) (funcall fn-selecionar-pontos resultado))
                                    (no-jogador1 no-atual)))
                       (pontos2 (if (= cor -1)
                                    (+ (no-jogador2 no-atual) (funcall fn-selecionar-pontos resultado))
                                    (no-jogador2 no-atual))))

                  (criar-no
                    (funcall fn-selecionar-problema resultado)
                    no-atual
                    (- pontos1 pontos2)
                    pontos1
                    pontos2)))
      (funcall fn-expandir-no (no-tabuleiro no-atual) peca-jogador1)))


;; (inverter-sinal-no (no-teste) 'inverter-sinal-tabuleiro)
(defun inverter-sinal-no (no fn-inverter-sinal-jogo)
  (let* ((novos-pontos-j1 (no-jogador2 no))
         (novos-pontos-j2 (no-jogador1 no)))

    (criar-no (funcall fn-inverter-sinal-jogo (no-tabuleiro no))
              (no-pai no)
              (no-f no)
              novos-pontos-j1
              novos-pontos-j2)))

(defun max-no-f (no1 no2)
  (let ((value-no1 (no-f no1))
        (value-no2 (no-f no2)))
    (if (> value-no1 value-no2) no1 no2)))

;; ============= SELETORES NO =============
;; <no>::= (<tabuleiro> <pai> <f> pontos1 pontos2)
(defun no-tabuleiro (no)
  "retorna o tabuleiro do no"
  (first no))

(defun no-pai (no)
  "retorna o no pai do no recebido"
  (second no))

(defun no-f (no)
  "Retorna o valor de f de um no."
  (third no))

(defun no-jogador1 (no)
  (fourth no))

(defun no-jogador2 (no)
  (fifth no))


;; ============= SELETORES SOLUCAO =============
;; <solucao>::= (<no-jogada> (<nos-analisados> <n-cortes> <tempo-gasto>))

(defun criar-no-solucao (no-jogada nos-analisados numero-cortes tempo-inicial)
  "Constr�i o n� solu��o"
  (list no-jogada (list nos-analisados numero-cortes (obter-tempo-gasto tempo-inicial))))

(defun obter-tempo-gasto (tempo-inicial)
  "Retorna a diferen�a temporal"
  (- (get-universal-time) tempo-inicial))


(defun solucao-nos-analisados (no-solucao-semjogada)
  (first no-solucao-semjogada))

(defun solucao-numero-cortes (no-solucao-semjogada)
  (second no-solucao-semjogada))

(defun solucao-tempo-gasto (no-solucao-semjogada)
  (third no-solucao-semjogada))





