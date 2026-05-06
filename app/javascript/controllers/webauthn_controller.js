import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { challengeUrl: String }
  static targets = ["username", "email", "error"]

  async register(event) {
    event.preventDefault()
    this.clearError()

    const username = this.usernameTarget.value.trim()
    const email = this.emailTarget.value.trim()

    if (!username || !email) {
      this.showError("Please enter a username and email.")
      return
    }

    try {
      const challengeRes = await fetch(this.challengeUrlValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.csrfToken,
          Accept: "application/json"
        },
        body: JSON.stringify({ username, email })
      })

      if (!challengeRes.ok) {
        this.showError((await challengeRes.json()).error)
        return
      }

      const options = await challengeRes.json()
      options.challenge = this.toBuffer(options.challenge)
      options.user.id = this.toBuffer(options.user.id)
      if (options.excludeCredentials) {
        options.excludeCredentials = options.excludeCredentials.map(c => ({
          ...c, id: this.toBuffer(c.id)
        }))
      }

      const credential = await navigator.credentials.create({ publicKey: options })

      const verifyRes = await fetch("/register", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.csrfToken,
          Accept: "application/json"
        },
        body: JSON.stringify({
          credential: {
            id: credential.id,
            rawId: this.toBase64(credential.rawId),
            response: {
              clientDataJSON: this.toBase64(credential.response.clientDataJSON),
              attestationObject: this.toBase64(credential.response.attestationObject)
            },
            type: credential.type
          }
        })
      })

      const result = await verifyRes.json()
      if (verifyRes.ok) {
        window.location.href = result.redirect_url
      } else {
        this.showError(result.error)
      }
    } catch (e) {
      this.showError(e.message || "Registration failed. Please try again.")
    }
  }

  async authenticate(event) {
    event.preventDefault()
    this.clearError()

    try {
      const challengeRes = await fetch("/sessions/challenge", {
        headers: { Accept: "application/json" }
      })
      const options = await challengeRes.json()
      options.challenge = this.toBuffer(options.challenge)
      if (options.allowCredentials) {
        options.allowCredentials = options.allowCredentials.map(c => ({
          ...c, id: this.toBuffer(c.id)
        }))
      }

      const credential = await navigator.credentials.get({ publicKey: options })

      const verifyRes = await fetch("/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.csrfToken,
          Accept: "application/json"
        },
        body: JSON.stringify({
          credential: {
            id: credential.id,
            rawId: this.toBase64(credential.rawId),
            response: {
              clientDataJSON: this.toBase64(credential.response.clientDataJSON),
              authenticatorData: this.toBase64(credential.response.authenticatorData),
              signature: this.toBase64(credential.response.signature),
              userHandle: credential.response.userHandle
                ? this.toBase64(credential.response.userHandle)
                : null
            },
            type: credential.type
          }
        })
      })

      const result = await verifyRes.json()
      if (verifyRes.ok) {
        window.location.href = result.redirect_url
      } else {
        this.showError(result.error)
      }
    } catch (e) {
      this.showError(e.message || "Sign in failed. Please try again.")
    }
  }

  showError(message) {
    if (this.hasErrorTarget) {
      this.errorTarget.textContent = message
      this.errorTarget.classList.remove("hidden")
    }
  }

  clearError() {
    if (this.hasErrorTarget) {
      this.errorTarget.textContent = ""
      this.errorTarget.classList.add("hidden")
    }
  }

  get csrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.content ?? ""
  }

  toBuffer(base64url) {
    const b64 = base64url.replace(/-/g, "+").replace(/_/g, "/")
    return Uint8Array.from(atob(b64), c => c.charCodeAt(0)).buffer
  }

  toBase64(buffer) {
    const bytes = new Uint8Array(buffer)
    let bin = ""
    bytes.forEach(b => (bin += String.fromCharCode(b)))
    return btoa(bin).replace(/\+/g, "-").replace(/\//g, "_").replace(/=/g, "")
  }
}
