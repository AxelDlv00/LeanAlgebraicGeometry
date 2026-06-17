# Lean Audit Report

## Slug
iter162

## Iteration
162

## Scope
- files audited: 5 (the directive-named set)
- files skipped (per directive): 0 — directive scoped me to 5 named project files; I read each in full.

Verification performed: `lean_verify` on both iter-162 focus declarations, `lean_diagnostic_messages` (errors) on the focus file, and an exhaustive `sorry`/`axiom`/`:= True` grep on all five files.

---

## Per-file checklist

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: 7 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **FOCUS — `isIntegral_of_retract` (L200–237): SOUND, axiom-clean.** Mathematically correct (a retract of an integral scheme is integral): irreducibility via the continuous-surjective image of `pr` (section `r` ⇒ `pr.base` surjective), reducedness via each `S`-stalk split-injecting into the reduced `T`-stalk (`(r≫pr).stalkMap = iso` ⇒ first factor injective). All three hypotheses (`[IsIntegral T]`, `r`, `pr`, `hrp`) are load-bearing (`hrp` used at L207/L220/L230). `lean_verify` → axioms `{propext, Classical.choice, Quot.sound}` only (no `sorryAx`, no custom axiom).
  - **FOCUS — `rigidity_eqAt_closedPoint_of_proper_into_affine` (L258–395): SOUND, axiom-clean, NO `sorry`.** Body is fully filled (was `sorry` per docstring). `lean_verify` → `{propext, Classical.choice, Quot.sound}` only. Not laundering: hypotheses are jointly satisfiable (e.g. `X=Y=Z=Spec k̄`), the proof is constructive (no `False`/`absurd`-from-contradictory-hyps), and every hypothesis is consumed — `_hx`→`hxc` (L283), `_hUV`→`hsecU` (L357/366), `_hfU`→`hrange` (L371), `_hU₀`→`IsAffine` (L353). The deep step delegates to the clean `eq_comp_of_isAffine_of_properIntegral` (L377); the `IsIntegral X.left` it needs is supplied via the new `isIntegral_of_retract` on the slice section (L351).
  - Whole `rigidity_lemma` chain (`rigidity_snd_lift`, `snd_left_isClosedMap`, `morphism_eq_of_eqAt_closedPoints`, `eq_comp_of_isAffine_of_properIntegral`, `isIntegral_of_retract`, `rigidity_eqAt_closedPoint_of_proper_into_affine`, `rigidity_eqOn_saturated_open_to_affine`, `rigidity_eqOn_dense_open`, `rigidity_core`, `rigidity_lemma`) is now `sorry`-free — confirmed by the focus `lean_verify` being clean (a `sorryAx` anywhere in the dependency tree would have surfaced).
  - The 3 remaining `sorry`s (L804 `morphism_P1_to_grpScheme_const`, L828 `genusZero_curve_iso_P1`, L857 `rigidity_genus0_curve_to_grpScheme`) are the known deferred iter-157 scaffolds (cube / Riemann–Roch / headline assembly). Honestly labelled `SCAFFOLD … body is sorry`. Not flagged (per directive: known).
  - **STALE docstrings** describing the now-proven Step 1 / now-`sorry`-free chain as still carrying a residual `sorry` — see Major block (L29–31, L255–257, L408–411, L458, L485–486, L643–645/L669–672, L757–759).

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 2 `sorry`s: `genusZeroWitness.key` (L265) and `positiveGenusWitness` (L303). Both are known scaffolds; the `key` sorry carries an honest, current (iter-156) gap rationale (import cycle + char-`p` + missing base-change functor) — a documented genuine gap, NOT an excuse-comment of the "temporary/will-fix" variety. The non-sorry parts of `genusZeroWitness` (six structural fields + uniqueness via `Flat.epi_of_flat_of_surjective`) read soundly. Docstrings are current (reference iter-155/156).

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 1 `sorry`: `rigidity_over_kbar` (L88), the fallback route-(a) artifact carrying `[CharZero kbar]`. Honestly labelled "iter-126 scaffold — body is a single `sorry`". The Option-A-vs-B encoding note (L31–45) is accurate and useful. No issues.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 4 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File is **sorry-free** (all `sorry`/`NEEDS_MATHLIB_GAP_FILL` hits are in comments). `shearMulRight` (L350–384) and its two `@[simp]` lemmas, `cotangentSpaceAtIdentity` (+ `_eq_extendScalars`, `_finrank_eq`), `schemeHomRingCompatibility`, `section_snd_eq_identity_struct`, `isIso_of_app_iso_module`, and `relativeDifferentialsPresheaf_restrict_along_identity_section` all have full bodies.
  - **STALE**: `shearMulRight` docstring (L346) tags it `NEEDS_MATHLIB_GAP_FILL`, but the declaration is fully proven. Misleading.
  - **STALE / orphaned**: two large section doc-blocks (L428–451 and L465–525) describe in detail the declarations `relativeDifferentialsPresheaf_basechange_along_proj_two`, `basechange_along_proj_two_inv*`, and `mulRight_globalises_cotangent` as `sorry`/`PARTIAL` — but those declarations were **excised in iter-145** (excise notes at L552–560 and L624–629). The doc-blocks now describe code that no longer exists. The piece-(i.b) overview (L297–327, esp. L319 Step 2 `NEEDS_MATHLIB_GAP_FILL`) is likewise partly orphaned.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (naming)
- **excuse-comments**: none
- **notes**:
  - File is **sorry-free** (the only `sorry`/`: True` tokens are inside the iter-145 import NOTE at L20–34 describing *removed* placeholders). All five sub-pieces (`algebra_isPushout_of_affine_product`, `_ratfunc_D_X_ne_zero`, `_algebraic_mem_range`, `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`, `df_zero_factors_through_constant_on_chart`, `constants_integral_over_base_field`, `ext_of_diff_zero`) have full bodies; the KDM lemma's joint `[IsAlgClosed k] [CharZero k] [IsDomain B]` hypotheses are explicitly justified against stated counterexamples (L166–168) — good hygiene.
  - **NAMING**: `ext_of_diff_zero` (L443) takes an `eqOnOpen` hypothesis directly and is a "thin renaming" of `ext_of_eqOnOpen` — it does **not** take a `df = 0` hypothesis despite the name. The docstring is upfront about this (L431–438 "Iter-147+ will refine the signature to *also* take a chart-algebra `df = dg` hypothesis"), so it is documented naming drift, not a hidden trap. Minor.
  - The iter-145/146 import NOTES (L20–34) are historical but harmless.

---

## Must-fix-this-iter

None. The two iter-162 focus proofs are sound and axiom-clean; the remaining `sorry`s across the tree (AbelianVarietyRigidity L804/828/857, Jacobian L265/303, RigidityKbar L88) are pre-existing, honestly-labelled, project-known deferred scaffolds — none are excuse-comments, weakened-wrong definitions, parallel Mathlib APIs, suspect bodies on a *claimed-proven* statement, or unauthorized axioms.

## Major

Stale comments that actively misrepresent proof status (a reader/agent would believe gaps exist where they do not, or that excised code still lives):

- `AbelianVarietyRigidity.lean:255-257` — `rigidity_eqAt_closedPoint_of_proper_into_affine` docstring still reads "**Status (iter-160): `sorry` (the genuinely-deep residual…)**", but the body is now fully proven and `lean_verify`-clean. Most directly misleading (labels a proven theorem as `sorry`).
- `AbelianVarietyRigidity.lean:29-31` — module docstring asserts "The lone residual `sorry` of the chain is the geometric slice/section assembly of Step 1"; Step 1 is now proven and the `rigidity_lemma` chain is `sorry`-free.
- `AbelianVarietyRigidity.lean:408-411` — `rigidity_eqOn_saturated_open_to_affine` docstring says it is "isolated here … with a precise statement and `sorry` body"; the body is now filled (delegates to `morphism_eq_of_eqAt_closedPoints`).
- `AbelianVarietyRigidity.lean:458` — inline comment "This `sorry` is therefore the assembly of those three Mathlib facts, left for the prover phase"; the `JacobsonSpace` `haveI` immediately below (L460–466) is fully proven, no `sorry`.
- `AbelianVarietyRigidity.lean:485-486` — `rigidity_eqOn_dense_open` docstring: "The chain's lone residual `sorry` is the geometric slice/section assembly of Step 1." Now false.
- `AbelianVarietyRigidity.lean:643-645` and `:669-672` — `rigidity_core` docstring twice calls Step 1's assembly "the lone residual `sorry`". Now false.
- `AbelianVarietyRigidity.lean:757-759` — `rigidity_lemma` docstring: "The lone residual `sorry` of the whole chain is Step 1's geometric slice/section assembly." The whole chain is now `sorry`-free.
- `Cotangent/GrpObj.lean:346` — `shearMulRight` docstring tagged `NEEDS_MATHLIB_GAP_FILL`, but the iso is fully constructed with proven `hom_inv_id`/`inv_hom_id`.
- `Cotangent/GrpObj.lean:428-451` — section doc-block describes `…basechange_along_proj_two` (Step 2) and `mulRight_globalises_cotangent` (Compose) as `sorry`/`PARTIAL`; both were excised iter-145 (see L624–629). Orphaned.
- `Cotangent/GrpObj.lean:465-525` — ~60-line section doc-block describes the excised `basechange_along_proj_two_inv*` declarations and their "three remaining concrete sub-goals"; the declarations no longer exist (excised at L552–560). Orphaned.

## Minor

- `Cotangent/GrpObj.lean:319` — piece-(i.b) overview lists Step 2 as `NEEDS_MATHLIB_GAP_FILL`; partly orphaned by the iter-145 excision (overview kept for narrative but no longer maps to a live declaration).
- `Cotangent/ChartAlgebra.lean:443` — `ext_of_diff_zero` name advertises a `df = 0` hypothesis the signature does not take (it takes `eqOnOpen`); documented naming drift, low risk.
- `Cotangent/ChartAlgebra.lean:20-34` — historical iter-145/146 import NOTES; harmless but accreting.

## Excuse-comments (always called out separately)

None. No `-- temporary`, `-- wrong but works`, `-- will fix later`, or `-- placeholder` style admissions were found on any declaration. The `sorry`s present are documented deferred scaffolds with genuine technical rationale, not self-acknowledged wrong code.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 10 (all stale/misleading status comments — 7 in `AbelianVarietyRigidity.lean`, 3 in `Cotangent/GrpObj.lean`)
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: the two iter-162 focus proofs (`isIntegral_of_retract`, `rigidity_eqAt_closedPoint_of_proper_into_affine`) are mathematically sound, axiom-clean, `sorry`-free, and launder nothing — the only debt this iter is a wave of stale docstrings/section-comments that still advertise the now-closed Step-1 `sorry` and excised Cotangent declarations.
