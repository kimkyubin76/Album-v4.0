; lib/GuiBuild.ahk
; 역할: GUI 컨트롤 생성 + 이벤트 바인딩 (모든 핸들러 참조 → 맨 마지막 로드)
; 의존: 모든 모듈

BuildGui() {
    g := Gui("+Resize +MinSize920x600", "액자-앨범 매칭 검수기 v4.0")
    g.SetFont("s10", "맑은 고딕")
    g.BackColor := "F5F4F0"
    g.OnEvent("Size",  OnResize)
    g.OnEvent("Close", (*) => ExitApp())
    UI.G := g

    UI.HdrBg := g.Add("Text", "x0 y0 w10 h48 BackgroundWhite", "")

    g.SetFont("s11 bold", "맑은 고딕")
    UI.Logo := g.Add("Text", "x14 y13 w114 h26 +0x200 BackgroundWhite c0284C7", "photo·match")
    g.SetFont("s8 norm", "맑은 고딕")
    UI.VerLbl := g.Add("Text", "x130 y32 w30 h14 BackgroundWhite c9CA3AF", "v4.0")
    g.SetFont("s9 norm", "맑은 고딕")

    UI.BtnModeA := g.Add("Button", "x166 y12 w66 h26", "자동(A)")
    UI.BtnModeB := g.Add("Button", "x236 y12 w66 h26", "수동(B)")
    UI.BtnModeA.OnEvent("Click", (*) => SwitchMode("A"))
    UI.BtnModeB.OnEvent("Click", (*) => SwitchMode("B"))

    g.Add("Text", "x312 y16 w36 h22 +0x200 BackgroundWhite vLblRoot", "루트:")
    UI.EdtRoot := g.Add("Edit", "x350 y14 w10 h22 vEdtRoot BackgroundWhite")
    UI.EdtRoot.OnEvent("Change", OnEditRoot)
    UI.BtnRoot := g.Add("Button", "x10 y12 w74 h26 vBtnRoot", "폴더 선택…")
    UI.BtnRoot.OnEvent("Click", OnBrowseRoot)

    g.Add("Text", "x312 y10 w36 h20 +0x200 Hidden BackgroundWhite vLblFrame", "액자:")
    UI.EdtFrame := g.Add("Edit", "x350 y8 w10 h20 Hidden vEdtFrame BackgroundWhite")
    UI.EdtFrame.OnEvent("Change", OnEditFrame)
    UI.BtnFrame := g.Add("Button", "x10 y6 w62 h22 Hidden vBtnFrame", "선택…")
    UI.BtnFrame.OnEvent("Click", OnBrowseFrame)

    g.Add("Text", "x312 y30 w36 h20 +0x200 Hidden BackgroundWhite vLblAlbum", "앨범:")
    UI.EdtAlbum := g.Add("Edit", "x350 y28 w10 h20 Hidden vEdtAlbum BackgroundWhite")
    UI.EdtAlbum.OnEvent("Change", OnEditAlbum)
    UI.BtnAlbum := g.Add("Button", "x10 y26 w62 h22 Hidden vBtnAlbum", "선택…")
    UI.BtnAlbum.OnEvent("Click", OnBrowseAlbum)

    g.SetFont("s9 bold", "맑은 고딕")
    UI.ChipTotal := g.Add("Text", "x10 y13 w70 h24 +0x200 +Center BackgroundEFF6FF c1D4ED8", "전체 0")
    UI.ChipNF    := g.Add("Text", "x10 y13 w80 h24 +0x200 +Center BackgroundFEF2F2 cB91C1C", "✕ NF 0")
    UI.ChipMatch := g.Add("Text", "x10 y13 w80 h24 +0x200 +Center BackgroundF0FDF4 c15803D", "✓ MATCH 0")
    g.SetFont("s9 norm", "맑은 고딕")

    UI.BtnScan     := g.Add("Button", "x10 y12 w84 h28", "▶ 스캔")
    UI.BtnCancel   := g.Add("Button", "x10 y12 w66 h28 Disabled", "✕ 취소")
    UI.BtnSettings := g.Add("Button", "x10 y12 w30 h28", "⚙")
    UI.BtnScan.OnEvent("Click",     OnScan)
    UI.BtnCancel.OnEvent("Click",   (*) => (ST.Cancel := true))
    UI.BtnSettings.OnEvent("Click", OnOpenSettings)

    UI.SepHdr := g.Add("Text", "x0 y48 w10 h1 +0x10")

    g.SetFont("s9 bold", "맑은 고딕")
    UI.FTabAll := g.Add("Button", "x0 y50 w10 h28", "전체")
    UI.FTabNF  := g.Add("Button", "x0 y50 w10 h28", "✕ NOT FOUND")
    UI.FTabM   := g.Add("Button", "x0 y50 w10 h28", "✓ MATCH")
    g.SetFont("s9 norm", "맑은 고딕")
    UI.FTabAll.OnEvent("Click", (*) => ApplyFilter("ALL"))
    UI.FTabNF.OnEvent("Click",  (*) => ApplyFilter("NOT"))
    UI.FTabM.OnEvent("Click",   (*) => ApplyFilter("MATCH"))

    UI.GrpSum := g.Add("Text", "x0 y80 w10 h20 +0x200 c555555 BackgroundF5F4F0", "  스캔 전")

    UI.LV := g.Add("ListView"
        , "x0 y100 w10 h10 +LV0x20 NoSortHdr -Multi BackgroundWhite"
        , ["상태", "앨범", "사이즈폴더", "파일명"])
    UI.LV.OnEvent("ItemFocus", OnItemFocus)
    UI.LV.OnEvent("ColClick",  OnLVColClick)

    g.SetFont("s8 norm", "맑은 고딕")
    UI.LVHint := g.Add("Text", "x0 y0 w10 h16 +0x200 c9CA3AF BackgroundF5F4F0"
        , "  F1전체  F2 MATCH  F3 NF  F4 다음NF!")
    g.SetFont("s9 norm", "맑은 고딕")

    UI.SepSide := g.Add("Text", "x230 y50 w1 h10 +0x10")

    UI.FileHdrBgM := g.Add("Text", "x0 y0 w10 h52 BackgroundWhite", "")
    UI.FileHdrBgN := g.Add("Text", "x0 y0 w10 h52 BackgroundFFF5F5 Hidden", "")

    g.SetFont("s11 bold", "맑은 고딕")
    UI.FileHdrName := g.Add("Text", "x0 y0 w10 h26 +0x200 BackgroundWhite", "파일을 선택하세요")
    g.SetFont("s9 norm", "맑은 고딕")
    UI.FileHdrSub  := g.Add("Text", "x0 y0 w10 h18 +0x200 BackgroundWhite c78716C", "—")

    g.SetFont("s9 bold", "맑은 고딕")
    UI.StatusBadge := g.Add("Text", "x0 y0 w86 h26 +0x200 +Center BackgroundEFF6FF c1D4ED8", "—")
    g.SetFont("s9 norm", "맑은 고딕")

    UI.BtnMemo := g.Add("Button", "x0 y0 w94 h24 Hidden", "📞 고객 메모")
    UI.BtnMemo.OnEvent("Click", OnCustomerMemo)

    g.SetFont("s9 bold", "맑은 고딕")
    UI.PicLblF := g.Add("Text", "x0 y0 w10 h24 +0x200 c0284C7 BackgroundEFF6FF", "  🖼  액자 원본")
    UI.PicLblA := g.Add("Text", "x0 y0 w10 h24 +0x200 c15803D BackgroundF0FDF4", "  📒  앨범 매칭")
    g.SetFont("s9 norm", "맑은 고딕")

    g.SetFont("s9 bold", "맑은 고딕")
    UI.BadgeTop := g.Add("Text"
        , "x0 y0 w48 h24 +0x200 +Center cWhite Background1D4ED8 Hidden", "")
    g.SetFont("s9 norm", "맑은 고딕")

    UI.PicF := g.Add("Picture", "x0 y0 w10 h10 BackgroundWhite +Border", "")
    UI.PicA := g.Add("Picture", "x0 y0 w10 h10 BackgroundWhite +Border", "")

    g.SetFont("s12 bold", "맑은 고딕")
    UI.TxtNone := g.Add("Text"
        , "x0 y0 w10 h60 +0x200 +Center cB91C1C BackgroundFFF5F5 Hidden"
        , "앨범에서 찾을 수 없음")
    g.SetFont("s9 norm", "맑은 고딕")

    g.SetFont("s8 norm", "맑은 고딕")
    UI.PicFootF := g.Add("Text", "x0 y0 w10 h18 +0x200 c78716C BackgroundF8F7F5", "")
    UI.PicFootA := g.Add("Text", "x0 y0 w10 h18 +0x200 c78716C BackgroundF8F7F5", "")
    g.SetFont("s9 norm", "맑은 고딕")

    UI.SepAction := g.Add("Text", "x0 y0 w10 h1 +0x10")

    g.SetFont("s8 norm", "맑은 고딕")
    UI.TxtRel := g.Add("Text", "x0 y0 w10 h22 +0x200 c57534E", "—")
    g.SetFont("s9 norm", "맑은 고딕")
    UI.CmbMatch := g.Add("DropDownList", "x0 y0 w10", ["(없음)"])
    UI.CmbMatch.OnEvent("Change", OnMatchCombo)
    UI.TxtMCnt := g.Add("Text", "x0 y0 w44 h22 +0x200 c0284C7", "")

    UI.BtnCopy     := g.Add("Button", "x0 y0 w82 h28", "📋 경로 복사")
    UI.BtnLocate   := g.Add("Button", "x0 y0 w90 h28", "📂 위치 열기")
    UI.BtnOpenF    := g.Add("Button", "x0 y0 w72 h28", "파일 열기")
    UI.BtnAlbumDir := g.Add("Button", "x0 y0 w98 h28", "앨범 폴더 열기")
    UI.BtnFrameDir := g.Add("Button", "x0 y0 w98 h28", "액자 폴더 열기")

    UI.BtnCopy.OnEvent("Click",     OnCopyPath)
    UI.BtnLocate.OnEvent("Click",   OnLocateAlbumFile)
    UI.BtnOpenF.OnEvent("Click",    OnOpenFile)
    UI.BtnAlbumDir.OnEvent("Click", OnOpenAlbumDir)
    UI.BtnFrameDir.OnEvent("Click", OnOpenFrameDir)
    UI.BtnCopy.Enabled   := false
    UI.BtnLocate.Enabled := false

    UI.BtnPrev   := g.Add("Button", "x0 y0 w64 h28", "← 이전")
    UI.BtnNextNF := g.Add("Button", "x0 y0 w142 h28", "⚠ 다음 NOT FOUND")
    UI.BtnNext   := g.Add("Button", "x0 y0 w68 h28",  "다음 →")
    UI.BtnPrev.OnEvent("Click",   (*) => NavPrev())
    UI.BtnNextNF.OnEvent("Click", (*) => NavNextNF())
    UI.BtnNext.OnEvent("Click",   (*) => NavNext())

    UI.SepBot  := g.Add("Text", "x0 y0 w10 h1 +0x10")
    UI.TxtProg := g.Add("Text", "x14 y0 w10 h20 +0x200 c555555", "대기 중")
    UI.Prg     := g.Add("Progress", "x0 y0 w10 h8 Range0-1000 c0EA5E9 BackgroundE8E8E8", 0)

    UI.FullPath  := ""
    UI._PicFPath := ""
    UI._PicAPath := ""

    HotIfWinActive("ahk_id " g.Hwnd)
    Hotkey("Right",  (*) => NavNext())
    Hotkey("Left",   (*) => NavPrev())
    Hotkey("Enter",  (*) => NavNext())
    Hotkey("F1",     (*) => ApplyFilter("ALL"))
    Hotkey("F2",     (*) => ApplyFilter("MATCH"))
    Hotkey("F3",     (*) => ApplyFilter("NOT"))
    Hotkey("F4",     (*) => NavNextNF())

    g.Show("w1100 h720")
    DllCall("Shell32\DragAcceptFiles", "Ptr", g.Hwnd, "Int", true)
    OnMessage(0x0233, OnWM_DROPFILES)
    DoLayout(1100, 720)
    SwitchMode("A")
}
