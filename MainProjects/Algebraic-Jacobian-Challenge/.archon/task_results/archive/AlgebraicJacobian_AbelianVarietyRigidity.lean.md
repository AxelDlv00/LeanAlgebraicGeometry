# AlgebraicJacobian/AbelianVarietyRigidity.lean

## Lane E — `IsOpenImmersion.lift_uniq` route refactor (iter-193)

### Summary

**Approach:** Pursued the iter-193 prover-brief route — replace the
opaque `Proj.appIso` evaluation in `iotaGm_chart1_appIso_eval` (4-iter
STUCK streak iter-188/189/190/191) with the cleaner
`IsOpenImmersion.lift_uniq` factorisation: define an explicit ring map
`kbarChart1Ring : Away 𝒜 X_1 →+* k̄`, identify
`iotaGm_r_1 = Spec.map kbarChart1Ring`, then chain through `Spec.map` /
pullback bridges.

**Result:** PARTIAL — HARD BAR met, residual displaced from `Proj.appIso`
to a cleaner `Spec.map` factorisation target.

**Sorry count delta:** `2 → 3` (+1 net, but residuals are structurally
better targeted; the 4-iter STUCK `Proj.appIso` blocker has been
**eliminated** as a residual).

### Helpers landed

#### `kbarChart1Ring` (line 198, **axiom-clean structural advance**)

```lean
private noncomputable def kbarChart1Ring (kbar : Type u) [Field kbar] :
    HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
        ((![MvPolynomial.X 0, MvPolynomial.X 1] :
          Fin 2 → MvPolynomial (Fin 2) kbar) 1) →+*
      kbar :=
  (MvPolynomial.eval (fun _ : Unit => (1 : kbar))).comp
    (homogeneousLocalizationAwayToMvPoly kbar 1)
```

The chart-`1` evaluation ring map `Away 𝒜 X_1 →+* k̄` at the `k̄`-point
`[1:1] ∈ D₊(X_1)`, sending the chart-`1` affine coordinate `isLocElem =
[X_0/X_1]` (via the chart-`1` ring iso `homogeneousLocalizationAwayToMvPoly`
sending `isLocElem ↦ X () = u`) to `1 ∈ k̄` (via `MvPolynomial.eval`).

**Status:** axiom-clean def. **Meets Lane E HARD BAR** ("≥1 axiom-clean
helper, e.g. `kbarChart1Ring` def + Spec-map factorisation").

#### `iotaGm_r_1_eq_specMap` (line 244, axiom-clean conditional)

```lean
private lemma iotaGm_r_1_eq_specMap (kbar : Type u) [Field kbar] :
    iotaGm_r_1 kbar = Spec.map (CommRingCat.ofHom (kbarChart1Ring kbar)) := by
  refine (IsOpenImmersion.lift_uniq
    (Proj.awayι ...)
    (ProjectiveLineBar.onePt kbar).left
    (iotaGm_r_1_range_subset kbar)
    _ (kbarChart1Ring_specMap_fac kbar)).symm
```

The identification of the abstract `IsOpenImmersion.lift` with the
concrete `Spec.map(kbarChart1Ring)`. Proof body uses
`IsOpenImmersion.lift_uniq` of `Proj.awayι X_1` applied to the
factorisation hypothesis (`kbarChart1Ring_specMap_fac`).

**Status:** axiom-clean conditional on `kbarChart1Ring_specMap_fac`.

#### `kbarChart1Ring_specMap_fac` (line 222, **new substantive sorry**)

```lean
private lemma kbarChart1Ring_specMap_fac (kbar : Type u) [Field kbar] :
    Spec.map (CommRingCat.ofHom (kbarChart1Ring kbar)) ≫
        Proj.awayι ... =
      (ProjectiveLineBar.onePt kbar).left := by
  sorry
```

The substantive Spec-map factorisation claim. Both sides are
morphisms `Spec k̄ ⟶ Proj 𝒜`. `onePt.left = Proj.fromOfGlobalSections 𝒜
evalIntoGlobal _`; the LHS is the canonical Spec-of-`kbarChart1Ring`
followed by `Proj.awayι X_1`.

**Status:** typed sorry (~30-60 LOC iter-194 close target). The substantive
content is the chart-`1` ring identification: `homogeneousLocalizationAwayToMvPoly`
matches the canonical algebra map on the `Away 𝒜 X_1` chart of
`Proj.fromOfGlobalSections`. Strategy: use
`Proj.fromOfGlobalSections_morphismRestrict` (Mathlib
`AlgebraicGeometry.ProjectiveSpectrum.Basic:493`) with `r = X_1, n = 1`
to factor `onePt.left ∣_ D₊(X_1)` through `toBasicOpenOfGlobalSections`,
then identify the algebra map with `kbarChart1Ring` via
`homogeneousLocalizationAwayIso_algebraMap` (already proven iter-174,
file `Genus0BaseObjects/ChartIso.lean:347`).

**Why this is a CLEANER target than the previous `Proj.appIso` residual:**

* `Proj.appIso` evaluation (previous blocker) had NO direct Mathlib
  API — required deep unfolding of `IsOpenImmersion.lift_app` +
  `Proj.appIso_inv` chain that was opaque under `simp`-loop.
* This new target uses NAMED Mathlib lemmas with documented signatures
  (`Proj.fromOfGlobalSections_morphismRestrict` + algebra-map identity).
  Cleaner unfolding path, fewer opacity barriers.

### `iotaGm_chart1_appIso_eval` consumer refactor (line 345)

Inserted `simp only [iotaGm_r_1_eq_specMap]` immediately after the
Stage 4 `iotaGm_chart1_section` unfold. The `rw` analogue fails with
"motive is not type correct" (because the `pullback.lift` cocycle
compatibility's *type* depends on `iotaGm_r_1`); `simp only` handles
the proof-irrelevant dependency via its built-in `@[congr]` infrastructure
and rewrites cleanly through the auto-param.

**Residual after substitution (line 439).** Goal is now a ring-map
equality where `iotaGm_r_1` no longer appears anywhere; both sides are
`Scheme.Hom.app` of `Spec.map`/iso chains (pullbackSymmetry,
pullbackRightPullbackFstIso, pullback.congrHom, pullbackSpecIso).
Substantive content: the pullback collapse via `pullbackSpecIso` +
`Algebra.TensorProduct.lid` (the trivial `Gm`-twist at `λ = 1`).

**Status:** typed sorry. The `Proj.appIso` blocker is GONE. New
residual is a tensor-product collapse, attackable via:
* `pullbackSpecIso_hom_appTop` / `pullback.congrHom_appTop` /
  `pullbackSymmetry_appTop` etc. to compute each `app(⊤)` factor;
* `Algebra.TensorProduct.lid` to collapse `1 ⊗ a ↦ a` on the chart-1
  twist branch;
* `MvPolynomial.algHom_ext` for the final ring-map identity check.

### Attempt log

#### `iotaGm_chart1_appIso_eval` (line 256→345, Lane E primary)

##### Attempt 1 — `rw [iotaGm_r_1_eq_specMap]`
- **Approach:** Direct rewrite of `iotaGm_r_1` after Stage 4 unfold.
- **Result:** FAILED — "motive is not type correct" because the
  `pullback.lift` cocycle hypothesis (`iotaGm_chart1_section._proof_3`)
  has a TYPE that mentions `iotaGm_r_1`; rewriting changes the type
  required for the proof. Standard `rw` cannot handle this dependency.
- **Dead end:** direct `rw` on `iotaGm_r_1` inside `pullback.lift`.

##### Attempt 2 — `simp only [iotaGm_r_1_eq_specMap]`
- **Approach:** Replace `rw` with `simp only`, which handles
  proof-irrelevant auto-param dependencies.
- **Result:** PARTIAL — rewrite succeeds; `iotaGm_r_1` replaced by
  `Spec.map(kbarChart1Ring)` throughout. New residual is a Spec.map /
  pullback collapse (no `Proj.appIso` anywhere).
- **Key insight:** `simp only` is the right tool for rewriting through
  auto-param dependencies; `rw` is too strict.
- **Next step:** attack the pullback-collapse residual via
  `pullbackSpecIso_hom_appTop` chain (~40-60 LOC).

#### `kbarChart1Ring_specMap_fac` (NEW, line 222)

##### Attempt 1 — direct construction
- **Approach:** Pose the factorisation as the substantive content
  enabling the `lift_uniq` identification.
- **Result:** PARTIAL — typed sorry left in body.
- **Strategy logged in body:** factor `onePt.left ∣_ D₊(X_1)` via
  `Proj.fromOfGlobalSections_morphismRestrict` (Mathlib
  `ProjectiveSpectrum/Basic.lean:493`), then identify the algebra-map
  factor with `kbarChart1Ring` via `homogeneousLocalizationAwayIso_algebraMap`
  (already proven iter-174).
- **Why not closed this iter:** the `morphismRestrict` chain requires
  computing `(X.isoOfEq ...).hom` for the preimage-of-`D₊(X_1)` =
  `Spec k̄.basicOpen 1 = ⊤` identification, then chasing through
  `toBasicOpenOfGlobalSections` to identify the chart-1 ring map.
  Doable but ~30-60 LOC and out of time budget this session.

##### Attempt 2 — `rw [← iotaGm_r_1_fac]` then cancel `Proj.awayι X_1`
- **Approach:** Reduce to `Spec.map(kbarChart1Ring) = iotaGm_r_1` by
  cancelling the open-immersion mono.
- **Result:** FAILED — circular. The reduced goal is exactly
  `iotaGm_r_1_eq_specMap`, which itself relies on this lemma. Confirms
  no shortcut exists: the factorisation must be proved independently.

### Lemmas found / Mathlib bridges

* `IsOpenImmersion.lift_uniq` (Mathlib `AlgebraicGeometry.OpenImmersion`)
  — applied successfully in `iotaGm_r_1_eq_specMap`.
* `Proj.fromOfGlobalSections_morphismRestrict` (Mathlib
  `AlgebraicGeometry.ProjectiveSpectrum.Basic:493`) — target for closing
  `kbarChart1Ring_specMap_fac` next iter.
* `homogeneousLocalizationAwayIso_algebraMap` (project-side, iter-174,
  `Genus0BaseObjects/ChartIso.lean:347`) — bridges `algebraMap kbar
  Away_X_1` with `mvPolyToHomogeneousLocalizationAway` round-trip.
* `simp only` vs `rw` for proof-irrelevant auto-param dependencies:
  use `simp only` when the rewrite must pass through a `pullback.lift`
  cocycle hypothesis or similar auto-generated proof.

### Push-beyond status

**HARD BAR met:** ≥1 axiom-clean helper landed (`kbarChart1Ring` def).

**PUSH-BEYOND status:** PARTIAL — close `iotaGm_chart1_appIso_eval`
axiom-clean. The substantive content has been DISPLACED (not closed):
* OLD residual: `Proj.appIso` evaluation (4-iter STUCK, no Mathlib API).
* NEW residual 1: `kbarChart1Ring_specMap_fac` (clean Mathlib API path).
* NEW residual 2: pullback-collapse via `pullbackSpecIso` (clean ring
  collapse).

### Iter-194 recommendations

1. **Close `kbarChart1Ring_specMap_fac`** via
   `Proj.fromOfGlobalSections_morphismRestrict` chain (~30-60 LOC).
   This is the ENTRY point — closing it makes `iotaGm_r_1_eq_specMap`
   axiom-clean.
2. **Close `iotaGm_chart1_appIso_eval`'s pullback-collapse residual**
   via `pullbackSpecIso_hom_appTop` chain + `Algebra.TensorProduct.lid`
   collapse (~40-60 LOC). Independent of (1).
3. Both targets together = full Lane E axiom-clean closure.

### Sorry inventory (file)

| Line | Decl | Status | Notes |
|------|------|--------|-------|
| 241 | `kbarChart1Ring_specMap_fac` | typed sorry | NEW iter-193 — Spec-map factorisation; iter-194 close via `Proj.fromOfGlobalSections_morphismRestrict`. |
| 439 | `iotaGm_chart1_appIso_eval` | typed sorry | residual displaced from `Proj.appIso` to pullback collapse; iter-194 close via `pullbackSpecIso_hom_appTop`. |
| 795 | `genusZero_curve_iso_P1` | typed sorry | Unrelated to Lane E. Riemann–Roch bridge, gated. |

### Build verification

```
lean_diagnostic_messages severity=error → []
lean_diagnostic_messages severity=warning → 3 × `declaration uses sorry`
```

File compiles cleanly. Lane E HARD BAR met; PUSH-BEYOND requires one
more session per target above.
