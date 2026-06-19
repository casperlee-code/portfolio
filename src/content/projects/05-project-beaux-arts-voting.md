---
title: "2026 FCU Beaux-Arts Ball 評分與控台系統"
year: 2026
category: "Computational Project"
cover: "/images/project-05/cover.png"
images:
  - "/images/project-05/cover.png"
  - "/images/project-05/process-01.jpg"
  - "/images/project-05/process-02.jpg"
  - "/images/project-05/process-03.jpg"
  - "/images/project-05/process-04.jpg"
featured: true
tags:
  - Firebase
  - Google Sheets
  - JavaScript
  - Real-time System
  - GitHub Pages
stack:
  - "Firebase Firestore（即時資料庫，< 100ms 同步）"
  - "Google Sheets Apps Script（名單管理與跨週備份）"
  - "GitHub Pages（靜態前端部署）"
  - "Vanilla JS + BroadcastChannel（離線備援模式）"
endpoints:
  - path: "index.html"
    role: "入口門戶，三端快速切換"
  - path: "admin.html"
    role: "中樞控制端，舞台狀態控制、投票監控"
  - path: "projector.html"
    role: "大螢幕投影端，即時排行榜與頒獎台"
  - path: "judge.html"
    role: "評審 / 學生評分端，手機優化"
  - path: "app.js"
    role: "共用核心引擎，資料處理與分數計算"
---

# 2026 FCU Beaux-Arts Ball 評分與控台系統

## 專案簡介

本系統為逢甲大學建築學系 2026 Beaux-Arts Ball 裝扮秀所設計的專屬客製化評分與視覺控制平台，結合 1931 年巴黎美院復古美學風格，提供三端實時連動的高性能前端架構。

系統透過 Firebase Firestore 進行低於 100 毫秒的即時資料交換，並與 Google Sheets Apps Script API 進行雙向同步，作為名單管理與跨週備份之用。

---

## 系統整體架構

### 三端架構說明

| 端點 | 檔案 | 功能 |
|------|------|------|
| 入口網頁 | `index.html` | 三個視窗（中控 / 投影 / 評審）快速切換門戶 |
| 中樞控制端 | `admin.html` | 控制舞台狀態、選取 / 跳過組別、監控 30 個投票端在線狀態與選票進度、一鍵重置、手動觸發 Google Sheet 同步 |
| 大螢幕投影端 | `projector.html` | 高對比日系簡約風格，即時更新評審給分燈號與得分率，自動縮放 1080p，結算階段展示 3D 領獎台與動態排行榜（支援平手判定） |
| 評審評分端 | `judge.html` | 手機優化，PIN 碼登入，同儕互評迴避鎖定，Tactile 按鈕評分，雙重確認視窗 |
| 共用引擎 | `app.js` | 核心資料處理、LocalStorage / Firestore 同步狀態管理、得分率數學計算 |

中控端、評審端、投影端皆與 Firebase Firestore 即時連動；若未配置 Firebase，系統自動切換為本地廣播模式（LocalStorage + BroadcastChannel）。

---

## 核心技術整合

### 1. GitHub Pages 前端靜態部署

將前端靜態檔案（HTML / CSS / JS）推送至 GitHub 儲存庫 `beaux-arts-scoring`，利用 GitHub Pages 部署，讓所有評委與控台透過手機與電腦網址直連，所有本地端 Git 提交均同步推送，實現即時版本備份。

### 2. Firebase Firestore 實時零延遲同步

- **雙模式智能切換**：若未填寫或停用 Firebase，系統自動切換為本地廣播通道模式（LocalStorage + BroadcastChannel），支援單機多分頁離線模擬測試。
- **Firestore 離線持續性**：啟用快取機制，若現場網路短暫中斷，系統暫存選票，網路恢復後自動重新上傳，確保選票零遺失。

### 3. Google Sheets 試算表雙向整合

在 Google 試算表建立 Apps Script 網頁應用程式（`google-sheets-script.js`）作為 API 接口，支援三個動作：

| 動作 | 說明 |
|------|------|
| 初始化 (Initialize) | 一鍵建立 `Roster` 分頁，填入 25 組隊伍樣板 |
| 拉取名單 (Fetch) | 從試算表讀取隊伍名稱、建築主題、組員姓名，覆寫至 Firestore 與 LocalStorage |
| 跨週儲存 (SAVE) | 建立時間命名備份工作表（`Scoreboard_yyyyMMdd_HHmm`），備份 25 組得分率與分數明細 |

---

## 重要功能設計

### 得分率計算公式

```
得分率 (%) = ( 已投選票之實際得分總和 ÷ (實際已投票人數 × 30) ) × 100
```

未投票的評審 / 小組直接忽略，其最高分不計入分母，解決了評審未準時投票導致得分率失真的問題。

### 投票燈號狀態系統

| 狀態 | 判定方式 | 顯示效果 |
|------|----------|----------|
| 在線 / 離線 | Presence 心跳機制（每 10 秒） | 綠燈 / 灰燈 |
| 已評分 | 即時分析投票資料 | 綠色打勾 |
| 未評分 | 未完成投票 | 紅色叉叉 |
| 自身迴避（免評） | 當前登場組別自動鎖定 | 金色禁止符號，從分母扣除 |

### 隊伍規模：25 組 × 30 位評審

- `VOTER_TOKENS`：PIN 碼 `2425` 對應第 25 組
- `DEFAULT_ROSTER`：`team_25`（25 組同儕評審 + 5 位專業評審）
- `shiftActiveTeam` 邊界：`currentId` 1 → 25

---

## 已修復問題記錄

### Apps Script CORS 阻擋與「假成功」Bug

**問題**：Apps Script 傳回 Exception 時，前端誤進入 Catch 區塊，返回 `mock_success` 假回應，控制台顯示「跨週存檔成功」但試算表實為空白。

**修復**：
1. 修正 `google-sheets-script.js` 第 160 行 `setBackground()` 傳入無效 RGB 字串導致服務崩潰的錯誤。
2. 重構 `admin.html` API 回傳判定邏輯，推斷是否真的呼叫成功；若遭遇錯誤或 API 未配置，彈出紅色警告提示管理員檢查 Web App 部署設定。

---

## 跨週活動標準作業程序（SOP）

### 第一週結束

1. 前往中控台「雲端試算表同步」分頁。
2. 點選「3. 雙向同步：跨週儲存 (SAVE)」，確認綠色成功，且試算表出現以日期命名的備份分頁。

### 第二週開始前

1. 點選「一鍵重置整場比賽 (Reset Entire Show)」清空當前選票。
2. 點選「2. 雙向同步：拉取名單 (Fetch)」從試算表載回第一週累積分數。
3. 開始第二週正常走秀與評分。

### 跨週分數累加機制

`Roster` 工作表的 `total_percentage` 欄位扮演「分數記憶體」角色：

| 階段 | 動作 | 結果 |
|------|------|------|
| 第一週結束 | 執行 SAVE | 得分率備份至 `Scoreboard_日期`，回寫 `Roster.total_percentage` |
| 第二週 Step 1 | 一鍵重置 | 清空當輪選票，`Roster` 累計分數不受影響 |
| 第二週 Step 2 | 拉取名單 Fetch | 從 `Roster` 讀取 `total_percentage` 覆寫進 Firestore |
| 第二週進行中 | 評審投票 | 在第一週基礎上繼續累加，形成兩週合併最終得分率 |

> 重點：「重置」與「分數基礎」是兩個獨立動作。重置只清除選票狀態；分數基礎透過 Fetch 單獨帶回，第二週起始分數不為 0。
