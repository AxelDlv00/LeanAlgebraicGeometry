# Lean ↔ Blueprint Check Report

## Slug
lvb-cech263

## Iteration
263

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.CechNerve}` (chapter: def:cech_nerve)
- **Lean target exists**: yes
- **Signature matches**: yes — `(𝒰 : X.OpenCover) (F : X.Modules) : CosimplicialObject.Augmented X.Modules`. The blueprint describes an "augmented cosimplicial object in QCoh(X)"; the Lean target type is the categorical encoding of that.
- **Proof follows sketch**: N/A (body is `:= sorry`; the blueprint explicitly documents the nerve as a current construction gap and provides no proof)
- **notes**: `:= sorry` is expected and consistent with the blueprint's own acknowledgement ("so `CechNerve` itself is left as the single genuine hole" in sec:cech_three_part). `\leanok` on statement block is correct per project marker vocabulary.

### `\lean{AlgebraicGeometry.CechComplex}` (chapter: def:cech_complex)
- **Lean target exists**: yes
- **Signature matches**: yes — `(f : X ⟶ S) (𝒰 : X.OpenCover) (F : X.Modules) : CochainComplex S.Modules ℕ`; the blueprint describes a cochain complex of O_S-modules. Consistent.
- **Proof follows sketch**: yes — body is `relativeCechComplexOfNerve f (CechNerve 𝒰 F)`, which is exactly the coherence-free plumbing passage described in paragraph (3) of sec:cech_three_part applied to the nerve of Definition def:cech_nerve.
- **notes**: Body axiom-quality depends on `CechNerve` (sorry), but the construction logic is correct and matches the blueprint.

### `\lean{AlgebraicGeometry.CechAcyclic.affine}` (chapter: lem:cech_acyclic_affine)
- **Lean target exists**: yes
- **Signature matches**: yes — `[IsAffine X] (f : X ⟶ S) [IsAffineHom f] (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules) (hF : F.IsQuasicoherent) (p : ℕ) (hp : 1 ≤ p) : IsZero ((CechComplex f 𝒰 F).homology p)`. Blueprint: affine `X`, affine `f`, finite standard cover, quasi-coherent `F`, `Ȟᵖ = 0` for `p > 0`. Matches.
- **Proof follows sketch**: N/A — body is `:= sorry`; blueprint proof explicitly documents the missing Mathlib infrastructure (localisation description of CechComplex + module-level contracting homotopy).
- **notes**: Sorry expected and documented in the blueprint's proof section.

### `\lean{AlgebraicGeometry.cech_computes_higherDirectImage}` (chapter: lem:cech_computes_cohomology)
- **Lean target exists**: yes
- **Signature matches**: yes — `[HasInjectiveResolutions X.Modules] (f : X ⟶ S) [QuasiCompact f] [IsSeparated f] (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules) (hF : F.IsQuasicoherent) (i : ℕ) : Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)`. Blueprint: separated quasi-compact `f`, quasi-coherent `F`, comparison `Nonempty (Hⁱ(Č•) ≅ Rⁱ f_* F)` under `HasInjectiveResolutions`. Matches precisely, including the `Nonempty` weakening that the blueprint justifies.
- **Proof follows sketch**: N/A — body is `:= sorry`; blueprint proof explicitly documents the missing infrastructure (Čech-to-derived and Leray spectral sequences for `Scheme.Modules`).
- **notes**: Sorry expected and documented.

### `\lean{AlgebraicGeometry.cechHigherDirectImage}` (chapter: def:cech_higher_direct_image)
- **Lean target exists**: yes
- **Signature matches**: yes — `(f : X ⟶ S) (𝒰 : X.OpenCover) (F : X.Modules) (i : ℕ) : S.Modules := (CechComplex f 𝒰 F).homology i`. Blueprint: i-th cohomology sheaf of the relative Čech complex. Matches.
- **Proof follows sketch**: yes — body is the verbatim definition from the blueprint.
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.cech_flatBaseChange}` (chapter: lem:cech_flat_base_change)
- **Lean target exists**: yes
- **Signature matches**: yes — `Nonempty ((Scheme.Modules.pullback g).obj (cechHigherDirectImage f 𝒰 F i) ≅ cechHigherDirectImage f' 𝒰' ((Scheme.Modules.pullback g').obj F) i)`. Blueprint: `g^*(Rⁱ f_* F) ≅ Rⁱ f'_* ((g')^* F)`, `Nonempty` form. Matches.
- **Proof follows sketch**: N/A — body is `:= sorry`; blueprint proof explicitly documents the missing infrastructure (term-wise affine base change of the Čech complex + exactness of `- ⊗_A B` for sheaves of modules).
- **notes**: Sorry expected and documented.

---

## Red flags

### Placeholder / suspect bodies
None beyond the four expected `sorry` proofs. All four are pre-authorized by the blueprint's own proof sections, which each end with an explicit "This proof depends on the following currently-absent Mathlib infrastructure" paragraph. No excuse-comments in the Lean source.

### Axioms / Classical.choice
None.

---

## Unreferenced declarations (informational)

The following five declarations in the Lean file have no `\lean{...}` reference in the blueprint chapter. None are private helpers; all are substantive intermediate infrastructure described (only in prose) in sec:cech_three_part.

| Declaration | Line | Axiom-clean? | Blueprint mention |
|---|---|---|---|
| `coverArrow` | 130 | yes | prose only (paragraph 1 of sec:cech_three_part) |
| `coverCechNerve` | 139 | yes | prose only (paragraph 1 of sec:cech_three_part) |
| `pushPullObj` | 163 | yes | prose only (paragraph 2, added iter-263) |
| `pushPullMap` | 175 | yes | prose only (paragraph 2, added iter-263) |
| `relativeCechComplexOfNerve` | 223 | yes | prose only (paragraph 3 of sec:cech_three_part) |

`coverArrow`, `coverCechNerve`, and `relativeCechComplexOfNerve` are backbone plumbing; `pushPullObj` and `pushPullMap` are the new axiom-clean bricks of the push–pull functor `G` added this iteration.

---

## Blueprint adequacy for this file

### (a) Coverage of G and its laws in sec:cech_three_part

**Paragraph (2) gives sufficient informal description of the object map and morphism map** to understand what `pushPullObj` and `pushPullMap` compute:
- Object map: "(Y →p X) ↦ p_* p^* F" — unambiguous.
- Morphism map: "via the unit/counit of the pull-push adjunction together with the over-triangle identifying the two structure maps" — the Lean `pushPullMap` is a 5-step composite (unit, `pushforwardComp.hom`, two `eqToHom` transports, `pushforward.map (pullbackComp.hom.app F)`); the blueprint's prose is too concise to uniquely specify the composite but points the right direction.

**However, `pushPullMap_id` / `pushPullMap_comp` are not formalized at all in the blueprint:**
- No `\lean{...}` hint for either law.
- No dedicated definition/lemma block for them.
- No proof sketch (not even a sketch at the level of "rewrite head as conjugate of `pullbackComp.inv` via `conjugateEquiv_pullbackComp_inv`").
- The Lean file itself supplies a detailed roadmap in a `/-` block comment (lines 189–212), but this is prover-authored, not blueprint-authored.

**Consequence for formalization:** A prover dispatched to close `pushPullMap_id`/`pushPullMap_comp` from the blueprint alone would have no statement block to target (no `\lean{...}` hint), no proof strategy, and no Lean name to formalize. They could not formalize from the chapter prose.

**Downstream obligations (CechNerve / CechComplex / CechAcyclic.affine):** These ARE adequately blueprinted. Each has a `\lean{...}` hint, a clear mathematical statement, and an honest acknowledgement of the blocking Mathlib gap. A prover knows exactly what to prove and why it is sorry.

### (b) Dependency claim — G's functor laws vs. project-local Sq1

**The blueprint's paragraph (2) of sec:cech_three_part states (lines 215–219):**
> "This is exactly the same pushforward/pullback coherence machinery **developed for the tensor--pullback substrate** (these same comparison isomorphisms, together with the unit-transport identities of that development): the functoriality of the relative-direct-image functor is a **consumer of that coherence**, not an independent construction."

This sentence asserts that `G`'s functor laws (`pushPullMap_id`/`pushPullMap_comp`) depend on the project-local TensorObjSubstrate coherence development — which includes Sq1 (`sheafificationCompPullback_comp`).

**The Lean file's deferred-section comment (lines 199–206) explicitly contradicts this:**
> "Note these coherences are **already in Mathlib** (the whole `pseudofunctor : Pseudofunctor (LocallyDiscrete Schemeᵒᵖ) (Adj Cat)` packaging), so the laws **do not strictly depend on the project-local Sq1** (`sheafificationCompPullback_comp`) machinery — but the assembly through the two `eqToHom` triangle transports and the unit is the same multi-step mate-calculus effort, and is left for a focused fine-grained pass."

**The discrepancy is clear and planning-critical:**
- Blueprint says: G's laws are consumers of project-local TensorObjSubstrate (implies: wait for Sq1 to close before dispatching G-law proofs).
- Lean comment says: G's laws only need Mathlib's pseudofunctor package (implies: can be dispatched immediately, no Sq1 gate).

A plan agent reading the blueprint would incorrectly block dispatch of `pushPullMap_id`/`pushPullMap_comp` until Sq1 is resolved. The chapter must be updated to reflect that these laws use only Mathlib's `pseudofunctor : Pseudofunctor (LocallyDiscrete Schemeᵒᵖ) (Adj Cat)` coherences and are **independent of project-local Sq1**.

### Summary

| Dimension | Assessment |
|---|---|
| Coverage | 6/11 declarations have `\lean{...}` blocks (6 helpers/bricks unreferenced) |
| Proof-sketch depth | adequate for the 4 documented sorry-theorems; **silent** for `pushPullMap_id`/`pushPullMap_comp` |
| Hint precision | precise for the 6 referenced declarations |
| Generality | matches need |
| Dependency accuracy | **wrong** — paragraph (2) asserts Sq1 coupling that the prover has de-coupled |

### Recommended chapter-side actions (for blueprint-writing subagent)

1. **[must-fix] Correct the dependency claim in sec:cech_three_part paragraph (2).** Replace "exactly the same pushforward/pullback coherence machinery developed for the tensor–pullback substrate … consumer of that coherence" with a statement that the G-functor laws use only Mathlib's pseudofunctor package (`Pseudofunctor (LocallyDiscrete Schemeᵒᵖ) (Adj Cat)`) and are independent of project-local Sq1 (`sheafificationCompPullback_comp`). The laws are non-trivial (a multi-step mate-calculus over the `eqToHom` triangle transports and the unit; plain `simp` makes no progress), but the obstacle is Lean proof engineering, not mathematical underdevelopment.

2. **[major] Add `\lean{...}` hints and definition blocks for `pushPullObj` and `pushPullMap`** in sec:cech_three_part (between the geometric backbone paragraph and the plumbing paragraph). These are now axiom-clean bricks that a prover can be dispatched to prove laws about.

3. **[major] Add a lemma block for `pushPullMap_id` / `pushPullMap_comp`** (or a combined functor-assembly block for `pushPullFunctor : (Over X)ᵒᵖ ⥤ X.Modules`) with:
   - `\lean{AlgebraicGeometry.pushPullMap_id}` / `\lean{AlgebraicGeometry.pushPullMap_comp}` hints.
   - A proof sketch indicating the route via `conjugateEquiv_pullbackComp_inv`, `conjugateEquiv_pullbackId_hom`, and the pseudofunctor unitor/pentagon identities (`pseudofunctor_left_unitality`, `pseudofunctor_right_unitality`, `pseudofunctor_associativity`).

4. **[major] Add `\lean{...}` hints for `coverArrow`, `coverCechNerve`, and `relativeCechComplexOfNerve`** (all axiom-clean) so the backbone declarations are formally tracked.

---

## Severity summary

| Finding | Severity |
|---|---|
| Blueprint paragraph (2) asserts project-local Sq1 dependency for G's laws; prover has de-coupled (Mathlib pseudofunctor suffices) — misleads planning about dispatch gates | **must-fix-this-iter** |
| No `\lean{...}` hints or proof-sketch for `pushPullMap_id`/`pushPullMap_comp` — a prover cannot formalize from prose alone | **must-fix-this-iter** |
| `pushPullObj`, `pushPullMap` (added iter-263): substantive axiom-clean declarations with no `\lean{...}` blueprint reference | **major** |
| `coverArrow`, `coverCechNerve`, `relativeCechComplexOfNerve`: axiom-clean declarations with no `\lean{...}` blueprint reference | **major** |
| `pushPullMap` morphism description in blueprint ("unit/counit … over-triangle") is too terse to uniquely specify the 5-step Lean composite | **minor** |

**Overall verdict:** The six `\lean{...}`-referenced declarations all exist with matching signatures and expected sorry states; the new iter-263 bricks `pushPullObj`/`pushPullMap` are axiom-clean and correct, but the blueprint chapter fails on two must-fix dimensions: (1) the dependency claim in sec:cech_three_part paragraph (2) incorrectly asserts Sq1 coupling that the prover has now de-coupled, and (2) the functor laws `pushPullMap_id`/`pushPullMap_comp` have no blueprint block, no `\lean{...}` hint, and no proof sketch, leaving a prover unable to formalize them from the chapter.

**Declarations checked: 11 (6 via `\lean{...}`, 5 unreferenced). Red flags: 2 must-fix (blueprint adequacy), 2 major (missing references), 1 minor.**
