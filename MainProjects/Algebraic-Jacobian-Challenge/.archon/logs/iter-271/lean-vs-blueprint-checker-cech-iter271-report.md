# Lean ↔ Blueprint Check Report

## Slug
cech-iter271

## Iteration
271

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.CechNerve}` (chapter: `def:cech_nerve`)
- **Lean target exists**: yes (line 89, `noncomputable def`, body `:= sorry`)
- **Signature matches**: yes — augmented cosimplicial object `CosimplicialObject.Augmented X.Modules` matches blueprint's "augmented cosimplicial object in QCoh(X)"
- **Proof follows sketch**: N/A (admitted gap; both blueprint and in-file comment explicitly identify the push-pull functor `map_comp` law as the blocker)
- **notes**: `\leanok` is correctly set (declaration present with sorry). Blueprint's proof sketch honestly says this is the "one non-formal step". Honest sorry, not a red flag.

### `\lean{AlgebraicGeometry.coverArrow}` (chapter: `def:cover_arrow`)
- **Lean target exists**: yes (line 130, axiom-clean)
- **Signature matches**: yes — `Arrow Scheme.{u}` via `Arrow.mk (Sigma.desc 𝒰.f)` matches "single morphism ∐ᵢ Uᵢ → X"
- **Proof follows sketch**: yes (one-liner, matches "packaging the cover as one arrow")
- **notes**: Clean.

### `\lean{AlgebraicGeometry.coverCechNerve}` (chapter: `def:cover_cech_nerve`)
- **Lean target exists**: yes (line 139, axiom-clean)
- **Signature matches**: yes — `SimplicialObject.Augmented Scheme.{u}` via `(coverArrow 𝒰).augmentedCechNerve`; matches "augmented simplicial scheme"
- **Proof follows sketch**: yes (uses `Arrow.augmentedCechNerve` as blueprint prescribes)
- **notes**: Clean.

### `\lean{AlgebraicGeometry.pushPullObj}` (chapter: `def:push_pull_obj`)
- **Lean target exists**: yes (line 163, axiom-clean)
- **Signature matches**: yes — `(pushforward Y.hom).obj ((Scheme.Modules.pullback Y.hom).obj F)` matches "p_* p^* F"
- **Proof follows sketch**: yes (definition matches the object map description)
- **notes**: Clean.

### `\lean{AlgebraicGeometry.pushPullMap}` (chapter: `def:push_pull_map`)
- **Lean target exists**: yes (line 175, axiom-clean)
- **Signature matches**: yes — five-step composite with unit, pushforwardComp, two eqToHom transports, pullbackComp; matches blueprint's five-arrow diagram
- **Proof follows sketch**: yes (blueprint's five steps match the Lean composite)
- **notes**: Clean.

### `\lean{AlgebraicGeometry.pushPullMap_id}` (chapter: `lem:push_pull_functor`)
- **Lean target exists**: yes (line 216, axiom-clean proof)
- **Signature matches**: yes — `pushPullMap F (𝟙 Y) = 𝟙 (pushPullObj F Y)` matches blueprint's `G(id_Y) = id_{G(Y)}`
- **Proof follows sketch**: yes — uses `unit_conjugateEquiv` + `conjugateEquiv_pullbackId_hom` + `pseudofunctor_right_unitality` as the blueprint prescribes; `hom_ext; intro U; rfl` collapse is the plumbing detail not in the sketch (acceptable)
- **notes**: This half of `lem:push_pull_functor` is correctly closed.

### `\lean{AlgebraicGeometry.pushPullMap_comp}` (chapter: `lem:push_pull_functor`)
- **Lean target exists**: **NO** — no declaration `pushPullMap_comp` exists. The name appears only inside a `/- … -/` block comment at lines 273–321, documenting the deferred approach and iter-271 progress. There is no `lemma pushPullMap_comp` statement, not even a `sorry` stub.
- **Signature matches**: N/A (no declaration)
- **Proof follows sketch**: N/A
- **notes**: The `% NOTE (iter-264)` in the blueprint still accurately describes the situation. The `\leanok` on `lem:push_pull_functor` over-states: `sync_leanok` apparently set it when `pushPullMap_id` became sorry-free, but the second `\lean{}` pin has no declaration at all. The NOTE's recommended actions (split the block, or add a sorry stub) remain unactioned. **See Major finding #1.**

### `\lean{AlgebraicGeometry.relativeCechComplexOfNerve}` (chapter: `def:relative_cech_complex_of_nerve`)
- **Lean target exists**: yes (line 389, axiom-clean)
- **Signature matches**: yes — `CochainComplex S.Modules ℕ` from `alternatingCofaceMapComplex ∘ whiskering ∘ Augmented.drop` matches blueprint's "forget augmentation, push forward, alternating-coface complex"
- **Proof follows sketch**: yes (blueprint's three steps exactly match the Lean body)
- **notes**: Clean.

### `\lean{AlgebraicGeometry.CechAcyclic.affine}` (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: yes (line 441, body `:= sorry`)
- **Signature matches**: yes — `IsZero ((CechComplex f 𝒰 F).homology p)` with `hp : 1 ≤ p`, `[IsAffine X]`, `[IsAffineHom f]`; matches blueprint's `\check{H}^p = 0` for `p > 0`
- **Proof follows sketch**: N/A (sorry; blueprint's proof block marks "currently-absent Mathlib infrastructure")
- **notes**: Honest acknowledged sorry. `\leanok` correct (statement present).

### `\lean{AlgebraicGeometry.cech_computes_higherDirectImage}` (chapter: `lem:cech_computes_cohomology`)
- **Lean target exists**: yes (line 478, body `:= sorry`)
- **Signature matches**: yes — `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` under `[HasInjectiveResolutions X.Modules]`, `[QuasiCompact f]`, `[IsSeparated f]`; matches blueprint's weak-existence form with the `HasInjectiveResolutions` hypothesis
- **Proof follows sketch**: N/A (sorry; blueprint marks "currently-absent: Čech-to-derived-functor spectral sequence + Leray spectral sequence")
- **notes**: Honest acknowledged sorry.

### `\lean{AlgebraicGeometry.cechHigherDirectImage}` (chapter: `def:cech_higher_direct_image`)
- **Lean target exists**: yes (line 506, axiom-clean)
- **Signature matches**: yes — `(CechComplex f 𝒰 F).homology i` matches `H^i(Č•(𝒰, F))`
- **Proof follows sketch**: yes (one-liner definition)
- **notes**: Clean.

### `\lean{AlgebraicGeometry.cech_flatBaseChange}` (chapter: `lem:cech_flat_base_change`)
- **Lean target exists**: yes (line 538, body `:= sorry`)
- **Signature matches**: yes — `Nonempty ((Scheme.Modules.pullback g).obj (cechHigherDirectImage f 𝒰 F i) ≅ cechHigherDirectImage f' 𝒰' ((Scheme.Modules.pullback g').obj F) i)` matches blueprint's `g^*(R^i f_* F) ≅ R^i f'_* F'`; `[Flat g]`, `[QuasiCompact f]`, `[IsSeparated f]` match hypotheses
- **Proof follows sketch**: N/A (sorry; blueprint marks "currently-absent: term-wise affine base change of Čech complex")
- **notes**: Honest acknowledged sorry.

---

## Red flags

### Missing `\lean{}` target declared in block

- **`lem:push_pull_functor`** (blueprint lines 335–385): carries `\lean{AlgebraicGeometry.pushPullMap_comp}` but no such Lean declaration exists (not even a sorry stub). The `\leanok` on this block was set by `sync_leanok` when `pushPullMap_id` became sorry-free, but the second pin is a dangling pointer. The `% NOTE (iter-264)` accurately flags this and recommends (a) splitting the block or (b) adding a sorry stub — **neither action has been taken in iter-271**.

This is the only true structural integrity issue in the file.

---

## Unreferenced declarations (informational)

Neither of the following has a `\lean{}` entry anywhere in the blueprint:

1. **`AlgebraicGeometry.pushPull_unit_mate`** (line 332, axiom-clean lemma) — the "mate-calculus core" that converts `η^{f≫p}` into iterated units; described in the in-file comment as a reusable ingredient for `pushPullMap_comp`. The blueprint paragraph (2) in `sec:cech_three_part` refers to the mate calculus by name but cites no specific sub-lemma. Predates iter-271.

2. **`AlgebraicGeometry.pushPull_transport_cancel`** (line 365, axiom-clean lemma) — **NEW in iter-271**. The kernel-cheap over-triangle transport cancellation helper. The blueprint has no entry for this. Its purpose is described in detail in the in-file comment at lines 350–378 but not in the blueprint at all.

   Per the directive: the planner should blueprint this as a named infrastructure lemma — suggested location: inside `sec:cech_three_part`, after `\paragraph{(2) Push--pull functor}`, as a brief remark block:
   ```
   \begin{lemma}\leanok
     [Over-triangle transport cancellation]
     \label{lem:push_pull_transport_cancel}
     \lean{AlgebraicGeometry.pushPull_transport_cancel}
     \uses{def:push_pull_map}
     ...
   \end{lemma}
   ```
   This is 1-to-1 coverage debt for iter-271.

---

## Blueprint adequacy for this file

- **Coverage**: 12/14 Lean declarations have a corresponding `\lean{}` block (counting `pushPullMap_id` and `pushPullMap_comp` as two targets). One `\lean{}` target (`pushPullMap_comp`) is dangling. Two declarations (`pushPull_unit_mate`, `pushPull_transport_cancel`) are unreferenced. All four sorry-bearing declarations are honestly flagged in both blueprint and Lean file. By substantive count: 12 blueprint-matched + 2 unreferenced helpers.

- **Proof-sketch depth**: **under-specified for `lem:push_pull_functor`** (`pushPullMap_comp`). The blueprint proof sketch (lines 362–385) correctly names the three Mathlib lemmas needed (conjugateEquiv_pullbackComp_inv, pseudofunctor_right_unitality, pseudofunctor_associativity) and the overall mate-calculus route, but is entirely silent on:
  - The specific kernel `whnf` blow-up on `eqToHom` transports that blocked five prior iterations
  - The `pushPull_transport_cancel` trick (free-hypothesis form, `subst h`, `erw` not `rw`) that resolved it
  - The `pushPull_unit_mate` sub-lemma
  
  A prover working from the blueprint alone would reproduce the blocked approach. The in-file comment (lines 273–321) now contains the actual working recipe, which is far more detailed than the blueprint.
  
  For the other sorry-bearing declarations, the proof sketches are adequate: they correctly identify the missing Mathlib infrastructure (spectral sequences, localisation homotopy, affine Čech base change) and provide enough mathematical detail for an independent check.

- **Hint precision**: **loose for `lem:push_pull_functor`** — the second `\lean{}` pin (`pushPullMap_comp`) points to a non-existent declaration. All other pins are precise.

- **Generality**: matches need for all covered declarations.

- **Recommended chapter-side actions**:
  1. **(Major, plan-agent action)** Split `lem:push_pull_functor` into two separate blueprint blocks — one for `pushPullMap_id` (already `\leanok`) and one for `pushPullMap_comp` (not yet a declaration). Remove the combined block's `\lean{pushPullMap_comp}` pin until the declaration exists. Alternatively, instruct the prover to add a `lemma pushPullMap_comp ... := sorry` stub so sync_leanok can track it independently. The `% NOTE (iter-264)` has been pending since iter-264 with no action.
  2. **(Major, blueprint-writing action)** Add a `\lean{AlgebraicGeometry.pushPull_transport_cancel}` entry — either as a brief remark block or a named lemma inside `sec:cech_three_part` after the push-pull paragraph. This is 1-to-1 coverage debt for iter-271.
  3. **(Minor, blueprint-writing action)** Add a `\lean{AlgebraicGeometry.pushPull_unit_mate}` entry (or a cross-reference) in the proof sketch of `lem:push_pull_functor`.
  4. **(Minor, optional)** Expand the `lem:push_pull_functor` proof sketch to document the `eqToHom` kernel obstacle and the `free-hypothesis subst` pattern, so future provers have a working recipe.

---

## Severity summary

### Major findings

1. **`lem:push_pull_functor` block lists `\lean{AlgebraicGeometry.pushPullMap_comp}` but no such declaration exists** — the `\leanok` on the combined block over-states coverage; `% NOTE (iter-264)` is still accurate and its recommended fix (split or sorry stub) has not been taken in iter-271. Blueprint `\lean{}` hint is a dangling pointer.

2. **`AlgebraicGeometry.pushPull_transport_cancel` (new in iter-271) has no `\lean{}` blueprint entry** — substantive axiom-clean infrastructure lemma, 1-to-1 coverage debt.

### Minor findings

3. **`AlgebraicGeometry.pushPull_unit_mate` has no `\lean{}` blueprint entry** — predates iter-271, helper for the deferred `pushPullMap_comp`; blueprint prose alludes to the mate calculus without naming the sub-lemma.

4. **`lem:push_pull_functor` proof sketch is under-specified for the `eqToHom` kernel obstacle** — correct mathematical content, but silent on the `pushPull_transport_cancel` technique that unblocked the actual formalization.

### No must-fix-this-iter findings

All sorry bodies (`CechNerve`, `CechAcyclic.affine`, `cech_computes_higherDirectImage`, `cech_flatBaseChange`) are honestly acknowledged in both the blueprint and the Lean file as depending on Mathlib-absent infrastructure. No excuse-comments, no fake/placeholder bodies on claims the blueprint asserts are proven, no axiom introductions, no weakened-wrong definitions.

---

**Overall verdict**: The file is structurally sound — all sorries are honest and documented, signatures match, axiom-clean declarations are correct — but carries two major blueprint hygiene issues: the dangling `\lean{pushPullMap_comp}` pin (pending since iter-264, unactioned) and the missing blueprint entry for the new iter-271 `pushPull_transport_cancel` brick. 12 declarations checked, 2 major / 2 minor findings, 0 must-fix-this-iter.
