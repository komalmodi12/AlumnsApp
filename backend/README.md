# Mock backend for Alumns App

Run a lightweight mock server locally for frontend integration and testing.

Setup:

```bash
cd backend
npm install
npm run start
```

By default the server runs on `http://localhost:3000` and exposes:

- `POST /login` — body `{ email, password }`, returns `{ token, user }`
- `GET /profile` — requires `Authorization: Bearer <token>`
- `GET /posts` — optional `page` and `limit` query params

The OpenAPI spec is in `openapi.yaml`.
