---
name: vn-market
description: Vietnamese stock market overview (VN-Index, VN30, top gainers and losers) AND single-sector analysis (dược, ngân hàng, thép, BĐS...). Use when the user types /vn-market or asks for today's VN market overview, or to analyze one industry/sector.
---

# vn-market — Thị trường & Ngành CK Việt Nam

Snapshot thị trường (VN-Index, VN30, top movers, dòng tiền) **hoặc** phân tích MỘT ngành.

## Trigger

`/vn-market` · "thị trường hôm nay", "VN-Index", "top tăng giảm" · "phân tích ngành <X>", "nhóm <ngành>"

## ⚡ Hiệu năng — ĐỌC TRƯỚC KHI GỌI TOOL

vnstock lấy dữ liệu từ nguồn VCI → **~9-10s/lệnh** (đo thực: import 0.7s + fetch ~9.3s; số mã KHÔNG làm chậm thêm — 1 mã 9.3s ≈ cả VN30 ~9s). **~10s là bình thường, đừng hủy.**

🚨 **Nếu lệnh MCP vnstock treo > 30s (tới vài phút)** = KHÔNG phải fetch chậm mà **tầng MCP server bị kẹt** (disconnect/reconnect loop). Bản thân `core.trading_price_board(...)` chạy ~10s khi gọi trực tiếp. Cách xử lý:
- **(a) Restart Claude:** `/exit` rồi mở lại từ thư mục repo (env `PYTHONUTF8` chỉ nạp khi khởi động mới) → server vnstock respawn khỏe.
- **(b) Bypass chạy trực tiếp** (CLI có shell): `python -c "from vnstock_agent import core, json; print(json.dumps(core.trading_price_board(['DHG','IMP','DBD'],'VCI'), default=str))"` (đặt `PYTHONUTF8=1`).

**3 nguyên tắc bắt buộc để nhanh:**
1. **Gọi vnstock ÍT LỆNH NHẤT.** Gộp TẤT CẢ mã vào **1 lệnh** `trading_price_board`. TUYỆT ĐỐI không gọi lặp từng mã, không gọi `listing_*` chỉ để lấy danh sách (dùng rổ hardcode bên dưới).
2. **Bảng giá đã đủ** giá + %thay đổi + khối lượng + KL/giá trị NN mua-bán → KHÔNG cần TradingView cho mã lẻ.
3. **VN-Index/HNX-Index** lấy qua **TradingView** (CDP local, nhanh ~tức thì) — vnstock KHÔNG có `market_overview`.

## Workflow

### A — Tổng quan thị trường (mặc định `/vn-market`)
1. **1 lệnh** `trading_price_board("ACB,BCM,BID,BVH,CTG,FPT,GAS,GVR,HDB,HPG,LPB,MBB,MSN,MWG,PLX,SAB,SHB,SSB,SSI,STB,TCB,TPB,VCB,VHM,VIB,VIC,VJC,VNM,VPB,VRE")` (rổ VN30 — cập nhật định kỳ).
2. VN-Index: `chart_set_symbol("HOSE:VNINDEX")` → `quote_get()` → `data_get_ohlcv(count=20, summary=true)`. (HNX tùy chọn: `HNX:HNXINDEX`.)
3. Top 5 tăng / 5 giảm + breadth tính TRỰC TIẾP từ bảng giá ở bước 1.

### B — Phân tích MỘT ngành ("ngành dược", "ngân hàng"...)
1. **CHỈ 1 lệnh** `trading_price_board(<rổ ngành bên dưới>)`. Hết. Không gọi gì thêm.
2. (Tùy chọn, nếu cần bối cảnh) VN-Index nhanh qua TradingView như A.2.
3. Phân tích ngay từ bảng giá: mã dẫn dắt, mã yếu, %TB ngành, dòng tiền NN, độ rộng.
4. Chỉ đào sâu 1 mã (financial_ratio, company_news...) NẾU user hỏi tiếp → mỗi lệnh +~9s, báo trước.

### Rổ ngành sẵn (copy nguyên chuỗi vào `symbols`)
- **Dược:** `DHG,IMP,DBD,TRA,DVN,DMC,OPC,DHT,DCL,AMV,PME,SPM,JVC,VMD`
- **Ngân hàng:** `VCB,BID,CTG,TCB,MBB,VPB,ACB,STB,HDB,VIB,TPB,SHB,LPB,EIB,SSB,MSB,OCB`
- **Thép:** `HPG,HSG,NKG,TLH,SMC,POM,TVN`
- **Bất động sản:** `VHM,VIC,VRE,NVL,PDR,DXG,KDH,DIG,NLG,CEO,HDG,KBC`
- **Chứng khoán:** `SSI,VND,HCM,VCI,MBS,SHS,FTS,BSI,CTS,VIX,AGR`
- **Dầu khí:** `GAS,PLX,PVD,PVS,BSR,PVT,OIL,PVC`
- **Bán lẻ:** `MWG,PNJ,FRT,DGW`
- **Điện:** `POW,REE,GEG,NT2,PC1,GEX`
- **Thực phẩm/Đồ uống:** `VNM,MSN,SAB,KDC,MCH,QNS,VHC,ANV`
- **Dệt may:** `TCM,MSH,TNG,STK,GIL,VGT`
- **Công nghệ:** `FPT,CMG,ELC,ITD,SAM`

Ngành ngoài danh sách → tự lập rổ 6–14 mã đại diện rồi gọi 1 lệnh.

## Phân tích
- **Xu hướng:** ngắn hạn (5 phiên) + trung hạn (20 phiên) — VN-Index hoặc mã dẫn dắt ngành.
- **Breadth:** số mã tăng/giảm trong rổ → tâm lý.
- **Volume:** so TB 20 phiên (nếu có) → tích lũy hay phân phối.
- **Dòng tiền NN:** mua/bán ròng → lực đỡ/áp lực.
- **Mã dẫn dắt vs mã yếu** trong ngành.

## Output — Tổng quan thị trường
```
🌐 THỊ TRƯỜNG CHỨNG KHOÁN VIỆT NAM — <thời gian>
CHỈ SỐ      VN-Index X,XXX.XX [±X.XX ±X.XX%] | HNX XXX.XX [±X.XX%]
PHIÊN       Tăng XX | Giảm XX | Đứng XX · KL X,XXX tỷ [XX% TB20] · Tâm lý: [..]
TOP TĂNG    VCB +X.XX% ...        TOP GIẢM   XXX -X.XX% ...
NGÀNH DẪN   [Ngành]: +X.XX% — [nhận xét]
NHẬN ĐỊNH   Ngắn hạn [..] · Chú ý [..] · Cơ hội [..]
```

## Output — Phân tích ngành
```
💊 NGÀNH <TÊN> — <thời gian>   (rổ N mã)
TỔNG QUAN   TB ngành ±X.XX% · Tăng X/Giảm Y/Đứng Z · vs VN-Index [mạnh/yếu hơn]
DẪN DẮT     MÃ +X.XX%  giá  KL  [lý do/ghi chú]   ×3–5
YẾU NHẤT    MÃ -X.XX%  giá  KL                      ×2–3
DÒNG TIỀN NN  Mua ròng: ... | Bán ròng: ...
NHẬN ĐỊNH   Xu hướng ngành [..] · Mã đáng chú ý [..] · Rủi ro [..]
```
⚠️ Luôn ghi disclaimer: dữ liệu tham khảo, không phải khuyến nghị đầu tư.
