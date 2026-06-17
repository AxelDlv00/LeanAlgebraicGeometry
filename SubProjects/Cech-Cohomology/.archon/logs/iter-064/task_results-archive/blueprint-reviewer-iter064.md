# Blueprint-reviewer report — iter-064

## Audit scope

Whole-blueprint audit with hard-gate focus on `Cohomology_CechHigherDirectImage.tex` (covers both
`CechSectionIdentification.lean` and `OpenImmersionPushforward.lean`). Changes verified: Part A
(pushPull_coprod_prod decomposition) and Part B (pushforward_slice_two_adjunction decomposition +
φ'' correction).

---

## Chapter: `Cohomology_HigherDirectImage.tex`

| Field | Value |
|---|---|
| complete | true |
| correct | true |
| must-fix | none |

Single definition `def:higher_direct_image` with `\leanok`. No open edges or broken refs.

---

## Chapter: `Cohomology_AcyclicResolution.tex`

| Field | Value |
|---|---|
| complete | true |
| correct | true |
| must-fix | none |

All lemmas carry `\leanok` or `\mathlibok`. No structural issues.

---

## Chapter: `Cohomology_CechHigherDirectImage.tex`

| Field | Value |
|---|---|
| complete | **false** |
| correct | **true** |
| hard-gate verdict | **READY FOR PROVER DISPATCH** — no must-fix-this-iter findings |

### leandag diagnostics

```
unknown_uses : []       ← no broken \uses{} edges
isolated     : 2        ← pre-existing, not new
unmatched_lean: see below
```

---

## Part A — CSI route decomposition

### New Lean declarations: existence status

| Blueprint node | Lean name | In Lean? | Notes |
|---|---|---|---|
| `lem:sigmaOptionIso` | `CategoryTheory.sigmaOptionIso` | **YES** | not in unmatched_lean |
| `lem:pushPullCoprodLegIso` | `AlgebraicGeometry.pushPullCoprodLegIso` | **YES** | not in unmatched_lean |
| `lem:pushPullObjCongr` | `AlgebraicGeometry.pushPullObjCongr` | **NO** | in unmatched_lean |
| `lem:over_sigmaOptionIso` | `AlgebraicGeometry.overSigmaOptionIso` | **NO** | in unmatched_lean |
| `lem:piOptionIso` | `AlgebraicGeometry.piOptionIso` | **NO** | in unmatched_lean |
| `lem:pushPull_coprod_prod_empty` | `AlgebraicGeometry.pushPull_coprod_prod_empty` | **NO** | in unmatched_lean |
| `lem:pushPull_coprod_prod` | `AlgebraicGeometry.pushPull_coprod_prod` | YES (sorry) | has `% NOTE: build target` |

### Statement correctness — Part A

**`lem:sigmaOptionIso`**: `∐_{Option α} Z(o) ≅ Z(none) ∐ (∐_{a:α} Z(some a))`. Standard
categorical splitting. No `\uses{}` needed. Statement **CORRECT**.

**`lem:pushPullObjCongr`**: If `e : Y ≅ Y'` in `Over X` then `pushPullObj F Y ≅ pushPullObj F
Y'`. Proof: apply `pushPullMap` (contravariant). `\uses{def:push_pull_obj, def:push_pull_map}`.
Statement **CORRECT**.

**`lem:over_sigmaOptionIso`**: The `Over X`-coproduct over `Option α` splits off the `none` leg
as a binary coproduct. `\uses{lem:sigmaOptionIso}`. Statement **CORRECT**. The proof uses
`Over.isoMk` with the underlying `sigmaOptionIso`; the structure-map compatibility is
componentwise by the coproduct universal property.

**`lem:piOptionIso`**: `∏_{Option α} W(o) ≅ W(none) × (∏_{a:α} W(some a))`. Dual of
`sigmaOptionIso`. No `\uses{}` needed. Statement **CORRECT**.

**`lem:pushPull_coprod_prod_empty`**: For `PEmpty`-indexed family, both sides are terminal.
`\uses{def:push_pull_obj, lem:isIso_modules_of_toPresheaf}`. Statement **CORRECT**. The empty
coproduct is the initial scheme; pulling back and pushing forward gives zero sections everywhere.
The empty product is terminal. Both sides are terminal in `X.Modules`.

**`lem:pushPull_coprod_prod`** (induction target): Statement `pushPullObj F (Over.mk
(Sigma.desc legs)) ≅ ∏_i pushPullObj F (legs i)` for finite `ι`. Proof by
`Fintype.induction_empty_option`: empty base (`lem:pushPull_coprod_prod_empty`), reindexing
stability, Option step (uses `lem:over_sigmaOptionIso`, `lem:pushPullObjCongr`,
`lem:pushPull_binary_coprod_prod`, `lem:piOptionIso`).
`\uses{...}` correctly lists all 7 dependencies. Statement **CORRECT**. Marked as build target.

**`lem:pushPullCoprodLegIso`**: Canonical per-leg identification in binary push-pull.
`\uses{def:push_pull_obj, lem:restrictFunctorIsoPullback_mathlib}`. Statement **CORRECT**.
Used by `lem:pushPull_binary_leg_coherence`. No `\leanok` visible — sync_leanok timing issue
(see §Missing `\leanok` below).

### `\uses{}` edge audit — Part A

All dependency edges for the new sub-lemmas resolve. `unknown_uses: []` confirms no broken label
references. The induction graph is:
```
pushPull_coprod_prod
├─ pushPull_coprod_prod_empty   (PEmpty base)
├─ pushPullObjCongr             (reindexing + Option transport)
├─ over_sigmaOptionIso          (Option step: slice coproduct split)
├─ piOptionIso                  (Option step: product reassembly)
├─ pushPull_binary_coprod_prod  (Option step: binary push-pull)
├─ def:push_pull_obj
└─ isIso_modules_of_toPresheaf
```
Edges correct and complete.

---

## Part B — OpenImm route decomposition and φ'' correction

### New Lean declarations: existence status

| Blueprint node | Lean name | In Lean? | Notes |
|---|---|---|---|
| `lem:slice_overs_equiv_continuity` (6 decls) | see below | **YES** (all 6) | not in unmatched_lean |
| `lem:slice_reverse_ring_map` | `AlgebraicGeometry.sliceReverseRingMap` | **NO** | in unmatched_lean |
| `lem:pushforward_slice_adjunction_h1` | `AlgebraicGeometry.pushforwardSliceAdjunctionH1` | **NO** | in unmatched_lean |
| `lem:pushforward_slice_adjunction_h2` | `AlgebraicGeometry.pushforwardSliceAdjunctionH2` | **NO** | in unmatched_lean |
| `lem:pushforward_slice_two_adjunction` | `AlgebraicGeometry.pushforwardSliceTwoAdjunction` | YES (sorry) | has `% NOTE: build target` |
| `lem:pushforward_slice_pullback_iso` | `AlgebraicGeometry.pushforwardSlicePullbackIso` | YES (sorry) | has `% NOTE: build target` |
| `lem:pushforward_iso_preserves_qcoh` | `AlgebraicGeometry.pushforward_iso_preserves_qcoh` | **NO** | in unmatched_lean |

The 6 declarations covered by `lem:slice_overs_equiv_continuity`:
`opensMapHomBase_isEquivalence`, `opensEquivOfIso`, `sliceOversEquiv`,
`sliceOversEquiv_functor_isContinuous`, `overPost_slice_inverse_isContinuous`,
`sliceOversEquiv_inverse_isContinuous` — all local, consistent with iter-063 axiom-clean report.

### Statement correctness — Part B

**`lem:slice_overs_equiv_continuity`**: Opens-lattice functor is an equivalence; φ induces
`sliceOversEquiv φ Uᵢ : Over Uᵢ ≃ Over Vᵢ`; both directions are continuous.
`\uses{...}` lists 5 Mathlib anchors. Statement **CORRECT**. No `\leanok` — sync_leanok timing.

**`lem:slice_reverse_ring_map`**: The corrected φ'', defined as over-pullback of
`φ.hom.toRingCatSheafHom` along the corrected inverse `eqv.inverse =
Over.post(Opens.map φ.hom.base) ∘ Over.map(unitIso.inv)`. The statement explicitly confirms
φ'' is *object-level correction-free*: `Over.map(unitIso.inv)` leaves `.left` unchanged, so
sections over any `W : (Over Vᵢ)ᵒᵖ` are sections of `X.ringCatSheaf.over Uᵢ` over
`φ.hom⁻¹ W.left`. `\uses{lem:slice_structureSheaf_hom, lem:slice_overs_equiv_continuity}`.
Statement **CORRECT** and mathematically coherent.

**`lem:pushforward_slice_adjunction_h1`** (H₁ counit square): φ'' and ψ_r satisfy the
counit-naturality square required by `pushforwardPushforwardAdj`. Proof: both structure-sheaf
comparisons `φ.hom.toRingCatSheafHom` and `φ.inv.toRingCatSheafHom` are mutually inverse; the
two slice ring maps are their over-pullbacks; naturality collapses to an equality of
equality-transport morphisms along `φ.hom⁻¹(φ.inv⁻¹ Uᵢ) = Uᵢ`, true by proof-irrelevance.
`\uses{lem:slice_reverse_ring_map, lem:slice_structureSheaf_hom}`.
Statement **CORRECT**. The proof is a proof-irrelevance argument — the right tool given the
non-definitional open identity.

**`lem:pushforward_slice_adjunction_h2`** (H₂ unit square): Same structure as H₁.
`\uses{lem:slice_reverse_ring_map, lem:slice_structureSheaf_hom}`. Statement **CORRECT**.

**`lem:pushforward_slice_two_adjunction`**: `pushforward φ'' ⊣ pushforward ψ_r`. Assembled
from Mathlib's `pushforwardPushforwardAdj` applied to `(sliceOversEquiv φ Uᵢ).symm.toAdjunction`
with H₁ and H₂. The proof explicitly identifies the `Over.map(unitIso.inv)` correction as the
source of all non-definitional bookkeeping. `\uses{...}` correctly lists all 7 dependencies.
Statement **CORRECT**. Marked as build target.

**`lem:pushforward_slice_pullback_iso`**: `(pullback ψ_r).obj (H.over Uᵢ) ≅ (Φ.functor.obj
H).over Vᵢ`. Two-step proof: (1) `pullback ψ_r ≅ pushforward φ''` by left-adjoint uniqueness
(`lem:leftAdjointUniq_mathlib`), both being left adjoint to `pushforward ψ_r`; (2) sections of
`pushforward φ''` over W are definitionally `Γ(H, φ.hom⁻¹ W.left)` — the same as sections of
`(Φ.functor.obj H).over Vᵢ` over W (by `pushforward_obj_obj_mathlib`). `\uses{...}` correctly
lists 7 dependencies. Statement **CORRECT**. Marked as build target.

**`lem:pushforward_iso_preserves_qcoh`**: Pushforward of quasi-coherent H along scheme iso φ is
quasi-coherent. Proof: extract quasi-coherence datum, form image cover, use per-member
`pullback ψ_r` (left adjoint, preserves colimits, so presentations transport) and then the iso
from `lem:pushforward_slice_pullback_iso` to carry the presentation across. `\uses{...}` lists 6
dependencies. Statement **CORRECT**. Marked as build target (no `% NOTE:` annotation — see
§Soft findings below).

### φ'' correction — coherence and propagation audit

The correction is **mathematically coherent** and **consistently propagated**:

1. **Source of correction**: `Over.postEquiv F` (Mathlib) has inverse
   `Over.post F.inverse ∘ Over.map(F.unitIso.inv.app X)`. For the opens-equivalence,
   `F.inverse.obj(F.functor.obj Uᵢ) = φ.hom⁻¹(φ.inv⁻¹ Uᵢ) ≠ Uᵢ` definitionally.
   Documented in `lem:over_postEquiv_mathlib`. ✓

2. **Old φ''** (`sliceStructureSheafHom φ⁻¹ Vᵢ`): completely absent from the current blueprint.
   No stale reference found. ✓

3. **New φ''** (`sliceReverseRingMap`): consistently used in H₁, H₂, and the parent
   `pushforward_slice_two_adjunction`. ✓

4. **Propagation to `pushforward_slice_pullback_iso`**: the statement and proof reference
   `lem:slice_reverse_ring_map` and explicitly note that sections of `pushforward φ''` equal
   sections of `(Φ.functor.obj H).over Vᵢ` by preimage identity. ✓

5. **H₁/H₂ absorb the correction**: both reduce to proof-irrelevance on the open identity
   `φ.hom⁻¹(φ.inv⁻¹ Uᵢ) = Uᵢ`. This is the correct technical form for the `Over.map` factor
   being trivial at the section level. ✓

### New `\mathlibok` anchors

8 new Mathlib anchors added (directive said 4; there are 8):

| Label | Lean name | Line |
|---|---|---|
| `lem:leftAdjointUniq_mathlib` | `CategoryTheory.Adjunction.leftAdjointUniq` | 10102 |
| `lem:pushforwardPushforwardAdj_mathlib` | `SheafOfModules.pushforwardPushforwardAdj` | 10113 |
| `lem:over_postEquiv_mathlib` | `CategoryTheory.Over.postEquiv` | 10130 |
| `lem:opens_mapMapIso_mathlib` | `TopologicalSpace.Opens.mapMapIso` | 10146 |
| `lem:instIsContinuousOverMapOver_mathlib` | `CategoryTheory.GrothendieckTopology.instIsContinuousOverMapOver` | 10156 |
| `lem:functor_isContinuous_comp_mathlib` | `CategoryTheory.Functor.isContinuous_comp` | 10167 |
| `lem:coverPreserving_overPost_mathlib` | `CategoryTheory.CoverPreserving.overPost` | 10177 |
| `lem:pullbackPushforwardAdjunction_mathlib` | `SheafOfModules.pullbackPushforwardAdjunction` | 10187 |

All 8 carry `\mathlibok` markers. All used correctly in `\uses{}` of the new sub-lemmas. ✓

### `\uses{}` edge audit — Part B

All edges resolve. Dependency graph for the OpenImm route:

```
pushforward_slice_pullback_iso
├─ slice_reverse_ring_map
│   ├─ slice_structureSheaf_hom
│   └─ slice_overs_equiv_continuity  (6 decls, all local)
├─ pushforward_slice_two_adjunction
│   ├─ slice_structureSheaf_hom
│   ├─ slice_reverse_ring_map
│   ├─ pushforward_slice_adjunction_h1
│   ├─ pushforward_slice_adjunction_h2
│   ├─ slice_overs_equiv_continuity
│   ├─ pushforwardPushforwardAdj_mathlib
│   └─ over_postEquiv_mathlib
├─ leftAdjointUniq_mathlib
├─ pullbackPushforwardAdjunction_mathlib
├─ pushforward_obj_obj_mathlib
└─ sheafOfModules_pullback_mathlib
```

No broken edge. `unknown_uses: []`. ✓

---

## Soft findings (non-blocking, low priority)

### Missing `% NOTE: build target` on 7 nodes

The following nodes are in `unmatched_lean` (Lean declaration absent) but lack the `% NOTE:
build target. The Lean declaration does not exist yet.` annotation used on the 4 parent build
targets:

- **Part A**: `lem:pushPullObjCongr`, `lem:over_sigmaOptionIso`, `lem:piOptionIso`,
  `lem:pushPull_coprod_prod_empty`
- **Part B**: `lem:slice_reverse_ring_map`, `lem:pushforward_slice_adjunction_h1`,
  `lem:pushforward_slice_adjunction_h2`

These are NOT must-fix: the prover sees the missing `\leanok` and can infer they need building.
Adding `% NOTE:` annotations improves clarity for human readers but is not required before
dispatch.

### Missing `\leanok` on iter-063 results

The following declarations are confirmed built axiom-clean in iter-063 (per proof journal) but
lack `\leanok` in the current blueprint:

- `lem:pushPullCoprodLegIso` (`pushPullCoprodLegIso`)
- `lem:pushPull_binary_leg_coherence` (`pushPull_binary_leg_coherence`)
- `lem:slice_overs_equiv_continuity` (all 6 declarations)

Cause: `sync_leanok` ran before the blueprint-writer pass added these nodes this iteration (or
the new node names weren't present when sync ran). **Action**: `sync_leanok` will repair this on
the next pass. No reviewer action needed.

---

## Hard-gate verdict

```
complete : false   (10 open build targets, expected)
correct  : true    (no false statement, no broken uses, φ'' correct)
```

**Chapter is READY for prover dispatch on `CechSectionIdentification.lean` and
`OpenImmersionPushforward.lean`.**

### Prover work queue (in dependency order)

**CechSectionIdentification.lean** — closes `lem:pushPull_coprod_prod`:
1. `pushPullObjCongr` — 1-step congr on pushPullMap
2. `overSigmaOptionIso` — Over.isoMk from sigmaOptionIso
3. `piOptionIso` — dual of sigmaOptionIso
4. `pushPull_coprod_prod_empty` — terminal-object check
5. `pushPull_coprod_prod` — `Fintype.induction_empty_option` assembly

**OpenImmersionPushforward.lean** — closes `hqc` leaf:
1. `sliceReverseRingMap` — over-pullback transport
2. `pushforwardSliceAdjunctionH1` — proof-irrelevance on `φ.hom⁻¹(φ.inv⁻¹ Uᵢ) = Uᵢ`
3. `pushforwardSliceAdjunctionH2` — same
4. `pushforwardSliceTwoAdjunction` — Mathlib `pushforwardPushforwardAdj` application
5. `pushforwardSlicePullbackIso` — `leftAdjointUniq` + sections identity
6. `pushforward_iso_preserves_qcoh` — presentation transport across iso
