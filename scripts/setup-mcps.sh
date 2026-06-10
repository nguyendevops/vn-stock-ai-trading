#!/usr/bin/env bash
# Setup script for vn-stock-ai-trading
# Installs vnstock-agent MCP + tradingview-mcp

set -e

echo "=== vn-stock-ai-trading Setup ==="
echo ""

# ── 1. Python / pip ───────────────────────────────────────────────────────────
echo "[1/5] Checking Python..."
if ! command -v python3 &>/dev/null && ! command -v python &>/dev/null; then
  echo "ERROR: Python not found. Install from https://python.org"
  exit 1
fi
echo "      OK: $(python3 --version 2>/dev/null || python --version)"

# ── 2. Node.js ────────────────────────────────────────────────────────────────
echo "[2/5] Checking Node.js..."
if ! command -v node &>/dev/null; then
  echo "ERROR: Node.js not found. Install from https://nodejs.org"
  exit 1
fi
echo "      OK: $(node --version)"

# ── 3. Install vnstock-agent ──────────────────────────────────────────────────
echo "[3/5] Installing vnstock-agent..."
VENDOR_PATH="$(cd "$(dirname "$0")/../vendor/vnstock-agent" && pwd)"
pip install --user "$VENDOR_PATH" -q
echo "      OK: vnstock-agent installed"
echo "      → Get free API key at: https://vnstocks.com/login"
echo "      → Set: export VNSTOCK_API_KEY=your_key"

# ── 4. Clone tradingview-mcp ──────────────────────────────────────────────────
echo "[4/5] Setting up tradingview-mcp..."
TV_DIR="$HOME/tradingview-mcp"
if [ -d "$TV_DIR" ]; then
  echo "      Already exists at $TV_DIR — skipping clone"
else
  git clone https://github.com/tradesdontlie/tradingview-mcp.git "$TV_DIR"
  cd "$TV_DIR" && npm install
  echo "      OK: cloned to $TV_DIR"
fi

# ── 5. Tavily web-search MCP (optional) ───────────────────────────────────────
# Key is written ONLY to per-user config (~/.claude.json) — NEVER into the repo.
echo "[5/5] Tavily web-search MCP (optional)..."
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if [ -n "$TAVILY_API_KEY" ]; then
  if command -v claude &>/dev/null; then
    (cd "$REPO_ROOT" && claude mcp add tavily-remote-mcp --transport http \
      "https://mcp.tavily.com/mcp/?tavilyApiKey=$TAVILY_API_KEY" >/dev/null)
    echo "      OK: tavily-remote-mcp registered (local scope, key stays outside repo)"
  else
    echo "      WARN: 'claude' CLI not found — register manually later (from repo root):"
    echo "        claude mcp add tavily-remote-mcp --transport http \"https://mcp.tavily.com/mcp/?tavilyApiKey=<YOUR_KEY>\""
  fi
else
  echo "      Skipped — to enable: TAVILY_API_KEY=tvly-xxx ./scripts/setup-mcps.sh"
  echo "      (free key at https://app.tavily.com)"
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Get vnstock API key (optional): https://vnstocks.com/login"
echo "  2. Copy config/claude-desktop-config-template.json"
echo "     → paste into: ~/Library/Application Support/Claude/claude_desktop_config.json"
echo "  3. Replace <YOUR_USERNAME> and your_api_key_here in the config"
echo "  4. Launch TradingView with CDP: ~/tradingview-mcp/scripts/launch_tv_debug_mac.sh"
echo "  5. Restart Claude Desktop"
echo "  6. Try: /vn-market"
