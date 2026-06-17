# Iter-162 (Archon canonical) — review

## Outcome at a glance
- **THE CHAIN-CLOSE ITER.** The prover lane on `AbelianVarietyRigidity.lean` closed the lone deep
  residual `rigidity_eqAt_closedPoint_of_proper_into_affine` (Step 1) and landed a new reusable helper
  `isIntegral_of_retract`. The **entire Rigidity-Lemma chain is now sorry-free and axiom-clean** —
  independently re-verified this review: `lean_verify` on `rigidity_lemma`,
  `rigidity_eqAt_closedPoint_of_proper_into_affine`, and `isIntegral_of_retract` each →
  `{propext, Classical.choice, Quot.sound}`, no `sorryAx`. Since the headline carries no `sorryAx`,
  it cannot be laundering — genuinely closed.
- **Dispatch MATCHED the plan — 5th consecutive iter** with no plan/dispatch contradiction.
- **Global bare-`sorry` 7 → 6** (AVR 4 → 3). Authoritative per-file inventory (`grep ^\s*sorry\s*$`):
  AVR L804/828/857 (the 3 OFF-LIMITS deferred genus-0 scaffolds), `Jacobian.lean` L265/L303,
  `RigidityKbar.lean` L88. No new `axiom`; no protected signature touched.
- Caps the iter-157→162 arc: 157 unsound → 158 repaired → 159 hfib closed → 160 Step-2 proven +
  sig-gap surfaced → 161 deep-algebra proven + Step-1 reduced → **162 Step-1 closed, chain done**.

## The advance, independently verified this review
1. **`rigidity_eqAt_closedPoint_of_proper_into_affine` (Step 1, lean 258) — PROVEN, axiom-clean.**
   The winning technique (KEY new pattern): the slice/retract identities CANNOT be done via
   `pullback.hom_ext` on `(X⊗Y).left` (`Category.assoc` can't match — composite middle object
   syntactically `(X⊗Y).left` vs `pullback.fst` domain `pullback X.hom Y.hom`, defeq-not-syntactic);
   instead lift `q` to `qhat := Over.homMk q hqsec : 𝟙_ ⟶ X⊗Y` and do all algebra in `Over (Spec k̄)`
   via `CartesianMonoidalCategory.hom_ext` + `lift_fst`/`lift_snd` + `toUnit_unique (… ≫ toUnit _) (𝟙 _)`.
   Slice→affine via the iter-161 `eq_comp_of_isAffine_of_properIntegral` with `IsIntegral X.left` from
   the new helper. Every hypothesis load-bearing (auditor-confirmed: `_hx`→hxc, `_hUV`→hsecU,
   `_hfU`→hrange, `_hU₀`→IsAffine).
2. **`isIntegral_of_retract` (lean 200) — NEW, axiom-clean.** Generic "retract of an integral scheme
   is integral", stated more generally than the blueprint's `X`/`X×Y`/`p₁` instance. Reducedness
   PER-STALK (the blueprint's global-sections argument is mathematically insufficient — reducedness is
   local; Lean does the right thing). Pins: `isReduced_of_isReduced_stalk` needs `[∀ x, IsReduced]` as
   an instance arg (`haveI hstalk` first); the residual iso discharged by `inferInstanceAs (IsIso (… ≫ 𝟙 _))`.

## Is this iter-157 laundering again? No.
Headline `rigidity_lemma` carries NO `sorryAx` — a `sorryAx` anywhere in its cone would surface, so
there is no hidden false `sorry`. Both review subagents explicitly checked and cleared the iter-157
anti-pattern; both proofs are constructive with every hypothesis load-bearing.

## Review-phase subagents (2 dispatched, both COMPLETE, 0 must-fix on changed scope)
| Subagent | Slug | must-fix / major / minor | Headline |
|---|---|---|---|
| `lean-auditor` | iter162 | 0 / 10 / 3 | Both focus proofs sound, axiom-clean, launder nothing. 10 majors = stale status comments (7 AVR still calling closed Step 1 "the lone residual sorry"; 3 orphaned `GrpObj.lean` doc-blocks describing iter-145-excised decls). |
| `lean-vs-blueprint-checker` | avr-iter162 | 0 / 1 / 2 | `isIntegral_of_retract` `\lean{}` correct; chain verified sorry-free + axiom-clean, no laundering of the chain. Major = proof-`\leanok` laundering on the 3 downstream `:= sorry` scaffolds (cube/RR/headline) — sync-owned. Minors = insufficient global-sections prose for `isIntegral_of_retract` (NOTE'd) + stale "residual sorry" prose. |
Reports: `logs/iter-162/{lean-auditor-iter162,lean-vs-blueprint-checker-avr-iter162}-report.md`.

## Actions taken this review
- Added `\lean{AlgebraicGeometry.isIntegral_of_retract}` to `lem:isIntegral_of_retract_of_integral`
  (was blank pending this helper) + a `% NOTE: (iter-162 review)` recording the generic-vs-specific
  statement and the stalk-vs-global-sections proof divergence (the prose half is mathematically
  insufficient; the Lean is correct).
- Added a `% NOTE: (iter-162 review)` to `rmk:rigidity_lemma_decomposition` flagging the now-stale
  "single genuinely-deep residual sorry" prose (chain closed) for the plan/blueprint-writer.
- Did NOT touch `\leanok`. Surfaced the recurring proof-`\leanok` laundering on the 3 `:= sorry`
  scaffolds (no marker-sync log under `logs/iter-162/` → likely a persistent `sync_leanok` defect) to
  recommendations + developer feedback.
- 2 new KB Proof Patterns in PROJECT_STATUS.md (Over-level cartesian slice/retract algebra;
  `isIntegral_of_retract` per-stalk reducedness) + the "Last Updated" pointer.

## For the next plan agent (see recommendations.md)
- **Chain is DONE** — do not re-assign any AVR chain lemma.
- **HIGH:** resolve the proof-`\leanok` laundering of the deferred cube/RR/headline scaffolds (confirm
  `sync_leanok` runs + strips; escalate if it's a sync defect). Do not trust the blueprint graph's
  "cube proven" status for the base-case route decision.
- **BINDING:** the genus-0 base-case route decision (cube vs c-hybrid vs Pic⁰), gated on the Milne
  §III.6 read of whether the cube is on Route A's Albanese-UP path. Decoupled from this (closed) chain.
- **MEDIUM:** cheap docstring/prose refresh (10 stale `.lean` comments; 2 blueprint prose items).
