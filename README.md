# zsh-config

Configuração pessoal do zsh (macOS) num único ficheiro, [.zshrc](.zshrc), assente em Oh My Zsh e em algumas ferramentas instaladas via Homebrew.

## O que faz

### Oh My Zsh
- Tema `amuse`, plugin `git`, atualizações automáticas (`zstyle ':omz:update' mode auto`).
- Correção automática de comandos desligada; mostra pontos enquanto espera pelo autocomplete; `-` e `_` são equivalentes no autocomplete.
- Adiciona o `site-functions` do Homebrew ao `fpath` (usa `/opt/homebrew` ou `brew --prefix`).

### PATH
- Acrescenta `~/.local/bin` ao início do `PATH` e remove entradas duplicadas.

### Histórico
- 100 000 entradas em `~/.zsh_history`, partilhado entre terminais abertos, com data/hora.
- Sem duplicados, ignora comandos começados por espaço, reduz espaços em branco e pede confirmação (`HIST_VERIFY`) ao expandir `!`.
- **Histórico enquanto escreves** (implementado de raiz, sem plugin): a partir de 2 caracteres mostra até 8 comandos anteriores que começam pelo que escreveste.
  - `↑` / `↓` (ou `Ctrl+P` / `Ctrl+N`) navegam na lista; `Tab` aceita a entrada escolhida.
  - Fora da navegação, `Tab` faz o autocomplete normal (via fzf).

### Autocomplete
- Completa ignorando maiúsculas/minúsculas, em partes de nomes (separadas por `.`, `_`, `-`) e tolera 1 erro de escrita (`_approximate`).
- Resultados agrupados com títulos coloridos, pastas primeiro, menu navegável no `kill`.
- No menu: `Shift+Tab` recua, `Esc` cancela.

### Node.js (fnm)
- Inicializa o `fnm` e muda automaticamente de versão do Node ao entrar numa pasta com `.nvmrc`/`.node-version` (`--use-on-cd`).

### fzf
- `Ctrl+R` pesquisa no histórico, `Ctrl+T` escolhe ficheiros (com pré-visualização via `bat`), `Alt+C` entra numa pasta (com pré-visualização do conteúdo).
- Usa `fd` para listar ficheiros/pastas, incluindo ocultos e a seguir symlinks, excluindo `.git` e `node_modules`.
- Interface a 40 % da altura do terminal (60 % no `Ctrl+R`).

### zoxide
- `z <pasta>` salta para pastas visitadas com frequência; `zi` abre um seletor interativo.

### Aliases
| Alias | Comando |
|---|---|
| `ll` / `la` / `l` | `ls -lah` / `ls -A` / `ls -CF` |
| `gs` / `gc` | `git status` / `git commit` |
| `cls` | `clear` |
| `clinica` | `cd ~/www/doutorfinancas` |
| `front` | `cd ~/www/doutorfinancas/clinica.doutorfinancas.pt` |
| `backend` | `cd ~/www/doutorfinancas/api.doutorfinancas.pt` |

### Plugins carregados no fim
- **zsh-autosuggestions**: sugere a continuação a partir do histórico e do autocomplete (`→` aceita).
- **zsh-syntax-highlighting**: colore o comando enquanto escreves. Tem de ser o último `source` do ficheiro.

## Requisitos
- [Oh My Zsh](https://ohmyz.sh/)
- Homebrew, com:

```sh
brew install fnm fzf fd bat zoxide zsh-autosuggestions zsh-syntax-highlighting
```

## Instalação
Faz um link do ficheiro para a home (ou copia-o) e abre um novo terminal:

```sh
ln -sf ~/www/zsh-config/.zshrc ~/.zshrc
source ~/.zshrc
```
