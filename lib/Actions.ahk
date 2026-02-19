; ============================================================
;  lib/Actions.ahk — 버튼 클릭 액션 핸들러
;  의존: Globals.ahk (ST, UI)
; ============================================================

OnCopyPath(*) {
    if UI.FullPath {
        A_Clipboard := UI.FullPath
        ToolTip("클립보드에 복사됨`n" UI.FullPath)
        SetTimer(() => ToolTip(), -2000)
    }
}

OnLocateAlbumFile(*) {
    if UI.FullPath && FileExist(UI.FullPath)
        Run('explorer.exe /select,"' UI.FullPath '"')
}

OnOpenAlbumDir(*) {
    p := ST.AlbumPath
    if p && DirExist(p)
        Run('explorer.exe "' p '"')
}

OnOpenFrameDir(*) {
    if ST.SelRow >= 1 && ST.SelRow <= ST.Filtered.Length {
        e := ST.Frames[ST.Filtered[ST.SelRow]]
        SplitPath(e.path, , &d)
        if DirExist(d)
            return Run('explorer.exe /select,"' e.path '"')
    }
    if ST.FramePath && DirExist(ST.FramePath)
        Run('explorer.exe "' ST.FramePath '"')
}

OnOpenFile(*) {
    if ST.SelRow < 1 || ST.SelRow > ST.Filtered.Length
        return
    e := ST.Frames[ST.Filtered[ST.SelRow]]
    if FileExist(e.path)
        Run('"' e.path '"')
}

OnCustomerMemo(*) {
    if ST.SelRow < 1 || ST.SelRow > ST.Filtered.Length
        return
    e    := ST.Frames[ST.Filtered[ST.SelRow]]
    memo := "📞 고객 확인 필요`n파일명: " e.name "`n경로: " e.path "`n앨범에서 찾을 수 없음"
    A_Clipboard := memo
    ToolTip("📋 고객 메모가 클립보드에 복사되었습니다`n" e.name)
    SetTimer(() => ToolTip(), -2500)
}
