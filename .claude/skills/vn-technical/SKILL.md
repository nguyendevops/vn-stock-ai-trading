# vn-technical — Phân tích Kỹ thuật CK Việt Nam

Phân tích kỹ thuật nhanh cho một mã CK VN sử dụng TradingView MCP.

## Trigger

`/vn-technical <SYMBOL>` hoặc "phân tích kỹ thuật", "chart", "điểm vào lệnh"

## Workflow

1. `chart_set_symbol("HOSE:<SYMBOL>")` — đổi sang mã cần phân tích
2. `chart_set_timeframe("D")` — khung ngày (mặc định)
3. `quote_get()` — giá realtime
4. `data_get_ohlcv(count=100)` — 100 nến gần nhất
5. `data_get_study_values()` — đọc indicator đang bật
6. `capture_screenshot(region="chart")` — chụp chart để nhìn trực quan

## Phân tích

- **Xu hướng**: Higher High/Higher Low hay Lower High/Lower Low?
- **Volume**: Tăng/giảm theo xu hướng? Divergence?
- **Hỗ trợ/Kháng cự**: Tìm vùng giá quan trọng từ lịch sử
- **Pattern nến**: Engulfing, Doji, Hammer, Pin bar
- **Momentum**: Giá có đang tăng tốc hay yếu dần?

## Output

```
📈 KỸ THUẬT: <SYMBOL> | <Giá> đ | Khung: Ngày

Xu hướng ngắn hạn : [Tăng/Giảm/Đi ngang]
Xu hướng trung hạn: [Tăng/Giảm/Đi ngang]

Hỗ trợ gần  : XX,XXX đ
Hỗ trợ mạnh : XX,XXX đ
Kháng cự gần: XX,XXX đ
Kháng cự mạnh: XX,XXX đ

Volume: [Nhận xét khối lượng]
Pattern: [Mô tả hình nến/pattern nếu có]

Tín hiệu: [MUA / BÁN / CHỜ]
Vùng mua tốt: XX,XXX – XX,XXX đ
Cắt lỗ đề xuất: XX,XXX đ
Mục tiêu: XX,XXX đ
```
