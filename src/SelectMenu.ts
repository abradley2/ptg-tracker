export class SelectMenu extends HTMLElement {
  onDisconnect?: () => void
  focusIndex?: number

  static get observedAttributes(): string[] {
    return ['show']
  }

  disconnectedCallback(): void {
    if (this.onDisconnect != null) this.onDisconnect()
  }

  connectedCallback(): void {
    this.setAttribute('tabindex', '-1')
  }

  attributeChangedCallback(name: string, oldVal: string, newVal: string): void {
    const children = this.children

    if (name === 'show') {
      const show = newVal === 'true'

      if (!show) {
        this.focusIndex = undefined

        if (this.onDisconnect != null) {
          this.onDisconnect()
          this.onDisconnect = undefined
        }
      }

      if (show) {
        if (typeof this.focusIndex === 'undefined') {
          this.focusIndex = -1
        }

        const handleKeyPress = (e: KeyboardEvent) => {
          const focusIndex = this.focusIndex as number
          const activeElement = document.activeElement as Element


          if (e.key === 'ArrowUp') {
            if (this.childNodes[focusIndex - 1]) {
              this.focusIndex = focusIndex - 1
            }

            const ev = new CustomEvent('focusindexchanged', {
              detail: this.focusIndex,
              bubbles: true
            })

            this.dispatchEvent(ev)
          }
          if (e.key === 'ArrowDown') {
            if (this.childNodes[focusIndex + 1]) {
              this.focusIndex = focusIndex + 1
            }

            const ev = new CustomEvent('focusindexchanged', {
              detail: this.focusIndex,
              bubbles: true
            })

            this.dispatchEvent(ev)
          }

          if (e.key === 'Enter') {
            const ev = new CustomEvent('itemselected', {
              bubbles: true,
              detail: this.focusIndex
            })

            this.dispatchEvent(ev)
            this.dispatchEvent(new CustomEvent('requestedclose'))
            const controller = document.querySelector('[aria-controls="' + this.id + '"]') as HTMLElement
            if (controller) controller.focus()
          }
        }

        const handleOutsideClick = (e: MouseEvent) => {
          if (e.target === this || this.contains(e.target as Node)) {
            return
          }

          if (e.target !== null && (e.target as Element).getAttribute('aria-controls') === this.getAttribute('id')) {
            return
          }

          const ev = new CustomEvent('requestedclose')

          this.dispatchEvent(ev)
        }

        const handleBlur = () => {
          const ev = new CustomEvent('requestedclose')

          this.dispatchEvent(ev)
        }

        const controller = document.querySelector('[aria-controls="' + this.id + '"]') as HTMLElement

        controller.addEventListener('blur', handleBlur)
        document.addEventListener('keydown', handleKeyPress)
        document.addEventListener('click', handleOutsideClick)

        this.onDisconnect = () => {
          controller.removeEventListener('blur', handleBlur)
          document.removeEventListener('keydown', handleKeyPress)
          document.removeEventListener('click', handleOutsideClick)
          this.onDisconnect = undefined
        }
      }
    }
  }
}

module.exports = { SelectMenu }
