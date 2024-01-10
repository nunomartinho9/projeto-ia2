
;;  Autores: Nuno Martinho e Joao Coelho e João Barbosa.


;; JOGADOR 1 (COMPUTADOR) ->    -1
;; JOGADOR 2 (PESSOA OU PC) ->  -2
;; ============= TABULEIROS =============



(defun tabuleiro-teste ()
  "Tabuleiro de teste sem nenhuma jogada realizada"
  '((94 25 54 89 21 8 36 14 41 96)
    (78 47 56 23 5 49 13 12 26 60)
    (0 27 17 83 34 93 74 52 45 80)
    (69 9 77 95 55 39 91 73 57 30)
    (24 15 22 86 1 11 68 79 76 72)
    (81 48 32 2 64 16 50 37 29 71)
    (99 51 6 18 53 28 7 63 10 88)
    (59 42 46 85 90 75 87 43 20 31)
    (3 61 58 44 65 82 19 4 35 62)
    (33 70 84 40 66 38 92 67 98 97)))

(defun tabuleiro-jogado ()
  "Tabuleiro de teste igual ao anterior mas tendo sido colocado o cavalo na posicao: i=0 e j=0"
  '((-1 25 54 89 21 8 36 14 41 96)
    (78 47 56 23 5 NIL 13 12 26 60)
    (0 27 17 83 34 93 74 52 45 80)
    (69 9 77 95 55 39 91 73 57 30)
    (24 15 22 86 1 11 68 79 76 72)
    (81 48 32 2 64 16 50 37 29 71)
    (99 51 6 18 53 28 7 63 10 88)
    (59 42 46 85 90 75 87 43 20 31)
    (3 61 58 44 65 82 19 4 35 62)
    (33 70 84 40 66 38 92 67 98 97)))

;; ============= FUNCOES AUXILIARES =============

;;(remover-se #'(lambda (x) (= x 0)) '(1 2 0 2 0 4)) -> (1 2 2 4)
(defun remover-se (pred lista)
  "Reconstroi uma lista sem os elementos que verificam o predicado passado como argumento."
  (cond ((null lista) NIL)
        ((funcall pred (car lista)) (remover-se pred (cdr lista)))
        (T (cons (car lista) (remover-se pred (cdr lista))))))

;; (somar-tabuleiro (tabuleiro-teste))
(defun somar-tabuleiro (tabuleiro)
  "Soma todos os valores do tabuleiro."
  (reduce #'+ (mapcan #'(lambda (linha) (remove-if #'(lambda (celula) (or (eq celula nil) (eq celula t))) linha)) tabuleiro)))


;; (linha 0 (tabuleiro-teste))
;; (94 25 54 89 21 8 36 14 41 96)
(defun linha (index tabuleiro)
  "Funcao que recebe um indice e o tabuleiro e retorna uma lista que representa essa linha do 
tabuleiro"
  (nth index tabuleiro))

;;  (celula 0 1 (tabuleiro-teste))
;; 25
(defun celula (lin col tabuleiro)
  "Funcao que recebe dois indices e o tabuleiro e retorna o valor presente nessa celula do
tabuleiro"
  (if (or (< lin 0) (< col 0)) NIL (linha col (linha lin tabuleiro))))

;; (lista-numeros)
#|
  (99 98 97 96 95 94 93 92 91 90 89 88 87 86 85 84 83 82 81 80 79 78 77 76 75 74
 73 72 71 70 69 68 67 66 65 64 63 62 61 60 59 58 57 56 55 54 53 52 51 50 49 48
 47 46 45 44 43 42 41 40 39 38 37 36 35 34 33 32 31 30 29 28 27 26 25 24 23 22
 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)
|#
(defun lista-numeros (&optional (n 100))
  "Funcao que recebe um numero positivo n e cria uma lista com todos os numeros
entre 0 (inclusive) e o numero passado como argumento (exclusive). Por default o n é 100."
  (cond
   ((= n 1) (cons '0 '()))
   (t (cons (1- n) (lista-numeros (1- n))))))


;; (baralhar (lista-numeros))
#|
  (7 55 2 94 39 54 61 26 72 82 0 63 80 40 34 49 3 71 27 85 37 42 91 41 44 89 19
 78 99 4 46 6 24 21 83 70 5 36 60 96 18 17 95 35 33 81 56 79 51 31 86 9 97 76
 57 12 14 90 67 53 73 62 74 65 28 75 22 45 64 30 20 52 69 32 84 15 25 1 93 8 58
 50 87 77 59 68 66 16 29 92 23 88 47 13 11 38 43 10 98 48)
|#
(defun baralhar (lista)
  "Funcao que recebe uma lista e ira mudar aleatoriamente os seus numeros"
  (cond
   ((null lista) lista)
   (t
     (let ((num (nth (random (length lista)) lista)))
       (cons num (baralhar (remover-se #'(lambda (x) (= num x)) lista)))))))

;; (tabuleiro-aleatorio)
(defun tabuleiro-aleatorio (&optional (lista (baralhar (lista-numeros))) (n 10))
  "Funcao que gera um tabuleiro n x n (10 x 10 valor default)"
  (cond
   ((null lista) nil)
   (t (cons (subseq lista 0 n) (tabuleiro-aleatorio (subseq lista n) n)))))

(defun tabuleiro-ordenado (&optional (lista (lista-numeros)) (n 10))
  (cond
   ((null lista) nil)
   (t (cons (subseq lista 0 n) (tabuleiro-ordenado (subseq lista n) n)))))


;; (substituir-posicao 0 (linha 0 (tabuleiro-teste)))
;; (NIL 25 54 89 21 8 36 14 41 96)
;; (substituir-posicao 0 (linha 0 (tabuleiro-teste)) T)
;; (T 25 54 89 21 8 36 14 41 96)
(defun substituir-posicao (index lista &optional (val NIL))
  "Funcao que recebe um indice, uma lista e um valor (por default o valor e NIL) e
substitui pelo valor pretendido nessa posicao"
  (cond
   ((null lista) '())
   ((= index 0) (cons val (cdr lista)))
   (t (cons (car lista) (substituir-posicao (1- index) (cdr lista) val)))))

;;  (substituir 0 0 (tabuleiro-teste) T)
(defun substituir (lin col tabuleiro &optional (val NIL))
  "Funcao que recebe dois indices, o tabuleiro e um valor (por default o valor e NIL). A
funcao devera retornar o tabuleiro com a celula substituida pelo valor pretendido"
  (cond
   ((null tabuleiro) '())
   ((or (eq nil lin) (eq nil col)) tabuleiro);; ver isto depois
   ((= lin 0) (cons (substituir-posicao col (linha lin tabuleiro) val) (cdr tabuleiro)))
   (t (cons (car tabuleiro) (substituir (1- lin) col (cdr tabuleiro) val)))))

;; (posicao-valor 15 (tabuleiro-teste))
;; (4 1)
;; melhorar isto deixar em vez do 9 trocar por n x n

(defun posicao-valor (valor tabuleiro &optional (row 0) (column 0))
  "Funcao que recebe o tabuleiro e devolve a posicao (i j) em que se encontra o (valor)."
  (cond
   ((null tabuleiro) nil)
   ((eq valor (celula row column tabuleiro)) (list row column))
   ((< 9 row) nil)
   ((< 9 column) (posicao-valor valor tabuleiro (1+ row)))
   (t (posicao-valor valor tabuleiro row (1+ column)))))



;; (posicao-cavalo (tabuleiro-teste))
;; NIL
;; (posicao-cavalo (tabuleiro-jogado))
;; (0 0)

(defun posicao-jogador1 (tabuleiro)
  "Funcao que recebe o tabuleiro e devolve a posicao (i j) em que se encontra o jogador 1."
  (posicao-valor -1 tabuleiro))

(defun posicao-jogador2 (tabuleiro)
  "Funcao que recebe o tabuleiro e devolve a posicao (i j) em que se encontra o jogador 2."
  (posicao-valor -2 tabuleiro))


;;(contar-casas-validas (linha 0 (tabuleiro-teste)))
;;10
(defun contar-casas-validas (linha)
  "Funcao que conta casas validas em que o jogador pode jogar"
  (cond
   ((null linha) 0)
   ((or (eq (car linha) nil) (eq (car linha) -1) (eq (car linha) -2)) (contar-casas-validas (cdr linha)))
   (t (1+ (contar-casas-validas (cdr linha))))))

(defun contar-casas-validas-tabuleiro (tabuleiro &optional (l 0))
"Devolve o numero de casas validas no tabuleiro."
  (if (and (>= l 0) (<= l 9))
      (+ (contar-casas-validas (linha l tabuleiro)) (contar-casas-validas-tabuleiro tabuleiro (1+ l)))
      0))

(defun casas-validas-posicoes (tabuleiro &optional (casas (linha 0 tabuleiro)))
"Devolve uma lista com as posicoes das casas validas por linha."
  (mapcar #'(lambda (l)
              (posicao-valor l tabuleiro))
    (remover-se #'(lambda (x) (or (eq x nil) (eq x -1) (eq x -2))) casas)))


(defun media-casas-pontos (tabuleiro)
  "Media por casa dos pontos que constam no tabuleiro x."
  (let ((media (/ (somar-tabuleiro tabuleiro) (contar-casas-validas-tabuleiro tabuleiro))))
    (if (= media 0)
        1
        media)))




(defun posicionar-cavalo (tabuleiro &optional (lin 0) (col 0))
  "Posiciona o cavalo no tabuleiro na dada linha, coluna."
  (substituir lin col tabuleiro T))


;; (n-simetrico 96)
;; 69
(defun n-simetrico (num &optional (sim 0))
  "Transforma o numero passado por argumento (num) para o seu simetrico."
  (cond
   ((= num 0) sim)
   (t
     (n-simetrico (/ (- num (rem num 10)) 10) (+ (* sim 10) (rem num 10))))))

;; (posicao-simetrico 96 (tabuleiro-teste))
;;(3 0)
(defun posicao-simetrico (num tabuleiro)
  "Funcao que recebe o tabuleiro e um numero e devolve a posicao (i j) em 
    que se encontra o numero simetrico de (num)"
  (posicao-valor (n-simetrico num) tabuleiro))

;; (eliminar-simetrico 96 (tabuleiro-teste))
#|
  ((94 25 54 89 21 8 36 14 41 96) (78 47 56 23 5 49 13 12 26 60)
 (0 27 17 83 34 93 74 52 45 80) (NIL 9 77 95 55 39 91 73 57 30)
 (24 15 22 86 1 11 68 79 76 72) (81 48 32 2 64 16 50 37 29 71)
 (99 51 6 18 53 28 7 63 10 88) (59 42 46 85 90 75 87 43 20 31)
 (3 61 58 44 65 82 19 4 35 62) (33 70 84 40 66 38 92 67 98 97))
|#
(defun eliminar-simetrico (num tabuleiro)
  "Funcao que elimina o simetrico de (num) no tabuleiro"
  (let ((coordenadas-sim (posicao-simetrico num tabuleiro)))
    (substituir (car coordenadas-sim) (cadr coordenadas-sim) tabuleiro)))

;; (duplop 22)
;; T
;; (duplop 15)
;; NIL
(defun duplop (num &optional (max 99))
  "Funcao que verifica se o numero passado como argumento e duplo"
  (cond
   ((> num max) nil)
   ((= 0 (rem num 11)) t)
   (t nil)))

;; lista com todos os duplos ate 99
(defun lista-duplos ()
  "lista com duplos ate 99"
  (list 11 22 33 44 55 66 77 88 99))

;; (posicao-duplos (tabuleiro-teste))
;; ((4 5) (4 2) (9 0) (8 3) (3 4) (9 4) (3 2) (6 9) (6 0))
(defun posicao-duplos (tabuleiro)
  "Funcao que devolve uma lista com as posicoes dos numeros duplos"
  (remover-se #'(lambda (x) (eq x nil))
              (mapcar #'(lambda (dp)
                          (posicao-valor dp tabuleiro)) (lista-duplos))))


;; calcular score de um no
(defun calcular-pontos (pontos-atual tabuleiro-anterior tabuleiro-novo)
  "Recebe a pontuacao atual e, com o tabuleiro anterior e o novo tabuleiro, e devolvida a nova pontuacao."
  (let* ((pos (posicao-cavalo tabuleiro-novo))
         (pontos (celula (car pos) (cadr pos) tabuleiro-anterior)))

    (+ pontos-atual pontos)))

