# Lean ↔ Blueprint Check Report

## Slug
cechhdi

## Iteration
002

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

All `\lean{...}` blocks in the chapter are enumerated below. Entries for
declarations absent from this file are marked "file not in scope" — they are
referenced in the blueprint but are not (and are not expected to be) in this Lean
file yet.

### `\lean{AlgebraicGeometry.coverArrow}` (chapter: `def:cover_arrow`)
- **Lean target exists**: yes (line 102)
- **Signature matches**: yes — `(𝒰 : X.OpenCover) : Arrow Scheme.{u}` ✓
- **Proof follows sketch**: N/A (definition)
- **notes**: Blueprint has `\leanok`. Body `Arrow.mk (Sigma.desc 𝒰.f)` is exact match of the "universal map out of the coproduct" description.

### `\lean{AlgebraicGeometry.coverCechNerve}` (chapter: `def:cover_cech_nerve`)
- **Lean target exists**: yes (line 111)
- **Signature matches**: yes — `(𝒰 : X.OpenCover) : SimplicialObject.Augmented Scheme.{u}` ✓
- **Proof follows sketch**: N/A (definition)
- **notes**: Blueprint has `\leanok`. Body `(coverArrow 𝒰).augmentedCechNerve` matches "augmented Čech nerve of the cover arrow". Correct.

### `\lean{AlgebraicGeometry.pushPullObj}` (chapter: `def:push_pull_obj`)
- **Lean target exists**: yes (line 135)
- **Signature matches**: yes — `(F : X.Modules) (Y : Over X) : X.Modules` ✓
- **Proof follows sketch**: N/A (definition)
- **notes**: Blueprint has `\leanok`. Body `(pushforward Y.hom).obj ((Scheme.Modules.pullback Y.hom).obj F)` = `p_* p^* F` matches blueprint exactly.

### `\lean{AlgebraicGeometry.pushPullMap}` (chapter: `def:push_pull_map`)
- **Lean target exists**: yes (line 147)
- **Signature matches**: yes — five-step composite type `pushPullObj F Y₁ ⟶ pushPullObj F Y₂` for `g : Y₂ ⟶ Y₁` ✓
- **Proof follows sketch**: N/A (definition)
- **notes**: Blueprint has `\leanok`. Five-step body (unit η → pushforwardComp.hom → eqToHom transport → pushforward of pullbackComp.hom → eqToHom transport) matches the blueprint's five-step diagram exactly, including the two eqToHom over-triangle coercions.

### `\lean{AlgebraicGeometry.pushPullMap_id}` (chapter: `lem:push_pull_id`)
- **Lean target exists**: yes (line 188)
- **Signature matches**: yes — `pushPullMap F (𝟙 Y) = 𝟙 (pushPullObj F Y)` ✓
- **Proof follows sketch**: yes — proof routes through `unit_conjugateEquiv`, `conjugateEquiv_pullbackId_hom`, `pseudofunctor_right_unitality`, and eqToHom collapse, exactly as described in the blueprint's proof block.
- **notes**: Proof is complete (no sorry). Blueprint lacks `\leanok` — sync matter, not a checker issue.

### `\lean{AlgebraicGeometry.pushPullMap_comp}` (chapter: `lem:push_pull_comp`) ← **FOCUS**
- **Lean target exists**: yes (line 627)
- **Signature matches**: yes — `pushPullMap F (h ≫ g) = pushPullMap F g ≫ pushPullMap F h` for composable `g : Y₂ ⟶ Y₁`, `h : Y₃ ⟶ Y₂` ✓
- **Proof follows sketch**: **partial** — mathematical content matches (pseudofunctor pentagon, composite-unit, transport cancellation) but implementation route diverges from the blueprint's proof sketch (see notes).
- **notes**: Proof is complete (no sorry). Blueprint lacks `\leanok` — sync matter. See **Blueprint adequacy** section for the proof-strategy divergence finding.

### `\lean{AlgebraicGeometry.pushPull_unit_mate}` (chapter: `lem:push_pull_unit_mate`)
- **Lean target exists**: yes (line 304)
- **Signature matches**: yes — the four-component equation at `N : Z.Modules` for `f : A ⟶ B`, `p : B ⟶ Z` ✓
- **Proof follows sketch**: yes — blueprint says "Proved directly in Lean"; proof uses `unit_conjugateEquiv`, `conjugateEquiv_pullbackComp_inv`, `Adjunction.comp_unit_app`, consistent with mate calculus.
- **notes**: Complete proof. Blueprint lacks `\leanok` — sync matter.

### `\lean{AlgebraicGeometry.pushPull_transport_cancel}` (chapter: `lem:push_pull_transport_cancel`)
- **Lean target exists**: yes (line 337)
- **Signature matches**: yes — eqToHom collapse with free hypothesis `h : gl ≫ p₁ = p₂` ✓
- **Proof follows sketch**: yes — blueprint says "Proved directly in Lean"; proof `subst h; simp` is exactly the expected single-substitution collapse.
- **notes**: Complete proof. Blueprint lacks `\leanok` — sync matter.

### `\lean{AlgebraicGeometry.relativeCechComplexOfNerve}` (chapter: `def:relative_cech_complex_of_nerve`)
- **Lean target exists**: yes (line 712)
- **Signature matches**: yes — `(f : X ⟶ S) (N : CosimplicialObject.Augmented X.Modules) : CochainComplex S.Modules ℕ` ✓
- **Proof follows sketch**: N/A (definition)
- **notes**: Blueprint has `\leanok`. Body (drop augmentation → whisker with pushforward f → alternatingCofaceMapComplex) faithfully implements the blueprint's three-step coherence-free plumbing.

### `\lean{AlgebraicGeometry.CechNerve}` (chapter: `def:cech_nerve`) ← **FOCUS**
- **Lean target exists**: yes (line 698)
- **Signature matches**: yes — `(𝒰 : X.OpenCover) (F : X.Modules) : CosimplicialObject.Augmented X.Modules` ✓
- **Proof follows sketch**: yes — blueprint describes whisker of `pushPullFunctor` with `(coverCechNerveOverAug 𝒰).rightOp`; body is exactly `(CosimplicialObject.Augmented.whiskeringObj (Over X)ᵒᵖ X.Modules (pushPullFunctor F)).obj (coverCechNerveOverAug 𝒰).rightOp` ✓
- **notes**: Blueprint has `\leanok`. Definition is **axiom-clean**: depends on `pushPullFunctor` which now has both functor laws (`pushPullMap_id`, `pushPullMap_comp`) proved. The docstring assertion "This is now *constructed*, not postulated" is accurate.

### `\lean{AlgebraicGeometry.CechComplex}` (chapter: `def:cech_complex`)
- **Lean target exists**: yes (line 737)
- **Signature matches**: yes — `(f : X ⟶ S) (𝒰 : X.OpenCover) (F : X.Modules) : CochainComplex S.Modules ℕ` ✓
- **Proof follows sketch**: N/A (definition)
- **notes**: Blueprint has `\leanok`. Body `relativeCechComplexOfNerve f (CechNerve 𝒰 F)` is the literal two-step construction the blueprint describes.

### `\lean{AlgebraicGeometry.CechAcyclic.affine}` (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: yes (line 764)
- **Signature matches**: yes — `[IsAffine X] (f : X ⟶ S) [IsAffineHom f] (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules) (hF : F.IsQuasicoherent) (p : ℕ) (hp : 1 ≤ p) : IsZero ((CechComplex f 𝒰 F).homology p)` ✓
- **Proof follows sketch**: N/A — sorry, by design (known issue per directive).
- **notes**: Blueprint has `\leanok`. Pre-approved sorry; not a red flag per directive.

### `\lean{AlgebraicGeometry.cech_computes_higherDirectImage}` (chapter: `lem:cech_computes_cohomology`)
- **Lean target exists**: yes (line 801)
- **Signature matches**: yes — `[HasInjectiveResolutions X.Modules] (f : X ⟶ S) [QuasiCompact f] [IsSeparated f] (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules) (hF : F.IsQuasicoherent) (i : ℕ) : Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)`. Matches blueprint's precise "Nonempty" existence form ✓.
- **Proof follows sketch**: N/A — sorry, by design (known issue per directive).
- **notes**: Blueprint has `\leanok`. Pre-approved sorry; not a red flag per directive. Frozen signature.

### `\lean{AlgebraicGeometry.affine_serre_vanishing}` (chapter: `lem:affine_serre_vanishing`)
- **Lean target exists**: no — absent from this file.
- **Signature matches**: N/A
- **notes**: Blueprint has no `\leanok` marker. Unformalized; not expected in this file this iteration.

### `\lean{AlgebraicGeometry.cech_eq_cohomology_of_basis}` (chapter: `lem:cech_to_cohomology_on_basis`)
- **Lean target exists**: no — absent from this file.
- **notes**: No `\leanok`. Unformalized; not expected this iteration.

### `\lean{AlgebraicGeometry.cechAugmented_exact}` (chapter: `lem:cech_augmented_resolution`)
- **Lean target exists**: no — absent from this file.
- **notes**: No `\leanok`. Unformalized; not expected this iteration.

### `\lean{AlgebraicGeometry.higherDirectImage_isSheafify_presheafCohomology}` (chapter: `lem:higher_direct_image_presheaf`)
- **Lean target exists**: no — absent from this file (defined in companion `HigherDirectImage.lean`).
- **notes**: No `\leanok` in this chapter. Cross-file; not expected here.

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}` (chapter: `lem:open_immersion_pushforward_comp`)
- **Lean target exists**: no — absent from this file.
- **notes**: No `\leanok`. Unformalized; not expected this iteration.

### `\lean{AlgebraicGeometry.cechTerm_pushforward_acyclic}` (chapter: `lem:cech_term_pushforward_acyclic`)
- **Lean target exists**: no — absent from this file.
- **notes**: No `\leanok`. Unformalized; not expected this iteration.

---

## Red flags

No must-fix red flags. The two sorry-bodies (`CechAcyclic.affine`, `cech_computes_higherDirectImage`) are pre-approved per the directive.

---

## Unreferenced declarations (informational)

The following declarations appear in the Lean file but have no `\lean{...}` reference in the blueprint. Per the directive, these are **all known issues** being tracked for blueprinting; they are listed here for completeness.

**Pre-existing helpers (no blueprint block)**:
- `rawPushPullMap` (line 389): raw form of `pushPullMap` with free over-triangle
- `rawPushPullMap_comp` (line 536): composition law for `rawPushPullMap` with free hypotheses; contains the actual proof content of `pushPullMap_comp`
- `pushPull_pentagon` (line 491): the pullback pseudofunctor pentagon; key sub-lemma
- `pushPull_unit_comp` (line 358): solved form of `pushPull_unit_mate`
- `pushforwardComp_hom_app_id` (line 377): strictness of pushforward comparison (= `rfl`)
- `rawPushPullMap_self` (line 455), `rawPushPullMap_self_gen` (line 472): transport-free forms of `rawPushPullMap`
- `pushPullMap_eq_raw` (line 406): `pushPullMap = rawPushPullMap …` by `rfl`

**New this iter (no blueprint block)**:
- `pushPullFunctor` (line 640): the assembled `(Over X)ᵒᵖ ⥤ X.Modules` functor; substantive — should have a blueprint block
- `coverCechNerveOver` (line 651): backbone lifted to `SimplicialObject (Over X)`
- `coverCechNerveOverAug` (line 660): augmented form of `coverCechNerveOver`
- `cechNerveCosimplicial` (line 670): the underlying cosimplicial object before adding the augmentation

Of these, **`pushPullFunctor`** is the most substantive unreferenced declaration: it is the functor assembled from the object map, morphism map, and both functor laws — the key mathematical object that the blueprint discusses at length (§ "(2) Push–pull functor") but does not give a `\lean{...}` tag to. The blueprint-writing subagent should add a `\begin{definition}…\lean{AlgebraicGeometry.pushPullFunctor}…\end{definition}` block, and similarly for `coverCechNerveOver` and `coverCechNerveOverAug`.

---

## Blueprint adequacy for this file

### Coverage
13 of 19 `\lean{...}` blocks in the chapter map to declarations present in this file. The remaining 6 (`affine_serre_vanishing`, `cech_eq_cohomology_of_basis`, `cechAugmented_exact`, `higherDirectImage_isSheafify_presheafCohomology`, `higherDirectImage_openImmersion_comp`, `cechTerm_pushforward_acyclic`) are unformalized in this file; none has a `\leanok` marker in the chapter.

Of the 13 declarations present: all 13 exist with correct signatures. 11 have correct (or N/A) proof bodies; 2 have pre-approved sorries (`CechAcyclic.affine`, `cech_computes_higherDirectImage`).

Among declarations in the Lean file: 13 have blueprint `\lean{...}` blocks (adequate), 11 are unlisted helpers that are either pre-existing (`rawPushPullMap` family) or new this iter (known issue per directive).

### Proof-sketch depth
**Partially under-specified for `lem:push_pull_comp`.** The blueprint's `\begin{proof}` block for this lemma reads:

> Using injectivity of the conjugateEquiv bijection, the claim reduces to the corresponding identity on the pullback side, which is the pseudofunctor pentagon pseudofunctor_associativity; the composite adjunction unit is handled by the mate core Lemma lem:push_pull_unit_mate (and its solved form pushPull_unit_comp), and the over-triangle eqToHom transports are discharged by Lemma lem:push_pull_transport_cancel.

The described route — via `conjugateEquiv_comp` and injectivity of `conjugateEquiv` — was **not used** in the actual Lean proof and was found to be infeasible in practice (as documented extensively in the inline proof-development comments in the Lean file). The actual proof:
1. Rewrites `pushPullMap` to `rawPushPullMap` three times via `pushPullMap_eq_raw` (a `rfl` lemma).
2. Applies `rawPushPullMap_comp`, which internally:
   - Uses `subst wg; subst wh` to make all eqToHom transports trivial (kernel-cheap); this is the actual mechanism for discharging transports, distinct from what the blueprint describes.
   - Uses `pushPull_unit_comp` (composite-unit decomposition).
   - Uses `pushPull_pentagon` (wrapping `pseudofunctor_associativity`).
   - Uses `(pullbackPushforwardAdjunction b).unit.naturality` to slide the inner unit.
   - Uses `convert … using 2` on the `(pushforward p₁).map` application of `INNER`.

The mathematical content is correct and the proof is complete (axiom-clean). But the proof sketch describes a different algorithmic route (via `conjugateEquiv` injectivity, i.e., working on the "pullback side" by bijection) that was abandoned. A prover reading the blueprint sketch and following it literally would fail.

The `\begin{proof}` block for `lem:push_pull_id` is **adequate** — the described route (`unit_conjugateEquiv`, `conjugateEquiv_pullbackId_hom`, `pseudofunctor_right_unitality`) is exactly what the Lean proof uses.

The proof sketches for `lem:push_pull_unit_mate` and `lem:push_pull_transport_cancel` both say "Proved directly in Lean." That is adequate for these technical sub-lemmas.

### Hint precision
**Precise** for the focus declarations. The `\lean{AlgebraicGeometry.pushPullMap_comp}` and `\lean{AlgebraicGeometry.CechNerve}` hints name the exact Lean declarations. All other `\lean{...}` tags are also precise.

### Generality
**Matches need** for declarations present. The `CechNerve` and `CechComplex` definitions are stated for `X.OpenCover` and `F : X.Modules` without affine or quasi-coherence assumptions (those appear only in the theorems that use them), which is the right level.

### Recommended chapter-side actions

1. **(major) Update `lem:push_pull_comp` proof sketch.** The current sketch describes a `conjugateEquiv_comp` route that is infeasible (kernel `whnf` blow-up). Replace with the actual approach:
   - Reduce `pushPullMap` to `rawPushPullMap` via `pushPullMap_eq_raw` (a `rfl`-lemma).
   - Apply `rawPushPullMap_comp`, which `subst`s the two over-triangles to make all transports trivial, then uses `pushPull_unit_comp` (composite-unit decomposition) and `pushPull_pentagon` (wrapping `pseudofunctor_associativity`). The key obstacle (`whnf` kernel blow-up from `conjugateEquiv`) is bypassed entirely by the `rawPushPullMap`/`subst` infrastructure.

2. **(minor) Add blueprint blocks for new substantive helpers** as they are blueprinted in the next round: `pushPullFunctor`, `coverCechNerveOver`, `coverCechNerveOverAug`, `cechNerveCosimplicial`, `rawPushPullMap`, `rawPushPullMap_comp`, `pushPull_pentagon`, `pushPull_unit_comp`. At minimum `pushPullFunctor` and `pushPull_pentagon` are worth explicit `def/lem` blocks.

3. **(minor — sync) The following lemmas have complete Lean proofs but lack `\leanok`**: `lem:push_pull_id`, `lem:push_pull_comp`, `lem:push_pull_unit_mate`, `lem:push_pull_transport_cancel`. These should be updated by `sync_leanok` on the next pass. No agent action needed, but if `sync_leanok` has already run this iter and they're still absent, the LSP may have a compilation issue to investigate.

---

## Severity summary

- **must-fix-this-iter**: NONE.
- **major** (1): Blueprint proof sketch for `lem:push_pull_comp` describes a `conjugateEquiv_comp` route that was found infeasible and was not used. The implemented approach (via `rawPushPullMap_comp`/`subst`/`pushPull_pentagon`) is not described in the `\begin{proof}` block. A prover guided by the current sketch would be misdirected.
- **minor** (2): (a) `pushPullFunctor` and other new helpers lack blueprint blocks (known, tracked). (b) `\leanok` missing for four complete lemmas — sync/build matter.

**Overall verdict**: The two focus declarations (`pushPullMap_comp` and `CechNerve`) faithfully implement their blueprint blocks — signatures correct, bodies axiom-clean, mathematical content consistent. The only substantive finding is a major blueprint-adequacy issue: the proof sketch for `lem:push_pull_comp` describes an approach that was not used and is infeasible; the blueprint should be updated to document the `rawPushPullMap`/`subst`/pentagon route that was actually proved.
