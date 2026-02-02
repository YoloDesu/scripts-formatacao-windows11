# Scripts para pré e pós formatação do Windows 11

> Atenção: Esses scripts foram baseados nos meus gostos e preferências e, portanto, estão sujeitos a alteração.

* [Autounattend](#autounattend)
   * [Resumo desse Autounattend](#resumo-desse-autounattend)
   * [Apps removidos (Debloat)](#apps-removidos)
   * [Checklist antes de usar](#checklist-antes-de-usar)
* [Script Powershell](#script-powershell)
---

## Autounattend

O arquivo **autounattend.xml** automatiza a instalação do Windows, define idioma/região, aceita a EULA, cria um usuário local administrador e executa scripts PowerShell em momentos específicos para aplicar personalizações adicionais. Para usar ele, basta colocar o arquivo `autounattend.xml` no pendrive de instalação do Windows. 

> **Observação importante**: Todas as configurações do `autounattend.xml` foram feitas através do [Schneegans.de](http://schneegans.de/windows/unattend-generator), créditos ao [Christoph Schneegans](https://github.com/cschneegans/). Quaisquer alterações desejadas devem ser feitas na [ferramenta](schneegans.de/windows/unattend-generator) através do import.

---

## Resumo desse Autounattend

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
- Desativação do `Smart App Control` e `SmartScreen`
- Desativação do reinicio forçado do Windows Update
- Desativação do Edge em 2º Plano e `First Experience`
- Desativação de acelerador de mouse
- Desativação de teclas de aderência
- Habilitação de caminhos longos (Máx: 32,767) sem o uso de `\\?\`
- Sem ativação nativa do BitLocker
- Remoção de apps padrão (Conferir)

---

## Apps removidos

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
- [ ] Colocou o arquivo .xml no pendrive de instalação?
- [ ] A lista de debloats condiz com o que quero?

>É recomendado rodar o comando `Disable-MMAgent -MemoryCompression` após a instalação se sua máquina possui 16GB de RAM ou mais.
---

## Script Powershell

Antes da execução de qualquer script, abra o Powershell como Admin (Win + X) e execute o comando:
>Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

E para a execução de qualquer script basta acessar a pasta onde foi feito o download do arquivo `.ps1` e rodar o comando
>.\\nome-do-script.ps1

---

## setup.ps1

Esse script é executado após a formatação do Windows para instalar os apps principais do autor do repositório, como:

- FFMPEG (Já adicionado ao PATH)
- Dependênicias de C e C++
- VS Code
- Visual Studio 2022
- Steam
- Epic Games
- Floorp (Browser)
- Discord
- Visual C++ 2015-2022
- .NET 3.5
- VLC Player
- GIT
- qbittorrent
- Vulkan
- AMD Adrenalin Software
