# Changelog

Versions follow [Semantic Versioning](https://semver.org). Until 1.0, a minor version
may change how things work.

## 0.1.0 - 2026-10-24

The first release.

- The lock screen, a process of its own that exists only while the session is locked: `ext-session-lock`, the password through PAM, a wrong password shakes the card.
- A preview that shows the screen without locking.
- The keyboard layout is shown if the compositor module is there, and the lock works without it.
- The PAM service is a setting.
