# vn-market — Tổng quan Thị trường Chứng khoán Việt Nam

Snapshot thị trường CK VN: VN-Index, VN30, top movers, dòng tiền, tâm lý.

## Trigger

`/vn-market` hoặc "thị trường hôm nay", "VN-Index", "tổng quan TTCK", "top tăng giảm"

## Workflow

1. `trading_price_board("VN30")` — bảng giá VN30 realtime
2. `market_overview()` — VN-Index, HNX-Index, UPCoM-Index
3. `chart_set_symbol("HOSE:VNINDEX")` + `quote_get()` — giá VN-Index
4. `data_get_ohlcv(count=20, summary=true)` — 20 phiên gần nhất VN-Index
5. Tổng hợp top 5 tăng / top 5 giảm từ bảng giá

## Phân tích

- **VN-Index**: Xu hướng ngắn hạn (5 phiên), trung hạn (20 phiên)
- **Breadth**: Số mã tăng/giảm → tâm lý thị trường
- **Volume**: So sánh với TB 20 phiên
- **Dòng tiền**: Phiên tích lũy hay phân phối?
- **Ngành dẫn dắt**: Ngành nào đang outperform?

## Output

```
🌐 THỊ TRƯỜNG CHỨNG KHOÁN VIỆT NAM
   Cập nhật: <thời gian>

CHỈ SỐ
  VN-Index : X,XXX.XX  [+/-X.XX  +/-X.XX%]
  HNX-Index: XXX.XX    [+/-X.XX  +/-X.XX%]
  UPCOM    : XXX.XX    [+/-X.XX  +/-X.XX%]

TỔNG QUAN PHIÊN
  Tăng: XX  |  Giảm: XX  |  Đứng: XX
  Khối lượng: X,XXX tỷ đ  [XX% so TB 20 phiên]
  Tâm lý: [Tích cực / Tiêu cực / Trung tính]

TOP 5 TĂNG MẠNH         TOP 5 GIẢM MẠNH
  VCB  +X.XX%  XX,XXX đ    XXX  -X.XX%  XX,XXX đ
  ...                       ...

NGÀNH DẪN DẮT
  [Ngành X]: +X.XX% — [nhận xét]
  [Ngành Y]: -X.XX% — [nhận xét]

NHẬN ĐỊNH
  Xu hướng ngắn hạn: [...]
  Điểm cần chú ý  : [...]
  Cơ hội nổi bật  : [...]
```
