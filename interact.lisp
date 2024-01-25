;; funções que permitem escrever e ler em ficheiros e tratar da interação com o utilizador 

(defun diretorio ()
    "C:/Users/joaor/OneDrive/Documentos/IPS/ESTS/LEI/3_ANO/IA/Projeto/ia-projeto2/"
;;    "U:/Documents/LEI/AnoCorrente/ia/PROJETO/"
)

(compile-file (concatenate 'string (diretorio) "algoritmo.lisp"))
(compile-file (concatenate 'string (diretorio) "jogo.lisp"))
(load (concatenate 'string (diretorio) "algoritmo.lisp"))
(load (concatenate 'string (diretorio) "jogo.lisp"))