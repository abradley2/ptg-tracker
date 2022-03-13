class FocusMenu extends HTMLElement {

    onDisconnect?: () => void;

    static get observedAttributes() {
        return ['show']
    }

    disconnectedCallback() {
        if (this.onDisconnect) this.onDisconnect()
    }

    attributeChangedCallback(name: string, oldVal: string, newVal: string) {
        const node = this
        const children = this.children

        if (name === 'show') {
            const show = newVal === 'true'

            if (!show) {
                ;[...node.children].forEach((child) => child.setAttribute('tabindex', '-1'))
                if (node.onDisconnect) {
                    node.onDisconnect()
                    node.onDisconnect = undefined
                }
            }

            if (show) {
                ;[...node.children].forEach((child) => child.setAttribute('tabindex', '0'))

                function handleKeyPress(e: KeyboardEvent) {
                    const activeElement = document.activeElement as Element

                    if (e.key === 'ArrowUp') {
                        if (
                            [...children].includes(activeElement) &&
                            activeElement.previousElementSibling
                        ) {
                            ; (activeElement.previousElementSibling as HTMLElement).focus()
                        }
                    }
                    if (e.key === 'ArrowDown') {
                        if (
                            [...children].includes(activeElement) &&
                            activeElement.nextElementSibling
                        ) {
                            ; (activeElement.nextElementSibling as HTMLElement).focus()
                        }
                    }
                }

                function handleFocusOut(e: FocusEvent) {
                    if (node.contains(e.relatedTarget as Node) || (e.relatedTarget as Element).getAttribute('aria-controls') === node.getAttribute('id')) {
                        return
                    }
                    node.dispatchEvent(new Event('requestedclose', {
                        bubbles: true
                    }))
                    if (node.onDisconnect) node.onDisconnect()
                }

                document.addEventListener('keydown', handleKeyPress)
                node.addEventListener('focusout', handleFocusOut)

                node.onDisconnect = function () {
                    document.removeEventListener('keydown', handleKeyPress)
                    node.removeEventListener('focusout', handleFocusOut)
                    node.onDisconnect = undefined
                }

                setTimeout(() => {
                    if (node.firstChild) {
                        ; (node.firstChild as HTMLElement).focus()
                    }
                }, 20)
            }
        }
    }
}

module.exports = { FocusMenu }
