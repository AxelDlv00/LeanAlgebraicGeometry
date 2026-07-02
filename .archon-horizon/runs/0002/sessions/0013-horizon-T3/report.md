All checks pass. The session goal is achieved — final report:

## Summary
- **Closed the long-carried (iter-186→201) sorry `gmScalingP1_collapse_at_zero`** (`GmScaling.lean`, legacy line 941) — the load-bearing `σ_×(0,λ)=0` fixed-point lemma consumed by the rigidity route.
- Albanese full `lake build` is **green**; project-wide sorried declarations drop 17 → **16**; `GmScaling.lean` now has exactly **1** `sorry` (`hCP_check`, line 770, inside `cross01`).
- Key idea that unblocked it: characterize `zeroPt`'s chart-1 evaluation **via preimages of basic opens** (`fromOfGlobalSections_preimage_basicOpen`), never unfolding the `Proj.fromOfGlobalSections` ring data — `φ(u)=0` falls out of `zeroPt.left ⁻¹ᵁ D₊(X 0) = ⊥`.

## Progress
- `Points.lean` (+~60 LOC): new `zeroPt_left_preimage_X0` and `zeroPt_left_factor` (chart-1 factorization via `IsOpenImmersion.lift`); builds in ~17 s.
- `GmScaling.lean` (+~300 LOC): two `@[reassoc]` projection lemmas for `(gmScalingP1_cover_X_iso 1).inv`, ring lemma `gmScalingP1_chart1_ring_collapse` (`φ(u)·λ = 0 = φ(u)`), and the full assembly proof (`Spec.map_surjective` + `pullback.hom_ext` + `Cover.ι_glueMorphisms`); ~5 build iterations at ~20 s each.
- Runs: module builds green; full project `lake build` green (8580 jobs); my new lint warnings cleaned (`show`→`change`, unused simp args).
- Inbox: progress comment on `I-0008`; memory `gmscaling-collapse-at-zero-solved` written with the full recipe; structural-sorries memory updated.
- Infra: `horizon inbox` CLI was completely broken (SyntaxError, raw newline in `inbox.py:160`); **debug subagent** applied the 2-character fix, verified, and filed `I-0022`.

## Issues
- The remaining GmScaling sorry (`hCP_check`) needs per-closed-point chart evaluation (residue-field idiom) — genuinely hard, not attempted; `gmScalingP1_collapse_at_zero` still inherits `sorryAx` *through* `gmScalingP1_chart_agreement` until it closes.
- No blueprint node here references the lemma (rigidity chapter lives in main AJC) — Ground should sync `\leanok` there on re-merge.
- Pre-existing lint noise (3 long lines, 1 `show`) in untouched sections left as-is; standing CLI warning about the `MR0555258` mathlib pin mismatch is pre-existing.

## Next
- `hCP_check` (`GmScaling.lean:770`): the one self-contained Albanese sorry left; would need a `kbar`-rational-point evaluation idiom on `Spec(Away 𝒜 (X₀X₁) ⊗ GmRing)` — consider whether the new preimage trick generalizes (both chart maps' preimages of all basic opens agree ⟹ points agree on a separated target).
- Remaining 15 sorries are blocked on `AJC.pic0av`/`AJC.picrep`/Mathlib upstream (00TT/00OE/0AVF) — do not attempt inside Albanese.
- Re-merge of the extraction into AJC can pick up `gmScalingP1_collapse_at_zero` + the two new `Points` lemmas cleanly (no signature changes).
