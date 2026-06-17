# Session 164 — review of iter-164 (hygiene lane)

## Session metadata
- Session number: 164 (= iter-164)
- Mode: parallel; single prover lane (`AbelianVarietyRigidity.lean`)
- Sorry count (global): **6 → 6** (unchanged — this was a hygiene-only lane by design)
  - `AbelianVarietyRigidity.lean`: 3 deferred genus-0 scaffolds (L927/951/976 — bodies untouched)
  - `Jacobian.lean`: 2 (`genusZeroWitness.key` L265, `positiveGenusWitness` L303)
  - `RigidityKbar.lean`: 1 (`rigidity_over_kbar` L88)
- Model: opus
- Targets attempted: 1 file with 2 hygiene sub-tasks (A) docstring refresh, (B) unused-instance drop

## Headline outcome

iter-164 was the **base-case-route DECISION + no-regret hygiene** iter. The plan agent (a) resolved
the multi-iter misconception about `ℙ¹ → A` needing Milne Thm 3.2 / theorem of the cube and
committed the **𝔾ₘ-scaling shortcut** (route resolved via three plan-phase consults: mathlib-analogist
`thm32-extend`, strategy-critic `basecase-reopen → CHALLENGE`, blueprint-writer `basecase-4throute`
+ `scaling-primary`), and (b) rewrote the blueprint to make the scaling shortcut the PRIMARY proof
of `prop:morphism_P1_to_AV_constant`, with the HARD GATE re-cleared via the fast-path scoped
re-review `avr-fastpath2`.

The prover then ran a pure hygiene lane on `AbelianVarietyRigidity.lean`: refreshed stale comments
on the now-proven chain, refreshed `morphism_P1_to_grpScheme_const`'s docstring to the new
scaling-shortcut framing, and dropped two unused instance-arg classes from the signatures of the
two new Cor 1.5 / Cor 1.2 corollaries.

### Verification this review
- `lake env lean AlgebraicJacobian/AbelianVarietyRigidity.lean` → exit 0, only the 3 expected
  scaffold-`sorry` warnings (L927/951/976).
- `lean_verify` re-confirmed `rigidity_lemma`, `hom_additive_decomp_of_rigidity`, and
  `av_regularMap_isHom_of_zero` are all axiom-clean (`{propext, Classical.choice, Quot.sound}`,
  no `sorryAx`).
- Blueprint doctor: clean (no orphans, no broken refs, no axiom decls).

## Per-target attempts

### `AbelianVarietyRigidity.lean` — hygiene lane (A) + (B)

**(A) Stale-docstring refresh — RESOLVED.** 12 sequential edits touching docstrings/comments
only — no proof bodies edited.

- File-header link 1 (≈L23–30): was "proven (iter-157–159) modulo bridge 2 … decomposed into
  Step 2 / Step 1 (per-closed-slice constancy)" → now "**PROVEN axiom-clean** (iters 157–162),
  whole chain `sorry`-free, including Step 1's geometric slice/section assembly via
  `isIntegral_of_retract`".
- File-header link 2 (≈L31–35): was "rests on the theorem of the cube" → now the
  𝔾ₘ-scaling-shortcut framing (NO cube, NO Thm 3.2, NO `Hom(𝔾ₐ,A)=0`, char-general).
- `rigidity_eqAt_closedPoint_of_proper_into_affine` status (L257): "Status (iter-160): `sorry`
  (the genuinely-deep residual …)" → "**Status (iter-162): PROVEN axiom-clean**".
- `rigidity_eqOn_saturated_open_to_affine` docstring (≈L406): "isolated … with `sorry` body"
  → "now PROVEN axiom-clean (iter-162), assembled from Step 2 over Step 1".
- `rigidity_eqOn_dense_open` docstring (≈L484): "chain's lone residual `sorry`" → "whole chain
  PROVEN axiom-clean (iter-162)".
- `rigidity_core` docstring header: "PROVEN, modulo `rigidity_eqOn_dense_open`" → "PROVEN
  axiom-clean".
- `rigidity_lemma` status line (≈L758): "Status (iter-161) … lone residual `sorry`" →
  "Status (iter-162): PROVEN axiom-clean … whole chain `sorry`-free".
- `morphism_P1_to_grpScheme_const` docstring (≈L909–926): rewrote to describe the 𝔾ₘ-scaling
  shortcut as the **route resolved iter-164**, status note "body stays `sorry` pending the
  concrete ℙ¹/𝔾ₘ/σ_× infra (iter-165)".

**Diagnostic before each edit set**: `lean_diagnostic_messages` confirmed the file still compiles
and only the 3 scaffold sorries remain. No proof body edited.

**(B) Generalize Cor 1.5 / Cor 1.2 hyps — RESOLVED (instances were unused; removed).** 2 edits.

- `hom_additive_decomp_of_rigidity` (L820–821): dropped A-side `[Smooth A.hom]`,
  `[GeometricallyIrreducible A.hom]`. Kept `[GrpObj A] [IsProper A.hom]`. `lean_diagnostic_messages`
  after the drop → only the 3 scaffold warnings, no errors.
- `av_regularMap_isHom_of_zero` (L890): dropped knock-on B-side `[Smooth B.hom]`,
  `[GeometricallyIrreducible B.hom]`. Kept `[GrpObj B] [IsProper B.hom]`. Diagnostic clean.
- `lean_verify` on `av_regularMap_isHom_of_zero` after both drops → still axiom-clean.

**Source-A-side dead-instance follow-up NOT made** (out of scope; minimal-change ethos).
Pre-existing `[Smooth A.hom]` / `[GeometricallyIrreducible A.hom]` on the SOURCE A of
`av_regularMap_isHom_of_zero` also turn out to be unused (per the lean-auditor's iter-164 minor
finding); kept this iter, queued as an optional follow-up for iter-165.

## Review-phase subagents (both COMPLETE, 0 must-fix introduced this iter)

| Subagent | Slug | mf / maj / min | Headline |
|---|---|---|---|
| `lean-auditor` | iter164 | 0 / 5 / 3 | iter-164's two-spot hygiene edit is sound; the file is clean. The 5 majors are all stale-narrative debt in `Cotangent/GrpObj.lean`, `Cotangent/ChartAlgebra.lean`, `RigidityKbar.lean`, `Jacobian.lean`'s `genusZeroWitness.key` docstring — leftover from the iter-156+ route pivot. The minors include 1 stale "this `sorry`" comment in AVR (L462–463: refers to an assembly that's now discharged immediately below) and 1 pre-existing dead-instance hyp on the source A-side of `av_regularMap_isHom_of_zero`. No must-fix-this-iter. |
| `lean-vs-blueprint-checker` | avr-iter164 | 0 (regression) / 0 / 3 | Iter-164's hygiene edits are faithful, sound, and bring the Lean docstrings into closer agreement with the chapter. No laundering, no axiom introductions. The instance generalization is documented as Lean being **strictly more general** than the blueprint prose (sound). Recommended in-place NOTE amendment for the two corollaries — **applied this review**. Three pre-existing scaffold `sorry`s on `morphism_P1_to_grpScheme_const` / `genusZero_curve_iso_P1` / `rigidity_genus0_curve_to_grpScheme` flagged by the strict severity rules; checker explicitly classifies them as not regressions. |

Reports: `logs/iter-164/{lean-auditor-iter164,lean-vs-blueprint-checker-avr-iter164}-report.md`.

## Is this iter-157 laundering again? No.

Explicitly checked. `_hf` / base-point hypotheses are genuinely consumed across the chain
(`rigidity_eqOn_dense_open` L580–591 via `hcomp`/`hfx`; `hom_additive_decomp_of_rigidity` `hh` in
`hvf`/`hwg` L844–845; `av_regularMap_isHom_of_zero` `hα` directly in `one_hom := hα` L907). No
`sorryAx` propagation through any apparently-closed proof. The three remaining `sorry`s are
declared scaffolds with `**Status**:` markers in their docstrings.

## Blueprint markers updated (manual)

- `AbelianVarietyRigidity.tex`, `lem:hom_additivity_over_product`: appended `% NOTE: (iter-164
  review)` documenting the A-side `[Smooth A.hom]` / `[GeometricallyIrreducible A.hom]` drop
  (Lean signature strictly more general; axiom-clean preserved).
- `AbelianVarietyRigidity.tex`, `lem:av_regular_map_is_hom`: appended `% NOTE: (iter-164
  review)` documenting the B-side instance drop + the lean-auditor's pending source-A-side
  cleanup follow-up.

No `\leanok` touched (owned by `sync_leanok`). No `\mathlibok` added (no new Mathlib re-export).
No stale `\notready` to strip.

## Key findings

1. **Hygiene lanes are non-trivial when the route just pivoted.** This iter's hygiene work
   removed actively-misleading framing (docstrings still naming the theorem of the cube / Thm 3.2
   as the bottleneck, on a route resolved by 𝔾ₘ-scaling). Without the refresh, the next prover
   in iter-165 would have hit conflicting narrative between the file and the blueprint.
2. **Dead-instance hygiene is a (small) generalization free lunch.** Dropping unused instance
   hypotheses from `hom_additive_decomp_of_rigidity` / `av_regularMap_isHom_of_zero` lightens the
   downstream signature for the scaling-shortcut consumer without weakening any proof.
3. **Stale-narrative debt is accumulating in fallback-route files** (`Cotangent/GrpObj.lean`,
   `Cotangent/ChartAlgebra.lean`, `RigidityKbar.lean`, `Jacobian.lean`'s `genusZeroWitness.key`
   `sorry` docstring). Each file's code is sound; only the "live work plan" framing is stale.
   See recommendations.md.

## Recommendations for next session (iter-165)

See `recommendations.md`. Bottom line: iter-165 must **convert to depth** per the iter-164
progress-critic verdict — fire the api-alignment consult on the concrete ℙ¹/𝔾ₘ/σ_× idiom + start
the scaffold + (if api-alignment lands fast) the scaling-shortcut proof for
`morphism_P1_to_grpScheme_const`. The hygiene round is done; another hygiene round would CHURN
the route.
