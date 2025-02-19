//
//  Hangul.swift
//  automata
//
//  Created by Manwoo Yi on 9/10/22.
//

import Foundation

struct Composition {
    var chosung:String = ""
    var jungsung:String = ""
    var jongsung:String = ""
    var done:Bool = false
    
    var Size:UInt {
        return UInt(self.chosung.count + self.jungsung.count + self.jongsung.count)
    }
}

struct Automata {
    // 현재 작업 중인 입력 시퀀스
    var current:[String]
    // 키보드
    var keyboard:Keyboard
    
    init(kbd:Keyboard) {
        self.current = []
        self.keyboard = kbd
    }
    
    func chosung(comp: inout Composition, ch:String) {
        if comp.chosung == "" {
            // 초성 입력이 처음이면 채움
            comp.chosung = ch
        } else {
            // 초성 입력이 이미 있는데
            if comp.jungsung != "" {
                // 중성도 있으면 조합 종료
                comp.done = true
            } else {
                // 중성은 아직 없음
                if self.keyboard.chosung_proc(comp: &comp, ch: ch) {
                    // 쌍자음이면 채움
                    comp.chosung += ch
                } else {
                    // 쌍자음이 아니면 조합 종료
                    comp.done = true
                }
            }
        }
    }

    func jungsung(comp:inout Composition, ch:String) {
        if comp.jungsung == "" {
            // 중성 입력이 처음이면 채움
            comp.jungsung = ch
        } else {
            // 중성 입력이 이미 있으면 이중 모음인지 확인
            if self.keyboard.jungsung_proc(comp: &comp, ch: ch) {
                // 이중 모음이면 채움
                comp.jungsung += ch
            } else {
                // 이중 모음이 아니면 조합 종료
                comp.done = true
            }
        }
    }

    func jongsung(comp: inout Composition, ch:String) {
        if comp.jongsung == "" {
            // 종성 입력이 처음이면 채움
            comp.jongsung = ch
        } else {
            // 종성 입력이 이미 있으면 겹받침인지 확인
            if self.keyboard.jongsung_proc(comp: &comp, ch: ch) {
                // 겹받침이면 채움
                comp.jongsung += ch
            } else {
                // 겹받침이 아니면 조합 종료
                comp.done = true
            }
        }
    }

    mutating func consume(comp:Composition) {
        for _ in 0..<comp.Size {
            self.current.removeFirst()
        }
    }

    mutating func run() -> Composition{
        var comp:Composition = Composition()
        
        for ch in self.current {
            // 입력이 초성인가?
            if self.keyboard.chosung_proc(comp: &comp, ch: ch) {
                self.chosung(comp: &comp, ch: ch)
            // 입력이 중성인가?
            } else if self.keyboard.jungsung_proc(comp: &comp, ch: ch) {
                self.jungsung(comp: &comp, ch: ch)
            // 입력이 종성인가?
            } else if self.keyboard.jongsung_proc(comp: &comp, ch: ch) {
                self.jongsung(comp:&comp, ch:ch)
            // 허용하는 조합이 아니다. 글자를 완성하고 다음에 조합
            } else {
                comp.done = true
            }
            // 조합을 종료하면 더이상 진행하지 않음
            if comp.done {
                break
            }
        }
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
    var automata:Automata?
    var keyboard:Keyboard?
    var committed:[unichar]
    var preediting:[unichar]
    
    // 디버그용. Normalization 하지 않은 coposition 정보를 넣는다. 디버그할 때 편하다.
    var debug_commit:[String]
    var debug_preedit:[String]
    
    init() {
        self.committed  = []
        self.preediting = []
        
        self.debug_commit  = []
        self.debug_preedit = []
    }

    func set_commit(comp:Composition) {
        if let kbd = self.keyboard {
            self.committed += kbd.normalization(comp: comp, is_commit: true)
            let dbg = kbd.debugout(comp: comp)
            if dbg != "" {
                self.debug_commit.append(dbg)
            }
        }
    }

    func set_preedit(comp:Composition){
        if let kbd = self.keyboard {
            self.preediting += kbd.normalization(comp: comp, is_commit: false)
            let dbg = kbd.debugout(comp: comp)
            if dbg != "" {
                self.debug_preedit.append(dbg)
            }
        }
    }
    
    func Stop() {
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
    static let hangul_keyboard:[Keyboard] = [
        Keyboard318(),
        Keyboard390(),
        Keyboard002()
    ]
    static func Get_keyboard318() -> Keyboard318? {
        return Hangul.hangul_keyboard[0] as? Keyboard318
    }
    static func Get_keyboard318() -> Keyboard390? {
        return Hangul.hangul_keyboard[1] as? Keyboard390
    }
    static func Get_keyboard002() -> Keyboard002? {
        return Hangul.hangul_keyboard[2] as? Keyboard002
    }
    
    func Start(type:Int) {
        // 일치하는 키보드가 없으면 318을 사용한다.
        self.keyboard = Hangul.hangul_keyboard[0]
        
        for k in Hangul.hangul_keyboard {
            if k.id == type {
                self.keyboard = k
            }
        }
        
        self.automata = Automata(kbd: self.keyboard!)
    }

    func Process(ascii:String) -> Bool {
        // 자체 영어 입력 모드 - 한글 오토마타를 잠시 중지하면 그게 영어 입력이다.
        if HangulMenu.shared.self_eng_mode {
            // 잠시 중지면 오토마타를 안돌림
            return false
        }
        
        // 한글인지 확인
        if self.keyboard?.is_hangul(ch: ascii) == false {
            return false
        }
        // 키보드 입력 시간 델타 업데이트
        self.keyboard?.update_key_input_time_delta()
        PrintLog.shared.Log(log: "Key time delta \(String(describing: self.keyboard?.input_delta))")
        
        // 키보드가 눌릴 때 마다 한 글자씩 오토마타로 넣는다.
        self.automata!.current.append(ascii)
        // 오토마타 돌린다.
        var comp:Composition = self.automata!.run()
        // 조합 완료한 글자가 있다면?
        while comp.done {
            // normalization 해서 commited 에 넣는다.
            self.set_commit(comp: comp)
            // comp.done이 없을 때까지  오토마타를 돌린다.
            comp = self.automata!.run()
        }
        // 조합 완료 안된 낱자는 preediting에 넣는다.
        self.set_preedit(comp: comp)
        
        return true
    }
    
    func Additional(ascii:String) -> String? {
        self.keyboard?.etc_layout[ascii]
    }
    
    func Backspace() -> Bool {
        if self.automata!.current.count > 0 {
            self.automata!.current.removeLast();
            // 오토마타 돌린다.
            let comp:Composition = self.automata!.run()
            // 조합 완료 안된 낱자는 preediting에 넣는다.
            self.set_preedit(comp: comp)
            return true
        }
        return false
    }

    func Flush() {
        // 오토마타를 돌리고
        let comp:Composition = self.automata!.run()
        // 완성이됐건 말건 그냥 commit 해 버리고
        self.set_commit(comp: comp)
        // 입력 버퍼를 비우면 flush!
        self.automata!.current = []
    }

    func GetPreedit() -> [unichar] {
        let ret:[unichar] = self.preediting
        self.preediting = []
        return ret
    }

    func GetCommit() -> [unichar] {
        let ret:[unichar] = self.committed
        self.committed = []
        return ret
    }
    
    func GetDebug(t:String) -> [String] {
        let ret:[String]
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
