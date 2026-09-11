# LAB1-09 3:8 디코더 - Xsim 사전 시뮬레이션

세 입력 `a`, `b`, `c`의 이진값과 같은 번호의 출력 비트 하나를 1로 만든다. `abc=000`은 `o[0]`, `abc=111`은 `o[7]`을 활성화한다.

- RTL: `src/decoder3x8.v`
- 테스트벤치: `sim/tb_decoder3x8.sv`
- 핀 제약: `constraints/decoder3x8.xdc`
- 검사: 8개 입력 전체, 각 10 ns
- 통과 기준: `LAB1_PASS decoder3x8 cases=8`, 종료 80 ns

`LAB1.code-workspace`에서 **터미널 → 작업 실행... → 02 Simulate**를 실행하고 **03 Open waveform**으로 파형을 연다.
