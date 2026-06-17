# Iter-195 — Detailed per-lane objectives (revised post-critic)

8 prover lanes (Pic0AV + Lane B dropped per critic must-fix).
Push-beyond-HARD-BAR framing per iter-192 standing user hint applies
to all 8 lanes.

---

## Lane H (#1) — `H1Vanishing.lean` — SAb.Exact direct attack

**Mode**: [prover-mode: mathlib-build]
**Helper budget**: 2 (REDUCED per progress-critic CHURNING must-fix)

### Context

iter-194 isolated the residual to a single typeclass-shaped goal at
L462: `SAb.Exact` where `SAb := S.map (sheafCompose J (forget₂
ModuleCat AddCommGrpCat))`. `Mono SAb.f` + `Epi SAb.g` axiom-clean
inline. Lane H has produced 3 consecutive PARTIALs (helpers added each
iter).

### Recipe

Two viable project-side routes:

**Route A** (~50-100 LOC): `(sheafCompose J (forget₂ _ _)).PreservesHomology`
via `forget₂` preserves finite limits + colimits + lift through
`sheafCompose`. Standard abelian-category exactness preservation
machinery.

**Route B** (~70-120 LOC): Stalkwise — exactness of sheaves of abelian
groups detected on stalks; stalks transfer under `forget₂` because
`forget₂` is faithful exact + preserves filtered colimits.

### HARD BAR

Close `SAb.Exact` axiom-clean.

### EXPLICIT CONSTRAINT (per progress-critic must-fix)

If `SAb.Exact` resists after **2 helpers**, INCOMPLETE the lane. Do
NOT pile more substrate. One more PARTIAL with helpers escalates Lane
H to STUCK protocol.

### PUSH-BEYOND

Once `SAb.Exact` is axiom-clean, propagate to
`HModule_flasque_eq_zero` (L572-636) `i = 1` + `i ≥ 2` cases via the
now-axiom-clean `shortExact_app_surjective`.

Blueprint: `chapters/RiemannRoch_H1Vanishing.tex`.

---

## BareScheme (#2) — `BareScheme.lean` — scaffold close (HARD GATE CLEARED)

**Mode**: [prover-mode: mathlib-build]
**Helper budget**: 3

### Context

iter-195 plan-phase landed blueprint coverage:
`lem:projectiveLineBar_smoothOfRelDim` + `lem:projectiveLineBar_geomIrred`
at `AbelianVarietyRigidity.tex:951-993`. HARD GATE cleared via fastpath.

### Recipe (`projectiveLineBar_smoothOfRelDim`)

`ProjectiveLineBar kbar` = `Proj (MvPolynomial.homogeneousSubmodule (Fin 2) kbar)`.
2-chart cover by `D₊(X 0)` and `D₊(X 1)` (already named in file).
Each chart is `Spec(k̄[t])` via the polynomial ring presentation.
Build `SmoothOfRelativeDimension 1 (ProjectiveLineBar kbar).hom`:

1. `Smooth.of_openCover` with the 2-chart cover.
2. Each chart: `Smooth_Spec_of_isStandardSmooth` +
   `RingHom.IsStandardSmooth.Polynomial` for `k̄[t]`.
3. Lift `Smooth` to `SmoothOfRelativeDimension 1` via the single
   generator `t` of the polynomial ring.

### Recipe (`projectiveLineBar_geomIrred`)

`Proj (k̄[X, Y])` over algebraically closed `k̄`: `k̄[X, Y]` is integral
domain → `Proj` is integral; base change to any field extension `K`
preserves integrality (since `K[X, Y]` is integral domain over `K`);
geometrically irreducible.

### HARD BAR

≥1 of the 2 scaffold sorries closed axiom-clean (≥30 LOC).

### PUSH-BEYOND

Close BOTH. Cascade unlocks:
- Lane I `instIsRegularInCodimOneProjectiveLineBar` via `Smooth ⟹
  IsRegularLocalRing ⟹ DVR-at-codim-1`.
- Lane RCI helper (a) per-fibre LQF via "smooth-dim-1 ⟹ 0-dim fibre".

Blueprint: `AbelianVarietyRigidity.tex` (consolidated; covers
BareScheme.lean).

---

## Lane E (#3) — `AbelianVarietyRigidity.lean` — ANALOGUE-DRIVEN

**Mode**: [prover-mode: mathlib-build]
**Helper budget**: 3

### Context

iter-195 dispatched `mathlib-analogist lane-e-proj-appiso-pivot` and
received ANALOGUE_FOUND verdict. **Persistent file**:
`analogies/lane-e-proj-appiso-pivot.md` — READ THIS BEFORE EDITING.

Mathlib's `IsAffineOpen.fromSpec_app_self`
(`Mathlib/AlgebraicGeometry/AffineScheme.lean:560-564`) is the same
structural shape: `Proj.awayι 𝒜 f f_deg hm = basicOpenIsoSpec.inv ≫
basicOpen.ι` matches `IsAffineOpen.fromSpec = isoSpec.inv ≫ U.ι`. The
proof technique transports verbatim.

### Recipe (30-50 LOC total; 3 helpers per analogist's analysis)

**Helper 1** (~5-10 LOC) — `Proj.awayι_isoSpec_compat`:

```
basicOpenIsoSpec.hom = hU.isoSpec.hom ≫ Spec.map basicOpenIsoAway.hom
```

where `hU := isAffineOpen_basicOpen 𝒜 f f_deg hm`. Via
`basicOpenToSpec` + `awayToSection` definitions.

**Helper 2** (~10-15 LOC) — `Proj.awayι_app_basicOpen` (mirror of
`fromSpec_app_self`):

```
(Proj.awayι 𝒜 f f_deg hm).app (Proj.basicOpen 𝒜 f) =
  (Proj.basicOpenIsoAway 𝒜 f f_deg hm).inv ≫
  (Scheme.ΓSpecIso _).inv ≫
  (Spec _).presheaf.map (eqToHom <proof_preimage>).op
```

Via `comp_app` on `awayι = basicOpenIsoSpec.inv ≫ basicOpen.ι` +
`basicOpenIsoSpec_hom` (helper 1) + `basicOpenToSpec_app_top`
(already in Mathlib).

**Helper 3** (~5-10 LOC) — `Proj.awayι_appIso_top_inv_apply_isLocElem`:

```
(Proj.awayι 𝒜 f f_deg hm).appIso ⊤ .inv isLocElem =
  presheaf.map(eqToHom).op (basicOpenIsoAway.hom ((ΓSpecIso _).hom isLocElem))
```

Via `Scheme.Hom.appIso_hom` + `Iso.eq_inv_apply` + `awayToSection_apply`.

**Drop-in** (~5 LOC each): apply helper 3 to close
`kbarChart1Ring_specMap_fac` (L273) AND `iotaGm_chart1_appIso_eval`
(L481).

### HARD BAR

≥1 of the 2 sorries (`kbarChart1Ring_specMap_fac` OR
`iotaGm_chart1_appIso_eval`) closed axiom-clean via the analogue
recipe.

### PUSH-BEYOND

- Close BOTH via the shared helper 3.
- Close `kbarChart1Ring_pullback_collapse` (L439) via `pullbackSpecIso`.
- File 3 → 0 (transitively; only standing RR-bridge gate remains).

### CRITICAL constraint (per progress-critic STUCK protocol)

If the analogue recipe fails after 3 helpers, INCOMPLETE the lane
with a precise gap report. The iter-196 plan agent will USER-escalate
(the iter-188-194 STUCK + analogue-confirmed route failure = the
strategy is wrong).

Blueprint: `chapters/AbelianVarietyRigidity.tex`.

---

## Lane I (#4) — `WeilDivisor.lean` — substrate cleanup (UNCONDITIONAL FALLBACK)

**Mode**: [prover-mode: prove]
**Helper budget**: 2

### Context

iter-194 closed `instIsLocallyNoetherianProjectiveLineBar`; the other
typed-sorry instance `instIsRegularInCodimOneProjectiveLineBar`
(L709) is contingent on BareScheme `smoothOfRelDim` closure.

### Primary objective (if lane #2 closes BareScheme `smoothOfRelDim`)

Close `instIsRegularInCodimOneProjectiveLineBar` (L709) via
`Smooth ⟹ IsRegularLocalRing ⟹ DVR-at-codim-1` chain. ~10-30 LOC.

### Unconditional fallback (if lane #2 INCOMPLETE)

Continue body Y₀ pull-through cleanup on
`degree_positivePart_principal_eq_finrank` OR close the f=0 branch
substrate. Surface precise gap statements for iter-196 attack.

### HARD BAR

≥1 axiom-clean closure OR substantive structural advance.

### PUSH-BEYOND

Close `instIsRegularInCodimOneProjectiveLineBar` AND attempt body via
`Hom.ofFunctionFieldEmbedding` substrate (iter-196+ Lane I directive
but available as push if BareScheme lands early).

Blueprint: `chapters/RiemannRoch_WeilDivisor.tex` §6.

---

## Lane F (#5) — `QuotScheme.lean` — Beck-Chevalley (post-refactor)

**Mode**: [prover-mode: prove]
**Helper budget**: 2

### Context

iter-195 plan-phase refactor `lane-f-step12-sigma-pair` LANDED:
- `step1` (`tildeIso_of_isQuasicoherent_isAffineOpen`, Stacks 01I8)
  signature now Σ-pair-typed.
- `step2` (`pullback_tildeIso`, Stacks 01HQ) signature now Σ-pair-typed.
- Both carry iso-characterizing identities.
- Build GREEN; +0 sorries.

### Recipe

Beck-Chevalley intertwining at `1 ⊗ₜ x` in
`pullback_app_isoTensor_baseMap_sectionLinearEquiv` (L815-area).
Now consumable via the Σ-pair identities: `rw [step1.2, step2.2]` +
`simp` chase. ~10-30 LOC.

### HARD BAR

≥1 axiom-clean closure (Beck-Chevalley OR another QuotScheme
residual; 12 total sorries; mostly mechanical).

### PUSH-BEYOND

Close Beck-Chevalley intertwining + 1-2 additional mechanical
typeclass-wiring residuals.

Blueprint: `chapters/Picard_QuotScheme.tex`.

---

## Lane A OCofP (#6) — `OCofP.lean` — unconditional fallback objectives

**Mode**: [prover-mode: prove]
**Helper budget**: 2

### Context

Per progress-critic must-fix: **decouple from Lane H gating**
(deferral phrase persisted ≥4 iters). 3 sorries:
- L1147 `h1_vanishing_genusZero` — cascade target if Lane H lands.
- L1209 `h0_sub_h1_lineBundleAtClosedPoint_eq_two` — χ-arithmetic
  helper.
- L1323 `exists_nonconstant_rational_from_dim_eq_two` — linear
  algebra + principal divisor; partial setup `s₁` from iter-194.

### Unconditional objectives

Attempt the 2 named substrate helpers INDEPENDENTLY of Lane H
cascade:
- L1209 χ-arithmetic helper — smaller; project-side.
- L1323 rational-from-dim helper — partial setup committed.

### Cascade objective (if Lane H lands)

Close `h1_vanishing_genusZero` (L1147) via the now-axiom-clean
`HModule_flasque_eq_zero`. Direct instance synthesis.

### HARD BAR

≥1 closure OR ≥1 substantive structural advance on the 2 substrate
helpers.

### PUSH-BEYOND

Close 2 of 3 sorries (any combination). If both Lane H cascade AND a
substrate helper close, near-complete file.

Blueprint: `chapters/RiemannRoch_OCofP.tex`.

---

## Lane RCI (#7) — `RationalCurveIso.lean` — `?hLPUnif` only (SCOPED)

**Mode**: [prover-mode: prove]
**Helper budget**: 1 (REDUCED per progress-critic STUCK + OVER_BUDGET)

### Context

iter-194 refactor v2 introduced typed sorry at L521 for `?hLPUnif`
(uniformiser hypothesis required by corrected Lane I signature).
Witness is `(localParameterAtInfty kbar).val` (named in consumer
L560-562).

### Recipe

Destructure `localParameterAtInfty` construction's uniformiser /
unique-zero property. Discharge `?hLPUnif` directly.

### HARD BAR

Close `?hLPUnif` axiom-clean.

### EXPLICIT CONSTRAINT

Do NOT attempt helper (a) per-fibre LQF (gated on BareScheme cascade)
or helper (d) IsNormalScheme (iter-196 mathlib-analogist Route B).
Scope strictly to `?hLPUnif`.

Blueprint: `chapters/RiemannRoch_RationalCurveIso.tex`.

---

## Lane G (#8) — `AuslanderBuchsbaum.lean` — minimal n=k+1 carving

**Mode**: [prover-mode: prove]
**Helper budget**: 1

### Context

Per progress-critic CONVERGING + n=k+1 deferral approaching STUCK
sub-goal threshold (3 consecutive iters of same deferral language).
iter-194 closed n=0 (file 2 → 1); n=k+1 at L1125 remains.

### Objective

Minimal commit: either (a) ≥1 substantive structural sub-step on
n=k+1 OR (b) propagate the lane to a clean state with precise n=k+1
sub-task carving + concrete iter-196 re-engagement timeline.

NO closure required.

### HARD BAR

Any substantive structural commit (carving or sub-step).

### PUSH-BEYOND

Close the minimal-finite-free-resolution carving sub-lemma (Stacks
090V chain).

Blueprint: `chapters/Albanese_AuslanderBuchsbaum.tex`.

---

## Lanes DROPPED from iter-195 dispatch

### Pic0AbelianVariety.lean — DROPPED

Reason: carrier-soundness refactor pulled forward to iter-196 (per
`analogies/carrier-soundness-design.md`). Committing partial body
proofs against `Pic0Scheme := sorry` carrier produces rework when
the refactor lands. Re-engages iter-196+.

### GmScaling.lean (Lane B) — DROPPED

Reason: progress-critic CHURNING + Lane E STUCK contingency.
Decoupled from Lane E; re-engages once Lane E ANALOGUE-driven route
lands (likely iter-196 cascade closure).

### IdentityComponent.lean (Lane A.3.i) body — DROPPED

Reason: `mathlib-analogist lane-a3i-stacks-04kv` returned
NEEDS_MATHLIB_GAP_FILL (0 ALIGN_WITH_MATHLIB on Stacks 037Q + 04KU
+ 04KV + field-tensor-product). iter-196 candidate: USER escalation
or Mathlib upstream PR (Route B ~350 LOC).

### CodimOneExtension.lean (Lane M↓) — STUCK protocol; not dispatched

Reason: Stacks 00OE + 02JK + 0AVF unowned. iter-200 broad sweep
candidate.

### RRFormula.lean — OFF-CRITICAL-PATH; iter-196+ cleanup

Reason: 1 residual sorry; bandwidth allocated to closure-shaped
lanes this iter.
