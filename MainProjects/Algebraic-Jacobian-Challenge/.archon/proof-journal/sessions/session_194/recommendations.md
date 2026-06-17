# Recommendations for the next plan iteration (iter-195)

## CRITICAL / HIGH

### 1. Carrier-soundness refactor — iter-195 should LAND it now (no further deferrals)

**Status**: iter-193 lean-auditor flagged 7+ load-bearing typed-`:= sorry`
definition carriers (`Pic0Scheme`, `PicScheme`, `QuotScheme`, `picSharp`,
`divFunctor`, `abelMap`, `PicSharp`, `presheaf`, `PicSharp.etSheaf`).
iter-194 plan-phase DEFERRED this to iter-195+, citing blast radius
across 5 files + Pic0AbelianVariety.lean re-shape + an unsubstantiated
iter-193 single-line "existential reshape" recommendation.

**iter-195 directive (HIGH)**: Either (a) dispatch the
`pic-quot-relpic-carrier-soundness` refactor with mathlib-analogist
preceding consult to validate the existential-bundle pattern (NOT
deferred to iter-200); or (b) explicitly remove the iter-195
commitment in STRATEGY.md and replace with a concrete iter-200+
calendar slot — the current "iter-195+ pending design analysis" is
sliding. The iter-194 plan-phase noted "exposure is latent, not
active" but the latency exists ONLY because Pic0AbelianVariety.lean
and IdentityComponent.lean's `:= sorry` consumers are also
sorry-bodied. As soon as a downstream prover lane attempts a
substantive Pic0AbelianVariety body close, the carrier shape becomes
load-bearing AND the silent sorryAx propagation activates. Better to
land the refactor *before* prover work on those files begins
iter-195+.

### 2. Lane I body close — Re-attempt with the proper substrate

**Status**: iter-194 closed 1 of 2 owed typed-sorry typeclass
instances (`instIsLocallyNoetherianProjectiveLineBar`). The other
(`instIsRegularInCodimOneProjectiveLineBar`) is blocked on the
project-side `projectiveLineBar_smoothOfRelativeDimension` scaffold
sorry in `BareScheme.lean:154-156`. The main lemma
`degree_positivePart_principal_eq_finrank` body is blocked on
`Scheme.Hom.ofFunctionFieldEmbedding` constructor (Hartshorne
I.6.12) which is a Mathlib gap.

**iter-195 directive**: Two viable routes —
(a) Close `projectiveLineBar_smoothOfRelativeDimension` (BareScheme
substrate, ~30-50 LOC project-side) — this unlocks
`instIsRegularInCodimOneProjectiveLineBar` via the `Smooth ⟹
IsRegularLocalRing ⟹ IsDiscreteValuationRing-at-codim-1` chain. Should be
this iter's Lane I directive.
(b) Build `Scheme.Hom.ofFunctionFieldEmbedding` project-side (~80-120
LOC) — unlocks the affine-chart `Spec(B) := φ⁻¹(Spec(A))` bridge to
`Ideal.sum_ramification_inertia`. Bigger lift; suitable for an
iter-196+ dedicated lane.

### 3. Lane H `shortExact_app_surjective` SAb.Exact — Direct attack route

**Status**: iter-194 narrowed the residual to a single typeclass
goal: `(sheafCompose J (forget₂ ModuleCat AddCommGrpCat)).PreservesHomology`
(or `PreservesRightHomologyOf S`). The bridge is structurally
isolated — Mono, Epi, IsFlasque transfer are all axiom-clean. This is
the **highest-leverage iter-195 closure target** because it directly
unlocks `HModule_flasque_eq_zero` (transitive), and via that the H¹
chain in `OCofP.lean`'s `h1_vanishing_genusZero` (Lane A).

**iter-195 directive**: Dispatch Lane H with a tight focused
directive — close the `PreservesHomology` instance via "forget₂
preserves all finite limits/colimits" + lift to `sheafCompose`. Two
candidate routes documented (Route A 50-100 LOC; Route B stalks-detect
70-120 LOC). NOT a Mathlib gap; this is project-side feasible.
Helper budget = 2.

### 4. Pic0 carrier-soundness blocks Pic0AbelianVariety.lean prover work

**Status**: Pic0AbelianVariety.lean has 5 typed sorries on the 5
chapter pins; each consumes `Pic0Scheme C` which is itself a `:=
sorry` carrier. iter-194 plan-phase listed Pic0AV as DEFERRED gated
on carrier-soundness refactor.

**iter-195 directive**: If recommendation #1 is acted on (refactor
LANDS iter-195), then iter-195 OR iter-196 can begin Pic0AV first
body close. If recommendation #1 slips again, escalate
Pic0AbelianVariety.lean to "STALLED" status in STRATEGY.md (currently
in `partial: A.3.iii-vi` row).

## MEDIUM

### 5. Lane F step1/step2 Σ-pair signature refactor

**Status**: iter-194 Lane F landed Steps a-c LinearEquiv extraction
axiom-clean; the Beck-Chevalley intertwining residual is provably
blocked on `step1`/`step2` opaque `Nonempty (... ≅ ...)` bodies.

**iter-195 directive**: Dispatch a `refactor lane-f-step12-sigma-pair`
to reshape `step1` (`tildeIso_of_isQuasicoherent_isAffineOpen`,
Stacks 01I8) and `step2` (`pullback_tildeIso`, Stacks 01HQ)
signatures to Σ-pair form carrying the canonical iso-characterizing
identity. ~10-15 LOC per pin. Bodies stay typed sorry but consumers
can use the identity to close Beck-Chevalley.

### 6. Lane E pivot needs Mathlib `Proj.appIso` corollary

**Status**: iter-193 pivot (`IsOpenImmersion.lift_uniq`) narrowed the
chart-1 evaluation residual but did NOT eliminate the opaque
`Proj.appIso ⊤ .inv` on `isLocElem` evaluation. iter-194 inner sorry
of `kbarChart1Ring_specMap_fac` is now the same content as
`iotaGm_chart1_appIso_eval` (single chart-`1` ring-map identity).

**iter-195 directive**: Search/contribute a Mathlib corollary
evaluating `Proj.awayι.appIso ⊤ .inv` on `isLocElem` (via
`basicOpenIsoSpec_inv_ι` + `Scheme.Hom.appIso` of open-immersion
composition). If not in Mathlib, project-side build ~30-50 LOC. Lane
E + Lane B share this idiom blocker; closing it unlocks BOTH.

### 7. Lane G n=k+1 inductive step — Multi-iter substrate work

**Status**: iter-194 closed the n=0 branch via
`Module.depth_pi_const_eq_depth_of_nonempty` axiom-clean. n=k+1
branch (L1125) requires 4 Mathlib substrate pieces (minimal finite
free resolutions, Stacks 00MF "what is exact", snake-lemma on
resolutions, depth-drops-by-one).

**iter-195 directive**: Lane G is OFF-CRITICAL-PATH per PROGRESS.md
(A.4.b uses direct regular-sequence path). DO NOT prioritise the
n=k+1 step. The iter-194 n=0 closure is a clean milestone; leave the
file at 1 sorry until iter-200+ analogist sweep or future
project-priority shift.

## LOW

### 8. Lane M↓ stays in iter-200 holding pattern

Lane M↓ HARD BAR was met via "precise gap surface" route per the
plan-phase progress-critic STUCK protocol. The 3 sorries remain at
the same precise Mathlib-gap surface. Do NOT dispatch Lane M↓ in
iter-195 — wait for iter-200 mathlib-analogist sweep verdict on
Stacks 00OE, 02JK, 0AVF.

### 9. Lane B `gmScalingP1_collapse_at_zero` — gated on Lane E idiom

Lane B's second sorry shares the chart-1 ring-map evaluation idiom
blocker with Lane E (recommendation #6). When Lane E lands, Lane B
follows.

### 10. Lane A.3.i `geometricallyConnected_of_connected_of_section` —
fully gated

Stacks 04KV + field-tensor-product criterion are both Mathlib gaps.
iter-194 reduced to precise surface; do NOT redispatch Lane A.3.i
body close in iter-195. The instance demotion (iter-194 HARD BAR
deliverable) cleared the lean-auditor must-fix; iter-200
mathlib-analogist sweep is the right venue for Stacks 04KV.

### 11. Lane RCI helper (a) per-fibre LQF — Mathlib gap on smooth-curve-fibre

iter-194 reduced `phi_left_locallyQuasiFinite_of_finrank_one` body
via `LocallyQuasiFinite.of_fiberToSpecResidueField` to a per-fibre
case. The per-fibre case ("smooth-dim-1 ⟹ 0-dim fibre") is a Mathlib
gap. iter-200 mathlib-analogist sweep candidate.

### 12. CodimOneExtension `private theorem` access — iter-196 cleanup

The plan-phase fast-path `blueprint-reviewer iter194-fastpath`
flagged a MEDIUM quality issue: `\lean{...}` pins on
`lem:module_free_kaehler_localization` and
`lem:rank_kaehler_localization_eq_relative_dim` reference
`AlgebraicGeometry.Scheme.module_free_kaehlerDifferential_localization`
and
`AlgebraicGeometry.Scheme.rank_kaehlerDifferential_localization_eq_relativeDimension`,
both declared `private`. Blueprint tooling cannot machine-verify
private declarations; no `\leanok` claimable on these blocks until
declarations are promoted. **iter-196 cleanup directive**: drop
`private` on both helpers, OR add a `% NOTE` on the chapter blocks
acknowledging they are intentionally private (in which case `\leanok`
stays absent and the pin is documentary-only).

## Reusable proof patterns discovered iter-194

1. **forget₂ bridge** from `Sheaf J (ModuleCat kbar)` to `Sheaf J
   AddCommGrpCat` for module-valued sheaf SES surjectivity / Mono /
   Epi work (Lane H).
2. **`Module.depth_pi_const_eq_depth_of_nonempty`** as canonical
   substrate for depth-via-free-rank arguments (Lane G).
3. **Closed-points reduction** via `JacobsonSpace.closure_closedPoints`
   for global topological range-containment proofs (Lane B).
4. **`IsProper.toLocallyOfFiniteType` + `LocallyOfFiniteType.isLocallyNoetherian`** chain for proper-over-Noetherian-base regularity prep (Lane I).
5. **Instance demotion** as a clean soundness fix when the instance
   body invokes `sorryAx` transitively (Lane A.3.i, lean-auditor
   must-fix recipe).
6. **`LocallyQuasiFinite.of_fiberToSpecResidueField`** reduces LQF of
   a scheme morphism to per-fibre LQF on
   `f.fiberToSpecResidueField y` (Lane RCI).
7. **Bare `sorry` → `by` block + axiom-clean preparatory derivations
   + precise gap-surface docstring** when full body close is gated on
   a Mathlib gap. Used in Lane M↓ for 3 sorries: each body now
   compiles with concrete inline gap documentation + named upstream
   substrate references. PROTOCOL: do NOT regress sorry count when
   the alternative is a full structural refactor (Lane M↓
   `extend_of_codimOneFree_of_smooth` Attempt 2 backed off because it
   regressed 1 → 3).
8. **Carving consumer-facing theorems through named substrate
   helpers** (Lane A OCofP): when a consumer body has multiple
   substantive sub-pieces, carve each into a named helper consuming
   only the relevant hypotheses. The consumer body becomes a clean 1-3
   line invocation chain; future provers attack the helpers
   independently.

## Targets to NOT re-dispatch in iter-195

- **Lane M↓ `isRegularLocalRing_stalk_of_smooth` body close** — gated
  on Stacks 00OE Mathlib gap; STUCK protocol applies.
- **Lane H `injective_flasque`** — gated on `j_!` Mathlib
  infrastructure; iter-200 mathlib-analogist sweep candidate.
- **Lane RCI `phi_left_fromNormalization_isIso`** — gated on
  project-side `IsNormalScheme` substrate; iter-200 candidate.
- **Lane A.3.i `geometricallyConnected_of_connected_of_section` body
  close** — Stacks 04KV gap; iter-200 candidate.
- **Lane G n=k+1 inductive step** — multi-iter substrate; off-critical-path.

## Iter-195 sorry projection

Entering iter-195 prover phase: **88 sorries / 0 axioms** (build
GREEN). With recommendations 2, 3, 5 actioned this iter (with
carrier-soundness refactor possibly +0..+5 sorrys from re-shape, but
net mathematical content unchanged):

- **Best case** (all 5 active lanes HARD BAR + ≥2 push-beyond closures
  including Lane H SAb.Exact + Lane I instance #2): 88 → ~80-83 (−5
  to −8).
- **Realistic** (3-4 HARD BARs + 1 push-beyond): 88 → ~84-87 (−1 to −4).
- **Worst** (Lane H + Lane I body close fail; only mechanical lanes
  yield): 88 → ~86-88 (−0 to −2).

Target: realistic-or-best band.
