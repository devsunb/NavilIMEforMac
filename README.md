```
** 주의 **

이 문서의 업데이트는 코드 업데이트보다 느림.
그러므로 최신 코드와 이 문서의 설명이 다를 수 있음.
커밋 히스토리를 추적해서 문서의 내용과 코드의 변경이 어떻게 이뤄졌는지 보는것도 추천함.
```
# 지원하는 한글 자판

* 세별식 318
* 세별식 390
* 두벌식

# 나빌 입력기 for 맥

나는 내가 디자인한 한글 세벌식 자판을 쓰고 있다.

<https://github.com/navilera/318Na_HangulKeyboard>

위 링크에서 관련 정보를 찾을 수 있다. 글자판의 이름은 318Na 자판이다.

![](https://github.com/navilera/318Na_HangulKeyboard/raw/master/3-18Na_layout.png)

위 그림이 318Na 자판의 배치다.

이 자판을 디자인하고 나서 실제로 사용하려고 나는 리눅스와 윈도우에서 직접 입력기를 만들었다. 리눅스에서는 libhangul을 수정하는 것으로 318Na 자판을 쓸 수 있었다.

<https://github.com/navilera/libhangul>

위 링크에서 내가 수정한 libhangul 코드를 볼 수 있다.

윈도우에서는 위 libhangul을 이용해서 입력기를 새로 만들었다.

<https://github.com/navilera/NavilIME>

위 링크에서 내가 만든 윈도용 입력기 코드를 얻을 수 있다. 이름은 나빌입력기이다. 나빌입력기는 지금도 내가 아주 잘 쓰고 있다. 그리고 쓰는 사람이 몇 명 더 있다고 한다. 이 자리를 빌어 감사를 표한다.

그렇게 나는 내가 필요한 환경에서 318Na 자판을 충분히 잘 쓰고 있었다. 나는 맥북 등 액OS 계열 제품을 쓸 생각이 없었기 때문에 리눅스와 윈도우에서 쓰면 충분했다. 그리고 윈도우에서 한글 입력기를 만들면서 충분히 즐거웠다.

## 강제로 맥을 쓰게 되다

회사를 옮겼다. 이직한 회사에서는 업무용 랩탑으로 맥북만 쓸 수 있다. 다른 선택은 없었다. 회사에서 일하면서 한글을 쓸 일은 그리 많지 않다. 그래도 업무상 채팅 등
으로 종종 한글을 쓸 일이 생겼다. 어쩔 수 없이 맥에서는 두벌식을 쓰는데 더이상 견딜 수가 없었다.

맥에서 318Na를 쓸 수 있는 입력기를 만들어야 겠다고 결심했다.

## 구름 입력기를 고려해보다

맥에서 기본 한글 입력기를 제외하고 가장 많이 사용하는 입력기는 구름 입력기다. 그리고 구름 입력기는 libhangul을 사용한다. 그래서 나는 내가 리눅스와 윈도우에서 사용하는 libhangul을 쓰기만 하면 구름 입력기를 이용해서 318Na 자판을 쓸 수 있을 줄 알았다.

나는 libhangul 라이브러리의 구조를 알고 있다. 그래서 구름 입력기도 리눅스에 ibus처럼 libhangul로부터 자판 정보를 받아서 여러 한글 자판을 지원하는 줄 알았다. 구름 입력기 소스 코드를 분석해 보니 여러 한글 자판을 별도로 등록해야 하고 자판 하나당 변경 혹은 추가해야 하는 코드가 여러 군데에 있었다. 그냥 318Na 자판을 추가하려고 시도하면 분명 필요한 코드를 빼먹을 것 같았다. 잘 찾아보고 하나씩 넣어 보면서 시도하면 될 것도 같았다. 그런데 그냥 하기 싫었다.

물론 이후 나빌 입력기를 구현하는데 있어서 구름 입력기의 소스 코드를 많이 참고했다.

## 그냥 내가 하나 만들까

이왕 이렇게 된거. 구름 입력기 활용하기엔 공부해야 할 것이 너무 많고.. 무엇보다 구름 입력기를 한 번에 빌드하지 못 했다. 빌드를 하려면 뭔가 추가적인 작업을 더 해야 했다. 그래서 그냥 내가 직접 새로 만들기로 마음을 정했다.

컨셉은 명확했다. 순수 swift로 만들 것. 318Na 자판을 지원할 것. 단순할 것.

무엇보다 아마도 어차피 나만 쓸 것이기 때문에 다른 자판은 고려 대상이 아니었다. 그래서 libhangul 말고 오토마타도 내가 직접 구현하기로 결정했다.

# 나빌 입력기 for 맥

완성한 나빌 입력기는 순수 swift로만 구현했다. 전체 코드는 오토마타를 포함해서 1000줄 정도다. 공백을 포함한 코드 라인 수니까 순수 코드는 몇 백 줄일 것이다. 모든 목적을 달성했다. 무엇보다 코드가 아주 간단하다는 것이 마음에 든다.

코드 줄 수가 적으므로 이 글에서 나빌 입력기 코드를 한 줄 씩 설명하려고 한다.

나는 나빌 입력기를 오토마타와 입력기 두 부분으로 구성했다.

## 오토마타

오토마타를 만들면서 잠재적으로 예상되는 범용적 상황을 고려하긴 했다. 그러나 현 시점에서 나빌 입력기의 오토마타는 318Na 자판만 구현했다. 별 어려움 없이 한글 두벌식이나 다른 여러 세벌식 자판을 추가할 수 있을 것이라 생각한다.

오토마타는 다음 파일 네 개로 구현했다.

* Hangul.swift
* Keyboards.swift
* Keyboard318.swift
* Testcases.swift

실제 오토마타 엔진에 대한 구현은 Hangul, Keyboards, Keyboard318 이렇게 세 파일이다. Testcases.swift 파일은 오토마타 기능을 검증하는 테스트 케이스들이 들어 있다. 

이제부터 오토마타 구현 소스를 한 줄씩 모두 설명하겠다.

### Hangul.swift

오토마타 코어 구현이다. 실질적인 오토마타 상태 머신 (state machine) 구현이 있는 파일이다.

#### Composition

```
struct Composition {
    var chosung:String = ""
    var jungsung:String = ""
    var jongsung:String = ""
    var done:Bool = false
    
    var Size:UInt {
        return UInt(self.chosung.count + self.jungsung.count + self.jongsung.count)
    }
}
```

구조체 이름이 컴포지션이다. 컴포지션을 영어 사전에서 찾으면 이런 뜻이다.

> 명사) 조립, 구성, 합성

한글은 초성, 중성, 종성을 조립하여 한 글자를 만든다. 그래서 Composition 구조체는 한글 한 글자를 구성하는 정보를 가진다.

* chosung : 한글 초성
* jungsung : 한글 중성
* jongsung : 한글 종성
* done : 조합 완료 표시
* Size : 컴포지션 구조체 크기

각 멤버 변수의 의미는 위와 같다. 각 멤버 변수를 어떻게 활용하는지는 이어질 코드를 보면 알게 된다.

#### Automata

오토마타 클래스는 말 그대로 오토마타 구현이 있다. 사실 한글 오토마타는 자판(두벌식, 세벌식 등) 마다 다르므로 자판에서 상당 부분 처리해야 한다. 그런데 생각해보면 가장 근본적인 한글 오토마타는 그대로 있고 자판에서는 오토마타에 전달해주는 입력을 결정한다. 따라서 오토마타는 한글 자판에서 명확하게 초성, 중성, 종성을 구분해서 넘겨준다는 가정을 하고 동작한다.

```
struct Automata {
    // 현재 작업 중인 입력 시퀀스
    var current:[String]
    // 키보드
    var keyboard:Keyboard
    
    init(kbd:Keyboard) {
        self.current = []
        self.keyboard = kbd
    }
```

스위프트에서 구조체(struct)와 클래스(class)는 상속 가능 유무 외에는 거의 차이가 없다. 더 파고들면 다른 큰차이가 있겠지만 나빌 입력기를 구현하고 코드를 이해하는 수준에서는 상속할 필요가 있으면 클래스, 상속할 필요가 없으면 구조체다.

나는 Automata를 구조체로 선언했다. 왜냐면 Automata 클래스는 다른 클래스가 상속하지 않기 때문이다. 구조체를 클래스로 바꿔도 동작은 동일하다. 이글에서는 더이상 구조체와 클래스는 구분하지 않고 그냥 클래스라고 부르겠다.

오토마타 클래스의 시작 부분은 위 코드와 같다. 클래스 변수는 아래 두 개다.

* current
* keyboard

current 변수는 오토마타가 처리해야 하는 입력이다. 한글 한 글자는 키보드에서 최소 입력 두 개에서 최대 입력 여섯 개 까지 필요하다. 그래서 키보드 입력을 아스키 코드(ascii)의 배열로 저장한다. 그러므로 나빌 입력기의 오토마타는 한 문장으로 다음과 같다.

> 아스키 코드의 배열을 유니코드 한글로 변환하는 변환기

keyboard 변수는 오토마타에 한글 자모를 전달하는 키보드다. 현 시점에서는 318Na 자판만 있다. 추후에 내가 기분이 좋거나 할 일이 없거나 정말 누군가 거절할 수 없는 제안을 하거나 다른 사람이 만들어 준다면 다른 자판 구현체가 이 keyboard 변수에 인스턴스로 들어갈 수 있다.

그 아래 init() 함수는 스위프트의 클래스 생성자다. 생성자이므로 클래스 변수를 초기화한다. current 변수는 빈 배열이다. keyboard 변수에는 생성자의 파라메터로 받은 자판 인스턴스를 넣는다.

```
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
                if self.keyboard.chosung_proc(comp: comp, ch: ch) {
                    // 쌍자음이면 채움
                    comp.chosung += ch
                } else {
                    // 쌍자음이 아니면 조합 종료
                    comp.done = true
                }
            }
        }
    }
```

chosung() 클래스 함수는 사용자가 초성을 입력했을 때 동작을 구현한다. 주석을 잘 써 놨으므로 주석만 봐도 코드 진행을 이해하는데 무리가 없을 것이다. 그래도 설명은 하겠다.

그냥 화면에서 한글이 조합되는 모습을 생각하면 된다. 보통은 초성을 먼저 입력한다. 모아치기를 지원하면 중성을 먼저 입력하는 것도 가능하다. 어느쪽이든 컴포지션에 초성이 없으면 초성을 채워주면 된다.

그럼 나머지는 초성이 이미 있는 상태에서 초성이 또 들어온 경우만 처리해주면 된다. 이 때도 두 가지 경우를 생각할 수 있다. 중성이 있는 경우와 중성이 없는 경우다. 중성이 있는 경우는 초성 + 중성이 완료된 상황이므로 이 시점에 초성이 또 들어온다는 것은 초성 + 중성인 글자는 조합을 완료하는 것이다.

> 도ᄂ

위와 같은 상황이다. 위 상황에서 앞 글자 '도'는 초성 + 중성이 이미 있다. 이 상태에서 기대하는 입력은 이중 모음을 만드는 중성이거나 종성인데 초성이 들어왔으면 '도'는 조합을 완료하고 초성 'ᄂ'을 조합 중인 상태로 해야한다. 그래서 초성 + 중성 상태에서 중성이 또 들어오면 comp.done = true로 하고 조합을 종료한다.

중성이 없는 상태에서 초성 + 초성에서 기대하는 입력은 쌍자음 뿐이다. 그래서 키보드에게 해당하는 초성 쌍자음이 있는지 검색을 요청한다. 키보드가 쌍자음이 있다고 응답하면 컴포지션 초성에 쌍자음에 해당하는 입력을 넣는다. 키보드에 해당 입력이 쌍자음으로 없으면 조합을 종료한다.

위 과정은 키보드 자판이 무엇이건간에 한글을 조합하는 기본적인 알고리즘이다. 그러므로 위 동작에서 매끄럽게 동작하는 키보드 클래스만 작성하면 아마도 나빌 입력기에서 여러 자판을 사용할 수 있을 것이다.

```
    func jungsung(comp:inout Composition, ch:String) {
        if comp.jungsung == "" {
            // 중성 입력이 처음이면 채움
            comp.jungsung = ch
        } else {
            // 중성 입력이 이미 있으면 이중 모음인지 확인
            if self.keyboard.jungsung_proc(comp: comp, ch: ch) {
                // 이중 모음이면 채움
                comp.jungsung += ch
            } else {
                // 이중 모음이 아니면 조합 종료
                comp.done = true
            }
        }
    }
```

중성에 대한 오토마타 처리도 초성과 비슷하다. 컴포지션에 중성이 없으면 처음 입력하는 중성이니까 당연히 컴포지션에 중성을 채운다. 중성이 이미 있는 상태에서 중성이 또 들어온 경우에 기대하는 입력은 이중 모음이므로 입력이 이중 모음인지 키보드에 검색을 요청한다. 키보드에서 이중 모음이 있다고 리턴하면 컴포지션에 이중 모음을 채운다. 키보드에서 이중 모음이 없다고 하면 조합을 종료한다.

```
    func jongsung(comp: inout Composition, ch:String) {
        if comp.jongsung == "" {
            // 종성 입력이 처음이면 채움
            comp.jongsung = ch
        } else {
            // 종성 입력이 이미 있으면 겹받침인지 확인
            if self.keyboard.jongsung_proc(comp: comp, ch: ch) {
                // 겹받침이면 채움
                comp.jongsung += ch
            } else {
                // 겹받침이 아니면 조합 종료
                comp.done = true
            }
        }
    }
```

종성에 대한 오토마타 처리도 초성, 중성과 비슷하다. 컴포지션에 종성이 없으면 처음 입력하는 종성이니까 당연히 컴포지션에 종성을 채운다. 종성이 이미 있는 상태에서 종성이 또 들어온 경우에 기대하는 입력은 겹받침 종성이므로 입력이 겹받침인지 키보드에 검색을 요청한다. 키보드에서 겹받침이 있다고 리턴하면 컴포지션에 겹받침을 채운다. 키보드에서 겹받침이 없다고 하면 조합을 종료한다.

```
    mutating func consume(comp:Composition) {
        for _ in 0..<comp.Size {
            self.current.removeFirst()
        }
    }

    mutating func run() -> Composition{
        var comp:Composition = Composition()
        for ch in self.current {
            // 입력이 초성인가?
            if self.keyboard.chosung_proc(comp: comp, ch: ch) {
                self.chosung(comp: &comp, ch: ch)
            // 입력이 중성인가?
            } else if self.keyboard.jungsung_proc(comp: comp, ch: ch) {
                self.jungsung(comp: &comp, ch: ch)
            // 입력이 종성인가?
            } else if self.keyboard.jongsung_proc(comp: comp, ch: ch) {
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
```

consume() 함수와 run() 함수는 같이 본다. run() 함수는 오토마타를 돌리는 함수다. run() 함수가 호출될 때 마다 컴포지션을 새로 선언한다. 그 말은 오토마타 실행의 결과가 컴포지션이라는 것이다. 오토마타의 입력은 클래스 변수인 current다.

current 클래스 변수에 있는 아스키 값을 하나씩 읽어서 이 아스키 값에 할당된 초성, 중성, 종성이 있는지 키보드에 조회를 요청한다. 그래서 초성이면 앞에서 설명했던 chosung() 함수를 호출한다. 중성이면 jungsung() 함수를 호출한다. 종성이면 jongsung() 함수를 호출한다. 만약 입력이 키보드에 없으면 즉시 조합을 종료한다.

current에 입력이 남아 있어도 초성, 중성, 종성 처리 중에 컴포지션 조합을 완료하면 즉시 종료하고 for 루프를 빠져나간다. 그러면 current에는 입력이 남아 있고 컴포지션은 조합을 완료했으므로 current에서 조합을 완료한 만큼 제거한다. 그 함수가 consume() 함수다.

#### Hangule

한글 클래스는 외부로 노출되는 클래스다. 입력기 프론트 엔드는 이 한글 클래스만 사용한다.

> 입력기 -> 한글 클래스 -> 오토마타 클래스 -> 키보드 클래스

대충 이런 구조다.

```
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
```

한글 클래스에는 클래스 변수가 6개다. 4개는 구현에 필요한 변수고 2개는 디버그용 변수다.

* automata : 오토마타 클래스 인스턴스
* keyboard : 키보드 클래스 인스턴스
* committed : 조합 완료해서 커밋 대기 중인 한글 리스트
* preediting : 조합 하고 있는 한글 리스트
* debug_commit : 디버그용 커밋 리스트
* debug_preedit : 디버그용 프리에딧 리스트

용어를 정리하자. 화면에서 한글이 입력되는 모습을 보면 두 부분으로 나누어진다. 대한민국을 입력하는 장면을 상상해보자.

```
대한|
 --
   
대한민|
   _
       
대한민국|
    --
```

대한민국 글자 아래에 --는 커서다. '대'를 입력하고 '한'을 입력하려고 하면 '한' 밑에 커서가 있거나 '한'이라는 글자가 블럭 안에 들어가 있다. 이 상태에서 '대'는 커밋된 글자이고 '한'은 프리에딧 중인 글자다. 그리고 '민'을 입력하면 '한'은 프리에딧이다가 커밋되고 '민'이 프리에딧 상태다. 이어서 '국'을 입력하면 '민'이 커밋되고 '국'이 프리에딧 상태다. 여기서 다른 한글을 입력하거나 한글이 아닌 글자를 입력하면 '국'도 커밋된다.

이렇게 한글 입력은 프리에딧 상태에서 커밋으로 바뀌면서 앞으로 진행한다. 커밋된 글자는 바꿀 수 없고 프리에딧 상태의 글자는 계속 바뀐다. 예를 들어 '한'을 입력하면 프리에딧 상태에서는 글자 모양이 아래처럼 바뀐다. 커서는 이동하지 않고 제자리에서 글자가 바뀐다.

> ᄒ -> 하 -> 한

글자가 커밋되어야만 커서가 앞으로 한 칸 간다.

이제 커밋과 프리에딧이 무엇인지 알았으리라 생각한다. 코드를 계속 이어서 보자.

```
    func set_commit(comp:Composition) {
        if let kbd = self.keyboard {
            self.committed += kbd.normalization(comp: comp)
            let dbg = kbd.debugout(comp: comp)
            if dbg != "" {
                self.debug_commit.append(dbg)
            }
        }
    }
```

set_commit() 클래스 함수는 컴포지션의 초성, 중성, 종성 정보를 한글 유니코드로 변환해서 커밋 리스트에 추가한다. 디버깅 할 때 쓰려고 디버깅용 커밋 정보도 debug_commit에 추가한다.

나는 커밋 정보를 리스트로 해야할 필요가 있는지 아직 의문이다. 보통 커밋은 프리에딧 직전에 글자 한 개이기 때문이다. 하지만 이것은 318Na 자판일 때 그런것이고 다른 세벌식 자판이나 두벌식 자판에서는 커밋에 두 글자 이상이 들어가는 경우도 있을지도 모르겠다. 그래서 이 부분은 libhangul의 설계를 그대로 따랐다. libhangul에서도 커밋 리스트는 배열로 리턴한다.

컴포지션의 초성, 중성, 종성 정보를 한글 유니코드로 변환하는 책임은 키보드 베이스 클래스에 있다. 위 코드에 kbd.normalization() 함수를 호출하는 코드가 키보드에 유니코드 변환을 요청하는 것이다.

```
    func set_preedit(comp:Composition){
        if let kbd = self.keyboard {
            self.preediting += kbd.normalization(comp: comp)
            let dbg = kbd.debugout(comp: comp)
            if dbg != "" {
                self.debug_preedit.append(dbg)
            }
        }
    }
```

프리에딧 중인 한글 한 글자를 프리에딧 리스트에 넣는 함수다. 기본 구성 자체는 커밋 글자를 얻는 함수와 같다.

```
    func Stop() {
        self.keyboard = nil
        self.automata = nil
    }
    
    func Start(type:String) {
        if type == "318" {
            self.keyboard = Keyboard318()
        } else {
            // 일치하는 키보드가 없으면 318을 사용한다.
            self.keyboard = Keyboard318()
        }
        self.automata = Automata(kbd: self.keyboard!)
    }
```

Stop() 함수는 오토마타를 종료하는 함수다. Start() 함수는 오토마타를 시작하는 함수다. 사실 Start() 함수의 기능은 생성자에 넣어도 된다. 맥의 입력기 프레임워크는 입력기가 클라이언트에 붙었다 떨어질 때마다 activateServer(), deactivateServer()라는 인터페이스 함수를 호출한다. 이때 변환기 (나빌 입력기에서는 오토마타)의 인스턴스를 해제하고 새로 할당하라는게 애플의 가이드다. 그래서 형식적으로나마 가이드를 따르려고 Stop()과 Start()를 만들었다.

```
    func Process(ascii:String) -> Bool {
        if self.keyboard?.is_hangul(ch: ascii) == false {
            return false
        }
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
```

프로세스 함수는 입력기 프론트 엔드에서 한글 입력에 대해 실질적인 변환 처리를 요청하는 함수다. 그래서 오토마타의 run() 함수를 이 프로세스 함수에서 호출한다. 오토마타의 run() 함수를 호출하는 것이 프로세스 함수의 핵심 역할이다.

프로세스 함수의 초입에서 입력이 키보드에 매핑 정보로 있는지 확인한다. is_hangul() 함수가 그것이다. 이 함수에서 true를 리턴받아야 키보드에서 매핑 가능한 입력이다. 아니면 키보드에서 매핑할 수 없으므로 오토마타로 변환할 수도 없다. 그러므로 이후 동작을 할 필요가 없다. 따라서 바로 리턴한다. 프로세스 함수가 false를 리턴한다는 것은 입력을 한글로 변환하지 않았다는 뜻이다. 리턴값을 보고 입력기 프론트 엔드에서 적절히 처리하면 된다.

역시 주석을 잘 달아놨으므로 주석만 봐도 코드를 이해하는데 어려움은 없을 것이다. 그래도 설명한다. 사용자의 입력은 아스키 코드 형태로 오토마타 클래스의 current 변수에 리스트 아이템으로 저장된다. 그리고 오토마타의 run()을 돌리면 한글 조립(조합) 여부에 따라 적절히 컴포지션을 채우고 current의 아스키 값을 삭제한다. current 리스트의 값을 어떻게 처리하는지에 따라서 조립을 완료한 글자는 한 개 이상 나올 수 있으므로 (앞에서도 언급했지만 318Na 자판에서는 생기지 않는 상황이다.) while 루프로 커밋 글자 리스트를 오토마타에서 조립 완료한 컴포지션이 나오지 않을 때까지 계속 채운다. 보통은 한 번이다. 마지막에 나오는 컴포지션은 조립을 완료하지 못한 컴포지션이므로 당연히 프리에딧이다.

```
    func Backspace() -> Bool {
        if self.automata!.current.count > 0 {
            self.automata!.current.removeLast();
            if self.automata!.current.count > 0 {
                // 오토마타 돌린다.
                let comp:Composition = self.automata!.run()
                // 조합 완료 안된 낱자는 preediting에 넣는다.
                self.set_preedit(comp: comp)
                return true
            }
        }
        return false
    }
```

한글 입력기에서 백스페이스 처리는 취향의 영역이다. 백스페이스를 눌렀을 때 그냥 한 글자를 바로 지워 버리는 것을 좋아하는 사람이 있는가 하면 어떤 사람은 프리에딧 상태에 글자는 자모 단위로 지우는 것을 좋아하는 사람도 있다. 예를 들면 이런것이다. 

> 대한 -> (백스페이스 입력) -> 대

이렇게 바로 한 글자를 지우는 경우와

> 대한 -> (백스페이스 입력) -> 대하 -> (백스페이스 입력) -> 대ᄒ -> (백스페이스 입력) -> 대

이렇게 자모 단위로 지우는 경우를 말한다. 나는 자모 단위로 지우는 것을 더 좋아한다. 글자를 바로 지우는 것은 딱히 입력기가 별도 처리를 하지 않아도 된다. 자모 단위로 지우려면 입력기가 처리해야 한다. 그래서 오토마타에도 백스페이스 입력에 따라 글자 조합을 뒤로 돌리는 작업을 해야 한다. 위 백스페이스 함수가 그 역할을 한다.

오토마타 클래스의 current 변수는 현재 입력을 가지고 있다고 했다. 그리고 백스페이스가 입력되는 상황에서 current 변수는 프리에딧 상태에 해당하는 입력만 가지고 있어야 한다. 알고리즘상 그러해야 한다. 그래서 current 변수의 아이템을 하나씩 최근 입력부터 삭제한다. removeLast()를 호출하면 스위프트 배열에 마지막 인덱스 아이템을 삭제한다. 다시 말해 최근 입력을 삭제하는 것이다.

배열 아이템을 계속 삭제하다보면 모든 입력을 다 삭제하게 된다. 이때부터는 입력기가 할 수 있는 일이 없다. 그러므로 꼭 current 변수의 배열 아이템 개수를 확인해야 한다. 개수가 0이면 더이상 입력이 없다는 뜻이므로 false를 리턴한다. 입력기 프론트 엔드가 받아서 적절히 처리한다.

current 변수에서 아이템을 하나 삭제하고 나면 화면에 보이는 글자도 자모를 하나 없애야 한다. 그러므로 오토마타 클래스의 run()을 호출해서 아이템이 삭제된 current를 기반으로 오토마타를 한 번 돌린다. 그리고 리턴으로 받은 컴포지션은 프리에딧이어야 하므로 프리에딧 리스트에 추가한다.

```
    func Flush() {
        // 오토마타를 돌리고
        let comp:Composition = self.automata!.run()
        // 완성이됐건 말건 그냥 commit 해 버리고
        self.set_commit(comp: comp)
        // 입력 버퍼를 비우면 flush!
        self.automata!.current = []
    }
```

입력기의 동작에 한글 조합을 중지하고 현재 프리에딧 상태의 글자를 바로 커밋해야 하는 상황이 꽤 많이 있다. 그런 상황에 호출하는 함수가 플러시 함수다. 그냥 오토마타 돌려서 리턴 받은 컴포지션은 모두 커밋해 버리고 current를 비우면 된다. 지금 보니 여기 코드도 while을 돌려야 하는것 아닌가 싶은데 318Na에서는 아무 문제 없기에 그냥 둔다. 나중에 다른 자판을 추가했을 때 문제가 생기면 그 때 고쳐야지.

```
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
```

커밋 리스트와 프리에딧 리스트는 입력기 프론트 엔드가 가져가면 바로 비워야 한다. 비우는 작업을 외부에서 하지 않으려면 복사해서 리턴하고 클래스 변수는 초기화해야 한다. 그래서 따로 리턴하는 함수를 두 개 만들었다.

```
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
```

디버그 커밋과 프리에딧 정보를 받는 함수다. 각각 만들기 귀찮아서 그냥 함수 한 개로 만들고 파라메터 받아서 커밋과 프리에딧을 구분해서 받는다. 딱히 특별한 내용은 없다.

### Keyboards.swift

키보드 파일에는 한글 자판을 정의하는 베이스 클래스와 한글 자모에 대한 정보가 있다.

#### Chosung

한글 초성 자모 유니코드 값을 정의하는 enum 선언이다. 매우 길기 때문에 윗 부분만 잘라내어 인용하겠다.

```
enum Chosung:unichar {
    // 현대 한글 초성
    case Giyuk       = 0x1100 //ᄀ
    case SsGiyuk     = 0x1101 //ᄁ
    case Nien        = 0x1102 //ᄂ
    case Digek       = 0x1103 //ᄃ
    case SsDigek     = 0x1104 //ᄄ
    case Riel        = 0x1105 //ᄅ
    case Miem        = 0x1106 //ᄆ
    case Biep        = 0x1107 //ᄇ
    case SsBiep      = 0x1108 //ᄈ
    case Siot        = 0x1109 //ᄉ
    case SsSiot      = 0x110a //ᄊ
    case Yieng       = 0x110b //ᄋ
    case Jiek        = 0x110c //ᄌ
    case SsJiek      = 0x110d //ᄍ
    case Chiek       = 0x110e //ᄎ
    case Kiyuk       = 0x110f //ᄏ
    case Tigek       = 0x1110 //ᄐ
    case Piep        = 0x1111 //ᄑ
    case Hiek        = 0x1112 //ᄒ
    // 여기부터 옛 한글 초성
    case YetNG       = 0x1113 //ᄓ
    case YetNN       = 0x1114 //ᄔ
    
    :
    :
    (후략) 밑으로 옛 한글 초성이 엄청 많음
```

유니코드에는 한글 정보가 크게 세 부분으로 되어 있다. 한글 자모 영역과 한글 호환 자모 영역 그리고 전체 한글 조합 영역이다. 맥OS는 NFD라는 방식으로 한글 유니코드를 처리한다. NFD 방식에서는 한글 자모 영역 유니코드로 한글 한 글자를 표현한다. 유니코드와 NFD에 대한 내용은 구글 검색하면 좋은 문서들이 많이 나온다. 이 글에서 설명하진 않겠다.

<https://d2.naver.com/helloworld/76650?source=post_page--------------------------->

위 링크 글이 관련 내용을 잘 설명하고 있다. 궁금한 사람은 방문해서 읽어보자.

내가 알기로 스위프트는 언어의 식별자(identifier)로 utf-8 인코딩을 사용하기 때문에 한글 식별자도 사용가능하다고 한다. 그래서 저 코드를 작성할 때 한글로 식별자를 쓸까 하다가 말았다. 나중에 해 봐야겠다.

#### Jungsung

한글 중성 자모에 대한 enum 타입 선언이다.

```
enum Jungsung:unichar {
    case Filler     = 0x1160 //
    // 현대 한글 중성ᅠ
    case A          = 0x1161 // ᅡ
    case Ae         = 0x1162 // ᅢ
    case Ya         = 0x1163 // ᅣ
    case Yae        = 0x1164 // ᅤ
    case Eo         = 0x1165 // ᅥ
    case E          = 0x1166 // ᅦ
    case Yeo        = 0x1167 // ᅧ
    case Ye         = 0x1168 // ᅨ
    case O          = 0x1169 // ᅩ
    case Wa         = 0x116a // ᅪ
    case Wae        = 0x116b // ᅫ
    case Oe         = 0x116c // ᅬ
    case Yo         = 0x116d // ᅭ
    case U          = 0x116e // ᅮ
    case Weo        = 0x116f // ᅯ
    case We         = 0x1170 // ᅰ
    case Wi         = 0x1171 // ᅱ
    case Yu         = 0x1172 // ᅲ
    case Eu         = 0x1173 // ᅳ
    case Yi         = 0x1174 // ᅴ
    case I          = 0x1175 // ᅵ
    // 옛 한글 중성
    case YetAo      = 0x1176 // ᅶ
    case YetAu      = 0x1177 // ᅷ
    case YetYao     = 0x1178 // ᅸ
    
    :
    :
    (후략)
```
 
쓸일은 없을지라도 유니코드에 있는 옛 한글 자모까지 모두 선언해 놨다. 옛 한글 자판을 추가할 수 있는 가능성을 열어 두기 위함이다.

#### Jongsung

한글 종성 자모에 대한 enum 선언이다. 마찬가지로 옛 한글 종성 자모도 선언했다.

```
enum Jongsung:unichar {
    // 현대 한글 종성
    case Kiyeok               = 0x11a8 // ᆨ
    case Ssangkiyeok          = 0x11a9 // ᆩ
    case Kiyeoksios           = 0x11aa // ᆪ
    case Nieun                = 0x11ab // ᆫ
    case Nieuncieuc           = 0x11ac // ᆬ
    case Nieunhieuh           = 0x11ad // ᆭ
    case Tikeut               = 0x11ae // ᆮ
    case Rieul                = 0x11af // ᆯ
    case Rieulkiyeok          = 0x11b0 // ᆰ
    case Rieulmieum           = 0x11b1 // ᆱ
    case Rieulpieup           = 0x11b2 // ᆲ
    case Rieulsios            = 0x11b3 // ᆳ
    case Rieulthieuth         = 0x11b4 // ᆴ
    case Rieulphieuph         = 0x11b5 // ᆵ
    case Rieulhieuh           = 0x11b6 // ᆶ
    case Mieum                = 0x11b7 // ᆷ
    case Pieup                = 0x11b8 // ᆸ
    case Pieupsios            = 0x11b9 // ᆹ
    case Sios                 = 0x11ba // ᆺ
    case Ssangsios            = 0x11bb // ᆻ
    case Ieung                = 0x11bc // ᆼ
    case Cieuc                = 0x11bd // ᆽ
    case Chieuch              = 0x11be // ᆾ
    case Khieukh              = 0x11bf // ᆿ
    case Thieuth              = 0x11c0 // ᇀ
    case Phieuph              = 0x11c1 // ᇁ
    case Hieuh                = 0x11c2 // ᇂ
    // 옛 한글 종성
    case YetKiyeokrieul       = 0x11c3 // ᇃ
    case YetKiyeoksioskiyeok  = 0x11c4 // ᇄ
    :
    :
    (후략)
```

종성은 겹받침 때문에 옛 한글이 정말 많다. 훈민정음 시절엔 이걸 정말 다 썼나 하는 생각이 든다. 아니면 그냥 조합 가능한 낱자를 모두 만들어 놓기는 하되 실제로 훈민정음 시절에도 사용은 안하지 않았을까 싶다. 

### NormType

정규화 타입을 선언하는 enum이다.

```
enum NormType {
    case NFC
    case NFD
}
```

앞서 언급했던 NFC와 NFD 타입의 정규화를 구분하려고 선언했다.

#### Keyboard

키보드 클래스는 사용자가 정의해서 추가할 수 있는 한글 자판을 만들 때 꼭 상속해야만 하는 베이스 클래스다. 키보드 처리에 대한 공통 구현이 들어 있다.

```
class Keyboard {
    var chosung_layout:[String:Chosung]
    var jungsung_layout:[String:Jungsung]
    var jongsung_layout:[String:Jongsung]
    
    var normalization_type:NormType = NormType.NFD
    
    init() {
        self.chosung_layout = [:]
        self.jungsung_layout = [:]
        self.jongsung_layout = [:]
    }
```

키보드 클래스에 변수는 초성 레이아웃, 중성 레이아웃, 종성 레이아웃이다. 각각 사용자 정의 키보드에 초성, 중성, 종성에 대한 키 맵핑 정보를 담고 있다. 베이스 클래스인 키보드 클래스에서는 정의하지 않고 상속 받는 클래스에서 키 맵핑을 정의한다. 그래서 생성자에서 초성, 중성, 종성 레이아웃을 정의하지 않고 그냥 초기화만 한다.

정규화 타입의 기본값은 NFD이다.

```
    func chosung_proc(comp:Composition, ch:String) -> Bool {
        self.chosung_layout[ch] != nil ? true : false
    }
    
    func jungsung_proc(comp:Composition, ch:String) -> Bool {
        self.jungsung_layout[ch] != nil ? true : false
    }
    
    func jongsung_proc(comp:Composition, ch:String) -> Bool {
        self.jongsung_layout[ch] != nil ? true : false
    }
```

아까 오토마타 코드에서 오토마타가 키보드에 키 매핑 존재 유무를 물어볼 때 호출했던 함수들이다. 기본 구현은 그냥 초성, 중성, 종성 키 매핑 테이블에 매핑 정보가 있는지 물어보는 것이다. 이 세 함수는 상속받는 클래스에서 반드시 오버라이드 해야 한다.

```
    func is_hangul(ch:String) -> Bool {
        // chosung_proc(),jungsung_proc(), jongsung_proc()은 override 가능하기 때문에
        // 초중종성 키매핑 레이아웃에서 직접 검색한다.
        let is_cho = self.chosung_layout[ch] != nil ? true : false
        let is_jung = self.jungsung_layout[ch] != nil ? true : false
        let is_jong = self.jongsung_layout[ch] != nil ? true : false
        return (is_cho || is_jung || is_jong)
    }
```
                     
사용자 입력이 한글 자판에서 매핑으로 처리하는지 여부를 뭍는 함수다. 현재까지 구현으로 봐서는 코드 중복을 피해서 chosung_proc(),jungsung_proc(), jongsung_proc() 함수를 재활용하는 것이 맞지만 사용자가 오버라이드해서 재정의한 함수 형태가 어떤 모습일지 알 수 없기 때문에 초성, 중성, 종성 맵핑 테이블에서 직접 검사한 결과를 리턴한다. 

```
    func debugout(comp:Composition) -> String {
        if comp.Size != 0 {
            let ch:String = comp.chosung != "" ? comp.chosung : "X"
            let ju:String = comp.jungsung != "" ? comp.jungsung : "X"
            let jo:String = comp.jongsung != "" ? comp.jongsung : "X"
            
            return ch + ju + jo
        }
        return ""
    }
```

디버깅 할 때는 정규화 대신 간단하게 사용자 입력 아스키 값의 순서만 검사한다. 매핑 테이블을 통해서 아스키 값을 유니코드 자모 값으로 바꾸는 작업은 1:1 변환이므로 디버깅 과정에서 입력 아스키 값의 순서만 보는 것으로도 충분히 검증이 가능하다. 그래서 초성, 중성, 종성 입력이 없을 때는 구분을 쉽게 하고 비교문 코드를 간단하게 작성할 수 있도록 "X"를 내보낸다.

```
    func norm_nfd(comp:Composition) -> [unichar] {
        var mac_nfd:[unichar] = []
        
        if comp.Size == 0 {
            return mac_nfd
        }
        
        // 맥 기본앱인 메모(Memo) 앱은 중성이 혼자 있고 조합 중인 상황에서 무조건 앞에 한글자를 잡아서 초성으로 간주한다.
        // 그래서 초성만 filler를 넣어준다. 다른 앱에서도 적당히 괜찮게 동작한다.
        
        // 초성
        if let chosung_unicode = self.chosung_layout[comp.chosung] {
            mac_nfd.append(chosung_unicode.rawValue)
        } else {
            mac_nfd.append(Chosung.Filler.rawValue)
        }
        
        // 중성
        if let jungsung_unicode = self.jungsung_layout[comp.jungsung]{
            mac_nfd.append(jungsung_unicode.rawValue)
        }
        
        // 종성
        if let jongsung_unicode = self.jongsung_layout[comp.jongsung] {
            mac_nfd.append(jongsung_unicode.rawValue)
        }
        
        return mac_nfd
    }
```

NFD 형태로 정규화를 수행하는 함수다. 표현은 그럴듯 하게 말했지만 실제 내용은 그냥 초성, 중성, 종성 enum 값을 그대로 배열로 만들어서 리턴하는 것 뿐이다. enum 값 자체가 유니코드 한글 자모 영역의 코드값이므로 그대로 배열에 넣으면 된다.

초성에만 filler 값을 채웠다. 유니코드에는 초성과 중성에 filler가 정의되어 있다. 그러나 테스트 결과 맥OS에서는 filler를 전달하지 않고 생성한 string 타입 글자가 더 예쁘게 화면에 출력됐다. 그러나 기본 앱 중 하나인 메모앱에서 초성에 filler가 없을 경우 중성이 혼자 있을 때 앞 글자 전체를 초성으로 간주하고 먹어버리는 현상이 있었다.

> 돈ᅟᅡ

예를 들면 위와 같은 경우다. 지금은 filler가 있어서 두 번째 중성 앞에 이상한 기호가 보인다. 폰트에 따라 안보일 수도 있다. 이 초성 filler가 없으면 메모앱은 두 번째 중성 앞의 '돈'이라는 글자 전체를 초성으로 간주해서 두 번째 중성과 묶어 버린다. 그래서 모아치기를 시도하면 앞 글자가 없어져 버리는 증상이 생겼다. 그래서 초성에만 filler를 넣는 코드를 추가했다.

물론 유니코드에 중성 filler도 있는 만큼 중성에도 filler를 채울 수 있긴한데 그러면...

> ᄏᄏᄏᄏ, ᄒᄒᄒᄒᄒ, ᄋᄋ

위와 같이 자음만으로 내용을 전달할 때 중성 filler가 항상 옆에 붙어서 이상해 보인다. 그래서 중성 filler는 넣지 않았다.

```
    func norm_nfc(comp:Composition) -> [unichar] {
        var nfc:[unichar] = []
        
        let cho_base = Chosung.Giyuk.rawValue
        let jung_base = Jungsung.A.rawValue
        let jong_base = Jongsung.Kiyeok.rawValue - 1
        
        // ((초성인덱스 * 588) + (중성인덱스 * 28) + 종성인덱스) + 0xAC00
        var cho_idx:Int = -1
        var jung_idx:Int = -1
        var jong_idx:Int = 0
        
        if let chosung_unicode = self.chosung_layout[comp.chosung] {
            cho_idx = Int(chosung_unicode.rawValue - cho_base)
        }
        if let jungsung_unicode = self.jungsung_layout[comp.jungsung]{
            jung_idx = Int(jungsung_unicode.rawValue - jung_base)
        }
        if let jongsung_unicode = self.jongsung_layout[comp.jongsung] {
            jong_idx = Int(jongsung_unicode.rawValue - jong_base)
        }
        
        if (cho_idx != -1) && (jung_idx != -1) {
            let uni_han = (cho_idx * 588) + (jung_idx * 28) + jong_idx + 0xac00
            let uch:unichar = unichar(uni_han)
            nfc = [uch]
        } else {
            // 초성과 중성이 없으면 완성된 글자가 아니므로 NFD로 정규화
            nfc = self.norm_nfd(comp: comp)
        }
        
        return nfc
    }
```

NFC 방식으로 정규화하는 함수다. 그런데 여러 테스트 결과 NFC로 정규화해서 OS로 보내도 파일로 저장해서 hexdump해 보면 그냥 NFD로 홑어져 저장된다. 따라서 위 함수는 사용하지 않는 함수다. 그냥 코딩해 놨으니까 버리기 아까워서 둔다. 혹시 아는가 언젠가 쓸일이 있을지도.

> ((초성인덱스 * 588) + (중성인덱스 * 28) + 종성인덱스) + 0xAC00

주석에 썼듯, 한글 조합 영역 (AC00 ~) 코드를 계산하는 공식은 위와 같다. 여기서 초성 인덱스, 중성 인덱스, 종성 인덱스는 유니코드에서 정한 한글 자모의 정렬 규칙에 따라 나열한 한글 자모의 순서다.

<https://navilera.com/318na-자판-빈도-분석/>

위 링크 글에 관련 설명이 있으니, 관심있는 사람은 한 번 읽어보길 권한다.

초성, 중성, 종성 enum이 이미 선언되어 있고 컴포지션으로부터 한글 자모 영역의 값을 받을 수 있다. 그러므로 한글 자모 코드 값으로부터 초성, 중성, 종성 인덱스를 구할 수 있다. 한글 조합 영역의 한글 자모 정렬 순서와 한글 자모 영역의 한글 자모 정렬 순서가 같기 때문이다.

초성의 'ᄀ'의 인덱스가 0이다. 'ᄁ'의 인덱스는 1이다. 'ᄀ'의 한글 자모 코드값은 0x1100이고 'ᄁ'의 코드 값은 0x1101이다. 그러므로 컴포지션에서 받은 코드값에서 0x1100을 빼면 인덱스 번호다. 중성과 종성도 마찬가지다. 그렇게 초성, 중성, 종성의 인덱스 번호를 구한 다음 위 공식에 넣으면 0xAC00부터 시작하는 한글 조합 영역의 코드 값을 얻을 수 있다. 이 코드 값을 리턴한다.

한가지 고려해야 할 점은 flush()다. 플러시 해 버리면 조합 중간이라도 커밋을 하기 때문에 이 정규화 함수에 미완성된 컴포지션이 넘어올 수 있다. 한글 조합 영역은 완성된 글자들이 배열 되어 있으므로 완성된 글자가 아니라면 코드를 만들 수 없다. 그래서 인덱스 초기 값을 0xffff로 정의했다. 0번 인덱스는 의미를 가지고 있으므로 -1로 없음을 표현했다. 종성은 없어도 완성한 문자를 만들 수 있으므로 종성 인덱스의 기본 값은 0이고 없는지 체크하지도 않는다. 없어도 되니깐.

```
    func normalization(comp:Composition, norm_type:NormType) -> [unichar] {
        var norm:[unichar] = []
        
        if norm_type == NormType.NFC {
            norm = self.norm_nfc(comp: comp)
        } else if norm_type == NormType.NFD {
            norm = self.norm_nfd(comp: comp)
        }
        
        return norm
    }
```

외부에서 호출하는 정규화 요청 함수다. 실질적으로 하는 일은 없고 두 번째 파라메터인 norm_type에 따라 NFD나 NFC 정규화 함수를 호출한다.

### Keyboard318.swift

318Na 자판을 구현하는 클래스를 작성한 파일이다. 키보드 베이스 클래스 부분에서 설명했듯 나빌 입력기 오토마타에서 키보드 글자판은 키보드 클래스를 상속해서 초성, 중성, 종성 레이아웃을 정의 한 다음 초성, 중성, 종성에 대한 매핑 요청 처리 함수만 오버라이드 하면 된다.

```
class Keyboard318 : Keyboard {
    override init() {
        super.init()
        
        // 초성 레이아웃
        self.chosung_layout = [
            "Q":Chosung.SsBiep,
            "W":Chosung.SsJiek,
            "E":Chosung.SsDigek,
            
            :
            :

        // 중성 레이아웃
        self.jungsung_layout = [
            "O":Jungsung.Yae,
            "P":Jungsung.Ye,
            
            :
            :
                
       // 종성 레이아웃
        self.jongsung_layout = [
            "y":Jongsung.Kiyeok,    "yy":Jongsung.Ssangkiyeok,
            "u":Jongsung.Sios,      "uu":Jongsung.Ssangsios,
```

318Na 자판 클래스다. 키보드 클래스를 상속한다. 오버라이드한 생성자에서 초성, 중성, 종성 레이아읏을 재정의 한다. 레이아웃은 스위프트의 딕셔너리 타입이다. 키는 아스키 코드이고 값은 초성, 중성, 종성 enum이다. 그러므로 (아스키 코드 : 유니코드 자모 코드 값)으로 매핑하는 매핑 테이블이다.

```
    override func chosung_proc(comp: Composition, ch: String) -> Bool {
        let chokey:String = comp.chosung + ch
        return self.chosung_layout.contains(where: {(key, value) -> Bool in return key == chokey})
    }
    
    override func jungsung_proc(comp: Composition, ch: String) -> Bool {
        // 기존 입력에 중성 있고 종성도 있음
        if comp.jungsung != "" && comp.jongsung != "" {
            // 중성 테이블에서 더이상 검색하지 않음
            return false
        }
        let jungkey:String = comp.jungsung + ch
        return self.jungsung_layout[jungkey] != nil ? true : false
    }
    
    override func jongsung_proc(comp: Composition, ch: String) -> Bool {
        let jongkey:String = comp.jongsung + ch
        return self.jongsung_layout[jongkey] != nil ? true : false
    }
```

베이스 클래스에 있는 초성, 중성, 종성 레이아웃에 대해 매핑 여부를 요청하는 함수를 오버라이드한 코드다. 다른 자판을 구현 할 때도 적절이 이 세 함수만 작성하면 잘 동작할 것이라고 생각한다.

두벌식을 예를 들어보자. 두벌식 레이아웃을 잘 생각해 보면 초성과 종성을 같은 키에 매핑한 자판이다. 컴포지션에 초성이 있는 상태에서 또 초성 입력이 들어오면 종성을 내보내는 자판인 것이다. 왼손으로 타이핑하는 키를 각각 초성 레이아웃과 종성 레이아웃에 동일하게 매핑한다. 그리고 초성 입력 여부를 물으면 컴포지션에서 초성을 확인하고 리턴한다. 중성은 그대로 중성이다. 사용자가 종성 입력을 의도하고 왼손으로 자음을 입력하면 오토마타는 우선 초성에 대한 매핑을 확인하려 한다. 컴포지션에 초성이 있다면 318 자판 클래스는 초성에 해당 아스키 코드에 매핑된 값이 없다고 리턴한다. 그러면 오토마타는 종성에 물어볼 것이고 종성이 매핑에 있다고 응답하면 된다.

다른 세벌식 자판도 이런식으로 처리 가능하리라고 생각한다. 안됨 말고.

## 입력기 프론트 엔드

맥OS의 Input Method Kit을 구현하는 프론트 엔드다. 한글 조합에 대한 핵심 기능은 오토마타에 모두 있다. 맥OS에서 입력기 이벤트를 처리하고 글자를 커밋하고 화면에 표시하는 동작등을 전담한다.

개인적인 생각으로는 입력기를 구현하는데 필요한 코드는 윈도우즈보다 맥OS 쪽이 훨씬 간단하다. 그러나 간단한 만큼 세세하게 제어를 하진 못한다. 그런데 사실 아주 대단한 입력기를 만들 것이 아니라면 세세한 제어는 필요없다.

### Info.plist

아이폰, 맥, 애플 워치, 애플 TV등 애플 생태계의 프로그램을 개발하는 프레임 워크에서 Info.plist는 응용 프로그램의 속성을 정의한다. xml 형태로 되어 있으며 정해진 키에 값을 설정한다.

```
<plist version="1.0">
<dict>
	<key>InputMethodConnectionName</key>
	<string>NavilIME</string>
	<key>InputMethodServerControllerClass</key>
	<string>NavilIMEInputController</string>
	<key>tsInputMethodCharacterRepertoireKey</key>
	<array>
		<string>Hang</string>
	</array>
	<key>tsInputMethodIconFileKey</key>
	<string>navilime.tiff</string>
	<key>LSBackgroundOnly</key>
	<string>1</string>
</dict>
</plist>
```

예전에는 Info.plist 파일에 모든 설정이 다 있었던걸로 보인다. 그런데 언젠가부터 기본 설정에서 바뀌거나 추가하는 값만  Info.plist에 기술한다. 그래서 나빌 입력기의 Info.plist 파일에도 입력기에 필요한 내용만 있다. 위 xml 코드에 있는 내용은 반드시 있어야 맥OS가 프로그램을 입력기로 인식한다. 

### AppDelegate.swift

xcode에서 그냥 GUI 어플리케이션 개발 탬플릿으로 선택하고 프로젝트를 시작하면 기본 윈도우를 제어하는 시작 클래스다.

```
import InputMethodKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var scrollView: NSScrollView!
    
    var server = IMKServer()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Insert code here to initialize your application
        server = IMKServer(name: Bundle.main.infoDictionary?["InputMethodConnectionName"] as? String, bundleIdentifier: Bundle.main.bundleIdentifier)
        NSLog("tried connection")
        
        // 디버깅 할 때는 로그를 봐야 하므로 아래 주석을 순서대로 사용한다.
        //PrintLog.shared.scrollView = self.scrollView      // Debuging mode ON
        PrintLog.shared.scrollView = nil                    // Debuging mode OFF
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Insert code here to tear down your application
    }
}
```

시작 클래스이므로 여기서 입력기 서버를 시작한다. 맥OS의 입력기는 입력기 서버가 뜨고 개별 프로그램에서 입력기를 사용할 때 마다 입력기 클라이언트를 실행해서 서버에 연결한다. 그래서 입력기의 시작과 함께 입력기 서버를 띄워야 한다.

내가 맥OS에서 프로그램을 만들어 본적이 없어서 이쪽을 바꾸는 방식을 모른다. 그래서 나빌 입력기를 처음 실행하면 GUI 윈도우가 뜬다. 이걸 없애는 방법을 몰라서 그냥 해당 윈도우를 로그 윈도우로 사용하기로 했다. 입력기를 사용하는데 있어서는 그 윈도우를 그냥 꺼도 문제 없다.

그래서 기본 윈도우에 스크롤 텍스트 뷰를 넣고 앱 딜리게이터 클래스와 연결했다. 스크롤 텍스트 뷰는 로깅을 담당하는 싱글톤 클래스에 연결했다. 스크롤 텍스트 뷰 인스턴스가 로깅 싱글톤 클래스에 연결되지 않으면 로깅을 하지 않는다. 그래서 주석을 왔다갔다 하면서 빌드하면 로깅을 껐다 켯다 할 수 있다. 어차피 디버깅 할 때마다 입력기는 계속 빌드하므로 런타임에서 로깅을 끄는 기능은 의미가 없다.

### NavilIMEInputController.swift

인풋 컨트롤러 클래스를 작성한 파일이다. 나빌 입력기 프론트 엔드에 가장 중요한 파일이고 분량도 가장 많다. 나빌 입력기 프론트 엔드 기능 거의 전부를 구현한 클래스다.

```
import InputMethodKit

@objc(NavilIMEInputController)
open class NavilIMEInputController: IMKInputController {
    let key_code:String =       "asdfhgzxcv\tbqweryt123465=97-80]ou[ip\tlj'k;\\,/nm"
    let shift_key_code:String = "ASDFHGZXCV\tBQWERYT!@#$^%+(&_*)}OU{IP\tLJ\"K:|<?NM"
    
    var hangul:Hangul!
```

인풋 컨트롤러 클래스는 IMKit의 IMKInputController 인터페이스를 구현한다. 시작하자마자 나오는 키코드는 IMKit에서 전달하는 이벤트 키코드의 순서다.

관련 정보는

<https://stackoverflow.com/questions/3202629/where-can-i-find-a-list-of-mac-virtual-key-codes>

위 링크에서 찾을 수 있다. 문서를 보면 이 키코드가 꽤나 역사가 길다는 것을 알 게된다. 생각해보면 넥스스트탭부터 따져도 맥OS 역사도 수십년이 넘는다. 키코드 기원도 역사가 오래됐다.

내가 필요한 정보는 키코드에 매핑되는 아스키 코드이므로 간단히 키코드와 매핑되는 문자열을 선언했다. 위 링크의 스택 오버플로우 답변들을 보면 알 수 있듯 enum으로 개별적으로 선언해서 의미를 부여해서 쓰거나 배열을 만들어서 쓸 수 있다. 나는 그냥 가장 간단한 방법을 택했다.

hangul 클래스 변수는 나빌 입력기 프론트 엔드와 오토마타를 연결하는 변수다.

```
    override open func activateServer(_ sender: Any!) {
        super.activateServer(sender)
        
        PrintLog.shared.Log(log: "Server Activated")
        self.hangul = Hangul()
        self.hangul.Start(type: "318")
    }
    
    override open func deactivateServer(_ sender: Any!) {
        super.deactivateServer(sender)
        
        PrintLog.shared.Log(log: "Server deactivating")
        
        self.hangul.Flush()
        self.update_display(client: sender)
        
        self.hangul.Stop()
    }
```

엑티베이트 서버와 디엑티베이스 서버 함수는 인터페이스 함수로 입력키 클라이언트가 입력기 서버에 붙거나 떨어질 때 각각 호출된다. 앞에서 오토마타를 설명할 때 한글 클래스에 Start()와 Stop()을 굳이 분리해 디자인 이유가 여기에 매칭하기 위함이다. 아무것도 안하기엔 뭔가 심심해서 맥OS의 입력기 동작 워크플로우에 맞춰 오토마타 객체의 시작과 끝도 맞추려고 했다.

```
    override open func handle(_ event: NSEvent!, client sender: Any!) -> Bool {
        switch event.type {
        case .keyDown:
            let eaten = self.keydown_event_handler(event: event, client: sender)
            if eaten == false {
                self.commitComposition(sender)
            }
            return eaten
        case .leftMouseDown, .leftMouseUp, .leftMouseDragged, .rightMouseDown, .rightMouseUp, .rightMouseDragged:
            self.commitComposition(sender)
        default:
            PrintLog.shared.Log(log: "unhandled event")
        }
        return false
    }
```

핸들 함수는 입력기 프론트 엔드 구현에서 가장 중요한 핵심 함수다. 이 함수에서 처리하는 동작이 입력기 동작의 90%다. 키 눌림, 마우스 버튼 눌림, 마우스 드래그 이벤트 처리를 재정의한다. 이 핸들 함수가 true를 리턴하면 맥OS는 입력을 직접 처리하지 않고 입력기의 조작을 반영한다. false를 리턴하면 맥OS가 입력을 처리한다. 따라서 오토마타에서 한글 입력을 처리해서 화면에 뿌리고 나면 true를 입력하고 입력기에서 처리하지 않는 입력에 대해서는 false를 리턴한다. 그러면 자연스럽게 한글 입력과 한글 외 입력(영문, 기호, 숫자 등)을 처리 할 수 있다.

함수 코드를 보면 실질적인 처리는 키 눌림에서 한다. 그외 이벤트는 모두 commitComposition() 함수로 보낸다. 이러면 현재 조합중인 입력을 커밋하고 새로운 입력을 대기한다. 그러므로 키 눌림을 제외한 마우스 이동이나 클릭등 이벤트가 발생하면 한글 입력 조합을 즉시 종료하고 현재 입력을 화면에 반영한다.

마우스 입력이나 움직임에 한글 조합을 종료하지 않으면 한글 입력 도중에 마우스를 클릭하면 마지막 글자가 마우스 커서를 따라다니는 악명 높은 한글 끝 글자 현상이 발생한다.

```
    func keydown_event_handler(event:NSEvent, client:Any!) -> Bool {
        let keycode = event.keyCode
        let flag = event.modifierFlags
        
        if flag.contains(.command)
            || flag.contains(.option)
            || flag.contains(.control) {
            PrintLog.shared.Log(log: "Modikey - \(keycode) with \(flag.rawValue)")
            return false
        }
```

키 눌림 이벤트를 처리하는 함수는 나빌 입력기 기능의 대부분을 담당한다. 따라서 길다. 한 번에 설명하는 것보다 여러 조각으로 잘라서 설명하겠다. 파라메터로 넘어오는 이벤트에는 키코드와 플래그가 있다. 키코드는 눌린 키가 어떤 키인지 구분할 수 있는 번호다. 위에서 설명했던 그 키코드다. 플래그는 알트, 컨트롤, 커맨드, 시프트 등 기능키에 대한 정보를 담고 있다.

기능키와 같이 누르면 한글 오토마타에서 처리를 안해야 하므로 플래그를 검사해서 캐맨드, 옵션, 컨트롤 키를 같이 누른 키 눌림 이벤트에 대한 콜백 핸들러 호출이면 간단히 로그 한 줄 찍고 false를 리턴해서 처리를 안한다.

```
        let backspace = 0x33    // MacOS defined
        if keycode == backspace {
            PrintLog.shared.Log(log: "Backspace")
            
            let remain = self.hangul.Backspace()
            if remain == true {
                self.update_display(client: client, backspace: true)
            }
            return remain
        }
```

백스페이스에 대한 처리를 구현한 코드다. 앞에 오토마타를 설명할 때 언급한 것처럼 자모 단위 삭제 구현을 하려고 백스페이스는 오토마타에서 처리한다. 그래서 백스페이스는 오토마타 함수를 호출한다. 백스페이스의 키코드는 0x33이다. 애플이 그렇게 정한 숫자다.

백스페이스 처리를 하고도 오토마타에 아직 입력이 남아 있으면 남은 입력을 화면에 프리에딧 상태로 출력해야 한다. 그래서 리턴값을 확인한다. 리턴 값이 true면 화면에 한글을 갱신한다. 리턴 값이 false면 오토마타에서 처리할 남은 입력이 없다는 뜻이므로 맥OS에서 백스페이스 동작을 처리한다.

```
        if keycode >= self.key_code.count {
            PrintLog.shared.Log(log: "Bypassd keycode: \(keycode) >= \(self.key_code.count)")
            
            self.hangul.Flush()
            self.update_display(client: client)
            
            return false
        }
```

애플 키코드는 아스키 값이 정렬되어 들어가 있지 않다. 그래서 아스키 값을 처리할 수 있는 최소한 범위만 문자열로 만들어서 매칭하고 나머지는 그냥 위 코드에서 걸러버린다. 내가 관심 있어하는 키코드 이외의 입력은 입력기에서 처리하지 않는다.

중요한 것은 입력기에서 처리하지 않는 입력이 들어오면 맥OS로 처리를 넘겨야 하는데 그 직전에 현재 조합 중인 한글은 플러시하고 커밋해야 한다는 것이다.

```
        let ascii_idx = self.key_code.index(self.key_code.startIndex, offsetBy: Int(keycode))
        var ascii = self.key_code[ascii_idx]
        let shift:Bool = flag.contains(.shift)
        if shift == true {
            ascii = self.shift_key_code[ascii_idx]
        }
```

나는 나빌 입력기를 만들려고 스위프트를 짧게 일주일 정도 공부했다. 공부하면서 스위프트가 특히 마음에 안 든 부분이 바로 문자열 인덱싱 방법이다. 복잡하고 직관적이지 않다. 왜 이딴식으로 문자열 객체를 디자인했는지 의문이다. 아무튼 위 코드는 키코드에 해당하는 아스키 코드를 얻는 것이다. 시프트가 같이 눌려 있으면 대문자를 얻는다. 318 자판은 시프트 입력으로 쌍자음과 겹받침을 입력 할 수 있기 때문에 시프트도 고려해야 한다.

```
        let eaten:Bool = self.hangul.Process(ascii: String(ascii))
        if eaten == false {
            PrintLog.shared.Log(log: "Not Hangul: \(ascii)")
            
            self.hangul.Flush()
            self.update_display(client: client)
            
            return false
        }
        
        self.update_display(client: client)
        
        return true
```

오토마타로 아스키 코드를 보낸다. 오토마타의 리턴은 오토마타가 해당 아스키 코드를 한글로 변환했는지 여부다. true면 한글로 변환한 것이고 false면 입력기가 해당 아스키 코드를 처리하지 않은 것이다. 입력기가 해당 아스키 코드를 처리하지 않았으면 처리를 맥OS로 보내야 한다. 그러므로 false를 리턴해야 한다. 그리고 그 직전에 플러시하고 커밋해야 한다.

입력기가 처리를 했으면 화면을 업데이트하고 true를 리턴한다. 그러면 맥OS는 해당 입력에 대해 아무것도 하지 않는다.

이렇게 해서 나빌 입력기 프론트 엔드에서 가장 중요한 핵심 함수 설명이 끝났다. 막상 알고 보면 별거 아니다.

```
    func update_display(client:Any!, backspace:Bool = false) {
        let commit_unicode:[unichar] = self.hangul.GetCommit()
        let preedit_unicode:[unichar] = self.hangul.GetPreedit()
        let commited:String = String(utf16CodeUnits:commit_unicode , count: commit_unicode.count)
        let preediting:String = String(utf16CodeUnits: preedit_unicode, count: preedit_unicode.count)
        
        PrintLog.shared.Log(log: "C:'\(commited)' - \(commited.count) P:'\(preediting)' - \(preediting.count)")
        
        guard let disp = client as? IMKTextInput else {
            return
        }
        
        if commited.count != 0 {
            disp.insertText(commited, replacementRange: NSRange(location: NSNotFound, length: NSNotFound))
            
            PrintLog.shared.Log(log: "61 Commit: \(commited)")
        }
        
        // replacementRange 가 아래 코드와 같아야만 잘 동작한다.
        if (preediting.count != 0) || (backspace == true) {
            // 백스페이스로 글자를 지울 때, preddition.count == 0 인 상태가 되는데
            // 이 때 명시적으로 length = 0 인 NSRange를 setMarkedText()에 주어야만 자연스럽게 처리된다.
            let sr = NSRange(location: 0, length: preediting.count)
            let rr = NSRange(location: NSNotFound, length: NSNotFound)
            disp.setMarkedText(preediting, selectionRange: sr, replacementRange: rr)
            
            PrintLog.shared.Log(log: "61 Predit: \(preediting)")
        }
    }
```

업데이트 함수는 나빌 입력기 프론트 엔드에서 두 번째로 중요한 함수다. 화면에 한글을 업데이트하는 역할을 한다. 앞에서 설명했던 것처럼 커밋과 프리에딧 두 부분으로 나눠서 업데이트해야 한다.

오토마타에서 정규화를 끝낸 유니코드 배열을 받아서 커밋과 프리에딧 각각 문자열 변수를 생성한다. 커밋 문자열이 있으면 커밋을 하고 프리에딧 문자열이 있으면 조합 중 표시를 하는 영역에 한글을 출력한다. 둘이 서로 다른 함수를 호출해서 화면에 한글을 출력한다. 커밋일 땐 insertText() 함수를 호출하고 프리에딧일 땐 setMarkedText() 함수를 호출한다.

출력할 내용이 없으면 출력을 안하는 것이 상식적이므로 커밋과 프리에딧 각각 화면 출력 함수를 호출하기 전에 문자열의 길이를 검사해서 문자열 길이가 0이 아닌 경우 (내용이 있는 경우)에만 화면에 내용을 출력한다. 그런데 프리에딧의 경우 백스페이스로 지웠을 때의 상황도 처리해야 한다. 백스페이스로 자모를 하나씩 지우다 보면 자모를 모두 지운 모습이 나와야 한다. 그 때는 프리에딧에 빈 문자열을 출력해야 한다. 그래서 백스페이스일 때는 문자열의 길이가 0일 때도 화면에 출력하도록 조건문에 백스페이스 조건을 검사하도록 했다.

커밋과 프리에딧(특히 프리에딧)에 NSRange 타입의 영역 정보 변수 값을 지정해야 한다. 내가 수십 번 (위 코드에 61이라는 숫자가 보이는가? 61번 빌드하고 테스트 했다는 뜻이다.) 반복 테스트해서 얻은 최적 튜닝 값이 결국 그냥 NSNotFound로 NSRange를 지정하는 것이었다. 좀 황당하긴 했지만 그래도 해결 한게 어딘가. 아무튼 NSRange를 NSNotFound로 지정하는 것은 매우 중요하다.

```
    /*
     입력 메서드가 이 메서드를 구현하면, 클라이언트가 컴포지션 세션을 즉시 종료하고자 할 때 호출됩니다.
     일반적인 응답은 클라이언트의 insertText 메서드를 호출한 다음 세션별 버퍼와 변수를 정리하는 것입니다.
     이 메시지를 받은 후 입력 방법은 주어진 컴포지션 세션이 완료된 것을 고려해야 합니다.
     */
    override open func commitComposition(_ sender: Any!) {
        PrintLog.shared.Log(log: "Commit Composition")
        self.hangul.Flush()
        self.update_display(client: sender)
    }
    
    /*
     클라이언트는 입력 메서드가 이벤트를 지원하는지 확인하기 위해 이 메서드를 호출합니다.
     기본 구현은 NSKeyDownMask를 반환합니다.
     입력 방법이 키 다운 이벤트만 처리하는 경우, 입력 방법 키트는 기본 마우스 처리를 제공합니다.
     기본 마우스다운 처리 동작은 다음과 같습니다:
       활성 컴포지션 영역이 있고 사용자가 텍스트를 클릭하지만 컴포지션 영역 외부에서 클릭하는 경우,
       입력 방법 키트는 입력 메서드에 commitComposition: 메시지를 보냅니다.
       이것은 기본값인 NSKeyDownMask만 반환하는 입력 메서드에서만 발생합니다.
     */
    override open func recognizedEvents(_ sender: Any!) -> Int {
        return Int(NSEvent.EventTypeMask(arrayLiteral: .keyDown, .flagsChanged,
            .leftMouseUp, .rightMouseUp, .leftMouseDown, .rightMouseDown,
            .leftMouseDragged, .rightMouseDragged,
            .appKitDefined, .applicationDefined, .systemDefined).rawValue)
    }
    
    override open func mouseDown(onCharacterIndex index: Int, coordinate point: NSPoint, withModifier flags: Int, continueTracking keepTracking: UnsafeMutablePointer<ObjCBool>!, client sender: Any!) -> Bool {
        PrintLog.shared.Log(log: "Mouse Down")
        
        self.commitComposition(sender)
        return false
    }
```

인터페이스 콜백 함수 구현이다. 각 함수 위에 길게 써 놓은 주석은 애플 개발자 사이트에 있는 해당 함수의 설명을 번역기 돌려서 넣어둔 것이다. 나중에 시간이 오래 지나 보면 무슨 함수인지 모를 수 있으니깐.

각각 현재 입력 내용을 강제로 커밋하는 함수, 핸들러 함수가 받을 수 있는 이벤트 종류를 지정하는 함수, 마우스 클릭이 발생했을 때 호출되는 함수다. 마우스 클릭이 생기면 현재 조합 중인 한글은 즉시 커밋해야 한다. 그래서 강제로 커밋하는 함수를 호출한다. 강제로 커밋하는 함수는 플러시하고 업데이트하는 동작을 한다.

### SingletonPrintLog.swift

없애는 방법을 몰라서 나빌 입력기가 시작할 때 나오는 윈도우를 활용하려고 만든 로그 처리 담당 클래스다.

```
import Foundation
import Cocoa

class PrintLog {
    static let shared = PrintLog()

    var scrollView: NSScrollView?
    
    private init() { }
    
    func Log(log:String) {
        if let scv = self.scrollView {
            scv.documentView?.insertText(log + "\n")
        }
    }
}
```

디버깅 로그 같은 것은 소스 코드의 여러 군데서 필요할 때마다 즉각 호출 할 수 있어야 하기 때문에 싱글톤으로 만들어야 한다. 내용은 별거 없다. 로그 함수가 호출되면 스크롤 텍스트 뷰 인스턴스 객체가 있는지 여부를 확인해서 객체가 nil이 아니면 GUI 화면에 로그 내용을 추가한다. 이게 전부다.

# 인스톨

맥OS에서 입력기를 인스톨하는 방법은 두 가지다. 글로벌 설치와 사용자 로컬 설치다. 글로벌 설치는 시스템의 다른 사용자에게도 모두 영향을 준다. 사용자 로컬 설치는 해당 사용자에게만 영향을 준다. 혼자 쓰는 맥 시스템이라면 어느 쪽에 인스톨을 하든 같은 동작이다.

## 사용자만 인스톨

사용자 개인 입력기 디렉터리에 나빌 입력기 앱 디렉터리를 복사한다.

> $ cp -r NavilIME.app ~/Library/Input\ Methods

끝이다.

## 글로벌 인스톨

전체 시스템에서 참조하는 입력기 디렉터리에 나빌 입력기를 복사한다. 여기에 복사하려면 관리자 권한이 필요하다. 그래서 sudo를 한다.

> $ sudo cp -r NavilIME.app /Library/Input\ Methods

끝이다.

## 키보드 환경 설정

![](https://raw.githubusercontent.com/navilera/NavilIMEforMac/main/install.png)

그리고 새로운 키보드로 NavilIME를 한국어에서 선택해서 추가한다. 추가한 다음에 반드시 *로그아웃/로그인* 하거나 *재부팅* 해야 새로운 키보드가 시스템에 반영된다. 나빌 입력기를 처음 시작할 때 "Log..."라고 써 있는 빈 윈도우가 하나 뜨는데 이건 그냥 끄면 된다.

# 언인스톨

당연히 인스톨의 역순이다. 키보드 환경 설정에서 NavilIME을 제거한다. 그리고 입력기 디렉터리에서 나빌 입력기를 지운다.

> rm -fr ~/Library/Input\ Methods/NavilIME.app

아니면

> sudo rm -fr /Library/Input\ Methods/NavilIME.app

끝이다.

# 빌드

나빌 입력기는 의존하는 패키지가 없다. 그러므로 그냥 xcode에서 프로젝트를 열어서 빌드하면 빌드 된다.

# 잘 동작한다

이 긴 README.md 파일을 맥에서 나빌 입력기를 이용해 썼다. 이 글을 쓰면서 제대로 동작 안하는 부분을 디버깅했다. 이정도 글을 쓰는 동안 별 문제가 없었다면 아마 별 문제 없이 계속 잘 쓸 수 있을 것이다.
