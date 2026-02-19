; ============================================================
;  lib/GuiLayout.ahk — 창 크기 변경 + 레이아웃 계산
;  의존: Globals.ahk (UI, ST, _LW, _LH), Preview.ahk (SetPic)
; ============================================================

OnResize(thisGui, minMax, w, h) {
    if minMax = -1
        return
    try UI.PicF.Value := ""
    try UI.PicA.Value := ""
    DoLayout(w, h)
    SetTimer(_RefreshPreviews, -120)
}

_RefreshPreviews() {
    try {
        if UI._PicFPath
            SetPic(UI.PicF, UI._PicFPath)
        if UI._PicAPath
            SetPic(UI.PicA, UI._PicAPath)
    }
}

DoLayout(w, h) {
    global _LW, _LH
    w := Integer(Max(920, w))
    h := Integer(Max(600, h))
    _LW := w
    _LH := h

    M      := 10
    GAP    := 6
    HDR    := 48
    SIDE_W := 232
    BOT_H  := 26

    ; ── 헤더 ────────────────────────────────────────────────────────
    UI.HdrBg.Move(0, 0, w, HDR)
    UI.SepHdr.Move(0, HDR, w, 1)

    settX := w - M - 30
    cancX := settX - GAP - 66
    scanX := cancX - GAP - 84
    cMX   := scanX - GAP - 80
    cNFX  := cMX   - 4   - 80
    cTX   := cNFX  - 4   - 70

    UI.ChipTotal.Move(cTX,   13, 70, 24)
    UI.ChipNF.Move(cNFX,     13, 80, 24)
    UI.ChipMatch.Move(cMX,   13, 80, 24)
    UI.BtnScan.Move(scanX,   12, 84, 28)
    UI.BtnCancel.Move(cancX, 12, 66, 28)
    UI.BtnSettings.Move(settX, 12, 30, 28)

    browseBtnW := 74
    browseBtnX := cTX - GAP - browseBtnW
    edtW       := Max(80, browseBtnX - GAP - 350)

    UI.G["LblRoot"].Move(312, 14, 36, 22)
    UI.EdtRoot.Move(350, 13, edtW, 24)
    UI.BtnRoot.Move(browseBtnX, 12, browseBtnW, 26)

    bBtnW  := 62
    bBtnX  := cTX - GAP - bBtnW
    bEdtW  := Max(60, bBtnX - GAP - 350)
    UI.G["LblFrame"].Move(312, 9, 36, 20)
    UI.EdtFrame.Move(350, 8, bEdtW, 20)
    try UI.G["BtnFrame"].Move(bBtnX, 7, bBtnW, 22)
    UI.G["LblAlbum"].Move(312, 29, 36, 20)
    UI.EdtAlbum.Move(350, 28, bEdtW, 20)
    try UI.G["BtnAlbum"].Move(bBtnX, 27, bBtnW, 22)

    ; ── 메인 영역 ────────────────────────────────────────────────────
    mainTop := HDR + 1
    mainBot := h - BOT_H - 1
    mainH   := mainBot - mainTop

    ; ── 사이드바 ─────────────────────────────────────────────────────
    TAB_H  := 30
    GRP_H  := 20
    HINT_H := 18

    tabW := Integer(SIDE_W / 3)
    UI.FTabAll.Move(0,        mainTop, tabW,              TAB_H)
    UI.FTabNF.Move(tabW,      mainTop, tabW,              TAB_H)
    UI.FTabM.Move(tabW * 2,   mainTop, SIDE_W - tabW * 2, TAB_H)

    UI.GrpSum.Move(0, mainTop + TAB_H, SIDE_W, GRP_H)

    lvTop := mainTop + TAB_H + GRP_H
    lvBot := mainBot - HINT_H
    lvH   := Max(80, lvBot - lvTop)
    UI.LV.Move(0, lvTop, SIDE_W, lvH)

    UI.LVHint.Move(0, lvBot, SIDE_W, HINT_H)
    UI.SepSide.Move(SIDE_W, mainTop, 1, mainH)

    ; LV 컬럼 너비
    c1  := 58
    c2  := 38
    rem := Max(80, SIDE_W - c1 - c2 - 6)
    c3  := Integer(rem * 0.38)
    c4  := rem - c3
    UI.LV.ModifyCol(1, c1 . " Center")
    UI.LV.ModifyCol(2, c2 . " Center")
    UI.LV.ModifyCol(3, Max(50, c3))
    UI.LV.ModifyCol(4, Max(70, c4))

    ; ── 상세 패널 ─────────────────────────────────────────────────────
    detX := SIDE_W + 2
    detW := Max(300, w - detX)

    FILE_HDR_H := 52
    curY := mainTop
    UI.FileHdrBgM.Move(detX, curY, detW, FILE_HDR_H)
    UI.FileHdrBgN.Move(detX, curY, detW, FILE_HDR_H)

    badgeW  := 90
    memoW   := 96
    nameW   := Max(100, detW - badgeW - memoW - M * 3)
    UI.FileHdrName.Move(detX + M, curY + 5, nameW, 26)
    UI.FileHdrSub.Move(detX + M, curY + 33, detW - M * 2, 16)
    UI.StatusBadge.Move(detX + M + nameW + M, curY + 12, badgeW, 28)
    UI.BtnMemo.Move(detX + M + nameW + M + badgeW + 4, curY + 14, memoW, 24)

    curY += FILE_HDR_H

    PIC_LBL_H  := 26
    PIC_FOOT_H := 18
    ACTION_H   := 4 + 22 + 4 + 28 + 2

    photoAreaH := Max(100, mainBot - curY - ACTION_H)
    picH       := Max(60, photoAreaH - PIC_LBL_H - PIC_FOOT_H)

    cardW  := Integer((detW - GAP) / 2)
    aCardX := detX + cardW + GAP

    UI.PicLblF.Move(detX, curY, cardW, PIC_LBL_H)
    UI.PicF.Move(detX, curY + PIC_LBL_H, cardW, picH)
    UI.PicFootF.Move(detX, curY + PIC_LBL_H + picH, cardW, PIC_FOOT_H)

    badgeW2 := 52
    UI.PicLblA.Move(aCardX, curY, cardW - badgeW2 - 4, PIC_LBL_H)
    UI.BadgeTop.Move(aCardX + cardW - badgeW2, curY, badgeW2, PIC_LBL_H)
    UI.PicA.Move(aCardX, curY + PIC_LBL_H, cardW, picH)
    UI.TxtNone.Move(aCardX, curY + PIC_LBL_H + Integer(picH / 2) - 30, cardW, 60)
    UI.PicFootA.Move(aCardX, curY + PIC_LBL_H + picH, cardW, PIC_FOOT_H)

    curY += PIC_LBL_H + picH + PIC_FOOT_H

    ; ── 액션 바 ──────────────────────────────────────────────────────
    UI.SepAction.Move(detX, curY, detW, 1)
    curY += 4

    relW := Max(80, detW - 200 - M * 2)
    UI.TxtRel.Move(detX + M, curY, relW, 22)
    cmbW := Min(180, Max(60, detW - relW - 60 - M * 3))
    UI.CmbMatch.Move(detX + M + relW + 4, curY, cmbW, 22)
    UI.TxtMCnt.Move(detX + M + relW + 4 + cmbW + 4, curY, 44, 22)
    curY += 26

    bY := curY
    bH := 28

    UI.BtnCopy.Move(detX + M, bY, 82, bH)
    UI.BtnLocate.Move(detX + M + 86, bY, 90, bH)
    UI.BtnOpenF.Move(detX + M + 180, bY, 72, bH)
    UI.BtnAlbumDir.Move(detX + M + 256, bY, 98, bH)
    UI.BtnFrameDir.Move(detX + M + 358, bY, 98, bH)

    UI.BtnNext.Move(detX + detW - M - 68, bY, 68, bH)
    UI.BtnNextNF.Move(detX + detW - M - 68 - GAP - 142, bY, 142, bH)
    UI.BtnPrev.Move(detX + detW - M - 68 - GAP - 142 - GAP - 64, bY, 64, bH)

    ; ── 하단 진행바 ──────────────────────────────────────────────────
    botY := h - BOT_H + 2
    UI.SepBot.Move(0, botY - 2, w, 1)
    prgW := Max(160, Integer(w * 0.38))
    UI.TxtProg.Move(M, botY, Max(100, w - prgW - M * 3), 20)
    UI.Prg.Move(w - M - prgW, botY + 7, prgW, 10)
}
