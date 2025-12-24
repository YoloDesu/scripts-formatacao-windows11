# scripts-formatacao-windows11

Este arquivo **Unattend/Autounattend** automatiza a instalação do Windows, define idioma/região, aceita a EULA, cria um usuário local administrador e executa scripts PowerShell em momentos específicos para aplicar personalizações adicionais.

> **Observação importante**: as **remoções e alterações mais profundas do Windows** normalmente estão **dentro dos scripts PowerShell** chamados por este XML (`Specialize.ps1`, `DefaultUser.ps1`, `FirstLogon.ps1`). Este `autounattend.xml` **orquestra** a execução desses scripts, mas **não descreve explicitamente** o que é removido sem a análise dos `.ps1`.

---

## Resumo:

- Automatiza a instalação inicial do Windows 11
- Define idioma, região e layout de teclado (pt-BR / ABNT2)
- Aceita automaticamente a licença (EULA)
- Direciona a instalação para uma edição específica via **Product Key genérica**
- Cria um usuário local administrador
- Sem Modo Compacto do OS
- Mostra arquivos ocultos (Não incluindo os do sistema)
- Mostra extensão dos arquivos
- Context Menu clássico (Clique direito do W10 em vez do W11)
- Explorador de arquivos direciona para `Este Computador` em vez de `Acesso Rápido`
- Clique direito em aplicativos da Taskbar oferece a opção 'Finalizar Tarefa' (Mesmo nível do Taskmanager)
- Menu do Windows à esquerda, e sem adicionais como barra de pesquisa
- Desativação dos `Widgets`
- Desativação dos resultados do Bing quando é feita pesquisa no menu do Windows
- Desativação do Smart App Control e SmartScreen
- Desativação do reinicio forçado do Windows Update
- Desativação do Edge em 2º Plano e `First Experience`
- Desativação de acelerador de mouse
- Desativação de teclas de aderência
- Habilitação de caminhos longos (Máx: 32,767) sem o uso de `\\?\`
- Sem ativação nativa do BitLocker
- Remoção de apps padrão (Conferir)

---

## Apps removidos (Debloat):

- 3D viewer
- Bing Search
- Clipchamp
- Copilot
- Cortana
- Dev Home
- Facial recognition (Windows Hello)
- Family
- Feedback Hub
- Game Assist
- Get Help
- Handwriting (all languages)
- Internet Explorer
- Mail and Calendar
- Maps   
- Math Input Panel
- Mixed Reality
- Movies & TV
- News
- Office 365
- OneDrive
- OneNote
- OneSync
- Outlook
- Paint 3D
- People
- Power Automate
- Quick Assist
- Recall
- Skype
- Solitaire Collection
- Speech
- Steps Recorder
- Sticky Notes
- Teams
- Tips
- To Do
- Weather
- Wallet

---

## Checklist antes de usar

- [ ] O usuário `usuario` é o desejado?
- [ ] A senha vazia é realmente intencional?
- [ ]
