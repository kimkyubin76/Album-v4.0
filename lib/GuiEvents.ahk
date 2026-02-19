; lib/GuiEvents.ahk
; 의존: Globals.ahk, PathUtil.ahk, GuiLayout.ahk

SwitchMode(m) {
    global _LW, _LH
    ST.Mode := m
    isA := m = "A"
    UI.BtnModeA.Text := isA  ? "▶ 자동(A)" : "자동(A)"
    UI.BtnModeB.Text := !isA ? "▶ 수동(B)" : "수동(B)"
    for n in ["LblRoot","EdtRoot","BtnRoot"]
        UI.G[n].Visible := isA
    for n in ["LblFrame","EdtFrame","BtnFrame","LblAlbum","EdtAlbum","BtnAlbum"]
        UI.G[n].Visible := !isA
    DoLayout(_LW, _LH)
}

OnBrowseRoot(*) {
    UI.G.Opt("+OwnDialogs")
    f := DirSelect(, 3, "[자동 모드] 루트 폴더를 선택하세요")
    if !f
        return
    f := RTrim(f, "\")
    ST.Root := f
    UI.EdtRoot.Value := f
}

OnBrowseFrame(*) {
    UI.G.Opt("+OwnDialogs")
    f := DirSelect(, 3, "[수동 모드] 액자 폴더를 선택하세요")
    if !f
        return
    f := RTrim(f, "\")
    ST.FramePath := f
    UI.EdtFrame.Value := f
}

OnBrowseAlbum(*) {
    UI.G.Opt("+OwnDialogs")
    f := DirSelect(, 3, "[수동 모드] 앨범 루트 폴더를 선택하세요")
    if !f
        return
    f := RTrim(f, "\")
    ST.AlbumPath := f
    UI.EdtAlbum.Value := f
}

OnEditRoot(ctrl, *) {
    val := Trim(ctrl.Value, ' "' . "`t`r`n")
    val := RTrim(val, "\")
    if !val
        return
    if DirExist(val) {
        ST.Root := val
        return
    }
    path := CleanPath(val)
    if path && DirExist(path) {
        ST.Root := path
        ctrl.Value := path
    }
}

OnEditFrame(ctrl, *) {
    val := Trim(ctrl.Value, ' "' . "`t`r`n")
    val := RTrim(val, "\")
    if !val
        return
    if DirExist(val) {
        ST.FramePath := val
        return
    }
    path := CleanPath(val)
    if path && DirExist(path) {
        ST.FramePath := path
        ctrl.Value := path
    }
}

OnEditAlbum(ctrl, *) {
    val := Trim(ctrl.Value, ' "' . "`t`r`n")
    val := RTrim(val, "\")
    if !val
        return
    if DirExist(val) {
        ST.AlbumPath := val
        return
    }
    path := CleanPath(val)
    if path && DirExist(path) {
        ST.AlbumPath := path
        ctrl.Value := path
    }
}

OnWM_DROPFILES(wParam, lParam, msg, hwnd) {
    count := DllCall("Shell32\DragQueryFileW"
        , "Ptr", wParam, "UInt", 0xFFFFFFFF, "Ptr", 0, "UInt", 0, "UInt")
    if count < 1 {
        DllCall("Shell32\DragFinish", "Ptr", wParam)
        return 0
    }
    reqLen := DllCall("Shell32\DragQueryFileW"
        , "Ptr", wParam, "UInt", 0, "Ptr", 0, "UInt", 0, "UInt")
    bufChars := reqLen + 2
    buf := Buffer(bufChars * 2, 0)
    DllCall("Shell32\DragQueryFileW"
        , "Ptr", wParam, "UInt", 0, "Ptr", buf, "UInt", bufChars, "UInt")
    rawPath := StrGet(buf, "UTF-16")
    pt := Buffer(8)
    DllCall("Shell32\DragQueryPoint", "Ptr", wParam, "Ptr", pt)
    dx := NumGet(pt, 0, "Int")
    dy := NumGet(pt, 4, "Int")
    DllCall("Shell32\DragFinish", "Ptr", wParam)
    path := CleanPath(rawPath)
    if !path {
        ToolTip("⚠ 드롭 경로 인식 실패`n" rawPath)
        SetTimer(() => ToolTip(), -3000)
        return 0
    }
    if ST.Mode = "A" {
        if _HitCtrl(UI.EdtRoot, dx, dy) || !_HitAnyRight(dx, dy) {
            ST.Root := path
            UI.EdtRoot.Value := path
        }
    } else {
        if _HitCtrl(UI.EdtFrame, dx, dy) {
            ST.FramePath := path
            UI.EdtFrame.Value := path
        } else if _HitCtrl(UI.EdtAlbum, dx, dy) {
            ST.AlbumPath := path
            UI.EdtAlbum.Value := path
        } else if !ST.FramePath || ST.FramePath = "" {
            ST.FramePath := path
            UI.EdtFrame.Value := path
        } else {
            ST.AlbumPath := path
            UI.EdtAlbum.Value := path
        }
    }
    ToolTip("📂 " path)
    SetTimer(() => ToolTip(), -1500)
    return 0
}

_HitCtrl(ctrl, x, y) {
    try {
        ctrl.GetPos(&cx, &cy, &cw, &ch)
        return x >= cx && x <= cx + cw && y >= cy && y <= cy + ch
    }
    return false
}

_HitAnyRight(x, y) {
    try {
        UI.PicF.GetPos(&px, &py, &pw, &ph)
        if x >= px
            return true
    }
    return false
}
