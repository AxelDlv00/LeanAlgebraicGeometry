# Lean ↔ Blueprint Check Report

## Slug
cech264

## Iteration
264

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.CechNerve}` (chapter: `def:cech_nerve`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(𝒰 : X.OpenCover) (F : X.Modules) : CosimplicialObject.Augmented X.Modules` matches "augmented cosimplicial object in QCoh(X)" for `F`
- **Proof follows sketch**: N/A — definition body is `:= sorry`; blueprint correctly identifies the push-pull functor as the sole gap
- **notes**: `:= sorry` is honest; blueprint's `\leanok` on statement block is correct per marker semantics (declaration present with at least a sorry). The in-file comment explains exactly why: `pushPullFunctor`'s `map_comp` requires `pushforwardComp/pullbackComp` coherence.

### `\lean{AlgebraicGeometry.CechComplex}` (chapter: `def:cech_complex`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(f : X ⟶ S) (𝒰 : X.OpenCover) (F : X.Modules) : CochainComplex S.Modules ℕ` matches the blueprint's "relative Čech complex in QCoh(S)"
- **Proof follows sketch**: yes — defined as `relativeCechComplexOfNerve f (CechNerve 𝒰 F)`, faithfully implementing the blueprint's stated factorization
- **notes**: Because `CechNerve` is sorry'd, `CechComplex` carries an implicit sorry. Blueprint's `\leanok` is correct (statement present). The factoring is exactly as the blueprint describes.

### `\lean{AlgebraicGeometry.coverArrow}` (chapter: `def:cover_arrow`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(𝒰 : X.OpenCover) : Arrow Scheme.{u}` packages `∐ᵢ Uᵢ → X`
- **Proof follows sketch**: yes — `Arrow.mk (Sigma.desc 𝒰.f)` is exactly what the blueprint describes
- **notes**: Axiom-clean. ✓

### `\lean{AlgebraicGeometry.coverCechNerve}` (chapter: `def:cover_cech_nerve`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(𝒰 : X.OpenCover) : SimplicialObject.Augmented Scheme.{u}`
- **Proof follows sketch**: yes — `(coverArrow 𝒰).augmentedCechNerve` is the one-liner the blueprint anticipates
- **notes**: Axiom-clean. ✓

### `\lean{AlgebraicGeometry.pushPullObj}` (chapter: `def:push_pull_obj`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(F : X.Modules) (Y : Over X) : X.Modules`, body `(pushforward Y.hom).obj ((pullback Y.hom).obj F)` = `p_* p^* F`
- **Proof follows sketch**: yes
- **notes**: Axiom-clean. ✓

### `\lean{AlgebraicGeometry.pushPullMap}` (chapter: `def:push_pull_map`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(F : X.Modules) {Y₁ Y₂ : Over X} (g : Y₂ ⟶ Y₁) : pushPullObj F Y₁ ⟶ pushPullObj F Y₂`
- **Proof follows sketch**: yes — the Lean definition is the exact five-step composite described in the blueprint (unit, pushforwardComp.hom, eqToHom transport, pushforward of pullbackComp.hom, eqToHom transport)
- **notes**: Axiom-clean. Blueprint description and Lean implementation align precisely. ✓

### `\lean{AlgebraicGeometry.pushPullMap_id}` — part of `lem:push_pull_functor`
- **Lean target exists**: yes
- **Signature matches**: yes — `(F : X.Modules) (Y : Over X) : pushPullMap F (𝟙 Y) = 𝟙 (pushPullObj F Y)`
- **Proof follows sketch**: yes — proof routes through `unit_conjugateEquiv`, `conjugateEquiv_pullbackId_hom`, `pseudofunctor_right_unitality`, exactly as the blueprint proof sketch prescribes
- **notes**: Claimed axiom-clean (no sorry); proof is ~55 LOC using the mate calculus the blueprint describes. ✓

### `\lean{AlgebraicGeometry.pushPullMap_comp}` — part of `lem:push_pull_functor`
- **Lean target exists**: **no** — this declaration does not appear anywhere in the Lean file; it is deferred to a `/-  ... -/` comment block (not a `lemma` or `def`)
- **Signature matches**: N/A (declaration absent)
- **Proof follows sketch**: N/A
- **notes**: **MAJOR FINDING.** The blueprint's `lem:push_pull_functor` block lists `\lean{AlgebraicGeometry.pushPullMap_comp}` alongside `\lean{AlgebraicGeometry.pushPullMap_id}`, and the statement block carries `\leanok`. However `pushPullMap_comp` has not been stubbed (not even as `:= sorry`) — it lives only in a block comment. The `\leanok` on `lem:push_pull_functor`'s statement block is thus inaccurate with respect to this second `\lean{...}` target. `sync_leanok` presumably set the marker based on `pushPullMap_id` alone; the block is partially incomplete. See **Red flags** below.

### `\lean{AlgebraicGeometry.relativeCechComplexOfNerve}` (chapter: `def:relative_cech_complex_of_nerve`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(f : X ⟶ S) (N : CosimplicialObject.Augmented X.Modules) : CochainComplex S.Modules ℕ`
- **Proof follows sketch**: yes — body is the exact three-step composition (drop augmentation, whisker pushforward, alternating-coface complex) the blueprint §(3) describes
- **notes**: Axiom-clean. ✓

### `\lean{AlgebraicGeometry.CechAcyclic.affine}` (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: yes
- **Signature matches**: partial match — blueprint's informal statement concerns standard covers of affines (`U = ∪ D(fᵢ)`), while Lean uses a general `X.OpenCover` without restricting to standard covers. The blueprint's conclusion (`IsZero` of positive cohomology) matches. This generality difference is intentional and acceptable (Lean is more general), but the blueprint does not explain this generalization.
- **Proof follows sketch**: N/A — body is `:= sorry`; the blueprint proof sketch (prime-local contracting homotopy) is present and detailed
- **notes**: The blueprint explicitly annotates: *"This proof depends on the following currently-absent Mathlib infrastructure…"*, which honestly explains the sorry. ✓ Minor generality drift noted (standard-cover vs general OpenCover).

### `\lean{AlgebraicGeometry.cech_computes_higherDirectImage}` (chapter: `lem:cech_computes_cohomology`)
- **Lean target exists**: yes
- **Signature matches**: yes — `[HasInjectiveResolutions X.Modules] (f : X ⟶ S) [QuasiCompact f] [IsSeparated f] (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules) (hF : F.IsQuasicoherent) (i : ℕ) : Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)`. Blueprint explicitly explains the `Nonempty` (existence) form and the `HasInjectiveResolutions` hypothesis.
- **Proof follows sketch**: N/A — body is `:= sorry`; blueprint provides the Čech-to-cohomology + Leray spectral sequence sketch
- **notes**: Blueprint explicitly notes both missing spectral sequences. Honest sorry. ✓

### `\lean{AlgebraicGeometry.cechHigherDirectImage}` (chapter: `def:cech_higher_direct_image`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(f : X ⟶ S) (𝒰 : X.OpenCover) (F : X.Modules) (i : ℕ) : S.Modules`; body `(CechComplex f 𝒰 F).homology i`
- **Proof follows sketch**: yes — definitional, no proof needed
- **notes**: Axiom-clean modulo cascaded sorry from `CechNerve`. ✓

### `\lean{AlgebraicGeometry.cech_flatBaseChange}` (chapter: `lem:cech_flat_base_change`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X) (h : IsPullback g' f' f g) [Flat g] [QuasiCompact f] [IsSeparated f] (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (𝒰' : X'.OpenCover) [Finite 𝒰'.I₀] (F : X.Modules) (hF : F.IsQuasicoherent) (i : ℕ) : Nonempty ((pullback g).obj (cechHigherDirectImage f 𝒰 F i) ≅ cechHigherDirectImage f' 𝒰' ((pullback g').obj F) i)`. Matches blueprint.
- **Proof follows sketch**: N/A — body is `:= sorry`; blueprint provides the term-wise affine base-change sketch
- **notes**: Blueprint explicitly notes missing Mathlib infrastructure (term-wise affine base change, flatness of `-⊗_A B`). Honest sorry. ✓

---

## Red flags

### Pseudo-placeholder / missing declaration behind a `\lean{...}` hint

- **`pushPullMap_comp`** (`lem:push_pull_functor`, blueprint line ~338–339): Blueprint lists `\lean{AlgebraicGeometry.pushPullMap_comp}` as the second `\lean{...}` target of `lem:push_pull_functor`. No such Lean declaration exists — the composition law lives only in a `/-  ... -/` block comment between `pushPullMap_id` and `relativeCechComplexOfNerve`. The declaration has neither a `lemma`/`theorem` header nor even a `:= sorry` stub. This means:
  1. The `\lean{pushPullMap_comp}` reference is a dangling pointer.
  2. The `\leanok` marker on the `lem:push_pull_functor` statement block (placed by `sync_leanok`) is based only on `pushPullMap_id` existing; strictly, the full lemma ("both laws assemble `G` into a functor") is not yet even stub-formalized.

### Stale excuse-comments (informational, not blocking)

No excuse-comments of the form "wrong but works for now" are present. The in-file comments for all sorry items are honest gap-descriptions (missing Mathlib infrastructure), not excuses for incorrect code.

### Axiom declarations
None found.

---

## Unreferenced declarations (informational)

The following Lean declarations appear in the file with no corresponding `\lean{...}` reference in the blueprint chapter:

- (none) — every declaration in the file maps to a `\lean{...}` reference in the chapter.

All seven `\lean{...}`-referenced declarations that ARE present in Lean (`CechNerve`, `coverArrow`, `coverCechNerve`, `pushPullObj`, `pushPullMap`, `pushPullMap_id`, `relativeCechComplexOfNerve`, `CechComplex`, `CechAcyclic.affine`, `cech_computes_higherDirectImage`, `cechHigherDirectImage`, `cech_flatBaseChange`) have blueprint entries. There are no helper-only declarations in the file that lack a blueprint entry.

---

## Blueprint adequacy for this file

- **Coverage**: 11/12 blueprint `\lean{...}` targets exist as Lean declarations; the missing one is `pushPullMap_comp` (see red flags above). The 11 present targets are all accounted for in the blueprint. No substantive unreferenced declarations.

- **Proof-sketch depth**: **adequate** for all open items. For each of the four `:= sorry` declarations the blueprint provides:
  - `CechNerve`: explanation that the push-pull functor is the sole gap and why (pseudofunctor coherence). Depth matches the Lean in-file comment block precisely.
  - `CechAcyclic.affine`: the prime-local contracting homotopy is written out with explicit formula `h(s)_{i₀…i_p} = s_{i_fix i₀…i_p}`; the Mathlib gap (missing localisation description of the Čech complex on affines) is named.
  - `cech_computes_higherDirectImage`: both spectral sequences used (Čech-to-cohomology + Leray) are identified; the Mathlib gap is named.
  - `cech_flatBaseChange`: the affine base-change step and flatness argument are written out; the Mathlib gap is named.
  - `pushPullMap_comp` (deferred): the blueprint proof sketch names the specific lemmas (`pseudofunctor_associativity`, `Adjunction.comp_unit_app`, `Adjunction.unit_naturality`), matches the Lean in-file comment block, and gives adequate guidance for the ~150-LOC pentagon calculation when it is attempted.

- **Hint precision**: **precise** — all twelve `\lean{...}` hints use fully qualified names in the `AlgebraicGeometry` namespace, match the actual Lean declaration names exactly (for the 11 that exist), and the one that doesn't exist (`pushPullMap_comp`) is the intended future name for the deferred law.

- **Generality**: **matches need** — the generality of the Lean signatures matches what the project requires. Minor exception: `CechAcyclic.affine` uses a general `X.OpenCover` while the blueprint's informal statement uses the more specific "standard open cover of an affine"; this is an acceptable generalization (Lean is more general), though the blueprint should note that the Lean statement is more general than stated in the informal prose.

- **Recommended chapter-side actions**:
  1. **[major]** Remove `\lean{AlgebraicGeometry.pushPullMap_comp}` from the `lem:push_pull_functor` statement block (or add a `% NOTE: pushPullMap_comp not yet stubbed`) until the declaration actually exists in Lean — even as `:= sorry`. The current state causes `sync_leanok` to mark the block as `\leanok` based only on `pushPullMap_id`, giving a false impression that both functor laws are at least stub-formalized. The correct resolution is one of:
     (a) Add a minimal `lemma pushPullMap_comp ... := sorry` stub to the Lean file, which will let `sync_leanok` set `\leanok` honestly for the full block, OR
     (b) Split `lem:push_pull_functor` into two blueprint blocks (one per law) so `\leanok` can track them independently.
  2. **[minor]** Note in `lem:cech_acyclic_affine` that the Lean signature generalises the informal statement from "standard open covers" to arbitrary `X.OpenCover` instances.

---

## Severity summary

| # | Finding | Severity |
|---|---------|----------|
| 1 | `\lean{AlgebraicGeometry.pushPullMap_comp}` referenced in `lem:push_pull_functor` but declaration does not exist in Lean (not even as `:= sorry`); `\leanok` on statement block is therefore inaccurate for the full lemma | **major** |
| 2 | `CechAcyclic.affine` Lean signature uses general `X.OpenCover` while blueprint prose restricts to "standard open covers"; undocumented generalization | **minor** |
| 3 | Four `:= sorry` bodies (`CechNerve`, `CechAcyclic.affine`, `cech_computes_higherDirectImage`, `cech_flatBaseChange`) are honestly described in both Lean and blueprint — not a red flag, honest gap notation | informational |

**Overall verdict**: The file is faithful to the blueprint for all 11 existing declarations; the sole drift is that `pushPullMap_comp` is named in a blueprint `\lean{...}` hint but has no Lean declaration (not even a sorry stub), causing the `\leanok` marker on `lem:push_pull_functor` to reflect only half the lemma. The remaining four sorries are honestly represented on both sides with appropriate Mathlib-gap acknowledgements.
