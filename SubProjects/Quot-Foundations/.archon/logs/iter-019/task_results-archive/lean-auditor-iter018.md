# lean-auditor — iter018

**Date**: 2026-06-06
**Scope**: all 7 project `.lean` files (full read)
**Focus areas**: QuotScheme new declarations (FA1), FlatteningStratification L4 sorry (FA2), FlatBaseChange Seam 2 comment (FA3)

---

## AlgebraicJacobian.lean

| Check | Result |
|---|---|
| Outdated comments | — |
| Suspect definitions | — |
| Dead-end proofs | — |
| Bad practices | — |
| Excuse-comments | — |

Import-only file. No declarations. Clean.

---

## AlgebraicJacobian/Cohomology/RegroupHelper.lean (99 lines)

| Check | Result |
|---|---|
| Outdated comments | — |
| Suspect definitions | — |
| Dead-end proofs | — |
| Bad practices | — |
| Excuse-comments | — |

`base_change_regroup_linearEquiv` is sorry-free and axiom-clean. The additive composite `comm ≪≫ cancelBaseChange ≪≫ comm` re-bundled as `R'`-linear equivalence; `map_smul'` discharged by TensorProduct induction with explicit `rightAlgebra` action. No issues.

---

## AlgebraicJacobian/Picard/RelativeSpec.lean (293 lines)

| Check | Result |
|---|---|
| Outdated comments | Pre-existing predecessor-project iter markers (iter-173–179) in `RelativeSpec` docstring — not actively misleading |
| Suspect definitions | — |
| Dead-end proofs | — |
| Bad practices | **Minor** — dead `have h` in `affine_base_iff` (line 286); see below |
| Excuse-comments | — |

**Minor finding M-1**: `affine_base_iff` (line 286) contains `have h : IsAffineHom (RelativeSpec.structureMorphism 𝒜) := UniversalProperty 𝒜` followed immediately by `exact isAffine_of_isAffineHom ...`. The binding `h` is unused — `isAffine_of_isAffineHom` resolves the `IsAffineHom` instance via Lean's instance synthesis without needing the explicit `h`. Dead code, not a bug.

---

## AlgebraicJacobian/Picard/GrassmannianCells.lean (635 lines)

| Check | Result |
|---|---|
| Outdated comments | — |
| Suspect definitions | — |
| Dead-end proofs | — |
| Bad practices | — |
| Excuse-comments | — |

All 30+ declarations proved, including triple-overlap cocycle condition (`cocycleCondition`). Transition map machinery (`transitionPreMap`, `transitionMap`, cocycle identity `cocycleΘIJ ≫ cocycleΘJK = cocycleΘIK`) fully verified. Entirely clean.

---

## AlgebraicJacobian/Cohomology/FlatBaseChange.lean (1649 lines) — Focus Area 3

| Check | Result |
|---|---|
| Outdated comments | STATUS comment block (lines 184–246): accurate documentation, not misleading |
| Suspect definitions | — |
| Dead-end proofs | — |
| Bad practices | — |
| Excuse-comments | **None — Seam 2 comment is accurate** |

### FA3 verdict: Seam 2 comment is accurate technical documentation

**`base_change_mate_fstar_reindex_legs` (lines 1270–1347)**:

The comment block (lines 1319–1346) correctly describes three distinct obstacles:

1. *Dependent-motive wall*: after `subst hfst` and `subst hsnd`, the goal cannot be refolded to `e.hom` / `inclA` form because the motive is not type-correct (the substituted variables appear in the expected types of the abbreviations). This is the standard Lean 4 dependent-elimination wall.

2. *Key / goal form mismatch*: `key` lives in `e.hom` / `inclA` form but the post-`subst` goal is in the free-variable form; the comment correctly identifies that `rw [he, hinclA] at key` would need to fold the helper, not unfold the goal.

3. *Telescoping cancellation*: the remaining proof obligation requires `pullback_isEquivalence_of_iso` and the codomain reading's internal structure to cancel the intermediate arrows. The comment accurately names the specific API needed.

The preceding tactics (`subst hfst/hsnd`, `simp only [gammaMap_pushforwardComp_inv_eq_id, gammaMap_pushforwardCongr_hom]`) are real proof progress — they reduce the goal before the structural sorry. **This is honest scaffolding, not an excuse-comment.**

**Other sorries**:

- `base_change_mate_gstar_transpose` (line 1451): honest. Comment correctly identifies pullback-dictionary coherence as the crux, citing `base_change_mate_fstar_reindex` and `pullback_spec_tilde_iso` as the ingredients. Not a dead end.
- `affineBaseChange_pushforward_iso` (line 1624): honest. Affine reduction step identified accurately.
- `flatBaseChange_pushforward_isIso` (line 1646): honest. Čech-cohomology infrastructure correctly identified as prerequisite.

**STATUS comment block (lines 184–246)**: Documents iter-234/236/240/241 history of routes (a) vs. (b) for the Γ-fragment iso. All referenced declarations (`gammaPushforwardIso`, `gammaPushforwardTildeIso`, `gammaPushforwardIsoAt`) are defined and proved below the comment. Accurate technical documentation, not misleading about current state.

**`set_option maxHeartbeats` bumps**:
- 4M at line 979 (`base_change_mate_unit_value`): justified — conjugate-unit calculus chains several `erw` defeq-unifications and a `simp` closure over `restrictScalars`/tilde–Γ round trips.
- 1.6M at lines 1260 and 1351: reasonable for large change-of-rings compositions.

None of the bumps appear to be masking an infinite loop.

---

## AlgebraicJacobian/Picard/FlatteningStratification.lean (1722 lines) — Focus Area 2

| Check | Result |
|---|---|
| Outdated comments | — |
| Suspect definitions | — |
| Dead-end proofs | — |
| Bad practices | `f * f` witness in L5 inductive step (line 1582): mathematically valid, minor note below |
| Excuse-comments | **None — L4 sorry is honest scaffolding** |

### FA2 verdict: L4 sorry is honest scaffolding over a real gap, not a wrong subgoal

**`exists_localizationAway_finite_mvPolynomial` (lines 486–610)**:

The six steps F1–F6 above the sorry (lines 530–579) are all proved real assertions:
- `hD`: `IsDomain A` (lines 530–532)
- `hNoe`: `IsNoetherianRing A` (lines 534–536)
- `hFinAlg`: `Algebra.FiniteType κ A` (lines 538–546)
- `φ`: the surjective `κ`-algebra map `MvPolynomial ... ↠ A` (lines 548–561)
- `ψ`: the Noether normalization map `MvPolynomial (Fin d) κ →ₐ[κ] A` (lines 563–571)
- `hAlgInd`: algebraic independence of the image (lines 573–579)

The sorry at line 610 covers exactly two remaining steps that the roadmap comments (lines 580–609) accurately describe:
1. **INJECTIVITY** of `ψ` via `AlgebraicIndependent.restrictScalars` (API name given correctly)
2. **FINITENESS ASSEMBLY** via `Algebra.IsIntegral.finite` (API name given correctly)

The roadmap is specific and accurate. **Honest scaffolding.**

**Other sorries**:

- `genericFlatnessAlgebraic` (lines 1622–1652): honest. Assembly via prime-filtration induction (`IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime`) described accurately.
- `genericFlatness` (lines 1684–1719): honest. Geometric assembly from algebraic version described accurately.

**Minor observation (not a bug)**: `exists_free_localizationAway_polynomial` (L5) is fully proved. In the inductive step (line 1582), `exists_free_localizationAway_of_shortExact ... hf0 hf0 hM'_free hTf_free` produces localization witness `f * f` rather than `f`. This is mathematically valid (domain: `f ≠ 0 → f * f ≠ 0`) but gives a less tight localization element. No correctness impact.

**`set_option` bumps**:
- `synthInstance.maxHeartbeats 1000000` (line 1109) and `maxHeartbeats 4000000` (line 1112) for `gf_torsion_reindex`: justified by deep localization-of-modules instance search over doubly-indexed polynomial rings. Not masking a loop.

---

## AlgebraicJacobian/Picard/QuotScheme.lean (1162 lines) — Focus Area 1

| Check | Result |
|---|---|
| Outdated comments | — |
| Suspect definitions | — |
| Dead-end proofs | — |
| Bad practices | **Minor** — `letI` boilerplate duplicated in `polyEndHom_X` / `polyEndHom_C`; see M-2 |
| Excuse-comments | — |

Expected sorry stubs (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`) not re-examined per directive.

### FA1 verdict: new declarations are sound; `polyModule` non-reducibility is defensible

**`polyEndHom` (lines 986–996)**

Signature sound. The route through `Algebra.adjoin κ (Set.range t)` with `Algebra.isMulCommutative_adjoin` + `IsMulCommutative.instCommRing` is the current non-deprecated pattern (replaces the deprecated `Algebra.adjoinCommRingOfComm`). The body correctly composes `val.toRingHom ∘ (MvPolynomial.aeval ⟨t i, ...⟩).toRingHom`. The commutativity hypothesis thread `(hcomm i j).eq` correctly grounds the `isMulCommutative_adjoin` call.

**`polyModule` reducibility (lines 1024–1026)**

`polyModule` is a `noncomputable def` returning `Module (MvPolynomial (Fin r) κ) M`, left un-`@[reducible]`. **This is defensible** for the following reasons:

1. Every consumer introduces it via `letI := polyModule t hcomm` (explicit local instance), not via global typeclass search. The consuming lemmas `polyModule_X_smul`, `polyModule_C_smul`, `polyModule_isScalarTower`, and `polySubmodule` all follow this pattern.

2. Making it `@[reducible]` would expose the `isDefEq` pathology (graded subtype elaborator loop, documented in project memory) by allowing the elaborator to unfold it during instance search across subtype boundaries.

3. All proofs about the module structure use `change` or `letI` to bridge the non-reducibility — this is the established project pattern. `polyModule_X_smul` uses `change polyEndHom t hcomm (MvPolynomial.X i) • m = t i m` to side-step the unfold.

4. `polySubmodule_coe` is proved by `rfl` (carrier is definitionally `N`), confirming the non-reducible `def` doesn't impede definitional equality checks on the carrier.

**`polySubmodule` induction (lines 1072–1082)**

The `smul_mem'` proof by `MvPolynomial.induction_on` is correct:
- `C a` case: `polyModule_C_smul` gives `(C a) • m = a • m`; `N.smul_mem a hm` closes. ✓
- `add p q` case: `add_smul` then both summands via IH. ✓
- `mul_X p i` case: `mul_smul` decomposes to `p • (X i • m)`, `polyModule_X_smul` rewrites to `p • (t i m)`, `hN i (Submodule.mem_map_of_mem hm)` gives `t i m ∈ N`, IH closes `p • (t i m) ∈ N`. ✓

**`SubquotientDatum.hfin` field type (lines 1134–1137)**

The `letI := polyModule t hcomm` inside a structure field type is unusual but valid Lean 4 (`let` in a type expression). The `N/N'` representation:

```
↥(polySubmodule t hcomm N hpresN) ⧸
  (polySubmodule t hcomm N' hpresN').comap (polySubmodule t hcomm N hpresN).subtype
```

is mathematically correct: `comap ι N'` inside `↥N` equals `{x ∈ N | x ∈ N'} = N ∩ N' = N'` (using `hle : N' ≤ N`), so the quotient represents `N/N'`. ✓

The outer `letI` and the internal `letI` inside `polySubmodule`'s body both call `polyModule t hcomm` with the same arguments; these are definitionally equal since `polyModule` is a `def` and `polyModule t hcomm = polyModule t hcomm` by `rfl`.

**`finiteDimensional_of_mvPolynomial_isEmpty_finite` (lines 1148–1155)**

Signature sound. The chain:
- `Module.Finite κ (MvPolynomial σ κ)` via `Module.Finite.equiv (MvPolynomial.isEmptyAlgEquiv κ σ).symm.toLinearEquiv` (uses `Module.Finite κ κ`, which holds for any field)
- `Module.Finite.trans (MvPolynomial σ κ) Q` using the hypothesis `[Module.Finite (MvPolynomial σ κ) Q]` and `[IsScalarTower κ (MvPolynomial σ κ) Q]`

is correct. This is the right base case for the Stacks 00K1 induction. ✓

**Minor finding M-2**: `polyEndHom_X` (lines 1002–1006) and `polyEndHom_C` (lines 1012–1019) each repeat the full `letI IsMulCommutative` / `letI CommRing` block verbatim from `polyEndHom`. This is three copies of the same 3-line boilerplate. Not a correctness issue; the `simp [polyEndHom]` in `polyEndHom_X` correctly unfolds via `MvPolynomial.aeval_X`. Consider extracting to a `private` helper `polyAdjoinCommRing` if these simp lemmas acquire siblings.

---

## Severity Summary

### Must-fix-this-iter
*None.*

### Major
*None.*

### Minor

| ID | File | Location | Description |
|---|---|---|---|
| M-1 | `RelativeSpec.lean` | line 286, `affine_base_iff` | `have h := UniversalProperty 𝒜` is never used; `h` is dead code |
| M-2 | `QuotScheme.lean` | lines 1002–1019, `polyEndHom_X`/`polyEndHom_C` | `letI IsMulCommutative / letI CommRing` boilerplate from `polyEndHom` duplicated in both simp lemmas (3 copies total) |

---

## Summary

All three focus-area questions are resolved:

- **FA1 (QuotScheme new declarations)**: All 20 new declarations are sound. `polyModule` as a non-reducible `def` is the correct design choice for this codebase. `SubquotientDatum.hfin` is elaboratable and mathematically correct. The `finiteDimensional_of_mvPolynomial_isEmpty_finite` base case is correct.

- **FA2 (FlatteningStratification L4)**: The sorry at line 610 is honest scaffolding. Steps F1–F6 are all real proved content; the roadmap comments correctly identify `AlgebraicIndependent.restrictScalars` and `Algebra.IsIntegral.finite` as the remaining API needs.

- **FA3 (FlatBaseChange Seam 2)**: The comment block around `base_change_mate_fstar_reindex_legs` accurately describes the dependent-motive wall, the key/goal form mismatch, and the telescoping cancellation needed. Not an excuse-comment.

No correctness issues found anywhere in the project. The two minor findings (dead `have h`, duplicated `letI` boilerplate) have no proof-theoretic impact.
