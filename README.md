# Zombie Arena

Um jogo de arena 2D onde o jogador enfrenta hordas de zumbis em uma batalha pela sobrevivência.

## Descrição

Zombie Arena é um jogo de ação em 2D onde o jogador controla um personagem em uma arena e deve sobreviver a ondas de zumbis que vêm de todas as direções. O jogo aumenta em dificuldade à medida que o tempo passa, com mais zumbis e zumbis mais fortes aparecendo.

## Como Jogar

- Use as teclas WASD ou as setas para mover o personagem
- Mire com o mouse
- Clique para atirar
- Sobreviva o máximo de tempo possível!

## Estrutura do Projeto

```
zoombie-arena/
├── scenes/             # Cenas do jogo
│   ├── Main.tscn       # Cena principal
│   ├── Arena.tscn      # Cena da arena
│   ├── Player.tscn     # Cena do jogador
│   └── Zombie.tscn     # Cena do zumbi
├── assets/             # Recursos do jogo
│   ├── images/         # Imagens e sprites
│   └── sounds/         # Efeitos sonoros e músicas
└── scripts/            # Scripts do jogo
    ├── Player.gd       # Script do jogador
    ├── Zombie.gd       # Script do zumbi
    └── GameManager.gd  # Script de gerenciamento do jogo
```

## Como Adicionar Imagens ao Jogo

Para adicionar imagens ao jogo, siga estas etapas:

1. Coloque seus arquivos de imagem na pasta `assets/images/`
2. Formatos recomendados: PNG ou SVG (para melhor qualidade)
3. Para usar uma imagem em uma cena:
   - Abra a cena no editor Godot
   - Selecione o nó onde deseja aplicar a imagem
   - No painel Inspector, encontre a propriedade "Texture" ou "Sprite"
   - Clique no ícone de pasta e navegue até sua imagem em `assets/images/`

### Imagens Necessárias

Para completar o jogo, você precisará criar e adicionar as seguintes imagens:

- `player.png`: Sprite do jogador (32x32 pixels recomendado)
- `zombie.png`: Sprite básico de zumbi (32x32 pixels recomendado)
- `arena_floor.png`: Textura do chão da arena (pode ser um padrão repetível)
- `arena_wall.png`: Textura para as paredes/limites da arena
- `bullet.png`: Sprite para os projéteis (pequeno, 8x8 pixels recomendado)
- `blood_splatter.png`: Efeito para quando um zumbi é atingido

## Desenvolvimento

Este jogo está sendo desenvolvido com Godot Engine 4.2. 