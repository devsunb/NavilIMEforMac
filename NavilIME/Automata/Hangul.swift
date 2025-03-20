//
//  Hangul.swift
//  automata
//
//  Created by Manwoo Yi on 9/10/22.
//

import Foundation

struct Composition {
    var chosung: String = ""
    var jungsung: String = ""
    var jongsung: String = ""
    var done: Bool = false

    var Size: UInt {
        return UInt(self.chosung.count + self.jungsung.count + self.jongsung.count)
    }
}

struct Automata {
    // 현재 작업 중인 입력 시퀀스
    var current: [String]
    // 현재 약어 확장 대기 중인 입력 시퀀스
    var pending: [String]
    // 키보드
    var keyboard: Keyboard

    init(kbd: Keyboard) {
        self.current = []
        self.pending = []
        self.keyboard = kbd
    }

    mutating func consume(comp: Composition) {
        for _ in 0..<comp.Size { self.current.removeFirst() }
    }

    mutating func comp(current: [String], nobreak: Bool = false) -> Composition {
        var comp: Composition = Composition()

        for (i, ch) in current.enumerated() {
            if self.keyboard.chosung_proc(comp: &comp, nobreak: nobreak, current: current, i: i) {
                // 입력이 초성
                comp.chosung += ch
            } else if self.keyboard.jungsung_proc(comp: &comp, nobreak: nobreak, current: current, i: i) {
                // 입력이 중성
                comp.jungsung += ch
            } else if self.keyboard.jongsung_proc(comp: &comp, nobreak: nobreak, current: current, i: i) {
                // 입력이 종성
                comp.jongsung += ch
            } else {
                // 이번 글자에 못 넣는 경우
                self.keyboard.fallback_proc(comp: &comp, current: current, i: i)
            }

            // 조합을 종료하면 더이상 진행하지 않음
            if comp.done { break }
        }

        return comp
    }

    mutating func run(nobreak: Bool = false) -> Composition {
        let comp: Composition = self.comp(current: self.current, nobreak: nobreak)

        // 현재까지 조립한 입력을 먹어치운다
        if comp.done {
            self.consume(comp: comp)
        }

        return comp
    }
}

// API
// * 한글 오토마타를 시작
//  * HangulStart(int type)
// * 한글 오토마타를 종료
//  * HangulStop()
// * 한글 낱자를 하나씩 오토마타로 보냄
//  * HangulProcess(ascii)
// * 한글 낱자 단위로 지움
//  * HangulBackspace()
// * 현재 조합 중인 글자를 받음
//  * HangulGetPreedit()
// * 조합 완료된 글자를 받음
//  * HangulGetCommit()
// * 조합을 중지하고 현재 글자를 완료로 표시함
//  * HangulFlush()
// * 백스페이스
//  * HangulBackspace()

class Hangul {
    var automata: Automata?
    var keyboard: Keyboard?
    var committed: [unichar]
    var preediting: [unichar]

    // // 약어 확장 타이머
    // var abbreviationTimer: Timer?

    // 디버그용. Normalization 하지 않은 coposition 정보를 넣는다. 디버그할 때 편하다.
    var debug_commit: [String]
    var debug_preedit: [String]

    init() {
        self.committed = []
        self.preediting = []

        self.debug_commit = []
        self.debug_preedit = []
    }

    func set_commit(comp: Composition) {
        self.committed += self.keyboard!.normalization(comp: comp, is_commit: true)
        let dbg = self.keyboard!.debugout(comp: comp)
        if dbg != "" {
            self.debug_commit.append(dbg)
        }
    }

    func set_preedit(comp: Composition) {
        self.preediting += self.keyboard!.normalization(comp: comp, is_commit: false)
        let dbg = self.keyboard!.debugout(comp: comp)
        if dbg != "" {
            self.debug_preedit.append(dbg)
        }
    }

    func Stop() {
        // // 약어 확장 타이머 정리
        // self.abbreviationTimer?.invalidate()
        // self.abbreviationTimer = nil

        self.keyboard = nil
        self.automata = nil
    }

    func ToggleSuspend() {
        HangulMenu.shared.self_eng_mode = !HangulMenu.shared.self_eng_mode
        if HangulMenu.shared.self_eng_mode {
            PrintLog.shared.Log(log: "영어")
        } else {
            PrintLog.shared.Log(log: "한글")
        }
    }

    /*
     입력기 프론트엔드에 한글 오토마타 엔진이 지원하는 자판 목록과 인스턴스를 전달함
     여기에 자판 객체를 등록하면 나빌입력기 전체에서 다 참조해서 사용함
     */
    static let hangul_keyboard: [Keyboard] = [
        KeyboardSemoi(),
        Keyboard002(),
    ]

    static func Get_keyboard002() -> Keyboard002? {
        return Hangul.hangul_keyboard.last as? Keyboard002
    }

    func Start(type: Int) {
        self.keyboard = Hangul.hangul_keyboard[0]
        for k in Hangul.hangul_keyboard { if k.id == type { self.keyboard = k } }
        self.automata = Automata(kbd: self.keyboard!)
    }

    func Process(ascii: String) -> Bool {
        // 자체 영어 입력 모드 - 한글 오토마타를 잠시 중지하면 그게 영어 입력이다.
        if HangulMenu.shared.self_eng_mode { return false }

        // 한글인지 확인
        if !self.keyboard!.is_hangul(ch: ascii) { return false }

        // 키보드 입력 시간 델타 업데이트
        self.keyboard!.update_input_delta()

        if self.automata!.pending.count > 0 && self.keyboard!.input_delta > self.keyboard!.input_delta_threshold {
            // 약어 대기열이 존재하는데 마지막 입력 이후 느리게 입력한 경우 대기열을 current로 이동
            PrintLog.shared.Log(
                log:
                    "약어 대기열 제거: current \(String(describing: self.automata!.current)) <- pending \(String(describing: self.automata!.pending))"
            )
            self.automata!.current += self.automata!.pending
            self.automata!.pending = []
        }

        if self.automata!.pending.count == 0 {
            // 약어 대기열이 비어있으면 새로운 약어 대기열 시도
            var canStartAbbr = false
            for (abbr, _) in self.keyboard!.abbreviations {
                if abbr.starts(with: ascii) {
                    canStartAbbr = true
                    break
                }
            }
            if canStartAbbr {
                // 새로운 약어 확장 대기열 시작
                self.automata!.pending = [ascii]
                PrintLog.shared.Log(log: "약어 대기열 시작: pending \(String(describing: self.automata!.pending))")
                // 한 글자 약어는 없으므로 확장 시도는 하지 않음
                // 새로운 글자는 약어 확장 대기열에 들어가있는 상태여서 커밋이 새로 생겼을리 없으므로 전부 preedit으로 처리
                var current = self.automata!.current + self.automata!.pending
                var comp: Composition = self.automata!.comp(current: current)
                while comp.done {
                    self.set_preedit(comp: comp)
                    for _ in 0..<comp.Size { current.removeFirst() }
                    comp = self.automata!.comp(current: current)
                }
                self.set_preedit(comp: comp)
                // 약어 계속 입력 중에는 일반 입력 처리 안 함
                return true
            }
            // 약어로 확장될 수 없는 글자이면 일반 입력 처리
        } else {
            // 약어 입력 중이었다면 계속 입력 저장
            self.automata!.pending.append(ascii)
            PrintLog.shared.Log(log: "약어 대기열 계속: pending \(String(describing: self.automata!.pending))")

            var abbrPrefix = false
            repeat {
                var abbr = ""
                let p = self.automata!.pending.joined()
                for (k, v) in self.keyboard!.abbreviations {
                    if k.count < p.count { continue }
                    if k == p {
                        abbr = v
                        break
                    } else if k.starts(with: p) {
                        abbrPrefix = true
                        break
                    }
                }
                if abbr != "" {
                    // 약어 매칭
                    self.automata!.pending = []
                    self.Flush()
                    self.committed += abbr.utf16
                    return true
                } else if !abbrPrefix {
                    // 현재 입력으로 인해 대기열이 약어의 접두사가 아니게 되면 한 글자씩 current로 이동
                    let ch = self.automata!.pending.removeFirst()
                    PrintLog.shared.Log(
                        log: "약어 대기열에서 글자 이동: pending \(String(describing: self.automata!.pending)), removed ch \(ch)")
                    self.automata!.current.append(ch)
                }
                // 약어 확장 대기열이 어떤 약어의 접두사가 되거나 빌 때까지 반복
            } while !abbrPrefix && self.automata!.pending.count > 0

            // 오토마타 돌린다.
            var comp: Composition = self.automata!.run()
            // 조합 완료한 글자가 있다면?
            while comp.done {
                // normalization 해서 commited 에 넣는다.
                self.set_commit(comp: comp)
                // comp.done이 없을 때까지 오토마타를 돌린다.
                comp = self.automata!.run()
            }
            // 조합 완료 안된 낱자 + 남은 약어 확장 대기 문자 preedit 처리
            var current = self.automata!.current + self.automata!.pending
            comp = self.automata!.comp(current: current)
            while comp.done {
                self.set_preedit(comp: comp)
                for _ in 0..<comp.Size { current.removeFirst() }
                comp = self.automata!.comp(current: current)
            }
            self.set_preedit(comp: comp)

            // 약어 계속 입력 중에는 일반 입력 처리 안 함
            return true
        }

        // 일반 입력 처리
        self.automata!.current.append(ascii)

        // 오토마타 돌린다.
        var comp: Composition = self.automata!.run()

        // 조합 완료한 글자가 있다면?
        while comp.done {
            // normalization 해서 commited 에 넣는다.
            self.set_commit(comp: comp)
            // comp.done이 없을 때까지 오토마타를 돌린다.
            comp = self.automata!.run()
        }

        // 조합 완료 안된 낱자는 preediting에 넣는다.
        self.set_preedit(comp: comp)

        return true
    }

    func Backspace() -> Bool {
        // 약어 확장 대기열이 존재하면 대기열에서 하나 삭제하고 나머지 current로 이동
        if self.automata!.pending.count > 0 {
            self.automata!.pending.removeLast()
            self.automata!.current += self.automata!.pending
            self.automata!.pending = []
        }

        if self.automata!.current.count == 0 { return false }
        self.automata!.current.removeLast()
        // 오토마타 돌린다.
        let comp: Composition = self.automata!.run(nobreak: true)
        // 조합 완료 안된 낱자는 preediting에 넣는다.
        self.set_preedit(comp: comp)
        return true
    }

    func Flush() {
        // 약어 확장 대기열이 존재하면 current로 이동
        if self.automata!.pending.count > 0 {
            self.automata!.current += self.automata!.pending
            self.automata!.pending = []
        }

        // 오토마타를 돌리고
        var comp: Composition = self.automata!.run(nobreak: true)
        // 조합 완료한 글자
        while comp.done {
            // normalization 해서 commited 에 넣는다.
            self.set_commit(comp: comp)
            // comp.done이 없을 때까지 오토마타를 돌린다.
            comp = self.automata!.run()
        }
        // 조합 완료 안된 낱자도 commit
        self.set_commit(comp: comp)
        // 입력 버퍼를 비우면 flush!
        self.automata!.current = []
    }

    func Additional(ascii: String) -> String? {
        self.keyboard?.etc_layout[ascii]
    }

    func GetPreedit() -> [unichar] {
        let ret: [unichar] = self.preediting
        self.preediting = []
        return ret
    }

    func GetCommit() -> [unichar] {
        let ret: [unichar] = self.committed
        self.committed = []
        return ret
    }

    func GetDebug(t: String) -> [String] {
        let ret: [String]
        if t == "commit" {
            ret = self.debug_commit
        } else if t == "preedit" {
            ret = self.debug_preedit
        } else {
            ret = []
            self.debug_commit = []
            self.debug_preedit = []
        }
        return ret
    }
}
