export class SelectMenu extends HTMLElement {
  onHide?: () => void
  onDisconnect?: () => void
  focusIndex: number
  controller: HTMLElement & HTMLButtonElement

  constructor() {
    super()
    this.controller = document.querySelector('[aria-controls="' + this.id + '"]') as HTMLElement & HTMLButtonElement
    this.focusIndex = -1
  }

  static get observedAttributes(): string[] {
    return ['show']
  }

  disconnectedCallback(): void {
    if (this.onHide) this.onHide()
    if (this.onDisconnect) this.onDisconnect()
  }

  connectedCallback(): void {
    this.controller = document.querySelector('[aria-controls="' + this.id + '"]') as HTMLElement & HTMLButtonElement
    this.setAttribute('tabindex', '-1')

    const onMouseDown = (e: MouseEvent) => {
      if (e.target && (e.target as HTMLElement).getAttribute('role') === 'option') {
        const idx = Array.from(this.children).indexOf(e.target as HTMLElement)

        const ev = new CustomEvent('itemselected', {
          bubbles: true,
          detail: idx
        })

        this.dispatchEvent(ev)

        // allow the input to blur, but then refocus it
        requestAnimationFrame(() => {
          this.controller.focus()
        })
      }
    }

    const onTouchStart = (e: unknown) => {
      onMouseDown(e as MouseEvent)
    }

    let onKeyDown: undefined | ((e: KeyboardEvent) => void)
    const onMenuClick = () => {
      if (this.getAttribute('show') === 'false') {
        this.dispatchEvent(new CustomEvent('requestedopen'))
      }
    }

    const handleFocus = () => {
      onKeyDown = (e: KeyboardEvent) => {
        if (this.getAttribute('show') === 'false' && e.key === 'Enter') {
          this.dispatchEvent(new CustomEvent('requestedopen'))
        }

        if (this.getAttribute('show') === 'false' && e.key === 'ArrowDown') {
          e.preventDefault()
          const showEv = new CustomEvent('requestedopen')

          this.dispatchEvent(showEv)
          requestAnimationFrame(() => {
            this.focusIndex = 0
            const focusEv = new CustomEvent('focusindexchanged', {
              detail: this.focusIndex,
              bubbles: true
            })
            this.dispatchEvent(focusEv)
          })
        }
      }
      this.controller.addEventListener('keydown', onKeyDown)
    }

    const handleBlur = () => {
      if (onKeyDown) {
        this.controller.removeEventListener('keydown', onKeyDown)
        onKeyDown = undefined
      }
    }

    this.controller.addEventListener('touchstart', onMenuClick)
    this.controller.addEventListener('mousedown', onMenuClick)
    this.controller.addEventListener('focus', handleFocus)
    this.controller.addEventListener('blur', handleBlur)
    this.addEventListener('touchstart', onTouchStart)
    this.addEventListener('mousedown', onMouseDown)

    this.onDisconnect = () => {
      this.removeEventListener('touchstart', onTouchStart)
      this.removeEventListener('mousedown', onMouseDown)
      this.controller.removeEventListener('touchstart', onMenuClick)
      this.controller.removeEventListener('mousedown', onMenuClick)
      this.controller.removeEventListener('focus', handleFocus)
      this.controller.removeEventListener('blur', handleBlur)
    }
  }

  attributeChangedCallback(name: string, oldVal: string, newVal: string): void {
    const children = this.children

    if (name === 'show') {
      const show = newVal === 'true'
      this.focusIndex = -1

      if (!show) {
        if (this.onHide) {
          this.onHide()
          this.onHide = undefined
        }
      }

      if (show) {
        const handleKeyPress = (e: KeyboardEvent) => {
          const focusIndex = this.focusIndex as number
          const activeElement = document.activeElement as Element


          if (e.key === 'ArrowUp') {
            if (this.childNodes[focusIndex - 1]) {
              this.focusIndex = focusIndex - 1
              e.preventDefault()
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
              e.preventDefault()
            }

            const ev = new CustomEvent('focusindexchanged', {
              detail: this.focusIndex,
              bubbles: true
            })

            this.dispatchEvent(ev)
          }

          if (e.key === 'Enter' && this.focusIndex === -1) {
            this.dispatchEvent(new CustomEvent('requestedclose'))
          }

          if (e.key === 'Enter' && this.focusIndex > -1) {
            const ev = new CustomEvent('itemselected', {
              bubbles: true,
              detail: this.focusIndex
            })

            this.dispatchEvent(ev)

            requestAnimationFrame(() => {
              this.dispatchEvent(new CustomEvent('requestedclose'))
            })
          }
        }


        const handleBlur = (e: any) => {
          const ev = new CustomEvent('requestedclose')

          this.dispatchEvent(ev)
        }

        this.controller.addEventListener('blur', handleBlur)
        document.addEventListener('keydown', handleKeyPress)

        this.onHide = () => {
          this.controller.removeEventListener('blur', handleBlur)
          document.removeEventListener('keydown', handleKeyPress)
          this.onHide = undefined
        }
      }
    }
  }
}

module.exports = { SelectMenu }
