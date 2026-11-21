# Intellectus web app

Next.js (App Router) client for the Intellectus API.

```bash
cp .env.example .env.local   # NEXT_PUBLIC_API_URL, defaults to http://localhost:8000
npm install
npm run dev                  # http://localhost:5173
```

## Layout

- `src/app` â€” routes. `/` landing, `/login`, `/register`, and the signed-in workspace under `/app`.
- `src/components/screens` â€” one component per workspace screen (overview, ask, documents, knowledge, actions, settings).
- `src/components/ui` â€” small UI primitives (button, fields, dialog, badges, toast).
- `src/lib/api.ts` â€” typed API client; handles token refresh and error messages.
- `src/stores/session.ts` â€” signed-in user, organizations, active organization.

## Design

Warm paper background, ink text, hairline rules and a single green accent, defined as CSS variables in
`src/app/globals.css` (with a dark-mode set). Type is IBM Plex Sans / Plex Mono with Source Serif 4 for headings.
Status colours are only used to carry meaning.
