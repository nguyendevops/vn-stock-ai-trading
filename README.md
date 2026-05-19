# 🇻🇳 VN Trading Analyst

> **AI phân tích chứng khoán Việt Nam cho Claude Code.**  
> Kết hợp TradingView MCP (biểu đồ kỹ thuật) + vnstock (dữ liệu CK VN) thành bộ skills phân tích toàn diện.  
> Trả về Trade Score 0–100 và kế hoạch giao dịch cụ thể.

> ⚠️ **Công cụ nghiên cứu, không phải lời khuyên tài chính. Tự chịu trách nhiệm khi ra quyết định đầu tư.**

---

## Kiến trúc

```
/vn-analyze VCB
       │
       ├─── Agent 1: TradingView MCP ──→ Chart, giá realtime, RSI/MACD
       ├─── Agent 2: vnstock MCP ────→ BCTC, P/E, ROE, tin tức
       └─── Agent 3: vnstock MCP ────→ VN-Index, VN30, dòng tiền ngành
                     │
              Tổng hợp Trade Score (0–100)
                     │
         Khuyến nghị + Kế hoạch giao dịch
```

**Hai MCP nguồn dữ liệu:**
- **TradingView MCP** ([tradesdontlie/tradingview-mcp](https://github.com/tradesdontlie/tradingview-mcp)): Biểu đồ kỹ thuật, giá realtime, screenshot chart, indicator, alert
- **vnstock MCP** ([mrgoonie/vnstock-agent](https://github.com/mrgoonie/vnstock-agent)): Dữ liệu CK VN — BCTC, P/E, ROE, tin tức, bảng giá, intraday

---

## Cài đặt

### 1. Yêu cầu

| Yêu cầu | Phiên bản |
|---------|-----------|
| Python | ≥ 3.8 |
| Node.js | ≥ 18 |
| Claude Desktop | Bất kỳ |
| TradingView Desktop | Bất kỳ (free account OK) |

### 2. Chạy setup tự động

```bash
git clone https://github.com/haivv-002/vn-trading-analyst.git
cd vn-trading-analyst
bash scripts/setup-mcps.sh
```

Script sẽ tự cài `vnstock-agent` (pip) và clone `tradingview-mcp` (npm).

### 3. Lấy vnstock API key (miễn phí)

Truy cập https://vnstocks.com/login → đăng ký → lấy API key.

### 4. Cấu hình Claude Desktop

Copy `config/claude-desktop-config-template.json` vào:
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`

Thay `<YOUR_USERNAME>` và `your_api_key_here` bằng giá trị thực.

### 5. Khởi động TradingView với debug port

**Windows (bản Store/MSIX)** — chạy PowerShell as Administrator:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
& "scripts\launch-tv-msix.ps1"
```

**Windows (bản .exe trực tiếp)**:
```
scripts\launch_tv_debug.bat
```

**macOS/Linux**:
```bash
~/tradingview-mcp/scripts/launch_tv_debug_mac.sh
```

### 6. Cài skills vào Claude Code

```bash
# Copy skills vào thư mục skills của Claude Code
cp -r .claude/skills/* ~/.claude/skills/
```

Restart Claude Desktop → bắt đầu sử dụng.

---

## Các lệnh

| Lệnh | Mô tả |
|------|-------|
| `/vn-analyze VCB` | 🏆 **Flagship** — Phân tích toàn diện, Trade Score 0-100, kế hoạch giao dịch |
| `/vn-technical VCB` | 📈 Kỹ thuật nhanh — xu hướng, hỗ trợ/kháng cự, tín hiệu vào lệnh |
| `/vn-fundamental VCB` | 📋 Cơ bản sâu — BCTC, định giá, so sánh ngành |
| `/vn-market` | 🌐 Tổng quan thị trường — VN-Index, VN30, top tăng/giảm |
| `/vn-report VCB` | 📄 Xuất báo cáo HTML đầy đủ (mở trên trình duyệt) |

---

## Ví dụ output

```
═══════════════════════════════════════
📊 PHÂN TÍCH: VCB — Vietcombank
   Ngày: 19/05/2026  |  Giá: 64,400 đ
═══════════════════════════════════════

🏆 TRADE SCORE: 72/100 — 🟢 MUA

📈 KỸ THUẬT (26/35)
   Xu hướng: Tăng ngắn hạn sau đáy 56,500
   Hỗ trợ: 62,000 đ  |  Kháng cự: 66,700 đ
   Volume: 2.7× TB — xác nhận breakout mạnh
   Tín hiệu: Breakout khối lượng lớn 2 phiên liên tiếp

📋 CƠ BẢN (26/35)
   P/E: 12.3  |  P/B: 2.1  |  ROE: 18.5%
   Doanh thu YoY: +14%  |  LNST YoY: +22%
   Đánh giá: Định giá hợp lý, tăng trưởng tốt

🌐 THỊ TRƯỜNG (14/20)
   VN-Index: Hồi phục từ vùng hỗ trợ 1,200
   Ngành NH: Outperform thị trường +3.2%

⚠️ RỦI RO (6/10)
   Lãi suất tăng, nợ xấu tiềm ẩn hậu COVID

🎯 KẾ HOẠCH GIAO DỊCH
   Vùng mua: 62,000 – 64,000 đ
   Cắt lỗ  : 59,500 đ (-7%)
   Mục tiêu: 72,000 đ (+12%)
   Tỷ lệ R:R = 1:1.7
```

---

## Nguồn dữ liệu

| Dữ liệu | Nguồn | Độ trễ |
|---------|-------|--------|
| Giá realtime, chart | TradingView (FXCM/HOSE) | ~15 phút (free plan) |
| Intraday, bảng giá | vnstock → VCI/KBS | Vài giây |
| BCTC, P/E, ROE | vnstock → TCBS/VCI | Ngày |
| Tin tức | vnstock → nhiều nguồn | Vài giờ |

---

## Cấu trúc repo

```
vn-trading-analyst/
├── .claude/
│   └── skills/
│       ├── vn-analyze/     # Flagship: phân tích toàn diện
│       ├── vn-technical/   # Kỹ thuật via TradingView
│       ├── vn-fundamental/ # Cơ bản via vnstock
│       ├── vn-market/      # Tổng quan thị trường
│       └── vn-report/      # Xuất báo cáo HTML
├── config/
│   └── claude-desktop-config-template.json
├── scripts/
│   ├── setup-mcps.sh        # Cài đặt tự động
│   ├── launch-tv-msix.ps1   # Khởi động TV (Windows Store)
│   └── launch_tv_debug.bat  # Khởi động TV (Windows .exe)
└── README.md
```

---

## Credits

- [thinh-vu/vnstock](https://github.com/thinh-vu/vnstock) — thư viện dữ liệu CK VN
- [mrgoonie/vnstock-agent](https://github.com/mrgoonie/vnstock-agent) — MCP server vnstock
- [tradesdontlie/tradingview-mcp](https://github.com/tradesdontlie/tradingview-mcp) — TradingView MCP
- [zubair-trabzada/ai-trading-claude](https://github.com/zubair-trabzada/ai-trading-claude) — cảm hứng kiến trúc skills

---

*⚠️ Không phải lời khuyên tài chính. Chỉ dùng cho mục đích nghiên cứu và học tập.*
