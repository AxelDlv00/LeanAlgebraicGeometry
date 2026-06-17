# Iter-189 Objectives Detail (per-lane work plan)

This document elaborates each lane's iter-189 directive. PROGRESS.md
`## Current Objectives` carries the dispatch-ready summary; this file
holds the per-lane detail.

## Lane A — `RiemannRoch/OCofP.lean` (RR.3) — Subfunctor refactor → Case B close

**Target**: with iter-189 plan-phase refactor agent
`ocofp-subfunctor-restructure` landing `carrierTypeSubfunctor` +
restructured `carrierPresheaf_isSheaf` body via
`CategoryTheory.Subfunctor.isSheaf_iff`, the prover closes the
remaining Case B residual.

**Recipe** (post-refactor):
1. The refactor agent restructures `carrierPresheaf_isSheaf` body
   to call `carrierTypeSubfunctor.isSheaf_iff.mpr` (or equivalent
   Mathlib idiom) with the stalk-locality predicate.
2. The stalk-locality predicate reduces to: for any cover `{U_i}` of
   `U`, any matching family `{s_i : carrier(U_i)}` glues to a unique
   `s : carrier(U)` — proved via irreducibility (any two non-empty
   opens of an irreducible scheme intersect, so the matching values
   coincide on overlaps).
3. The new structure handles `⊥` cleanly: `carrierTypeSubfunctor`
   imposes `(carrier-condition) ∧ (U ≠ ⊥ ∨ f = 0)` at the SET level,
   so the empty-cover case is absorbed in the trivial-at-⊥ part.

**Substrate**: Mathlib at b80f227 has `CategoryTheory.Subfunctor`
(verify location via `lean_local_search Subfunctor`); the
sheaf-condition equivalence is via Subfunctor / sub-presheaf framework.

**HARD BAR**: ≥1 sorry close iter-189. Helper budget = 1.

**Effort**: ~30-60 LOC axiom-clean post-refactor.

**Blueprint**: `chapters/RiemannRoch_OCofP.tex` — iter-189 plan-phase
added `def:lineBundleAtClosedPoint_carrierSubmoduleSheaf` block
pinning iter-188's `⊓ trivAtBot` carrier-refinement wrapper.

---

## Lane I — `RiemannRoch/RationalCurveIso.lean` (RR.4) — both remaining sorries

**Target 1**: `Hom.poleDivisor_degree_eq_finrank` L408 body.

**Recipe**: 5-step `Ideal.sum_ramification_inertia` scaffold per
iter-186 inline doc (~78 LOC). Body choice gives
`degree (principal (φ^* t_∞)) = 0` via
`Scheme.WeilDivisor.principal_degree_zero` once available.

Note from iter-188 directive: degree-via-finrank identification may
need refinement — either:
- Refine body to read `(φ^* t_∞)_0` (positive-part of principal); OR
- Refine helper signature to take positive-part argument.

Decision deferred to the prover; landing the body is the primary
target, signature refinement allowed if necessary.

**Effort**: ~80-130 LOC.

**Target 2** (parallel-startable): `iso_of_degree_one` L651 body via
Pin 3 recipe per `analogies/ratcurveiso-pin3.md`. ~50-100 LOC.

**HARD BAR**: ≥1 sorry close iter-189 (both is best-case; either is realistic).

**Blueprint**: `chapters/RiemannRoch_RationalCurveIso.tex` (PASS).

---

## Lane G2 — `Albanese/AuslanderBuchsbaum.lean` (A.4.b) — joint induction

**Target**: `exists_isSMulRegular_quotient_isRegularLocal_succ`
L1286 body.

**Recipe**: Joint induction Stacks 00NQ + 00NU. The cotangent
dim-drop substrate proven iter-188 G1 (axiom-clean ~150 LOC) provides
the bridge:
- Stacks 00NQ (`IsRegularLocalRing ⟹ IsDomain`) — ~150 LOC.
- Stacks 00NU (Krull's principal ideal theorem for regular quotient) — ~100 LOC.

**Strategy**: induct on Krull dimension. Base case: dimension 0,
trivial. Inductive step: given regular local of dimension n+1, pick
a regular system of parameters; show quotient by the first parameter
is regular local of dimension n (via G1 cotangent dim-drop) AND a
domain (Stacks 00NQ on the quotient).

**Substrate (present at b80f227 per iter-186/187 verification)**:
- `Ideal.mapCotangent`,
- `Submodule.finrank_quotient_add_finrank`,
- `finrank_span_singleton`,
- G1 `finrank_cotangentSpace_quot_span_singleton_succ` (proved
  iter-188).

**HARD BAR**: ≥1 sorry close iter-189.

**Effort**: ~200 LOC kernel-only.

**Blueprint**: `chapters/Albanese_AuslanderBuchsbaum.tex` (PASS).

---

## Lane A.3.i — `Picard/IdentityComponent.lean` — HARD SCOPE CAP scaffold closures

**Target**: close ≥2 of the 5 scaffold sorries from iter-186/187
Path B split:

| Decl | Status iter-188 | iter-189 target |
|---|---|---|
| `isSubgroupHomomorphism` | typed sorry | **CLOSE** |
| `isFiniteTypeGeometricallyIrreducible` | typed sorry | **CLOSE** |
| `baseChangeIso` | typed sorry | secondary |
| `Pic0Scheme.finrank_eq_genus` | typed sorry | secondary |
| `Pic0Scheme.kPoints_iff_kerDegree` | typed sorry | secondary |

**HARD SCOPE CAP** (per progress-critic must-fix):
- ZERO new sorry additions permitted this iter.
- ZERO new helper functions permitted (helper budget = 0).
- If the existing 8 sorries cannot be reduced to ≤6, route
  transitions STUCK iter-190 → structural refactor on
  `IdentityComponent.lean` API shape (likely consult cross-domain-
  inspiration analogist on group-scheme-identity-component
  Mathlib analogues).

**Recipe**:
- `isSubgroupHomomorphism`: define on objects via the group object's
  structure morphisms (mul, inv, one) and on morphisms by naturality;
  this is "definitional" content once the API shape is right.
- `isFiniteTypeGeometricallyIrreducible`: from
  `LocallyOfFiniteType.isLocallyNoetherian` (used iter-188) + the
  Path B split's chapter content on geometric irreducibility of
  connected components of a locally Noetherian scheme.

**HARD BAR**: ≥2 closures (or escalate iter-190 to refactor).

**Effort**: ~80-150 LOC for 2-3 closures.

**Blueprint**: `chapters/Picard_IdentityComponent.tex` (PASS).

---

## Lane A.1.b — `Picard/LineBundlePullback.lean`

**STATUS**: DONE iter-188. Full file axiom-clean (1 → 0). No prover
dispatch iter-189. Migrated to task_done.md.

---

## Lane F — `Picard/QuotScheme.lean` — unbundle Steps 1+3 + close `_sectionLinearEquiv`

**Status update**: Lane F analogist returned (A) STRUCTURAL OK.
`IsBaseChange.of_equiv` is the correct API path; the iter-188 STUCK
pattern was caused by Steps 1+2+3 being bundled into one typed sorry.

**Recipe** (per `analogies/lane-f-isbasechange.md`):

1. Add 2 new named typed-sorry pins to `Picard/QuotScheme.lean`,
   parallel to the existing `pullback_tildeIso` (Step 2, Stacks 01HQ):
   - `tildeIso_of_isQuasicoherent_isAffineOpen` (Step 1, Stacks 01I8):
     `N|_V ≅ tilde Γ(N, V)` on `Spec Γ(X, V)` from `[N.IsQuasicoherent]`
     + `hV : IsAffineOpen V`. Body ~20-40 LOC, owed iter-190+.
   - `pullback_of_openImmersion_iso_restrict` (Step 3): pullback along
     `U.ι` is restriction-to-`U`. Body ~30-50 LOC, owed iter-190+.

2. Refactor `pullback_app_isoTensor_baseMap_sectionLinearEquiv` body
   L630 to pure compositional glue:
   - Apply Step 1 pin to get `N|_V ≅ tilde Γ(N, V)` on `Spec Γ(X, V)`.
   - Apply Step 2 pin (`pullback_tildeIso`) to get tilde of
     base-changed module.
   - Apply Step 3 pin to transport via `hU.isoSpec` back to `U`-sections.
   - Apply `tilde.isoTop` (Mathlib HAS) to evaluate at `⊤`.
   - Naturality of adjunction unit (Mathlib HAS + ~20-40 LOC project glue).

3. Close `_sectionLinearEquiv` body axiom-clean.

**Sorry net**: +1 closed (`_sectionLinearEquiv`) + 2 new pinned typed
sorries = **+1 net**, but 3 INDEPENDENT Mathlib gaps targetable iter-190+
(unbundled from iter-188's single bundled sorry).

**HARD BAR**: ≥1 closure on `_sectionLinearEquiv` body.

**Helper budget**: 2 (the 2 new named typed-sorry pins).

**Effort**: ~50-80 LOC compositional glue + ~30-50 LOC restructure.

**Blueprint**: `chapters/Picard_QuotScheme.tex` — iter-189 plan-phase
added `def:pullback_app_isoTensor_sigma`; iter-190 plan-phase adds
pins for the 2 new Step 1/3 declarations after this iter's prover
landing.

---

## Lane B — `Genus0BaseObjects/Cross01Substrate.lean` (NEW FILE) — Substrate 1

**Status update**: Lane B analogist returned (B) FEASIBLE at 80-200
LOC. iter-188 USER-SILENT FALLBACK Option B confirmed feasible.

**Recipe** (per `analogies/lane-b-substrate.md` §2 — 6 steps):

Substrate 1 signature:
```lean
theorem IsClosedImmersion.lift_iff_range_subset
    {X Y Z : Scheme.{u}} (i : Z ⟶ X) [IsClosedImmersion i] [IsReduced Z]
    (g : Y ⟶ X) [QuasiCompact g] [IsReduced Y] :
    (∃ h : Y ⟶ Z, h ≫ i = g) ↔ Set.range g.base ⊆ Set.range i.base
```

Proof structure:
1. (⇒) trivial range pushdown.
2. (⇐) Step 1: `range i.base = i.ker.support` (via `range_subschemeι`
   transported through `i = subschemeι (i.ker)` up to iso).
3. Step 2: `g.ker.support = closure (range g) ⊆ i.ker.support` (target
   side is closed, so `closure_minimal` applies).
4. Steps 3-4: `Y` reduced ⟹ `g.ker` is radical (and similarly `i.ker`
   from `Z` reduced) — via `ker_apply` reduction to ring kernels.
5. Step 5: Galois-connection chain
   `i.ker = i.ker.radical = vanishingIdeal i.ker.support
     ≤ vanishingIdeal g.ker.support = g.ker.radical = g.ker`.
6. Step 6: apply `IsClosedImmersion.lift`.

**Mathlib primitives** (all shipped at b80f227):
- `IsClosedImmersion.lift` + `lift_fac` / `lift_fac_assoc`.
- `Scheme.Hom.ker` + `ker_apply` (under `[QuasiCompact f]`).
- `Scheme.Hom.support_ker` (under `[QuasiCompact f]`).
- `IdealSheafData.vanishingIdeal_support` (the Galois pin).
- `IdealSheafData.gc` (`GaloisConnection support vanishingIdeal`).
- `IdealSheafData.range_subschemeι`.
- `IdealSheafData.radical`.

**File creation**: NEW file `AlgebraicJacobian/Genus0BaseObjects/Cross01Substrate.lean`
with imports `BareScheme`, `Points`,
`Mathlib.AlgebraicGeometry.IdealSheaf.Basic`,
`Mathlib.AlgebraicGeometry.Morphisms.ClosedImmersion`,
`Mathlib.AlgebraicGeometry.Morphisms.QuasiCompact`.

**HARD BAR**: ≥1 closure (Substrate 1 body axiom-clean).

**Helper budget**: 0 (no new helpers; close the body directly).

**Effort**: ~40-60 LOC kernel-only.

**Blueprint**: NO chapter yet. iter-190 plan-phase will write
`Genus0BaseObjects_Cross01Substrate.tex` chapter post landing.
**Source for prover**: `analogies/lane-b-substrate.md` §2 (full proof
structure + Mathlib citations).

**Sorry net**: -0 from iter-188 (this is a NEW substrate file; the
GmScaling.lean consumer sorries iter-190+).

**iter-190+ phased delivery**:
- iter-190: Substrate 2 (`gmRing_tensor_homogeneousAway_isDomain`
  ~50-80 LOC via localization-polynomial iso chain).
- iter-191-193: GmScaling.lean consumer closures (cross01 + gm_geomIrred
  + projGm_isReduced, ~65-105 LOC total).

---

## Off-limits / deferred lanes (HALTED iter-189)

### Lane E — `AbelianVarietyRigidity.lean`

HALTED iter-189 per progress-critic STUCK verdict + Lane E analogist
PROCEED-with-refactor verdict. iter-190 plan-phase will dispatch:
1. `refactor` on `iotaGm_onePt_chart1_factor` packaging (extract
   `iotaGm_r_1` def + paired lemmas + range-containment lemma).
2. Prover `r_1_appTop_isLocElem_eq_one` helper close ~60-80 LOC.

### Lane H — `RiemannRoch/RRFormula.lean`

HALTED iter-189 per progress-critic CHURNING verdict. iter-190
plan-phase: dispatch blueprint-writer `rr_h1_vanishing_skeleton`
(new chapter for RR.2.H¹ sub-phase) + iter-191+ prover dispatch on
NEW file `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean` (file
skeleton).

### Lane M↓ — `Albanese/CodimOneExtension.lean`

COMPLETE-EXCEPT-UPSTREAM-GAP per iter-188 Option (c). No dispatch.

### Lane J — `RiemannRoch/OcOfD.lean`

STRUCTURALLY BLOCKED per iter-187. No dispatch.
