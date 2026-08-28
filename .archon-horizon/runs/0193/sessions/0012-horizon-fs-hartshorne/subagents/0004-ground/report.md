Checkpoint clears commits `dfcca8c003` and `09020e6b58`.

- Degree-zero kernel, point-class section, surjectivity, and decomposition are mathematically correct and remain explicitly conditional on `PrincipalDivisorsHaveDegreeZero`.
- Rational-section signs match `D - E = div(g)`: the inverse choices correctly convert `div(g) + D ≥ 0` to an effective representative and back.
- No improper `Pic⁰` identity-component claim is made.
- Hartshorne scope is clean and committed; no blueprint edits, `sorry`/`admit`/project axioms, or pending Hartshorne diff.
- Recorded full build passed all 3111 jobs; graph has 499 TeX + 309 Lean nodes, zero stale nodes, and task status correctly remains `running`.

Residual hygiene only: graph sync also reports 8 pre-existing authored/generated edge conflicts in addition to the 239 frozen-blueprint unattached declarations. They do not affect these commits, but should be folded into open traceability issue `I-2067` or the final report rather than omitted.

Highest-value next action: port the geometric/Euler-characteristic substrate needed to discharge `PrincipalDivisorsHaveDegreeZero` unconditionally.
