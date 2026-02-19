; ============================================================
;  lib/Globals.ahk — 전역 변수 정의
;  모든 모듈이 공유하는 전역 객체 선언 (선언만, 로직 없음)
; ============================================================

global GDIP_TOKEN := 0   ; GdipInit() 에서 채워짐

global CFG := {
    Ext:         ["jpg","jpeg","png","heic"],
    FrameName:   "액자",
    AlbumMin:    1,
    AlbumMax:    99,
    ThumbW:      300,
    ThumbH:      230,
    HashChunk:   1048576
}

global ST := {
    Mode:         "A",
    Root:         "",
    FramePath:    "",
    FrameFolders: [],
    AlbumPath:    "",
    AlbumHash:    Map(),
    Frames:       [],
    Filtered:     [],
    Filter:       "ALL",
    Scanning:     false,
    Cancel:       false,
    SelRow:       0,
    Tick0:        0,
    SortCol:      1,      ; 기본: 상태 컬럼
    SortAsc:      false   ; false = NOT FOUND 먼저
}

global UI   := {}
global _LW  := 1100
global _LH  := 720

global FILT := {
    Patterns:    [],  RawText:    "",
    DirPatterns: [],  DirRawText: "",
    FrameKW:     [],  FrameKWText:"",
    AlbumKW:     [],  AlbumKWText:"",
    IgnoreCase:  true,
    UseRegex:    false,
    Excluded:    0
}

global SETTINGS_INI := A_ScriptDir "\settings.ini"
