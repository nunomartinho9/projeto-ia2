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
                (cor 1)
                (d-maximo 50)
                (alfa most-negative-fixnum)
                (beta most-positive-fixnum)
                (tempo-inicial (get-universal-time))
                (nos-analisados 1)
                (numero-cortes 0)
                (fn-expandir-no 'usar-operadores)
                (peca-jogador1 -1)
                (peca-jogador2 -2)
                (fn-selecionar-problema 'resultado-tabuleiro)
                (fn-selecionar-pontos 'resultado-pontos)
                (fn-inverter-sinal-jogo 'inverter-sinal-tabuleiro))
  "Executa o algoritmo negamax para um no"
  (let* ((lista-expandidos (ordenar-negamax (gerar-sucessores
                                              no
                                              cor
                                              fn-expandir-no
                                              peca-jogador1
                                              peca-jogador2
                                              fn-selecionar-problema
                                              fn-selecionar-pontos)
                                            cor))
         (tempo-decorrido (obter-tempo-gasto tempo-inicial))) ;;- (get-universal-time) tempo-inicial
    (cond
     ((or (= d-maximo 0) (= (length lista-expandidos) 0) (>= tempo-decorrido (/ tempo-limite 1000)))
       (criar-no-solucao (if (= cor 1) no (inverter-sinal-no no fn-inverter-sinal-jogo))
                         nos-analisados numero-cortes tempo-inicial))
     (T
       (negamax-aux
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
   ((= (length sucessores) 1)
     (negamax
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

            (no-solucao (car solucao))
            (melhor-valor (max-no-f no-solucao no-pai))
            (novo-alfa (max alfa (no-f melhor-valor)))
            (nos-analisados-solucao (solucao-nos-analisados (cadr solucao)))
            (numero-cortes-solucao (solucao-numero-cortes (cadr solucao))))
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
;; <no>::= (<tabuleiro> <pai> <f> <d> pontos1 pontos2)
;;<jogada>::= (<jogador> <linha> <coluna>)
;; ((<tabuleiro> <jogada>) (<tabuleiro> <jogada>) (<tabuleiro> <jogada>) (<tabuleiro> <jogada>))

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

(defun gerar-sucessores (no-atual cor fn-expandir-no peca-jogador1 peca-jogador2 fn-selecionar-problema fn-selecionar-pontos)
  "Recebe um no e a funcao de expansao de nos, 
  (a funcao passada normalmente vai ser a usar-operadores que ira gerar uma lista das proximas jogadas)
  depois essa lista de tabuleiros sera convertida para uma lista de nos."

  (let ((jogador (if (= cor 1) peca-jogador1 peca-jogador2)))

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
                    (abs (- pontos1 pontos2))
                    pontos1
                    pontos2)))
      (funcall fn-expandir-no (no-tabuleiro no-atual) jogador))))


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

;; ============= SELETORES =============

;; <caminho-solucao>::= (lista (<tabuleiro> <pontos-obj> <pontos-atual> <profundidade>) ... )
;; <solucao>::= (<caminho-solucao> <n-abertos> <n-fechados>)
;; <solucao-a*>::= (<caminho-solucao> <n-abertos> <n-fechados> <n-nos-expandidos>)

(defun encontrar-no (no lista)
  "Encontra um no presente na lista recebida e devolve o no encontrado nessa lista."
  (cond
   ((null lista) nil)
   ((comparar-estados no (car lista)) (car lista))
   (t (encontrar-no no (cdr lista)))))


(defun comparar-estados (no1 no2)
  "Compara o tabuleiro do no1 com o no2, devolve T se forem iguais, caso contrario NIL"
  (equal (no-tabuleiro no1) (no-tabuleiro no2)))


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

#| (defun no-profundidade (no)
  "retona a profundidade atual do no"
  (fourth no)) |#

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


;;TODO: a estrutura do no solucao ainda nao está bem definida. Arranjar depois
(defun solucao-nos (solucao)
  "Buscar o caminho-solucao (lista de nos desde o inicial ate ao no-solucao)"
  (first solucao))

(defun solucao-abertos (solucao)
  "Buscar o numero de abertos da solucao"
  (second solucao))

(defun solucao-fechados (solucao)
  "Buscar o numero de fechados/expandidos da solucao"
  (third solucao))

;; CAMINHO SOLUCAO
(defun no-caminho-solucao (index solucao)
  "Retorna um dos nos do caminho-solucao no index recebido (começa no 0)."
  (if (and (>= index 0) (< index (tamanho-solucao solucao)))
      (nth index (solucao-nos solucao))
      NIL))


(defun no-caminho-solucao-primeiro (solucao)
  "Buscar o primeiro NO no caminho-solucao. (este NO deve ser o no solucao)"
  (no-caminho-solucao 0 solucao))

(defun no-caminho-solucao-ultimo (solucao)
  "Buscar o ultimo NO no caminho-solucao. (este NO deve ser o no inicial)"
  (no-caminho-solucao (1- (tamanho-solucao solucao)) solucao))

;;(solucao-no-tabuleiro (no-caminho-solucao-primeiro solucao-inteira))

(defun solucao-no-pontos-obj (solucao-no)
  "retorna os pontos objetivo do no (da nova estrutura de nos que esta no caminho-solucao)"
  (second solucao-no))

(defun solucao-no-pontos-atual (solucao-no)
  "retorna a pontuacao atual "
  (third solucao-no))

(defun solucao-no-profundidade (solucao-no)
  "retona a profundidade atual do no (da nova estrutura de nos que esta no caminho-solucao)"
  (fourth solucao-no))

(defun tamanho-solucao (solucao)
  "Retorna o tamanho da solucao"
  (length (solucao-nos solucao)))

(defun num-nos-gerados (solucao)
  "Retorna o numero de nos gerados"
  (+ (solucao-abertos solucao) (solucao-fechados solucao)))


;; ============ MEDIDAS DE DESEMPENHO ============

;; fator de ramificacao media
(defun fator-ramificacao-media (lista &optional (L (tamanho-solucao lista)) (valor-T (num-nos-gerados lista)) (B-min 0) (B-max valor-T) (margem 0.1))
  "Retorna o fator de ramificacao media (metodo bisseccao)"
  (float (let ((B-avg (/ (+ B-min B-max) 2)))
           (cond ((< (- B-max B-min) margem) (/ (+ B-max B-min) 2))
                 ((< (aux-ramificacao B-avg L valor-T) 0) (fator-ramificacao-media lista L valor-T B-avg B-max margem))
                 (T (fator-ramificacao-media lista L valor-T B-min B-avg margem))))))

;; B + B^2 + ... + B^L = T
(defun aux-ramificacao (B L valor-T)
  (cond
   ((= 1 L) (- B valor-T))
   (T (+ (expt B L) (aux-ramificacao B (- L 1) valor-T)))))

(defun penetrancia (solucao)
  "Calcula a penetrancia"
  (float (/ (tamanho-solucao solucao) (num-nos-gerados solucao))))

;; <solucao>::= (<no-jogada> (<nos-analisados> <n-cortes> <tempo-gasto>))
;; <no>::= (<tabuleiro> <pai> <f> <d> pontos1 pontos2)
'((((NIL 25 54 89 21 8 36 14 41 96) (78 47 56 23 5 49 13 12 26 60)
   (0 -1 17 83 34 93 74 52 45 80) (69 9 77 95 55 39 91 73 57 30)
   (24 15 22 86 1 11 68 79 76 NIL) (81 48 32 2 64 16 50 37 29 71)
   (99 51 6 18 53 28 7 63 10 88) (59 42 46 85 90 75 87 43 20 31)
   (3 61 58 44 65 82 19 4 35 62) (33 70 84 40 66 38 92 67 -2 97))

  (((-1 25 54 89 21 8 36 14 41 96) (78 47 56 23 5 49 13 12 26 60)
    (0 27 17 83 34 93 74 52 45 80) (69 9 77 95 55 39 91 73 57 30)
    (24 15 22 86 1 11 68 79 76 72) (81 48 32 2 64 16 50 37 29 71)
    (99 51 6 18 53 28 7 63 10 88) (59 42 46 85 90 75 87 43 20 31)
    (3 61 58 44 65 82 19 4 35 62) (33 70 84 40 66 38 92 67 -2 97))
   NIL 0 0 25 98)

  -46 1 52 98)

  
 (67991 14579 5))
