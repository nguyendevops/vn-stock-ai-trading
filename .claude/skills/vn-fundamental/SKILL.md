# vn-fundamental — Phân tích Cơ bản CK Việt Nam

Phân tích cơ bản sâu cho một mã CK VN sử dụng vnstock MCP.

## Trigger

`/vn-fundamental <SYMBOL>` hoặc "phân tích cơ bản", "định giá", "P/E", "tài chính"

## Workflow

Gọi song song qua vnstock MCP:

1. `stock_overview(<SYMBOL>)` — thông tin công ty
2. `financial_ratio(<SYMBOL>, period="quarter")` — các chỉ số tài chính
3. `income_statement(<SYMBOL>, period="annual")` — KQKD 4 năm gần nhất
4. `balance_sheet(<SYMBOL>, period="annual")` — BCĐKT
5. `cash_flow(<SYMBOL>)` — lưu chuyển tiền tệ
6. `company_news(<SYMBOL>)` — tin tức gần nhất (5 tin)
7. `dividend_history(<SYMBOL>)` — lịch sử cổ tức nếu có

## Phân tích

### Định giá
- P/E so với ngành và lịch sử
- P/B so với Book Value thực
- EV/EBITDA nếu có

### Tăng trưởng
- Doanh thu CAGR 3 năm
- LNST CAGR 3 năm
- EPS tăng trưởng

### Sức khỏe tài chính
- ROE, ROA, ROIC
- Tỷ lệ Nợ/Vốn chủ sở hữu
- Current Ratio, Quick Ratio
- FCF (Free Cash Flow)

### Chất lượng lợi nhuận
- FCF so với LNST (>80% là tốt)
- Xu hướng biên lợi nhuận gộp/ròng

## Output

```
📋 CƠ BẢN: <SYMBOL> — <Tên công ty>
   Ngành: <ngành>  |  Vốn hóa: X,XXX tỷ đ

ĐỊNH GIÁ
  P/E: XX  (TB ngành: XX)  → [Rẻ/Hợp lý/Đắt]
  P/B: XX  (TB ngành: XX)
  Cổ tức: XX%

TĂNG TRƯỞNG (3 năm)
  Doanh thu CAGR: +XX%
  LNST CAGR    : +XX%
  EPS mới nhất : X,XXX đ

SỨC KHỎE TÀI CHÍNH
  ROE: XX%  ROA: XX%
  Nợ/VCP: XX  Current Ratio: X.X
  FCF: [Dương/Âm] — [Nhận xét]

ĐIỂM MẠNH
  • [...]
  • [...]

ĐIỂM YẾU / RỦI RO
  • [...]
  • [...]

TIN TỨC GẦN NHẤT
  • [tóm tắt 3 tin quan trọng nhất]

ĐỊNH GIÁ NỘI TẠI (ước tính)
  Giá hợp lý theo P/E: XX,XXX đ
  Giá hợp lý theo P/B: XX,XXX đ
  Upside/Downside: ±XX%
```
