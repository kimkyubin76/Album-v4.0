; ============================================================
;  lib/ListView.ahk — ListView 정렬, 필터, 아이콘, 통계
;  의존: Globals.ahk (ST, UI, FILT)
; ============================================================

SetIcons() {
    static inited := false
    if !inited {
        inited := true
        hIL := IL_Create(2, 0, false)
        IL_Add(hIL, "shell32.dll", 297)
        IL_Add(hIL, "shell32.dll", 132)
        UI.LV.SetImageList(hIL, 1)
    }
    Loop ST.Frames.Length {
        e := ST.Frames[A_Index]
        UI.LV.Modify(A_Index, "Icon" (e.status = "MATCH" ? 1 : 2))
    }
}

OnLVColClick(ctrl, col) {
    if ST.Filtered.Length = 0
        return
    if col = ST.SortCol
        ST.SortAsc := !ST.SortAsc
    else {
        ST.SortCol := col
        ST.SortAsc := (col != 1)
    }
    SortLV(col, ST.SortAsc)
}

SortLV(col, asc) {
    if ST.Filtered.Length = 0
        return
    arr := ST.Filtered.Clone()
    n   := arr.Length
    Loop n - 1 {
        i   := A_Index + 1
        key := arr[i]
        j   := i - 1
        while j >= 1 && _LVCompare(arr[j], key, col, asc) > 0 {
            arr[j + 1] := arr[j]
            j--
        }
        arr[j + 1] := key
    }
    ST.Filtered := arr

    UI.LV.Opt("-Redraw")
    UI.LV.Delete()
    for , idx in ST.Filtered {
        e   := ST.Frames[idx]
        ic  := e.status = "MATCH" ? 1 : 2
        stT := e.status = "MATCH" ? "MATCH" : "NOT FOUND"
        aC  := e.status = "MATCH" ? e.albumNum : ""
        UI.LV.Add("Icon" ic, stT, aC, e.subdir, e.name)
    }
    UI.LV.Opt("+Redraw")
    _SetLVColWidths()
    if ST.Filtered.Length > 0
        UI.LV.Modify(1, "Select Focus Vis")
}

_SetLVColWidths() {
    UI.LV.GetPos(, , &lvW)
    c1  := 58
    c2  := 40
    rem := Max(80, lvW - c1 - c2 - 6)
    c3  := Integer(rem * 0.38)
    c4  := rem - c3
    UI.LV.ModifyCol(1, c1 . " Center")
    UI.LV.ModifyCol(2, c2 . " Center")
    UI.LV.ModifyCol(3, Max(60, c3))
    UI.LV.ModifyCol(4, Max(80, c4))
}

_LVCompare(idxA, idxB, col, asc) {
    a := ST.Frames[idxA]
    b := ST.Frames[idxB]
    switch col {
        case 1:
            va   := a.status = "MATCH" ? 0 : 1
            vb   := b.status = "MATCH" ? 0 : 1
            diff := va - vb
        case 2:
            va   := _AlbumSortKey(a)
            vb   := _AlbumSortKey(b)
            diff := StrCompare(va, vb)
        case 3:
            sa   := StrLower(a.subdir)
            sb   := StrLower(b.subdir)
            diff := sa < sb ? -1 : sa > sb ? 1 : 0
        case 4:
            sa   := StrLower(a.name)
            sb   := StrLower(b.name)
            diff := sa < sb ? -1 : sa > sb ? 1 : 0
        default:
            diff := 0
    }
    return asc ? diff : -diff
}

_AlbumSortKey(e) {
    if e.status != "MATCH" || e.albumNum = "" || e.albumNum = "-"
        return "Z"
    try {
        v := Integer(e.albumNum)
        return "A_" Format("{:04}", v)
    }
    return "B_" StrLower(e.albumNum)
}

ApplyFilter(m) {
    ST.Filter := m
    UI.FTabAll.Text := m = "ALL"   ? "▶ 전체"         : "전체"
    UI.FTabNF.Text  := m = "NOT"   ? "▶ ✕ NOT FOUND"  : "✕ NOT FOUND"
    UI.FTabM.Text   := m = "MATCH" ? "▶ ✓ MATCH"      : "✓ MATCH"

    if m = "ALL" && ST.SortCol = 1 {
        ST.SortAsc := false
    }

    UI.LV.Opt("-Redraw")
    UI.LV.Delete()
    ST.Filtered := []
    for idx, e in ST.Frames {
        ok := m = "ALL"
           || (m = "MATCH" && e.status = "MATCH")
           || (m = "NOT"   && e.status != "MATCH")
        if !ok
            continue
        ST.Filtered.Push(idx)
        ic  := e.status = "MATCH" ? 1 : 2
        stT := e.status = "MATCH" ? "MATCH" : "NOT FOUND"
        aC  := e.status = "MATCH" ? e.albumNum : ""
        UI.LV.Add("Icon" ic, stT, aC, e.subdir, e.name)
    }
    UI.LV.Opt("+Redraw")
    _SetLVColWidths()

    if ST.Filtered.Length > 0
        SortLV(ST.SortCol, ST.SortAsc)
    else
        ClearPreview()
}

UpdateChips(tot, mc, nc) {
    UI.ChipTotal.Text := "전체 " tot
    UI.ChipMatch.Text := "✓ " mc
    UI.ChipNF.Text    := "✕ " nc
}

UpdateGrpSum(nc, mc) {
    if nc > 0
        UI.GrpSum.Text := "  ⚠ NOT FOUND: " nc "개  |  ✓ MATCH: " mc "개"
    else
        UI.GrpSum.Text := "  ✓ 전체 MATCH: " mc "개"
}
