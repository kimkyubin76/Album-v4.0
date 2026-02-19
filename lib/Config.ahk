; ============================================================
;  lib/Config.ahk — settings.ini 로드/저장 + 패턴 파싱
;  의존: Globals.ahk
; ============================================================

LoadFilterSettings() {
    ini := SETTINGS_INI
    if !FileExist(ini) {
        FILT.RawText     := "Thumbs.db`ndesktop.ini`n._*`n~$*`n*.tmp"
        FILT.DirRawText  := "설명서"
        FILT.FrameKWText := ""
        FILT.AlbumKWText := "표지`n가족사진"
        FILT.IgnoreCase  := true
        FILT.UseRegex    := false
        _ParsePatterns()
        SaveFilterSettings()
        return
    }
    FILT.RawText     := StrReplace(IniRead(ini, "Filter",   "Patterns",      ""), "||", "`n")
    FILT.DirRawText  := StrReplace(IniRead(ini, "Filter",   "DirPatterns",   ""), "||", "`n")
    FILT.FrameKWText := StrReplace(IniRead(ini, "Classify", "FrameKeywords", ""), "||", "`n")
    FILT.AlbumKWText := StrReplace(IniRead(ini, "Classify", "AlbumKeywords", ""), "||", "`n")
    FILT.IgnoreCase  := IniRead(ini, "Filter", "IgnoreCase", 1) + 0
    FILT.UseRegex    := IniRead(ini, "Filter", "UseRegex",   0) + 0
    _ParsePatterns()
}

SaveFilterSettings() {
    ini := SETTINGS_INI
    IniWrite(StrReplace(FILT.RawText,     "`n", "||"), ini, "Filter",   "Patterns")
    IniWrite(StrReplace(FILT.DirRawText,  "`n", "||"), ini, "Filter",   "DirPatterns")
    IniWrite(FILT.IgnoreCase ? 1 : 0,                  ini, "Filter",   "IgnoreCase")
    IniWrite(FILT.UseRegex   ? 1 : 0,                  ini, "Filter",   "UseRegex")
    IniWrite(StrReplace(FILT.FrameKWText, "`n", "||"), ini, "Classify", "FrameKeywords")
    IniWrite(StrReplace(FILT.AlbumKWText, "`n", "||"), ini, "Classify", "AlbumKeywords")
}

_ParsePatterns() {
    FILT.Patterns := []
    for line in StrSplit(FILT.RawText, "`n", "`r ") {
        line := Trim(line)
        if line = "" || SubStr(line, 1, 1) = "#"
            continue
        FILT.Patterns.Push(line)
    }
    FILT.DirPatterns := []
    for line in StrSplit(FILT.DirRawText, "`n", "`r ") {
        line := Trim(line)
        if line = "" || SubStr(line, 1, 1) = "#"
            continue
        FILT.DirPatterns.Push(line)
    }
    FILT.FrameKW := []
    for line in StrSplit(FILT.FrameKWText, "`n", "`r ") {
        line := Trim(line)
        if line = "" || SubStr(line, 1, 1) = "#"
            continue
        FILT.FrameKW.Push(StrLower(line))
    }
    FILT.AlbumKW := []
    for line in StrSplit(FILT.AlbumKWText, "`n", "`r ") {
        line := Trim(line)
        if line = "" || SubStr(line, 1, 1) = "#"
            continue
        FILT.AlbumKW.Push(StrLower(line))
    }
}
