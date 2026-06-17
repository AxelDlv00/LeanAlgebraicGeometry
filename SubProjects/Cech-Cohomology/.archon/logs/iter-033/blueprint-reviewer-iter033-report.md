# Blueprint Review Report — iter-033

**Reviewer:** blueprint-reviewer subagent  
**Date:** 2026-06-07  
**Directive:** `.archon/logs/iter-033/blueprint-reviewer-iter033-directive.md`

---

## Per-Chapter Checklist

### Chapter 1: `Cohomology_HigherDirectImage.tex`

| Field | Status |
|-------|--------|
| complete | **true** |
| correct | **true** |
| must-fix findings | none |

Single definition `def:higher_direct_image` with `\leanok` and `\lean{AlgebraicGeometry.higherDirectImage}`. Proof-body note about `[HasInjectiveResolutions]` hypothesis is accurate and up-to-date. No issues.

---

### Chapter 2: `Cohomology_AcyclicResolution.tex`

| Field | Status |
|-------|--------|
| complete | **true** |
| correct | **true** |
| must-fix findings | none |

Horseshoe lemma, dimension shift, and Leray acyclicity development all carry `\leanok`. Dependencies are internally consistent. No broken `\uses{}` edges. No issues.

---

### Chapter 3: `Cohomology_CechHigherDirectImage.tex` (consolidated)

| Field | Status |
|-------|--------|
| complete | **partial** |
| correct | **partial** |
| must-fix findings | 1 (see below) |

All sections outside the single must-fix block are complete and correct. Known-deferred blocks (P1a geometry gap, protected sorries) are honestly marked and do not contribute to this verdict.

---

## Gate Decisions

### Gate 1 — `AffineSerreVanishing.lean` prover lane

#### `lem:toSheaf_preservesFiniteColimits`
**`\lean{AlgebraicGeometry.toSheaf_preservesFiniteColimits}`** (NEW this iter)

| Field | Status |
|-------|--------|
| complete | **partial** |
| correct | **partial** |

**Findings:**

**[must-fix-this-iter] Step 2 of proof is mathematically correct but unreadable as written.**

The proof has two steps:
- Step 1: `(sheafification α).comp (SheafOfModules.toSheaf R) ≅ (PresheafOfModules.toPresheaf R₀).comp (presheafToSheaf J AddCommGrpCat)` (from `\lean{PresheafOfModules.sheafificationCompToSheaf}`, mathlibok), and this composite preserves finite colimits since both factors do (`toPresheaf_preservesFiniteColimits` on the presheaf side, `presheafToSheaf` as a left adjoint). This step is correct and clearly stated.
- Step 2: Descent to `SheafOfModules.toSheaf R` alone via the reflective-subcategory / counit-is-iso argument. The mathematical argument is: the sheafification functor `sheafification α : SheafOfModules R₀ → Sheaf J AddCommGrpCat` is an equivalence on its image (counit is an isomorphism), so if `(sheafification α) ∘ (toSheaf R)` preserves finite colimits and `sheafification α` is an equivalence, then `toSheaf R` preserves finite colimits. This is sound. However:
  - The current proof prose uses inconsistent composition-order notation, switching between `F ∘ G` and `G.comp F` convention mid-paragraph with at least one apparent typo (`F ∘ forget R` vs `forget R ∘ F`).
  - The key equation that makes Step 2 work — `toSheaf R ≅ (sheafification α)⁻¹ ∘ (sheafification α ∘ toSheaf R)` together with the counit-iso fact — is never stated explicitly, making the descent opaque.

**[must-fix-this-iter] Missing `\uses{}` edge.**  
Step 2 invokes the sheafification adjunction and the fact that the counit `L ∘ ι → id` is an isomorphism on sheaves (i.e., sheafification of a sheaf is itself). This should be covered by `\uses{lem:mod_pmod_adjunction}` (or whichever blueprint lemma states the sheafification adjunction counit-iso). That lemma is currently absent from the `\uses{}` list for `lem:toSheaf_preservesFiniteColimits`, meaning the dependency graph is incomplete and the block cannot be marked complete.

**Additional note (from Mathlib search):** Mathlib has `SheafOfModules.instPreservesFiniteLimitsSheafAddCommGrpCatToSheaf` (finite **limits** for `toSheaf`), confirming there is no Mathlib-backed finite **colimits** instance — the project-to-build claim is correctly set up. The proof route via `sheafificationCompToSheaf` is the right approach; it just needs Step 2 rewritten clearly.

**Prescribed fix (fast-path):** Writer rewrites Step 2 prose to state explicitly: (a) the counit `(sheafification α) ∘ ι ≅ id` where `ι : Sheaf J AddCommGrpCat → SheafOfModules R₀` is the forgetful direction; (b) therefore `toSheaf R` is a retract of `(sheafification α) ∘ (toSheaf R)` up to natural isomorphism; (c) a retract of a colimit-preserving functor preserves colimits. Notation should be unified (pick one of Lean-style `.comp` or ∘ notation and stick with it). Add `\uses{lem:mod_pmod_adjunction}` (verify the label name matches the blueprint lemma for the sheafification adjunction).

---

#### `lem:to_sheaf_preserves_epi`
**`\lean{AlgebraicGeometry.toSheaf_preservesEpimorphisms}`**

| Field | Status |
|-------|--------|
| complete | **true** (conditional) |
| correct | **true** (conditional) |

Proof correctly derives epi preservation from `lem:toSheaf_preservesFiniteColimits` + Mathlib's `preservesEpimorphisms_of_preservesColimitsOfShape` (pushouts / WalkingSpan). `\uses{}` is correctly set. Conditioned on the above must-fix: once Step 2 of `lem:toSheaf_preservesFiniteColimits` is fixed, this block is fully clean.

---

#### `lem:affine_surj_of_vanishing`

| Field | Status |
|-------|--------|
| complete | **true** |
| correct | **true** |

Three-step proof (local surjectivity → cofinal-cover refinement → H¹=0 gluing via `ses_cech_h1`) is detailed and correct. `\uses{}` edges are properly populated. No issues.

---

#### `def:affine_cover_system`

| Field | Status |
|-------|--------|
| complete | **true** |
| correct | **true** |

Correctly assembles basis = distinguished opens, Cov = standard affine covers, three proof fields corresponding to `BasisCovSystem`. All referenced lemmas are `\leanok` or `\mathlibok`. No issues.

---

**Gate 1 verdict: DOES NOT CLEAR.**

`AffineSerreVanishing.lean` prover should NOT be dispatched this iter. The must-fix in `lem:toSheaf_preservesFiniteColimits` (Step 2 prose + missing `\uses{}`) must be resolved first. **Fast-path:** writer applies the prescribed fix above (Step 2 rewrite + `\uses{lem:mod_pmod_adjunction}`); re-review is quick since only that one block changed. The other three Gate 1 blocks are already clean.

---

### Gate 2 — `TildeExactness.lean` prover lane (new file to scaffold)

#### `lem:tilde_preserves_kernels`
**`\lean{AlgebraicGeometry.tildePreservesFiniteLimits}`**  
(informal proof written iter-032; NOT yet `\leanok`)

| Field | Status |
|-------|--------|
| complete | **true** |
| correct | **true** |
| must-fix findings | none |

The stalkwise-flatness proof is sufficiently detailed and all Mathlib ingredients are verified to exist:

1. **Stalk identity:** `ModuleCat.Tilde.stalkIso` (Mathlib, `Mathlib.AlgebraicGeometry.Modules.Tilde`) gives `(~M)_𝔭 ≅ M_𝔭` as an R_𝔭-module. ✓
2. **Flatness of localization:** R_𝔭 is flat over R for every prime 𝔭 (standard Mathlib algebra). This means the stalk functor at 𝔭 is exact (preserves finite limits and colimits). ✓
3. **Stalkwise exactness → global exactness:** `TopCat.Presheaf.isIso_of_stalkFunctor_map_iso` (Mathlib, `Mathlib.Topology.Sheaves.Stalks`) gives the stalkwise iso criterion: a map of sheaves is an iso iff it is stalkwise an iso. Kernels in `Sheaf J Ab` are computed as sheafifications of pointwise kernels, but stalkwise the sheafification doesn't change stalks, so a map that is stalkwise a kernel is globally a kernel. ✓
4. **Conclusion:** For a finite-limit diagram in `SheafOfModules R`, the canonical map `~(lim F) → lim (~F)` is stalkwise an iso (at each 𝔭, it reduces to the iso `(lim F)_𝔭 ≅ lim(F_𝔭)` which holds by flatness + stalkIso), hence globally an iso. ✓

The proof outline gives the prover the exact Mathlib lemma names for each step. Formalization effort is moderate (the main work is chasing the stalkwise-iso criterion through the sheaf-of-modules vs. sheaf-of-abelian-groups layers, which is mechanical given the cited lemmas).

**Gate 2 verdict: CLEARS.**  
`TildeExactness.lean` prover can be dispatched now. The scaffold should contain `tildePreservesFiniteLimits` with proof strategy: introduce `stalkIso`, apply flatness, invoke `isIso_of_stalkFunctor_map_iso`.

---

## Known-Deferred (confirmed not blocking)

- **`lem:isQuasicoherent_restrict_basicOpen` (P1a):** Correctly annotated with `% NOTE:` marking it as geometry infra absent from Mathlib. No `\leanok`, not dispatched this iter. Honestly marked. ✓
- **Protected sorries in `CechHigherDirectImage.lean` and `CechAcyclic.lean`:** Signature-frozen declarations not touched. ✓

---

## Tool Findings

**leandag (dependency graph):**
- No broken `\uses{}` references.
- 8 isolated lean_aux nodes — all are standard `_mathlibok` auxiliary stubs for `\mathlibok` blocks; not anomalous.
- No unmatched `\lean{}` refs outside the known project-to-build declarations.

**blueprint-doctor:**
- No orphaned chapters, no broken `\ref`/`\uses`/`\proves` detected.
- No new `axiom` declarations beyond the known protected set.

---

## Severity Summary

| Severity | Count | Items |
|----------|-------|-------|
| must-fix-this-iter | 2 | `lem:toSheaf_preservesFiniteColimits`: Step 2 prose + missing `\uses{lem:mod_pmod_adjunction}` |
| suggest | 0 | — |
| note | 1 | Mathlib has `instPreservesFiniteLimitsSheafAddCommGrpCatToSheaf` (limits, not colimits) — confirms colimit claim is correctly project-to-build |

---

## Overall Verdict

```
Gate 1 (AffineSerreVanishing.lean): DOES NOT CLEAR
  → Block: lem:toSheaf_preservesFiniteColimits — Step 2 rewrite + \uses{} fix required
  → Fast-path: writer applies fix, trivial re-review (single block changed)

Gate 2 (TildeExactness.lean):       CLEARS
  → lem:tilde_preserves_kernels is complete and correct
  → Prover can be dispatched immediately
```
