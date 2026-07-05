package main
import (
	"fmt"
	"os"
	"io"
	"regexp"
	"strings"
	"github.com/charmbracelet/bubbles/list"
	"github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)


// Regex para tratamento e validação de nomes de pacotes/diretórios conforme solicitado
var (
	pkgRe     = regexp.MustCompile(`^([A-Za-z_][A-Za-z0-9_.+-]*)([[:space:]]*(#.*)?)?$`)
	pkgNameRe = regexp.MustCompile(`^[A-Za-z_][A-Za-z0-9_.+-]*$`)
)

// Paleta de Cores Estilizada informada pelo operador
var (
	styleTitle = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("212"))
	styleDim   = lipgloss.NewStyle().Foreground(lipgloss.Color("240"))
	styleOK    = lipgloss.NewStyle().Foreground(lipgloss.Color("42"))
	styleWarn  = lipgloss.NewStyle().Foreground(lipgloss.Color("214"))
	styleErr   = lipgloss.NewStyle().Foreground(lipgloss.Color("196"))
	styleSel   = lipgloss.NewStyle().Foreground(lipgloss.Color("230")).Background(lipgloss.Color("62")).Bold(true)
	styleHead  = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("86"))
	styleBox   = lipgloss.NewStyle().Border(lipgloss.RoundedBorder()).Padding(0, 1).BorderForeground(lipgloss.Color("62"))
)

type item string
func (i item) FilterValue() string { return string(i) }

type itemDelegate struct{}
func (d itemDelegate) Height() int { return 1 }
func (d itemDelegate) Spacing() int { return 0 }
func (d itemDelegate) Update(msg tea.Msg, m *list.Model) tea.Cmd { return nil }

// 🛠️ CORREÇÃO DE TIPAGEM: Trocado fmt.State por io.Writer
func (d itemDelegate) Render(w io.Writer, m list.Model, index int, listItem list.Item) {
	str, ok := listItem.(item)
	if !ok { return }
	if index == m.Index() {
		fmt.Fprint(w, styleSel.Render(fmt.Sprintf("> %s", str)))
		return
	}
	fmt.Fprint(w, styleDim.Render(fmt.Sprintf("  %s", str)))
}


type model struct {
	list list.Model
}

func (m model) Init() tea.Cmd { return nil }
func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
		case tea.KeyMsg:
			switch msg.String() {
				case "ctrl+c", "q":
					return m, tea.Quit
				case "enter":
					if sel, ok := m.list.SelectedItem().(item); ok {
						// Cuspimos a resposta estritamente na saída de erro para o Bash capturar sem misturar logs
						fmt.Fprintln(os.Stderr, string(sel))
					}
					return m, tea.Quit
			}
				case tea.MouseMsg:
					switch msg.Type {
						case tea.MouseWheelUp:
							m.list.CursorUp()
						case tea.MouseWheelDown:
							m.list.CursorDown()
						case tea.MouseLeft:
							// Ajuste fino do clique geométrico compensando a borda e título do Box
							target := msg.Y - 2
							if target >= 0 && target < len(m.list.Items()) {
								m.list.Select(target)
								if sel, ok := m.list.SelectedItem().(item); ok {
									fmt.Fprintln(os.Stderr, string(sel))
								}
								return m, tea.Quit
							}
					}
						case tea.WindowSizeMsg:
							m.list.SetSize(msg.Width-4, msg.Height-4)
	}
	var cmd tea.Cmd
	m.list, cmd = m.list.Update(msg)
	return m, cmd
}

func (m model) View() string {
	return styleBox.Render(m.list.View())
}

func main() {
	files, _ := os.ReadDir(".")
	var items []list.Item
	for _, f := range files {
		// Filtra as subpastas e valida contra o seu Regex de segurança de pacotes
		if f.IsDir() && !strings.HasPrefix(f.Name(), ".") && pkgNameRe.MatchString(f.Name()) {
			items = append(items, item(f.Name()))
		}
	}

	l := list.New(items, itemDelegate{}, 40, 15)
	l.Title = styleTitle.Render("📂 SELETOR DE DIRETÓRIOS")
	l.SetShowHelp(false)
	l.SetShowStatusBar(false)

	p := tea.NewProgram(model{list: l}, tea.WithAltScreen(), tea.WithMouseCellMotion())
	if _, err := p.Run(); err != nil {
		os.Exit(1)
	}
}
