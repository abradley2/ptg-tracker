export class SelectMenu extends HTMLElement {
  onDisconnect?: () => void
  focusIndex?: number

  static get observedAttributes(): string[] {
    return ['show']
  }

  disconnectedCallback(): void {
    if (this.onDisconnect != null) this.onDisconnect()
  }

  attributeChangedCallback(name: string, oldVal: string, newVal: string): void {
    const children = this.children

    if (name === 'show') {
      const show = newVal === 'true'

      if (!show) {
        this.tabIndex = -1
        this.focusIndex = undefined

        if (this.onDisconnect != null) {
          this.onDisconnect()
          this.onDisconnect = undefined
        }
      }

      if (show) {
        this.focusIndex = -1
        const focusIndex = this.focusIndex as number

        this.tabIndex = 0
        this.focus()

        const handleKeyPress = (e: KeyboardEvent) => {
          const activeElement = document.activeElement as Element

          if (e.key === 'ArrowUp') {
            if (this.children[focusIndex + 1]) {
              this.focusIndex = focusIndex + 1
            }

            const ev = new CustomEvent('focusindexchanged', {
              detail: this.focusIndex
            })

            this.dispatchEvent(ev)
          }
          if (e.key === 'ArrowDown') {
            if (this.children[focusIndex - 1]) {
              this.focusIndex = focusIndex + 1
            }

            const ev = new CustomEvent('focusindexchanged', {
              detail: this.focusIndex
            })

            this.dispatchEvent(ev)
          }

          if (e.key === 'Enter') {
            const ev = new CustomEvent('itemselected', {
              bubbles: true
            })

            this.dispatchEvent(ev)
          }
        }

        const handleOutsideClick = (e: MouseEvent) => {

        }

        document.addEventListener('keydown', handleKeyPress)
        document.addEventListener('click', handleOutsideClick)

        this.onDisconnect = () => {
          document.removeEventListener('keydown', handleKeyPress)
          this.removeEventListener('click', handleOutsideClick)
          this.onDisconnect = undefined
        }
      }
    }
  }
}

module.exports = { SelectMenu }
