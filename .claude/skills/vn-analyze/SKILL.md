# vn-analyze — Phân tích Toàn diện Cổ phiếu VN

Chạy phân tích đầy đủ một mã CK Việt Nam bằng 3 agent song song:
Technical (TradingView) + Fundamental (vnstock) + Market Context.
Trả về Trade Score 0-100 và khuyến nghị đầu tư.

## Trigger

Dùng skill này khi user gõ `/vn-analyze <MÃ>` hoặc yêu cầu "phân tích toàn diện", "nên mua/bán", "đánh giá đầu tư" một mã CK VN.

## Input

```
/vn-analyze <SYMBOL>   # VD: /vn-analyze VCB
```

## Workflow

### Bước 1 — Thu thập dữ liệu song song (3 agent)

Spawn 3 subagent cùng lúc:

**Agent 1 — Technical (TradingView MCP):**
- `chart_set_symbol(HOSE:<SYMBOL>)` → đổi chart
- `chart_set_timeframe("D")` → khung ngày
- `quote_get()` → giá realtime
- `data_get_ohlcv(count=60, summary=true)` → 60 nến
- `data_get_study_values()` → RSI, MACD, EMA nếu có
- `capture_screenshot()` → chụp chart
- Phân tích: xu hướng, hỗ trợ/kháng cự, volume, pattern nến

**Agent 2 — Fundamental (vnstock MCP):**
- `stock_overview(<SYMBOL>)` → tổng quan công ty
- `income_statement(<SYMBOL>)` → doanh thu, lợi nhuận
- `balance_sheet(<SYMBOL>)` → tài sản, nợ
- `financial_ratio(<SYMBOL>)` → P/E, P/B, ROE, ROA
- `company_news(<SYMBOL>)` → tin tức gần nhất
- Phân tích: định giá, tăng trưởng, sức khỏe tài chính

**Agent 3 — Market Context (vnstock MCP):**
- `market_overview()` → VN-Index, HNX-Index xu hướng
- `price_board("VN30")` → top stocks VN30
- `stock_intraday(<SYMBOL>)` → dữ liệu trong phiên
- Phân tích: so sánh với ngành, dòng tiền thị trường

### Bước 2 — Tổng hợp Trade Score

Tính điểm theo 4 chiều:

| Chiều | Trọng số | Tiêu chí |
|-------|----------|---------|
| Kỹ thuật | 35% | Xu hướng, volume, momentum |
| Cơ bản | 35% | P/E, ROE, tăng trưởng EPS |
| Thị trường | 20% | VN-Index trend, ngành |
| Rủi ro | 10% | Beta, biến động, thanh khoản |

**Thang điểm:**
- 80-100: 🟢 **Mua mạnh**
- 65-79: 🟢 **Mua**
- 50-64: 🟡 **Nắm giữ**
- 35-49: 🔴 **Thận trọng**
- 0-34: 🔴 **Tránh**

### Bước 3 — Output

Trình bày theo template:

```
═══════════════════════════════════════
📊 PHÂN TÍCH: <SYMBOL> — <Tên công ty>
   Ngày: <ngày>  |  Giá: <giá> đ
═══════════════════════════════════════

🏆 TRADE SCORE: XX/100 — [Tín hiệu]

📈 KỸ THUẬT (XX/35)
   Xu hướng: [Tăng/Giảm/Đi ngang]
   Hỗ trợ: XX,XXX đ  |  Kháng cự: XX,XXX đ
   Volume: [Nhận xét]
   Tín hiệu: [Mô tả ngắn]

📋 CƠ BẢN (XX/35)
   P/E: XX  |  P/B: XX  |  ROE: XX%
   Doanh thu YoY: +XX%  |  LNST YoY: +XX%
   Đánh giá: [Nhận xét]

🌐 THỊ TRƯỜNG (XX/20)
   VN-Index: [Xu hướng]
   Ngành: [So sánh]
   Dòng tiền: [Nhận xét]

⚠️ RỦI RO (XX/10)
   [Các rủi ro chính]

💡 LUẬN ĐIỂM ĐẦU TƯ
   Bull case: [...]
   Bear case: [...]

🎯 KẾ HOẠCH GIAO DỊCH
   Vùng mua: XX,XXX – XX,XXX đ
   Cắt lỗ: XX,XXX đ (XX%)
   Mục tiêu: XX,XXX đ (XX%)
   Tỷ lệ R:R = 1:X

⚠️ Đây là công cụ nghiên cứu, không phải lời khuyên tài chính.
```

## Lưu ý

- Nếu vnstock MCP không có → dùng dữ liệu TradingView thay thế, ghi rõ nguồn
- Nếu TradingView không kết nối → phân tích fundamental only
- Luôn ghi rõ thời điểm lấy dữ liệu
- Data CK VN trên TradingView free plan trễ ~15 phút
