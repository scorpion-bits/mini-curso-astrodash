# mini-curso-astrodash

Mini curso para fazer o primeiro jogo!

Em duas aulas de 1h20 a gente cria do zero, no **Godot 4.7**, um jogo de sobrevivência no espaço inspirado no modo singleplayer do AstroDash: asteroides vêm de todas as direções e a nave precisa desviar e sobreviver o máximo de tempo possível.

A arte provisória é o ícone do Godot. Na segunda parte do curso desenhamos as artes no LibreSprite e trocamos no jogo.

## O que tem aqui

| Pasta | Conteúdo |
|---|---|
| `slides/index.html` | Apresentação com prints do Godot e todos os códigos (botão **Copiar** em cada um) |
| `slides/AstroDash-mini-curso.pdf` | A mesma apresentação em PDF |
| `CODIGOS.md` | Todos os scripts do curso, para copiar e colar |
| `projeto/checkpoint-aula1/` | O projeto como fica no **fim da Aula 1**. Use para começar a Aula 2 se você se perdeu |
| `projeto/astrodash-final/` | O jogo completo, no fim da Aula 2 |

## Como usar os slides

Online: **https://scorpion-bits.github.io/mini-curso-astrodash/** (GitHub Pages)

Ou abra `slides/index.html` no navegador (funciona sem internet).

- `→` / `espaço` / clique: próximo slide · `←`: anterior
- `M`: índice com todos os slides · `F`: tela cheia
- Clique em um print para ampliar
- O botão **Copiar** copia o arquivo inteiro, mesmo quando o script está dividido em várias páginas

## Como abrir os projetos

1. Abra o Godot 4.7 → **Importar** → escolha o `project.godot` de uma das pastas em `projeto/`.
2. Aperte **F5** para jogar. Controles: **WASD**, **setas** ou analógico do controle.

## Arquitetura do jogo

```
autoload/game_manager.gd        GameManager (Autoload): tempo, recorde, troca de cena
components/                     HealthComponent e HurtboxComponent (reutilizáveis)
entities/player/                Nave (CharacterBody2D)
entities/asteroid/              Asteroide (RigidBody2D)
systems/asteroid_spawner/       Path2D + Timer + Curve de dificuldade
levels/game/                    A fase: fundo, paredes, spawner, player e UI
levels/background/              Fundo animado (Parallax2D)
ui/                             HUD, Game Over, Menu e tema global
assets/sprites, backgrounds     Artes da 2ª parte (LibreSprite)
```

Sempre que dá, o curso usa ferramentas do editor em vez de código: Mapa de Entrada, nomes de camadas de física, sinais conectados pelo editor (inclusive direto para `queue_free`), Path2D, Timer, Curve exportada, Parallax2D, Containers e Tema.

## Trocando a arte (2ª parte)

| Arte | Tamanho | Onde trocar |
|---|---|---|
| Nave | 32×32, apontando para a **direita** | `entities/player/player.tscn` → Sprite2D → Texture (volte o Scale para 1) |
| Asteroide | 32×32 | `entities/asteroid/asteroid.tscn` → Sprite2D → Texture (volte o Scale para 1) |
| Fundo | 640×360 | `levels/background/background.tscn` → Sprite2D → Texture |
| Partícula | 4×4 ou 8×8 | `player.tscn` → DeathParticles → Texture |
| Fonte | .ttf pixel | `ui/theme.tres` → Default Font |

O projeto já usa resolução 640×360 com filtro **Nearest**, então pixel art fica nítida sem configurar nada.
