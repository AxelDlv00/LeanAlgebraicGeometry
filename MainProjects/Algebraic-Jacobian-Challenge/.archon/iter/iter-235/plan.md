# Iter-235 plan-agent run

## Headline outcome

The **"d.2 stays CONVERGING → dispatch stage (iv); FlatBaseChange ruled STUCK → replace the prover
slot with a Mathlib-idiom consult"** iter. Execution-continuation on the lead lane, corrective on the
engine lane. No strategic change (carrier pivot + d.2 settled iters 232–233).

## What I processed (iter-234 outcomes)

- **StalkTensor.lean (d.2):** stage (iii) MET — `stalkTensorLinearMap` + 3 helpers landed axiom-clean
  (the iter-234 binary convergence probe). The named carrier-duality obstacle (CommRingCat/RingCat) was
  identified AND retired the same iter. 0 sorries. Next unit = stage (iv) reverse map.
- **FlatBaseChange.lean (engine):** 0 decls committed. Γ-fragment
  `moduleSpecΓFunctor_pushforward_tilde_iso` blocked on a typeclass-instance wall; prover flagged the
  brick is BOTH blocked AND insufficient (even closed, the affine lemma still needs Mathlib-absent
  QC-of-pushforward + pullback dict + fibre product + `cancelBaseChange` match).
- **Reviews (lean-auditor + lean-vs-blueprint-checker, iter-234):** StalkTensor axiom-clean, 0 code
  must-fix; 2 MAJOR blueprint-side pin gaps (no standalone `\lean{}` block for `stalkTensorLinearMap`;
  forward-looking `stalkTensorIso` pin — already NOTE-annotated). FlatBaseChange's 2 lean-auditor
  "must-fix" sorries are the genuine documented deep-engine sorries (not avoidable this iter).

## Subagents dispatched

| Subagent | Slug | Status |
|---|---|---|
| progress-critic | ts235 | **CONVERGING (d.2) / STUCK (FlatBaseChange)** — must-fix: replace FBC prover slot with a consult. |
| blueprint-writer | d2-linmap | **COMPLETE** — added `lem:stalk_tensor_linear_map` (`\lean{stalkTensorLinearMap}`), the stage-(iii) pin (fixes lean-vs-blueprint major #2). |
| blueprint-clean | ts235 | **PASS** — one Lean-leakage strip in the new block; Stacks SOURCE QUOTE byte-intact; no markers. |
| mathlib-analogist | fbc-dict | (api-alignment) — FlatBaseChange STUCK corrective: element-free Γ-fragment handle + QC-of-pushforward existence. |

- **strategy-critic: SKIPPED** — see `## Subagent skips`.
- **blueprint-reviewer: SKIPPED** — see `## Subagent skips`.

## Decision made — d.2 stage (iv) proceeds; FlatBaseChange prover slot → consult (STUCK corrective)

**Chosen:** one prover lane this iter (StalkTensor.lean stage (iv) reverse map, mathlib-build). The
FlatBaseChange prover slot is replaced — per the progress-critic STUCK must-fix — by the
mathlib-analogist consult (`fbc-dict`), NOT another prover round.

**Why (honoring the STUCK verdict, not rebutting it):**
- d.2 is CONVERGING: two consecutive iters of named-stage completion (forward map → linear packaging),
  0 sorries, named risk identified+retired each iter, ≤3 iters elapsed vs 4–7 estimate. Stage (iv) is
  the natural next unit (the critic explicitly endorsed dispatching it).
- FlatBaseChange is STUCK: 4 helpers over 3 iters, 0 sorries eliminated (0→2), iter-234 zero-commit on
  an instance wall the prover called both blocking AND insufficient. The dispatch guidance forbids
  re-dispatching the same lane with cosmetic recipe variation; the critic's primary corrective is a
  Mathlib-idiom consult on the element-free handle (`SheafOfModules.pushforward` ring-map accessor;
  `ModuleCat.restrictScalarsComp`) + whether QC-of-pushforward is genuinely Mathlib-absent. I dispatched
  exactly that consult. The secondary corrective (blueprint expansion of the full affine dictionary) is
  sequenced AFTER the consult (it needs the consult's absent-vs-hard-to-find verdict) — decided below
  once `fbc-dict` returns.

**LOC/risk:** d.2 stage (iv) ≈ 150–250 LOC nested colimit descent (no Mathlib shortcut; built by hand
from `TopCat.Presheaf.stalk`). FlatBaseChange consult is read-only, ~0 risk, unblocks the next prover
round. **Cheapest reversing signal:** if the analogist finds a direct Mathlib
`pushforward (Spec.map φ) (tilde M) ≅ tilde (restrictScalars φ.hom M)` (or QC-of-pushforward present),
the FBC lane is much shorter than feared and re-opens next iter with a real recipe; if it confirms both
genuinely absent, the FBC engine brick is a multi-iter Mathlib-gradient build and the blueprint must be
expanded to cover all four sub-bricks before the next prover round.

## mathlib-analogist `fbc-dict` findings (the STUCK corrective paid off — high value)

The consult both dissolved the instance wall AND surfaced a **critical soundness defect**:

1. **CRITICAL (acted on this iter): missing `[F.IsQuasicoherent]`.** Both
   `affineBaseChange_pushforward_iso` and `flatBaseChange_pushforward_isIso` took an arbitrary
   `F : X.Modules` — FALSE as typed (Stacks 02KH requires QC; over an affine open a general F is not
   `tilde M`, so the affine proof cannot apply). Verified `SheafOfModules.IsQuasicoherent` is the
   Mathlib typeclass (loogle; `tilde M` carries the instance) and no downstream consumer exists (grep).
   **Fixed this iter** via refactor `fbc-qc-hyp` (added `[F.IsQuasicoherent]` to both; build green, 2
   pre-existing sorries, no new binders). This is the "soundness check before spending budget" rule
   firing for real: the lane's recurring blocker was partly a *false statement*, not only a Mathlib gap.
2. **The instance wall was a wrong-altitude symptom.** `tilde.functor` is fully faithful with essential
   image QC; for QC modules `IsIso α ↔ IsIso (moduleSpecΓFunctor.map α)` via the `fromTildeΓ` counit,
   reducing the goal to `IsIso` of a concrete `ModuleCat R` map (`cancelBaseChange`) with NO section-smul
   instances. (And the iter-234 "action not synthesizable" claim was refuted — Mathlib materialises it
   with `letI`/`haveI`.)
3. **The lane reduces to ONE Mathlib-absent brick**, not a multi-brick chain:
   `pushforward (Spec.map φ)(tilde M) ≅ tilde (restrictScalars φ.hom M)`. This single iso discharges BOTH
   the Γ-fragment (Q1) AND QC-of-pushforward (Q2, which is otherwise genuinely Mathlib-absent but needs
   no separate theorem). Idiom corrections: ring-map accessor is `.hom`/`f.appTop` (not `.val`);
   `(Spec.map φ)⁻¹ᵁ ⊤ = ⊤` is `rfl` (`Scheme.preimage_top`). Rationale persisted in `analogies/fbc-dict.md`.

**FlatBaseChange is therefore NOT a hopeless grind** — STUCK was the right diagnosis and the consult
converted it into a bounded, sound next step. This iter: soundness fixed (refactor) + chapter reframed
(blueprint-writer `fbc-reframe` + blueprint-clean). NEXT FlatBaseChange prover round (next iter,
mathlib-build): build `lem:pushforward_spec_tilde_iso`, then close the affine lemma via the
full-faithfulness reframe + `cancelBaseChange`. The instance-wall route is abandoned.

## Rebuttal status

No rebuttal to progress-critic — both verdicts accepted and acted on (d.2 prover dispatched; FBC STUCK
slot replaced by the consult, which then drove this iter's soundness fix + chapter reframe).

## Subagent skips

- **strategy-critic**: STRATEGY.md SHA-unchanged since iter-233; the prior ts233 CHALLENGE's
  active-route parts (carrier pivot, d.2 associator) were addressed and are executing; its remaining
  autoduality-RR part concerns Route 2 (A.4), gated ~12–16+ iters out and tracked in STRATEGY open Qs —
  not actionable this execution-continuation iter. (Same rationale as iter-234.)
- **blueprint-reviewer**: the two active chapters' per-file gates are current — `Picard_TensorObjSubstrate`
  (d.2) was confirmed by the iter-234 lean-vs-blueprint-checker ("adequate for stages (iv)/(v)", 0 code
  must-fix) and this iter's only edit (the stage-(iii) pin) was re-checked by blueprint-clean PASS;
  `Cohomology_FlatBaseChange` is complete+correct (and gets NO prover this iter — replaced by a consult,
  so its gate is moot this round). The cross-chapter ts233 findings are on held/paused chapters not
  feeding the single active prover lane. Re-running the whole-blueprint review every stable iter is the
  hollow-dispatch anti-pattern the skip affordance exists to avoid.
