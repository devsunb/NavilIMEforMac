//
//  KeyboardSemoi.swift
//  automata
//
//  Created by Jaeseok Lee on 3/15/25.
//

import Foundation

class KeyboardSemoi: Keyboard {
    override init() {
        super.init()

        self.name = "세모이"
        self.id = 325

        // 초성 레이아웃
        self.chosung_layout = [
            "k": Chosung.Giyuk,
            "kj": Chosung.SsGiyuk, "jk": Chosung.SsGiyuk,
            "u": Chosung.Nien,
            "i": Chosung.Digek,
            "ij": Chosung.SsDigek, "ji": Chosung.SsDigek,
            "m": Chosung.Riel,
            "y": Chosung.Miem,
            "o": Chosung.Biep,
            "oj": Chosung.SsBiep, "jo": Chosung.SsBiep,
            "n": Chosung.Siot,
            "nj": Chosung.SsSiot, "jn": Chosung.SsSiot,
            "j": Chosung.Yieng,
            "l": Chosung.Jiek,
            "lj": Chosung.SsJiek, "jl": Chosung.SsJiek,
            "lh": Chosung.Chiek, "hl": Chosung.Chiek,
            "ih": Chosung.Tigek, "hi": Chosung.Tigek,
            "kh": Chosung.Kiyuk, "hk": Chosung.Kiyuk,
            "oh": Chosung.Piep, "ho": Chosung.Piep,
            "h": Chosung.Hiek,
        ]

        // 중성 레이아웃
        self.jungsung_layout = [
            "f": Jungsung.A,
            "fd": Jungsung.Ae, "df": Jungsung.Ae,
            "gv": Jungsung.Ya, "vg": Jungsung.Ya, "g.": Jungsung.Ya, ".g": Jungsung.Ya,
            "tv": Jungsung.Yae, "vt": Jungsung.Yae, "t.": Jungsung.Yae, ".t": Jungsung.Yae,
            "r": Jungsung.Eo,
            "c": Jungsung.E,
            "t": Jungsung.Yeo,
            "cv": Jungsung.Ye, "vc": Jungsung.Ye, "c.": Jungsung.Ye, ".c": Jungsung.Ye,
            "v": Jungsung.O, ".": Jungsung.O,
            "vf": Jungsung.Wa, "fv": Jungsung.Wa, ".f": Jungsung.Wa, "f.": Jungsung.Wa,
            "vfd": Jungsung.Wae, "vdf": Jungsung.Wae, "fvd": Jungsung.Wae, "fdv": Jungsung.Wae,
            "dvf": Jungsung.Wae, "dfv": Jungsung.Wae, ".fd": Jungsung.Wae, ".df": Jungsung.Wae,
            "f.d": Jungsung.Wae, "fd.": Jungsung.Wae, "d.f": Jungsung.Wae, "df.": Jungsung.Wae,
            "vd": Jungsung.Oe, "dv": Jungsung.Oe, ".d": Jungsung.Oe, "d.": Jungsung.Oe,
            "v.": Jungsung.Yo, ".v": Jungsung.Yo,
            "b": Jungsung.U,
            "rb": Jungsung.Weo, "br": Jungsung.Weo, "rv": Jungsung.Weo, "vr": Jungsung.Weo,
            "r.": Jungsung.Weo, ".r": Jungsung.Weo,
            "bc": Jungsung.We, "cb": Jungsung.We,
            "bd": Jungsung.Wi, "db": Jungsung.Wi,
            "bv": Jungsung.Yu, "vb": Jungsung.Yu, "b.": Jungsung.Yu, ".b": Jungsung.Yu,
            "g": Jungsung.Eu,
            "gd": Jungsung.Yi, "dg": Jungsung.Yi,
            "d": Jungsung.I,
        ]

        // 종성 레이아웃
        self.jongsung_layout = [
            "x": Jongsung.Kiyeok,
            "xa": Jongsung.Ssangkiyeok, "ax": Jongsung.Ssangkiyeok,
            "xq": Jongsung.Kiyeoksios, "qx": Jongsung.Kiyeoksios,
            "s": Jongsung.Nieun,
            "sa": Jongsung.Nieunhieuh, "as": Jongsung.Nieunhieuh,
            "se": Jongsung.Nieuncieuc, "es": Jongsung.Nieuncieuc,
            "sz": Jongsung.Thieuth, "zs": Jongsung.Thieuth,
            "e": Jongsung.Rieul,
            "eq": Jongsung.Rieulsios, "qe": Jongsung.Rieulsios,
            "ew": Jongsung.Rieulpieup, "we": Jongsung.Rieulpieup,
            "ex": Jongsung.Rieulkiyeok, "xe": Jongsung.Rieulkiyeok,
            "ez": Jongsung.Rieulmieum, "ze": Jongsung.Rieulmieum,
            "az": Jongsung.Rieulthieuth, "za": Jongsung.Rieulthieuth,
            "aw": Jongsung.Rieulphieuph, "wa": Jongsung.Rieulphieuph,
            "a;": Jongsung.Rieulhieuh, ";a": Jongsung.Rieulhieuh,
            "z": Jongsung.Mieum,
            "w": Jongsung.Pieup,
            "wq": Jongsung.Pieupsios, "qw": Jongsung.Pieupsios,
            "q": Jongsung.Sios,
            "qa": Jongsung.Ssangsios, "aq": Jongsung.Ssangsios, ";": Jongsung.Ssangsios,
            "a": Jongsung.Ieung,
            "e;": Jongsung.Cieuc, ";e": Jongsung.Cieuc,
            "q;": Jongsung.Chieuch, ";q": Jongsung.Chieuch,
            "x;": Jongsung.Khieukh, ";x": Jongsung.Khieukh,
            "z;": Jongsung.Tikeut, ";z": Jongsung.Tikeut,
            "w;": Jongsung.Phieuph, ";w": Jongsung.Phieuph,
            "s;": Jongsung.Hieuh, ";s": Jongsung.Hieuh,
        ]

        // 기타 기호, 숫자 레이아웃
        self.etc_layout = [
            "p": ";",
            "P": ":",
            "L": ".",
            " ": " ",
        ]

        // 약어
        self.abbreviations = [
            "jw": "입니다. ", "wj": "입니다. ",
        ]
    }

    override func chosung_proc(comp: inout Composition, nobreak: Bool, current: [String], i: Int) -> Bool {
        // 마지막 낱자 처리: 초성, 중성, 종성 낱자 종류별 모아치기 허용 최대 시간 제한
        // 아래 조건에 따라 글자 분할 (현재 글자 조합 종료 및 이번 낱자부터 다음 글자 조합 시작)
        // - nobreak 인자가 true 이면 글자 분할하지 않음: Backspace 및 Flush 등 새로운 글자가 생길 수 없는 경우에 사용
        // - 조합 중인 글자에 동일 종류 낱자가 이미 존재하고
        //   (즉, 이번 마지막 낱자가 초성이면 조합 중인 글자에 초성이 존재하고)
        // - 직전 동일 종류 낱자 입력 이후 input_delta_threshold 경과한 경우 글자 분할
        //   (즉, 이번 마지막 낱자가 중성이면 직전 중성 입력 이후 시간 경과 시)
        // 따라서 초성, 중성, 종성 간에는 이어치기가 가능하지만, 한 글자 내의 동일 종류 낱자는 반드시 시간 내에 모아쳐야 함
        // 즉, "안" 을 입력한 상태에서 시간이 지난 경우 "앤" 으로 가려면 모음 "ㅏ" 까지 삭제한 후 새로 "ㅏ", "ㅣ" 를 눌러 "ㅐ" 를 입력해야 함
        // 이 처리가 없으면 "하지" 와 "채" 를 구분할 수 없음
        let chokey: String = comp.chosung + current[i]
        let cho: Bool = self.chosung_layout[chokey] != nil
        if i == current.count - 1 && cho {
            // 이번 마지막 낱자가 초성: 직전 초성 입력 이후 시간 측정
            // 오토마타 반복 때문에 마지막 낱자가 초성일 때만 시간 측정해야 함
            self.update_chosung_input_delta()
            // nobreak 인자가 true 이거나, 조합 중인 글자에 초성이 없거나, 직전 초성 입력 이후 시간이 기준보다 짧으면 계속 조합
            // = nobreak 인자가 false 이고, 조합 중인 글자에 초성이 있고, 직전 초성 입력 이후 시간이 기준보다 길면 조합 종료
            if !nobreak && comp.chosung != "" && self.chosung_input_delta > self.input_delta_threshold {
                comp.done = true
                return false
            }
        }
        return cho
    }

    override func jungsung_proc(comp: inout Composition, nobreak: Bool, current: [String], i: Int) -> Bool {
        let jungkey: String = comp.jungsung + current[i]
        let jung: Bool = self.jungsung_layout[jungkey] != nil
        if i == current.count - 1 && jung {
            self.update_jungsung_input_delta()
            if !nobreak && comp.jungsung != "" && self.jungsung_input_delta > self.input_delta_threshold {
                comp.done = true
                return false
            }
        }
        return jung
    }

    override func jongsung_proc(comp: inout Composition, nobreak: Bool, current: [String], i: Int) -> Bool {
        let jongkey: String = comp.jongsung + current[i]
        let jong: Bool = self.jongsung_layout[jongkey] != nil
        if i == current.count - 1 && jong {
            self.update_jongsung_input_delta()
            if !nobreak && comp.jongsung != "" && self.jongsung_input_delta > self.input_delta_threshold {
                comp.done = true
                return false
            }
        }
        return jong
    }

    func moa_jongsung_proc(comp: inout Composition, current: [String], i: Int) {
        // 모아치기 종성 다음 글자로 넘김
        // "서울"을 입력하려고 할 때 "서"가 입력된 상태에서 두 번째 글자의 종성 "ㄹ"을 가장 먼저 입력하는 경우 "설우"가 되는 현상 방지
        // 즉, 두 번째 글자를 입력할 때 종성을 먼저 입력하더라도 다른 낱자를 input_delta_threshold 내에 입력하면 종성이 제자리를 찾아감
        // 아래 조건에 따라 다음 글자로 넘어갈 때 이번 글자의 종성을 다음 글자로 넘김
        // - 이번 글자의 종성이 비어있지 않고
        // - 직전 낱자 입력 이후 input_delta_threshold 경과하지 않은 경우
        // - 이번 글자의 가장 마지막에 연속으로 입력된 모든 종성을 다음 글자로 넘김
        // 이 기능으로 인해 만약 첫 번째 글자가 종성으로 끝나고 input_delta_threshold 내에 두 번째 글자를 종성으로 시작하는 경우
        // 첫 번째 글자의 종성이 분리되는 문제가 발생하는데, input_delta_threshold 내에 두 개 이상의 글자를 입력하는 경우는 애초에 고려 대상이 아니므로 무시
        let simultaneous = self.input_delta < self.input_delta_threshold
        if comp.jongsung != "" && simultaneous {
            let a = current.prefix(i).reversed()
            let b = Array(comp.jongsung).reversed()
            var c = 0
            for (x, y) in zip(a, b) { if x == String(y) { c += 1 } else { break } }
            if c > 0 {
                PrintLog.shared.Log(log: "모아치기 종성 넘김: \(a.joined()) 중 종성 \(String(b)) (\(c)개) 다음 글자로")
                comp.jongsung.removeLast(c)
            }
            // current에 두 번째 글자도 완료 처리할 수 있는 낱자가 쌓여있을 때 무한루프 가능성이 있음
            // 이를 방지하기 위해 input_delta를 input_delta_threshold보다 크게 설정
            self.clear_input_delta()
        }
    }

    override func fallback_proc(comp: inout Composition, current: [String], i: Int) {
        self.moa_jongsung_proc(comp: &comp, current: current, i: i)
        comp.done = true
    }
}
