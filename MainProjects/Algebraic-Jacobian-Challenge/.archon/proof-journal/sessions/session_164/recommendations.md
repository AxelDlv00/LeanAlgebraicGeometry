# Recommendations for iter-165 plan agent

## HIGH — Convert iter-164's de-risk+pivot into depth (progress-critic mandate)

The iter-164 progress-critic verdict was **CONVERGING** but with an explicit instruction: iter-165
must convert the route correction into depth — actual infra and proof, not a second hygiene round.
Another hygiene/cosmetic round on the same scope would be CHURNING. Treat this as binding.

1. **Dispatch the api-alignment consult FIRST** (`mathlib-analogist`, mode `api-alignment`,
   proactive trigger — see `.archon/subagents/mathlib-analogist.md`). The PROGRESS.md "Next iter"
   block already names this. Ask specifically about:
   - The idiom for `ℙ¹` as `Over (Spec k̄)` (Mathlib's `Proj`/projective space packaging).
   - `𝔾ₘ` and `𝔾ₐ` as `GrpObj` (AffineSpace 𝔸(1) + units, or Mathlib's group-scheme idiom).
   - The scaling action `σ_× : ℙ¹ × 𝔾ₘ ⟶ ℙ¹` (in `Over`-categorical form).

   **Do NOT scaffold blind.** The progress-critic's reversal trigger explicitly names "if
   `gmScalingP1`/`ProjectiveLineBar` prove intractable to even state cleanly" — that is the
   trigger to back off and consider differential (route B's `H⁰(ℙ¹, O(-2)) = 0`) for a char-0
   sub-case. The consult is the cheapest signal.

2. **After the consult returns**, scaffold `def:genus0_base_objects` + `def:gaTranslationP1`
   (`ProjectiveLineBar`, `Gm`, `gmScalingP1`) inside `AbelianVarietyRigidity.lean`. Refine
   `morphism_P1_to_grpScheme_const` from the abstract `P1` proxy to the concrete `ProjectiveLineBar`
   (the avr-fastpath2 "soon" recommendation).

3. **Prove the scaling shortcut** for `morphism_P1_to_grpScheme_const`: apply Cor 1.5
   (`hom_additive_decomp_of_rigidity`) with `V = ℙ¹` proper, `W = 𝔾ₘ`, base points `0, 1`; the
   `W`-axis collapses at the scaling fixed point; constancy on dense `𝔾ₘ ⊆ ℙ¹` via `ext_of_eqOnOpen`
   (proven, separated target). All inputs already exist except the new infra above.

4. Then `rigidity_genus0_curve_to_grpScheme` (transport `C ≅ ℙ¹` via `genusZero_curve_iso_P1`).
   The composition itself is short; gated on (1) above and (2) below.

## HIGH — Resolve the lingering false `\leanok` on 3 genus-0 scaffolds (was iter-163 CRITICAL)

The plan agent's iter-164 sidecar root-caused the persistent false `\leanok` on the 3 genus-0
scaffold props: `sorry_analyzer.py` emits `in_declaration` WITH the Lean keyword prefix (e.g.
`"theorem morphism_P1_to_grpScheme_const"`), but `sync_leanok.py::_decl_has_sorry` compares
against the bare/qualified name without stripping the keyword, so the prefixed name never matches
and `sync_leanok` keeps the proof-block `\leanok` (false positive). Reported to the developer via
`.debug-feedback` with the one-line fix. **CONFIRM** in iter-165 whether the developer applied
the fix; if not, escalate again. The 3 scaffold props remain OPEN regardless of the marker
(everyone is treating them so) but the launder makes downstream blueprint reviews noisier.

## MEDIUM — Stale-narrative debt accumulated in fallback-route files

The lean-auditor `iter164` returned 5 majors, all stale-narrative debt. Each file's code is
**sound** and axiom-clean; only the "live work plan" framing is wrong. Recommend a single small
blueprint-writer/refactor pass to refresh these, OR a documented decision to let them rot (each
gets harder to audit through over time):

- **`AlgebraicJacobian/Cotangent/GrpObj.lean:297–327`** — section header announces a closure plan
  (`mulRight_globalises_cotangent` + 3-step Step-2 helpers + main lemma) that was EXCISED iter-145.
  The actual code is the Step-1 shear iso + `schemeHomRingCompatibility` + Step-3 iso only.
- **`AlgebraicJacobian/Cotangent/GrpObj.lean:428–525`** — "Helper sub-lemmas and main lemma of
  piece (i.b) … Step 2 PARTIAL iter-137 … (iter-138+ target)" narrates excised work.
- **`AlgebraicJacobian/Cotangent/ChartAlgebra.lean:36–79`** — file header frames the chart-algebra
  route as "the iter-144 chart-algebra pivot route for piece (ii) of the M2.body-pile". Per memory
  this differential / chart route is the off-path fallback (Route C committed iter-163).
- **`AlgebraicJacobian/RigidityKbar.lean:20–29, 70–74`** — status block presents `rigidity_over_kbar`
  as "the keystone classical input for M2.a"; per memory it's now the fallback route (a) artifact
  superseded by upstream `rigidity_genus0_curve_to_grpScheme`. Note that the `[CharZero kbar]`
  instance is correctly retained for the artifact.
- **`AlgebraicJacobian/Jacobian.lean:237–263`** — the 3-gate "IMPORT CYCLE / CHAR-`p` GAP /
  BASE-CHANGE" analysis inside `genusZeroWitness.key`'s `sorry` is partially superseded. Gates
  (1) and (2) are resolved by the iter-156+ creation of `AbelianVarietyRigidity.lean` (upstream
  of `Jacobian.lean`, char-general). Gate (3) (base-change functor) is still live if `k → k̄`
  descent is wanted. The `sorry` body retention is correct; only the explanatory narrative is
  stale.

These are SECONDARY — none blocks iter-165's main lane. If iter-165 has bandwidth after the
api-alignment + scaffold + scaling-shortcut work, queue a single "stale-narrative purge" refactor
that touches only comments/docstrings in the 4 files above. Do not let them accumulate further.

## MEDIUM — Source-A-side dead-instance hygiene follow-up on `av_regularMap_isHom_of_zero`

The lean-auditor flagged that the pre-existing `[Smooth A.hom]` / `[GeometricallyIrreducible A.hom]`
on the SOURCE A-side of `av_regularMap_isHom_of_zero` (not introduced this iter) are ALSO unused
in the body. iter-164 dropped only the symmetric target-B-side (knock-on of the Cor 1.5 drop) to
keep the change minimal. A future small hygiene lane can drop these too — strictly a
generalization. Defer until next time the file is touched for substantive work; not blocking.

## LOW — Promote three Lean-only helpers to `\lean{…}` blocks in `AbelianVarietyRigidity.tex`

The lean-vs-blueprint-checker noted that `rigidity_snd_lift`, `snd_left_isClosedMap`, and
`rigidity_core` are mentioned by name in the chapter but lack their own `\lean{…}` blocks under
`rmk:rigidity_lemma_decomposition`. Adding them is a small writer pass — coverage 12/14 → 14/14.
Acceptable as-is (the checker classifies them as helpers), so this is genuinely low priority.

## LOW — Reconcile `isIntegral_of_retract` proof-prose divergence in the blueprint

The Lean proof uses the per-stalk route; the blueprint prose at L580–584 describes the
global-sections split-injection route. Both are mathematically sound; the pre-existing NOTE at
L562–568 already flags this. A future writer pass could align the prose to the actual stalk-level
proof, but it does NOT block anything.

## Do NOT retry approaches

- **Theorem of the cube, Milne Thm 3.2 / Lemma 3.3, `Hom(𝔾ₐ, A) = 0`, the 𝔾ₐ-additive route** —
  all OFF the genus-0 critical path under the committed 𝔾ₘ-scaling shortcut. Do NOT redirect any
  prover to these for the genus-0 path. (Thm 3.2's codim-1 half remains a Route-A scaffold
  pointer for the Albanese UP, not a genus-0 prerequisite.)
- **The proven Rigidity-Lemma chain bodies** (`rigidity_lemma`, `rigidity_core`,
  `rigidity_eqOn_dense_open`, `rigidity_eqOn_saturated_open_to_affine`,
  `morphism_eq_of_eqAt_closedPoints`, `eq_comp_of_isAffine_of_properIntegral`,
  `isIntegral_of_retract`, `rigidity_eqAt_closedPoint_of_proper_into_affine`,
  `hom_additive_decomp_of_rigidity`, `av_regularMap_isHom_of_zero`) — all axiom-clean. Do NOT
  touch their bodies. Generalizations of hypotheses are OK; tightening would be regression.
- **Another hygiene-only lane** on `AbelianVarietyRigidity.lean` — would CHURN. iter-165 must
  convert to depth (per the progress-critic verdict).

## Reusable proof patterns discovered

(Carried forward from prior iters — re-recorded under PROJECT_STATUS Knowledge Base, not duplicated
here. iter-164 itself did not introduce new proof techniques.)
