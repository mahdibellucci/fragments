#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# One-command launcher for E2B Fragments inside a sandboxed VM.
#
# The sandbox this runs in does not persist `node_modules` or `.env.local`
# between restarts, so this script is idempotent: it recreates anything that
# is missing and then starts the real Next.js dev server on 0.0.0.0:3000.
#
# Usage:  ./start.sh
# ---------------------------------------------------------------------------
set -euo pipefail

PORT="${PORT:-3000}"
HOST="${HOST:-0.0.0.0}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

echo "==> E2B Fragments launcher (host=$HOST port=$PORT)"

# 1. Dependencies -----------------------------------------------------------
if [ ! -d node_modules ] || [ ! -d node_modules/next ]; then
  echo "==> node_modules missing - installing dependencies..."
  npm install --no-audit --no-fund
else
  echo "==> node_modules present, skipping install"
fi

# The offline font fix depends on @fontsource/inter; make sure it is present.
if [ ! -d node_modules/@fontsource/inter ]; then
  echo "==> installing @fontsource/inter (offline font provider)..."
  npm install @fontsource/inter --no-audit --no-fund
fi

# 2. Environment ------------------------------------------------------------
# Recreate .env.local with empty credential slots if it was wiped.
if [ ! -f .env.local ]; then
  echo "==> .env.local missing - writing default (no secrets)..."
  cat > .env.local <<'ENVFILE'
# No secrets here on purpose. Fill these in and restart to enable generation,
# or paste a key into the app at runtime via the settings gear.
E2B_API_KEY=
OPENAI_API_KEY=
ANTHROPIC_API_KEY=
GROQ_API_KEY=
FIREWORKS_API_KEY=
TOGETHER_API_KEY=
GOOGLE_AI_API_KEY=
GOOGLE_VERTEX_CREDENTIALS=
MISTRAL_API_KEY=
XAI_API_KEY=
DEEPSEEK_API_KEY=
MORPH_API_KEY=
NEXT_PUBLIC_SITE_URL=
KV_REST_API_URL=
KV_REST_API_TOKEN=
RATE_LIMIT_MAX_REQUESTS=
RATE_LIMIT_WINDOW=
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
NEXT_PUBLIC_POSTHOG_KEY=
NEXT_PUBLIC_POSTHOG_HOST=
NEXT_PUBLIC_GTM_ID=
# Allow embedding in the preview iframe (see next.config.mjs)
ALLOW_IFRAME_EMBEDDING=true
ENVFILE
else
  echo "==> .env.local present, skipping"
fi

# 3. Run --------------------------------------------------------------------
echo "==> starting Next.js dev server on http://$HOST:$PORT"
exec npm run dev -- -H "$HOST" -p "$PORT"
