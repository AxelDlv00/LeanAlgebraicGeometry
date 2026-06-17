# Recommendations for iter-005 plan agent

## 0. Review-subagent findings (act on these first)

All three review subagents returned **0 must-fix** — no gate blocks. The actionable items:

### HIGH — close FBC `base_change_mate_regroupEquiv` via a file split
The prover found a **clean, sorry-free closure**: `exact LinearEquiv.toModuleIso
(base_change_regroup_linearEquiv ↑M)` typechecks ONLY when `base_change_regroup_linearEquiv` (the
axiom-clean L4-a core) lives in a **separately-compiled module** — same-file the `Module A (A ⊗[R] R')`
instance diamond does not reduce. **Action:** dispatch the `refactor` subagent to split
`base_change_regroup_linearEquiv` (+ its `rightAlgebra`/`comm`/`cancelBaseChange` plumbing) into a new
file (e.g. `AlgebraicJacobian/Cohomology/RegroupHelper.lean`) imported by `FlatBaseChange.lean`. This
closes the `hms`/`map_smul'` sorry (line 978) outright. Caveat: lean-auditor flagged the "separate
module" claim as unverifiable from source — the prover verified it end-to-end in a scratch import, so
it is the recommended path, but confirm the typecheck on the first attempt before committing the split.
Report: `task_results/lean-vs-blueprint-checker-fbc.md`, `task_results/lean-auditor-iter004.md`.

### MEDIUM — fix the stale L4 `% LEAN SIGNATURE` block (plan-agent prose)
`Picard_FlatteningStratification.tex`, `lem:gf_noether_clear_denominators`: the `% LEAN SIGNATURE`
block (lines ~365–387) claims the AlgHom encoding "replaces the earlier anonymous instance
existentials", but the landed Lean **retains** `(_ : Algebra (Localization.Away g) (Localization.Away
(algebraMap A B g)))` as the 3rd existential (needed to type the AlgHom target). I added a `% NOTE:`
flagging this; the planner should rewrite the block's conclusion to insert that binder and drop the
"replaces…" sentence, so the L5 assembly work consumes the correct existential shape.
Report: `task_results/lean-vs-blueprint-checker-gf.md`.

### MEDIUM — verify `sync_leanok` proof-block behavior
The fbc checker reports that ~19 fully-proved, axiom-clean lemmas in `FlatBaseChange.lean` lack
PROOF-block `\leanok` (their STATEMENT blocks are marked). `sync_leanok-state.json` shows iter-004 ran
(+12 / −19). This is outside the review agent's `\leanok` domain (deterministic-sync owned), so it is
surfaced, not fixed. Planner: confirm whether `sync_leanok` is meant to add proof-block markers; if so
this is a tooling gap making the blueprint look more incomplete than it is. Report:
`task_results/lean-vs-blueprint-checker-fbc.md` (Blueprint adequacy section).

### LOW — stale comment + deprecation hygiene (prover-owned, next time those files open)
- `FlatBaseChange.lean:234–246` — stale "What remains" comment claims `pushforward_spec_tilde_iso`
  has an outstanding QC obligation, but it is **proved** at line 537. Misleads readers. Ask the FBC
  prover to delete/correct it next time the file is open.
- `FlatBaseChange.lean` ~22 sites — deprecated `CategoryTheory.Sheaf.val` / `.val.obj` / `.val.map`
  (replacement `ObjectProperty.obj`). All in proved code; build-breaking at the next Mathlib pin bump.
  Schedule a mechanical sweep (carry-over from iter-003).
- `RelativeSpec.lean:233` `UniversalProperty` / `:280` `affine_base_iff` — naming drift (names imply
  more than the types deliver). Cosmetic until RelativeSpec representability reactivates.
- Pervasive parent-project iter-number references (`iter-173`…`iter-241`) across all `.lean` files —
  cosmetic.

## 1. Closest-to-completion targets to prioritize (iter-005)

1. **FBC `base_change_mate_regroupEquiv` (hms)** — closeable THIS iter via the file split above. Once
   it lands, `base_change_mate_generator_trace` and `pushforward_base_change_mate_cancelBaseChange`
   become fully sorry-free modulo only `base_change_mate_generator_trace_eq`.
2. **FBC `base_change_mate_generator_trace_eq`** — the genuine mate-unwinding crux. Do NOT re-assign
   the monolithic sorry; **effort-break per trace step** (unit value / `f_*` reindex / `(g^* ⊣ g_*)`
   transpose) first, as the effort-breaker ramp flagged. This is the last real FBC-A blocker before
   the affine close.

## 2. Promising approaches needing more work

- **GF L5 generic-rank dévissage** (`exists_free_localizationAway_polynomial`, sorry 495): the torsion
  sub-case is done; the residue is the non-torsion `0 → A_g[X]^{⊕m} → N_g → T → 0` SES + IH on `T`.
  **Structural prerequisite:** restructure the proof skeleton to strong induction on `d` with `N`
  universally quantified (the current `rcases` split has no IH in scope — auditor flagged this is
  understated in the comment). Effort-break the generic-rank SES construction AFTER the induction
  restructure. The L3 chain it splices through is now fully proved, so this is unblocked downstream.
- **GF L4 Step 2** (`exists_localizationAway_finite_mvPolynomial`, sorry 445): denominator-clearing
  over the finitely many integral-dependence equations is Mathlib-absent. Effort-break the
  denominator-clearing as its own lemma before re-dispatch.

## 3. Blocked targets — do NOT re-assign as-is

- **FBC `affineBaseChange_pushforward_iso`** (sorry 1141): the per-affine-open
  restriction-compatibility of `pushforwardBaseChangeMap` is Mathlib-absent and NOT isolated as a
  named lemma in the blueprint. Effort-break (blueprint side) before any prover dispatch — both the
  fbc checker and auditor flag the missing sub-lemma granularity.
- **FBC `flatBaseChange_pushforward_isIso`** (sorry 1163): deferred FBC-B; needs Čech/Mayer-Vietoris
  infra. Keep deferred.
- **GF `genericFlatnessAlgebraic` / `genericFlatness`**: deferred assemblies — only wire once L4/L5
  close. Do not dispatch.

## 4. Coverage debt (1-to-1 graph correspondence) — planner to blueprint

`archon dag-query unmatched` returns **1 node**:
- `lean:AlgebraicGeometry.base_change_regroup_linearEquiv` (FlatBaseChange.lean ~848) — prover-created
  helper, proved axiom-clean, NO blueprint block. Its Lean depends on
  `TensorProduct.AlgebraTensorModule.cancelBaseChange`, `TensorProduct.comm`,
  `Algebra.TensorProduct.rightAlgebra`. Add a `\begin{lemma}\lean{…base_change_regroup_linearEquiv}…`
  block (pure-tensor-algebra `R'`-linear `(A⊗_R R')⊗_A M ≃ R'⊗_R M`) just before
  `lem:base_change_mate_regroupEquiv`, which it implements. If the file split (rec. 0/HIGH) happens,
  the block should point at the new file's slug.

## 5. Reusable proof patterns discovered (added to PROJECT_STATUS Knowledge Base)
- Re-prove `R'`-linearity by hand for `cancelBaseChange` (only `B`-linear in `M`; use
  `induction_on` + `rightAlgebra`).
- Separately-compiled-module trick to force a defeq-but-non-reducing ModuleCat instance diamond to
  reduce for `toModuleIso` packaging.
- `IsBaseChange.of_comp` to transport freeness across localization towers without the Mathlib-absent
  converse-localization lemmas.

## 6. Stuck-protocol note
No target has hit the same blocker for ≥3 iters. FBC-A and GF-alg both showed genuine sorry-elimination
this iter (progress-critic CONVERGING last iter; this iter confirms it). No route pivot warranted.
Keep both as single-file `prove` lanes (the iter-004 plan's no-split decision held).
