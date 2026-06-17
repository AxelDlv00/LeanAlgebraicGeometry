# Iter-196 — Detailed per-lane objectives (revised post-critics)

6 prover lanes (Lane F deferred to iter-197 per progress-critic
STUCK; Lane G OFF-CRITICAL-PATH; Lane Pic0AV + Lane B + Lane A.3.i
+ Lane M↓ all in off-limits / deferred / excised state).

Push-beyond-HARD-BAR framing per iter-192 standing user hint applies
to all 6 lanes.

---

## BareScheme (#1) — `Genus0BaseObjects/BareScheme.lean` — re-dispatch

**Mode**: [prover-mode: mathlib-build]
**Helper budget**: 3

### Context

iter-195 errored API 529 after ~25 min mathlib scouting; no edits
committed. HARD GATE cleared via iter-195 fastpath (writer landed
`lem:projectiveLineBar_smoothOfRelDim` + `lem:projectiveLineBar_geomIrred`
at AbelianVarietyRigidity.tex:951-993). Re-dispatch is mandatory.

### Recipe (`projectiveLineBar_smoothOfRelDim`)

`ProjectiveLineBar kbar` = `Proj (MvPolynomial.homogeneousSubmodule (Fin 2) kbar)`.
2-chart cover by `D₊(X 0)` and `D₊(X 1)` (already in file via
`projectiveLineBar_cover`). Each chart `Spec(k̄[t])` via the polynomial
ring presentation.

1. `Smooth.of_openCover` with the 2-chart cover.
2. Each chart: `Smooth_Spec_of_isStandardSmooth` +
   `RingHom.IsStandardSmoothOfRelativeDimension.Polynomial` for `k̄[t]`.
3. Lift to `SmoothOfRelativeDimension 1` via the single generator `t`.

### Recipe (`projectiveLineBar_geomIrred`)

`Proj (k̄[X, Y])` over algebraically closed `k̄`: `k̄[X, Y]` is integral
domain → `Proj` is integral; base change to any field extension `K`
preserves integrality (`K[X, Y]` is integral domain over `K`);
geometrically irreducible.

### HARD BAR

≥1 of the 2 scaffold sorries closed axiom-clean (≥30 LOC).

### PUSH-BEYOND

Close BOTH. Cascade unlocks Lane I (`isRegularInCodimOneProjectiveLineBar`
via Route 2) + Lane RCI helper (a) per-fibre LQF.

Blueprint: `chapters/AbelianVarietyRigidity.tex` (consolidated; covers
BareScheme.lean).

---

## Lane E (#2) — `AbelianVarietyRigidity.lean` — analogue-driven re-dispatch

**Mode**: [prover-mode: mathlib-build]
**Helper budget**: 3

### Context

iter-195 errored API 529 after ~3.5 min; no edits committed.
iter-196 blueprint-writer `avr-lane-e-recipe` IN FLIGHT (will land
before this lane dispatches) — adds 2 new `\lean{...}` pins
(`Proj.awayι_app_basicOpen`, `Proj.awayι_appIso_top_inv_apply_isLocElem`)
with explicit Mathlib substrate references.

Lane E STUCK 5 iters (0 closures, 9 helpers accumulated iter-191-194).
Progress-critic primary corrective: explicit Lean API specification in
the blueprint — LANDED iter-196 plan-phase.

### Recipe (3 helpers, ~30-50 LOC total)

Per blueprint-writer `avr-lane-e-recipe` (referenced in chapter post-
landing) and `analogies/lane-e-proj-appiso-pivot.md` (persistent
reference):

1. `Proj.awayι_app_basicOpen` (~10-15 LOC) — port of Mathlib's
   `IsAffineOpen.fromSpec_app_self`
   (`Mathlib/AlgebraicGeometry/AffineScheme.lean:560-564`). 4-step:
   (i) unfold `awayι = basicOpenIsoSpec.inv ≫ basicOpen.ι`; (ii)
   `basicOpen.ι ⁻¹ᵁ basicOpen 𝒜 f = ⊤`; (iii) `basicOpenIsoSpec.inv.app
   ⊤ = (basicOpenToSpec.app ⊤)⁻¹` via `basicOpenToSpec_app_top`; (iv)
   simplify.

2. `Proj.awayι_appIso_top_inv_apply_isLocElem` (~5-10 LOC) — point-
   value via `Iso.eq_inv_apply` + `awayToSection_apply`.

3. Drop into `kbarChart1Ring_specMap_fac` (L273) +
   `iotaGm_chart1_appIso_eval` (L481).

### HARD BAR

≥1 of the 2 sorries closed axiom-clean.

### PUSH-BEYOND

Close BOTH + `kbarChart1Ring_pullback_collapse` (L439) via
`pullbackSpecIso`.

Blueprint: `chapters/AbelianVarietyRigidity.tex`. **Persistent file
reference**: `analogies/lane-e-proj-appiso-pivot.md` — read this BEFORE
touching the file.

### Reversal signal

If iter-196 returns 0 closures on Lane E (5+ iters STUCK now), escalate
to USER iter-197 (analogue-confirmed + blueprint-expanded route failed
→ strategy needs reconsideration).

---

## Lane I (#3) — `RiemannRoch/WeilDivisor.lean` — Route 2 post-demotion

**Mode**: [prover-mode: prove]
**Helper budget**: 2

### Context

iter-196 must-fix-demotions refactor LANDED:
`isRegularInCodimOneProjectiveLineBar` is now a theorem (non-private)
— callers (3 RCI consumers) thread via explicit
`[Scheme.IsRegularInCodimensionOne ...]` binder. No silent sorryAx
synthesis.

### Recipe (Route 2, ~50-80 LOC)

Per iter-195 prover comment in body:

Affine-chart `k̄[t]` PID transfer through `projectiveLineBarAffineCover`
(from BareScheme.lean): the 2 charts are isomorphic to `Spec(k̄[t])`, a
PID; PID stalks at maximal ideals are DVRs; transfer back via the
chart-stalk iso.

Sub-steps:
1. For each prime divisor `Y` of `ProjectiveLineBar kbar`, find the
   chart it lives in (`D₊(X 0)` or `D₊(X 1)`).
2. Identify the stalk at `Y.point` with a localization of `k̄[t]` at a
   maximal ideal (PID).
3. Use Mathlib's `IsPrincipalIdealRing.isDiscreteValuationRing` (or
   equivalent name) to get DVR at the maximal localization.
4. Transfer back via the chart-stalk iso (`Proj.basicOpenIsoAway`
   already in scope).

### HARD BAR

Close `isRegularInCodimOneProjectiveLineBar` axiom-clean OR substantive
structural advance on `degree_positivePart_principal_eq_finrank` body.

### PUSH-BEYOND

Close BOTH (`isRegularInCodimOneProjectiveLineBar` + the
`degree_positivePart_principal_eq_finrank` body Hartshorne II.6.9 chain).

Blueprint: `chapters/RiemannRoch_WeilDivisor.tex` §6.

---

## Lane A (#4) — `RiemannRoch/OCofP.lean` — finalize post-blueprint-expansion

**Mode**: [prover-mode: prove]
**Helper budget**: 2

### Context

iter-196 blueprint-writer `ocofp-leanrecipes` LANDED (+368 LOC). 3 new
`\lean{...}` pins for sub-claims (a), (b), (c) of
`exists_nonconstant_rational_from_dim_eq_two` (L1323):

- `lineBundleAtClosedPoint.toFunctionField_injective` — sub-claim (a).
- `lineBundleAtClosedPoint.order_conditions_of_globalSection` — sub-claim (b).
- `WeilDivisor.principal_ne_zero_of_nonconstant` — sub-claim (c).

### Recipe per blueprint chapter (`subsec:lineBundleAtClosedPoint_substrate_substeps`)

**(a) toFunctionField injectivity** (~30-50 LOC): 5-layer composition:
(1) `HModule_zero_linearEquiv` (project bridge); (2)
`sheafToPresheaf.map` (Mathlib `Sheaf.fullyFaithfulSheafToPresheaf`);
(3) `constantSheafAdj.homEquiv` (Mathlib); (4) evaluation at `1 : kbar`
(`LinearMap.applyOneEquiv`); (5) `Subtype.val` (injective on integral
scheme `C`).

**(b) order conditions** (~10 LOC): one-line invocation of
`globalSections_iff_mpr` with witness `⟨s, hf_def.symm⟩` from iter-195
setup.

**(c) principal_ne_zero_of_nonconstant** (~30-50 LOC): contrapositive
via Hartshorne I.3.4 (Stacks 01XU) — `Γ(C, 𝒪_C^×) = k̄^×` on complete
geom-irred curve. `kbar`-linearity of `toFunctionField` (`htF_smul` +
`htF_zero`, in scope) + `hs_not_const` (from iter-195 setup) gives
contradiction.

### HARD BAR

Close (a) + (b) axiom-clean.

### PUSH-BEYOND

Close all 3 sub-claims → `exists_nonconstant_rational_from_dim_eq_two`
body fully closes → cascades to `exists_nonconstant_genusZero`.

Blueprint: `chapters/RiemannRoch_OCofP.tex`
(`subsec:lineBundleAtClosedPoint_substrate_substeps`).

---

## Lane H (#5) — `RiemannRoch/H1Vanishing.lean` — scope-reduced

**Mode**: [prover-mode: mathlib-build]
**Helper budget**: 2

### Context

iter-195 closed `shortExact_app_surjective` axiom-clean. Lane H
CHURNING + OVER_BUDGET per iter-196 progress-critic.

**SCOPE REDUCTION (must-fix iter-196)**: `IsFlasque.injective_flasque`
(L572, ~100-150 LOC Mathlib `j_!` extension-by-zero gap) is EXCISED
from iter-196 scope. Target ONLY:

- `IsFlasque.constant_of_irreducible` (L138).
- `skyscraperSheaf_eq_pushforward_const` (L760).

### Recipe (`constant_of_irreducible`)

For an irreducible topological space `X`, the constant sheaf `U ↦ A`
already satisfies the sheaf condition (nonempty open is connected and
dense; sheaf condition trivializes). Flasque := restriction maps
between nonempty opens are surjective. In the constant sheaf the
restriction map between nonempty opens is identity on `A` — trivially
surjective.

### Recipe (`skyscraperSheaf_eq_pushforward_const`)

Skyscraper sheaf `skyscraperSheaf p A` = pushforward of constant sheaf
along the inclusion `{p} ↪ X`. Standard identification.

### HARD BAR

Close ≥1 of the 2 in-scope sorries axiom-clean.

### PUSH-BEYOND

Close BOTH.

Blueprint: `chapters/RiemannRoch_H1Vanishing.tex`.

### Reversal signal

DO NOT attempt `injective_flasque` (L572) this iter — it's permanently
excluded from in-loop scope per the strategy-critic iter-196 finding.

---

## Lane RCI (#6) — `RiemannRoch/RationalCurveIso.lean` — CONDITIONAL

**Mode**: [prover-mode: prove]
**Helper budget**: 1

### Context

Lane RCI CHURNING + OVER_BUDGET (16+ iters elapsed) per progress-
critic. CONDITIONAL DISPATCH: only attempt close if BareScheme cascade
lands AND new substrate becomes available.

### Trigger condition

If BareScheme prover closes `smoothOfRelDim` OR `geomIrred`, then
Lane RCI helper (a) `phi_left_locallyQuasiFinite_of_finrank_one`
(L870) unblocks via "smooth-dim-1 ⟹ 0-dim fibre".

### Recipe (gated on cascade)

If cascade triggers: close helper (a) body via
`LocallyQuasiFinite.of_fiberToSpecResidueField` + the BareScheme-supplied
smooth structure on `(ProjectiveLineBar kbar).left` → 0-dim fibre at
generic point → locally quasi-finite. ~30-50 LOC.

### HARD BAR

If cascade lands: close helper (a) body OR substantive structural
advance.
If cascade does NOT land: explicit hold-with-rationale + carve any
remaining mechanical sub-step that doesn't depend on BareScheme.

### PUSH-BEYOND

NONE — helper (d) `IsNormalScheme` remains gated on iter-197+ Route B
analogist consult. Do NOT attempt.

Blueprint: `chapters/RiemannRoch_RationalCurveIso.tex`.

---

## Cross-lane carrier-soundness refactor (NOT a prover lane)

`refactor carrier-soundness-fgapic` dispatched plan-phase (in flight).
Targets `Picard/FGAPicRepresentability.lean` — Option A
`Functor.IsRepresentable` re-encoding of 5 `:= sorry` carriers.

This is a **2-3 iter PROBE** per strategy-critic abort criterion. If
iter-198 `lean_verify` still shows silent sorryAx propagation through
typeclass synthesis at touched consumers, REVERT and re-evaluate.

Out of scope this iter: cross-file consumers
(`Pic0AbelianVariety.lean`, `IdentityComponent.lean`, etc.). Those
ride iter-197+ slices conditional on probe success.

Net sorry delta this iter: +0 (5 `:= sorry` carriers → 5 `instance ... :=
⟨sorry⟩` constructors).
