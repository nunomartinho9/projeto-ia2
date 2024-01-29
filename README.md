# Manual de Utilizador

### **Projeto N.º 2 - Época Normal**

Inteligência Artificial - Escola Superior de Tecnologia de Setúbal

2023/2024

Prof. Joaquim Filipe

**Grupo 17**

---

Nuno Martinho, n.º 201901769

João Coelho, n.º 201902001

João Barbosa, n.º 201901785

### **Índice**

---
- [**Acrónimos e Siglas**](#acrónimos-e-siglas)
- [**Introdução**](#introdução)
- [**Instalação e Utilização**](#instalação-e-utilização)

<a id="acrónimos-e-siglas"></a>
### **Acrónimos e Siglas**

---

> IDE - Integrated Development Environment (Ambiente de Desenvolvimento Integrado)
> 

> Listener - Ferramenta do *LispWorks* em que executamos funções.
> 

> Stack - A memória stack é uma região de armazenamento temporário na RAM.
> 
<a id="introdução"></a>
### **Introdução**

---

Este manual tem como objetivo ser um guia para a correta utilização do programa Jogo do Cavalo, uma versão simplificada do jogo original. Nesta versão, que já conta com partidas de 2 jogadores, existem também dois modos de jogo (“Humano vs Computador” e “Computador vs Computador”) que serão realizados em tabuleiros de tamanho 10 por 10 completamente aleatórios.

![Tabuleiro do Jogo do Cavalo](imagens/Untitled.png)

Tabuleiro do Jogo do Cavalo

Este programa foi desenvolvido na linguagem de programação LISP em ambiente de desenvolvimento *LispWorks*.

<a id="instalação-e-utilização"></a>
### **Instalação e Utilização**

---

> **Instalação**
> 

Para que o programa possa funcionar é necessário possuir um *IDE* ou um interpretador que compile a linguagem *Common LISP* (é recomendado o programa *LispWorks Personal Edition 8.0.1*).

1. Abrir com o programa escolhido o ficheiro *interact.lisp*
2. (Opcional) Se estiver a usar o *LispWorks* é recomendado aumentar o *stack* do *listener*: Tools → *Preferences*… → *Listener* → *Initial stack size* → Alterar de *Default* para 64000.
3. Reabrir/abrir o *Listener*
4. Abrir o ficheiro *interact.lisp*
5. Alterar no editor o caminho da pasta do projeto (ver função *diretorio*)
6. Compilar o ficheiro *interact.lisp*

> **Navegação**
> 

Para iniciar o programa é necessário executar a função (***iniciar***).

Para continuar a navegar pelos menus basta apenas premir um dos algarismos presentes no ecrã e clicar na tecla ***Enter.***

Para regressar ao menu inicial (ou sair da aplicação no caso de já estar localizado no menu inicial) bastará escolher a **opção 0**.

> **Escolher o modo de jogo**
> 

Para poder iniciar uma partida do Jogo do Cavalo deverá selecionar um dos modos de jogo disponíveis no menu seguinte.

![Untitled](imagens/Untitled%201.png)

- Se escolher a opção **1 - Humano vs CPU** - será iniciada uma partida em que o utilizador irá jogar contra o computador.
- Caso escolha a opção **2 - CPU vs CPU** - será iniciada uma partida em que o computador irá jogar contra um outro computador.
- A opção **0 - Sair** - permitirá encerrar o programa.

> **Escolher o primeiro a jogar** (apenas no modo *Humano vs CPU*)
> 

Neste menu poderá escolher quem irá ser o primeiro a jogar: Humano (opção 1) ou Computador (opção 2).

![Untitled](imagens/Untitled%202.png)

> **Definir o tempo limite da jogada do CPU**
> 

Para que as jogadas efetuadas pelo Computador não demorem muito tempo, terá de definir o tempo limite da jogada do mesmo.

![Untitled](imagens/Untitled%203.png)

> **Definir a profundidade máxima**
> 

Defina a profundidade máxima do algoritmo de procura no menu seguinte. 

<aside>
💡 Para uma profundidade equilibrada recomenda-se um valor próximo de 50.

</aside>

![Untitled](imagens/Untitled%204.png)

> **Jogabilidade**
> 

> **Humano vs Computador**
> 

![Untitled](./manuais/imagens/Untitled%205.png)

Depois de iniciar a partida, irá ser apresentado algo idêntico ao que está a ser mostrado acima (podendo mudar apenas as posições de cada jogador e os valores do tabuleiro). 

Nesta partida o primeiro jogador a realizar uma jogado é o utilizador (jogador -2). Cada jogador pode mover a sua indicando a Linha e de seguida a Coluna para a qual a quer mover. A peça só pode ser movida em L (como o cavalo no xadrez).

![Untitled](./manuais/imagens/Untitled%206.png)

O Utilizador realizou a jogada na Linha 7 e Coluna 8, movendo a sua peça para a devida posição, colocando a posição anterior a NIL e somando os pontos da sua posição atual com os pontos totais do mesmo.

De seguida, joga o CPU no tempo definido na criação do jogo (neste caso foi 1000ms).

![Untitled](./manuais/imagens/Untitled%207.png)

Após varias jogadas, o jogo irá determinar um vencedor quando já houver mais jogadas possíveis, ou seja, nenhum dos dois jogadores poder mover a sua peça.

Assim, são comparados os pontos entre os dois jogadores e é dada a vitória ao jogador com mais pontos somados ao longo da partida e é apresentado o output seguinte.

![Untitled](./manuais/imagens/Untitled%208.png)

> **Computador vs Computador**
> 

Quando se trata de CPU vs CPU, para a partida ser iniciado é necessário escolher o tempo de cada jogada (entre 1000ms e 5000ms) e a profundidade.

![Untitled](./manuais/imagens/Untitled%209.png)

Após o inicio da partida, cada um dos CPU faz as suas jogadas de forma automática dentro do tempo indicado no iniciar da partida.

Jogada do CPU1.

![Untitled](./manuais/imagens/Untitled%2010.png)

De seguida a jogada do CPU2 no tempo definido.

![Untitled](./manuais/imagens/Untitled%2011.png)

Após diversas jogadas automáticas entre os CPU’s, consagra-se o vencedor da partida entre os mesmos.

Novamente apresentando o output necessário com a ultima jogada, os pontos e o vencedor.

 

![Untitled](./manuais/imagens/Untitled%2012.png)