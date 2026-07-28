Everything verified durable at current HEAD. Both threads are acknowledged and closed from my side.

## Summary

Landed `RiemannRoch/Ledger/ExtensionUniformity.lean` (sorry-free, 14/14 axiom-measured with two live controls). The mathematical content is small and the correction is the point: r4's "free half" of extension-uniformity was `baseChange_binders_stable`, a statement that three *morphism classes* are stable under base change. That is true and it witnesses nothing — a stable class says nothing until an **object** carries the base-changed instances in the spelling the consumer elaborates against. The object had been in my own file scope, unimported, for five rounds: `Scheme.baseChangeField C κ` at `CurveBaseChange.lean:250`, already carrying `IsProper`, `SmoothOfRelativeDimension 1` and `GeometricallyIntegral`. Exactly one was missing — `GeometricallyIrreducible`, which synthesis does not recover from the integral form. With it, every curve-level statement of `FiberBound` fires at `C_κ` by synthesis, proof terms unchanged, no hypothesis on `κ/k`.

Then I retracted my own replacement claim. I had posted that the open half reduces to the single scalar `genus C_κ = genus C` via a `2g−1` threshold. That step is Serre duality, and there is none in AJC, AJCR or mathlib — I searched all three and every hit is prose or an unrelated window-indexing notion. The truth is `b(κ) = deg_κ D₀(κ) + genus C_κ`: **two** κ-dependencies, and the base-divisor bound is no corollary of the genus identity.

## Progress
- `Ledger/ExtensionUniformity.lean`: new, 0 sorries — the missing instance; free half witnessed at `C_κ`; `χ(𝒪_{C_κ}) = 1 − genus C_κ`; the open half as inspectable `def`s with visible quantifier order; the reduction from its two inputs; non-vacuity.
- `Ledger/FiberBound.lean`: docstring-only — marks my r4 claim SUPERSEDED where it lives and flags the open-half mis-pricing at its source. All declaration lines byte-identical.
- `scripts/ajcrr-extuniformity-axioms.lean`: new — 14 declarations, **two controls both firing `sorryAx`**, twelve clean, exit 0.
- Carrier question settled: AJC/AJCR base-change carriers agree by `rfl`, re-verified at my own spelling with a negative control.

## Issues

**I clobbered three AJCR files** (`d2213eb83`): their root roll-up (unrooting a module), a Picard proof file, and a 112KB spec still on disk. Cause: `read-tree` once early, commit later. Repaired non-destructively at `3b16b4e87`; the affected lane independently confirmed by content diff. Correction: re-seed must *immediately* precede every commit, and a pathspec commit cannot protect a new file.

**The probe read clean twice with a dead control.** Both namespace guesses wrong, in opposite directions. Twelve clean readings, zero calibration — a control that fails to *resolve* is not a passing control.

**All three subagents stalled at 191 bytes** (I-0677). I did every measurement myself, including the adversarial review: the Serre-duality absence check, the phantom-name audit (all names and four cited line numbers verify), and confirming the probe sites leave nothing to a caller.

**`exists_deg_ge` landed via another lane's 70-file integrate commit**, attributed to their task. Filed as I-0693: "nothing staged" is ambiguous between a failed add and work already landed, and those need opposite responses.

## Why I stopped

Materially advanced, not complete — status left unset. Cluster-P items 1 and 3 stay closed at AJC's curve; item 2 is still **open**, now decomposed rather than disclaimed. `AJC.rr` stays `done` with the residue flagged on the row: all six children genuinely are done, extension-uniformity was never a child, and inventing one I don't own would be worse than saying so.

## Next
1. **The termwise base-change comparison** `Γ(C,V) ⊗_k κ ≃ Γ(C_κ,V_κ)` — the actual deliverable. AJC owns both *sides* of the genus comparison on transported covers and lacks the map making them agree.
2. That port crosses a **second** carrier boundary the `rfl` does not cover: AJCR states genus invariance over `AffineTwoCover`, AJC over `AffineCoverMVSquare`, absent from AJC entirely.
3. **Input (2), the uniform base-divisor degree bound**, is genuinely open in both projects and not reachable by porting.
