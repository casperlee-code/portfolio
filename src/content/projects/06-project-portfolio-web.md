---
title: "個人作品集網站"
year: 2026
category: "Computational Project"
cover: "/images/project-06/cover.jpg"
images:
  - "/images/project-06/cover.jpg"
featured: true
tags:
  - Astro
  - Tailwind CSS
  - Static Site
  - GitHub Pages
  - Web Development
stack:
  - "Astro v6.4.6（前端框架，預設靜態 HTML 輸出）"
  - "Tailwind CSS v4.3.0（Utility-First 樣式框架）"
  - "Markdown + JSON（無資料庫內容管理）"
  - "Git + GitHub Pages（版本控制與自動化部署）"
routes:
  - path: "/"
    file: "index.astro"
    role: "首頁，作品幻燈片輪播"
  - path: "/about"
    file: "about.astro"
    role: "關於我"
  - path: "/projects"
    file: "projects/index.astro"
    role: "作品總覽頁，分類篩選"
  - path: "/projects/[slug]"
    file: "projects/[slug].astro"
    role: "作品詳細頁，動態路由"
---

# 個人作品集網站

## 專案簡介

以 Astro 框架建構的個人建築設計作品集網站，著重網頁載入速度、極簡視覺美學，以及內容維護的便利性。採無資料庫（Database-less）架構，所有作品內容以 Markdown 檔案管理，透過 GitHub Pages 自動化部署至線上。

---

## 系統技術簡介

| 技術 | 版本 | 用途 |
|------|------|------|
| **Astro** | v6.4.6 | 前端框架，預設編譯成純靜態 HTML |
| **Tailwind CSS** | v4.3.0 | Utility-First CSS 框架，實現極簡空間美學 |
| **Markdown + JSON** | — | 無資料庫架構，內容由本地文字檔案動態解析 |
| **Git + GitHub Pages** | — | 版本控制與自動化部署 |

---

## 資料夾結構

```
專案根目錄/
├── public/                        # 靜態資源（不需編譯）
│   ├── my_cv.pdf                  # 個人簡歷 PDF
│   └── images/                    # 作品照片庫
│       └── project-01/            # 各作品子資料夾
├── src/                           # 網頁原始碼
│   ├── config.json                # 全站設定檔（姓名、LOGO、聯絡資訊）
│   ├── content.config.ts          # 資料欄位設定（Frontmatter 格式）
│   ├── content/projects/          # 作品集資料庫（每個 .md = 一個作品）
│   ├── layouts/                   # 網頁佈局範本（HTML 結構、SEO、Navbar）
│   ├── pages/                     # 網頁路由頁面
│   │   ├── index.astro            # 首頁（幻燈片輪播）
│   │   ├── about.astro            # 關於我
│   │   ├── projects/index.astro   # 作品總覽頁（分類篩選）
│   │   └── projects/[slug].astro  # 作品詳細頁（動態路由）
│   └── styles/                    # 基礎樣式（global.css）
├── sync.bat                       # 一鍵同步與部署腳本（Windows）
├── astro.config.mjs               # Astro 框架設定，整合 Tailwind CSS
└── package.json                   # 套件管理與啟動指令
```

---

## 網站維護與內容更新指南

### 更新個人資訊與簡歷

- **自介與聯絡方式**：修改 `src/config.json` 中的對應值，網站隨即更新。
- **更換 CV 履歷 PDF**：將新 PDF 重新命名為 `my_cv.pdf`，直接覆蓋 `public/my_cv.pdf`。

### 新增作品項目（Project）

**Step 1 — 準備相片**

在 `public/images/` 下新建子資料夾（如 `project-05`），將渲染圖、草圖放入。

> ⚠️ 圖片必須是真正的 `.jpg`、`.png` 或 `.webp` 格式，檔名使用英文或數字。

**Step 2 — 建立 Markdown 檔案**

在 `src/content/projects/` 下新增 `.md` 檔（如 `05-urban-oasis.md`），填入以下 Frontmatter：

```markdown
---
title: "都市綠洲計畫"
year: 2026
category: "School Project"
# 僅限以下四種：
# "School Project" | "Internship Project" | "Other Experience" | "Sketch & Idea"
cover: "/images/project-05/cover.jpg"
images:
  - "/images/project-05/cover.jpg"
  - "/images/project-05/process-01.jpg"
  - "/images/project-05/sketch.png"
featured: true   # 設為 true 才會出現在首頁幻燈片
---

這裡輸入該專案的詳細文字理念、基地分析、所用工具及設計說明...
```

---

## GitHub 同步與自動化部署機制

本專案採用 **Dual-Branching（雙分支）** 架構，透過 `sync.bat` 一鍵完成備份與部署：

```
[ 本地修改檔案 ]
       │
       ▼
[ 步驟 1 ] git add + commit — 自動本地存檔
       │
       ▼
[ 步驟 2 ] push → GitHub master 分支 — 原始碼備份
       │
       ▼
[ 步驟 3 ] npm run build — Astro 編譯成純 HTML/CSS
       │
       ▼
[ 步驟 4 ] force push dist → gh-pages 分支 — 發布靜態網頁
       │
       ▼
(( GitHub Pages 線上網站即時更新 ))
```

| 步驟 | 動作 | 說明 |
|------|------|------|
| 1 | `git add + commit` | 將所有修改記錄成 commit，永久備份至 master 分支 |
| 2 | `git push master` | 上傳原始碼至 GitHub 雲端儲存庫 |
| 3 | `npm run build` | Astro 將 Markdown 與 Astro 頁面編譯為瀏覽器可讀的 HTML/CSS |
| 4 | `force push → gh-pages` | 在 `dist/` 初始化乾淨 Git 倉庫，強制推送至 gh-pages 分支 |

> 執行方式：在 **PowerShell** 終端機輸入 `.\sync.bat`（建議，非雙擊）

---

## 開發問題記錄與解決方案

### 問題 1：動態詳情頁面的圖片絕對路徑問題

| 項目 | 內容 |
|------|------|
| **症狀** | 作品詳細頁左側大圖區塊無法載入（破圖） |
| **原因** | `images` 清單只記錄檔名，瀏覽器以當前 URL 為起點尋找，導致路徑錯誤（404） |
| **解法** | 將 `images:` 陣列改為從根目錄出發的絕對路徑，如 `/images/project-01/cover.jpg` |

### 問題 2：HEIC 檔案格式更名導致的破圖

| 項目 | 內容 |
|------|------|
| **症狀** | 部分圖片在網頁中無法顯示 |
| **原因** | Apple `.HEIC` 格式圖片僅更改副檔名為 `.jpg`，內部編碼仍為 HEIC，主流瀏覽器無法解碼 |
| **解法** | 透過 Windows 小畫家「另存新檔為 JPEG」或線上轉檔工具進行真正的格式轉換 |

### 問題 3：自動化部署時的 Git 帳號驗證錯誤

| 項目 | 內容 |
|------|------|
| **症狀** | 執行 `sync.bat` 最後一步時出現 `Author identity unknown` 錯誤，推送失敗 |
| **原因** | `dist/` 中初始化的新 Git 倉庫找不到全域 Git 身份設定（Global Config） |
| **解法** | 修改 `sync.bat`，初始化後自動於本地設定寫入 `git config user.name "Casper Lee"` 與 Email |

### 問題 4：終端機雙擊執行找不到 npm 指令

| 項目 | 內容 |
|------|------|
| **症狀** | 直接雙擊 `sync.bat` 出現 `'npm' is not recognized` 錯誤 |
| **原因** | 雙擊時使用 `cmd.exe` 執行，Node.js 環境變數僅在 PowerShell 中生效 |
| **解法** | 統一改在 PowerShell 終端機中輸入 `.\sync.bat` 執行 |
