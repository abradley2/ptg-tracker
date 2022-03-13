export class FocusMenu extends HTMLElement {
  onDisconnect?: () => void

  static get observedAttributes(): string[] {
    return ['show']
  }

  disconnectedCallback(): void {
    if (this.onDisconnect != null) this.onDisconnect()
  }

  attributeChangedCallback(name: string, oldVal: string, newVal: string): void {
    const node = this
    const children = this.children

    if (name === 'show') {
      const show = newVal === 'true'

      if (!show) {
        this.tabIndex = -1

        if (node.onDisconnect != null) {
          node.onDisconnect()
          node.onDisconnect = undefined
        }
      }

      if (show) {
        this.tabIndex = 0
        this.focus()

        function handleKeyPress(e: KeyboardEvent) {
          const activeElement = document.activeElement as Element

          if (e.key === 'ArrowUp') {
            if (
              [...children].includes(activeElement) &&
              (activeElement.previousElementSibling != null)
            ) {
              ; (activeElement.previousElementSibling as HTMLElement).focus()
            }
          }
          if (e.key === 'ArrowDown') {
            if (
              [...children].includes(activeElement) &&
              (activeElement.nextElementSibling != null)
            ) {
              ; (activeElement.nextElementSibling as HTMLElement).focus()
            }
          }
        }

        function handleFocusOut(e: FocusEvent) {
          if (node.contains(e.relatedTarget as Node) ||
            ((e.relatedTarget != null) && (e.relatedTarget as Element).getAttribute('aria-controls') === node.getAttribute('id'))
          ) {
            return
          }

          node.dispatchEvent(new Event('requestedclose', {
            bubbles: true
          }))
          if (node.onDisconnect != null) node.onDisconnect()
        }

        document.addEventListener('keydown', handleKeyPress)
        node.addEventListener('focusout', handleFocusOut)

        node.onDisconnect = function () {
          document.removeEventListener('keydown', handleKeyPress)
          node.removeEventListener('focusout', handleFocusOut)
          node.onDisconnect = undefined
        }

        setTimeout(() => {
          if (node.firstChild != null) {
            ; (node.firstChild as HTMLElement).focus()
          }
        }, 20)
      }
    }
  }
}

module.exports = { FocusMenu }
