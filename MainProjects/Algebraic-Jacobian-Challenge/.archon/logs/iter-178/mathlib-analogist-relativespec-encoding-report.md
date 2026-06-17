# Mathlib Analogist Report

## Mode
api-alignment

## Slug
relativespec-encoding

## Iteration
178

## Question

What is the right Mathlib-aligned shape for the body of
`AlgebraicGeometry.Scheme.RelativeSpec` (Spec_X(𝒜)) and its
`structureMorphism`? The iter-176 closure `RelativeSpec 𝒜 := X`,
`structureMorphism _ := 𝟙 X` discards `𝒜` and is flagged CRITICAL by
the iter-177 lean-auditor. Four candidate encodings — (a) GlueData on a
QcohAlgebra carrier; (b) relative graded `Spec`; (c) functor-of-points;
(d) other — are on the table. Which is the Mathlib-aligned answer?

## Verdict

**ALIGN-WITH-MATHLIB. The placeholder is wrong and must be replaced
THIS iter / next-prover-cycle.** Mathlib already ships the relative-Spec
construction under a different name; the project should consume it
verbatim.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Body of `RelativeSpec` | ALIGN_WITH_MATHLIB | critical (must-fix) |
| 2. `QcohAlgebra` carrier needs `Coequifibered` field | ALIGN_WITH_MATHLIB | critical (must-fix) |
| 3. Body of `structureMorphism` | ALIGN_WITH_MATHLIB | critical (must-fix) |
| 4. Shape of 4 downstream theorems | ALIGN_WITH_MATHLIB | critical (must-fix) |

## Must-fix-this-iter

All four verdicts apply to *shipped* placeholder code at
`AlgebraicJacobian/Picard/RelativeSpec.lean:131-194,227-311`.

### 1. `RelativeSpec` body

Currently: `RelativeSpec 𝒜 := X` (line 172-173). Wrong — discards
`𝒜`. **Refactor to**:

```lean
noncomputable def RelativeSpec (𝒜 : X.QcohAlgebra) : Scheme.{u} :=
  (AffineZariskiSite.relativeGluingData 𝒜.coequifibered).glued
```

Cite Mathlib:
- `Mathlib/AlgebraicGeometry/Sites/SmallAffineZariski.lean:293`
  (`relativeGluingData` builder)
- `Mathlib/AlgebraicGeometry/RelativeGluing.lean:102`
  (`Cover.RelativeGluingData.glued`)

### 2. Add `Coequifibered` field to `QcohAlgebra`

Currently: `QcohAlgebra X` is `(sheaf, unit)` only (line 131-136). The
quasi-coherence overlay is missing. **Add a third field**:

```lean
structure QcohAlgebra (X : Scheme.{u}) where
  sheaf : TopCat.Sheaf CommRingCat.{u} X.toPresheafedSpace
  unit : X.sheaf ⟶ sheaf
  coequifibered : NatTrans.Coequifibered
    (whiskerLeft (AffineZariskiSite.toOpensFunctor X).op unit.val)
```

This is the **Stacks 01LL form of quasi-coherence** for algebras:
on every affine open `U` and section `f : Γ(X, U)`, the restriction
to the basic open `D(f) ⊆ U` is the `IsLocalization.Away (α U f)`
(equivalent form via
`Mathlib/AlgebraicGeometry/Sites/SmallAffineZariski.lean:266`).

Critically, this is **NOT** the same as the
`SheafOfModules.IsQuasicoherent` predicate that
`analogies/qcohalgebra-structure.md` Decision 1 flagged as needing
sheafified-tensor infrastructure. `Coequifibered` is a *pointwise
`IsLocalization.Away`* condition; it does NOT need monoidal-`SheafOfModules`
machinery. The Mathlib upstream gap on `SheafOfModules.IsQuasicoherent`
**does not block** this construction.

### 3. `structureMorphism` body

Currently: `structureMorphism _ := 𝟙 X` (line 192-194). Wrong — has
nothing to do with the algebra. **Refactor to**:

```lean
noncomputable def RelativeSpec.structureMorphism (𝒜 : X.QcohAlgebra) :
    X.RelativeSpec 𝒜 ⟶ X :=
  (AffineZariskiSite.relativeGluingData 𝒜.coequifibered).toBase
```

Cite Mathlib: `Mathlib/AlgebraicGeometry/RelativeGluing.lean:114`.

### 4. Downstream theorems

The trivializing proofs at lines 228-237 (`UniversalProperty`),
260-267 (`affine_base_iff`), 295-311 (`base_change`) collapse against
the placeholder body. After Block A lands they each become
~10-30 LOC proofs against Mathlib lemmas:

- `UniversalProperty` (affine-form): via the open cover
  `RelativeGluingData.cover` + `HasAffineProperty.iff_of_iSup_eq_top`
  (`Mathlib/AlgebraicGeometry/Morphisms/Affine.lean:146`).
- `affine_base_iff`: adapt `SmallAffineZariski.isColimitCocone`
  (lines 343-366 of `SmallAffineZariski.lean`).
- `base_change`: via stability of `Coequifibered` under sheaf-pullback
  + Mathlib's gluing universal property.

## The smoking gun

`Mathlib/AlgebraicGeometry/Sites/SmallAffineZariski.lean:240-255`
carries this header verbatim:

> ## "Quasi-coherent `𝒪ₓ`-algebras"
>
> A presheaf `F` of rings on `X.AffineZariskiSite` with a structural
> morphism `α : 𝒪ₓ ⟶ F` is said to be `Coequifibered` if
> `F(D(f)) = F(U)[1/f]` for every open `U` and any section
> `f : Γ(X, U)`.
>
> Under this condition we can construct a family of gluing data (See
> `relativeGluingData`) and glue `F` into a scheme over `X` via
> `(relativeGluingData _).glued`.
>
> This is closely related to the notion of quasi-coherent
> `𝒪ₓ`-algebras, and we shall link them together once the theory of
> quasi-coherent `𝒪ₓ`-algebras are developed.

Mathlib has packaged Stacks 01LL/01LM/01LP exactly — they just
haven't *named* it `RelativeSpec`. The already-shipped consumer
`Hom.normalization`
(`Mathlib/AlgebraicGeometry/Normalization.lean:120,127`) shows the
exact 2-line idiom:

```lean
def normalizationGlueData := relativeGluingData f.coequifibered_normalizationDiagramMap
def normalization : Scheme := f.normalizationGlueData.glued
```

The project's `RelativeSpec` is the same 2-line construction with
`f.coequifibered_normalizationDiagramMap` replaced by
`𝒜.coequifibered`.

## Pivot plan (concrete)

**Block A — carrier upgrade, iter-178 / iter-179 prover lane (~25 LOC net)**:

1. Two new helpers (~10 LOC):
   ```lean
   abbrev QcohAlgebra.affinePresheaf (𝒜 : X.QcohAlgebra) :
       X.AffineZariskiSiteᵒᵖ ⥤ CommRingCat.{u} :=
     (AffineZariskiSite.toOpensFunctor X).op ⋙ 𝒜.sheaf.val
   abbrev QcohAlgebra.affineUnit (𝒜 : X.QcohAlgebra) :
       (AffineZariskiSite.toOpensFunctor X).op ⋙ X.presheaf ⟶ 𝒜.affinePresheaf :=
     whiskerLeft (AffineZariskiSite.toOpensFunctor X).op 𝒜.unit.val
   ```
2. Add `coequifibered : 𝒜.affineUnit.Coequifibered` field on `QcohAlgebra` (~5 LOC).
3. Replace `RelativeSpec` body with Mathlib value (~3 LOC).
4. Replace `structureMorphism` body with Mathlib value (~3 LOC).
5. `functor` body becomes substantive automatically (no edit needed).

**Block B — downstream theorem rewrites (~60 LOC, iter-179+)**:

6. `UniversalProperty` (affine-form) via `HasAffineProperty.iff_of_iSup_eq_top`.
7. `affine_base_iff` via `isColimitCocone`-style argument.
8. `base_change` via `Coequifibered` stability under pullback +
   universal property of the gluing.

**Block C — `UniversalProperty` upgrade to `Functor.RepresentableBy` (iter-180+, ~40 LOC)**:

Use `RelativeGluingData.isPullback_natTrans_ι_toBase`
(`Mathlib/AlgebraicGeometry/RelativeGluing.lean:172`) to get the
Yoneda statement on each affine; glue via Mathlib's locally-directed
universal property. This is the **type-level upgrade** flagged in
`analogies/qcohalgebra-structure.md` Decision 4.

## LOC estimate

| Scope | LOC (delta) |
|---|---|
| Minimum substantive landing (Blocks A + B, removes ALL must-fix verdicts) | **~85 LOC** |
| Full alignment incl. representability (A + B + C) | **~125 LOC** |

This is **~8× smaller than** the 680-LOC estimate in
`analogies/qcohalgebra-structure.md`, because Mathlib has already
done the heavy lifting (the gluing + the cocycle conditions + the
affine-cover infrastructure).

## Informational

- The existing analogy `analogies/qcohalgebra-structure.md` correctly
  diagnosed Encoding I as the right *carrier* but was overly cautious
  about the quasi-coherence overlay. **The overlay needed is
  `NatTrans.Coequifibered`, NOT `SheafOfModules.IsQuasicoherent`.**
  The former exists, has no upstream-tensor dependency, and is the
  exact predicate Mathlib's `relativeGluingData` consumes. This
  unblocks the construction without waiting for monoidal-`SheafOfModules`
  to land upstream.

- The blueprint chapter `Picard_RelativeSpec.tex` should cite Stacks
  01LH (relative gluing) in addition to 01LL/01LO/01LQ/01LR/01LS, to
  match the Mathlib construction's primary reference.

## Persistent file

- `analogies/relative-spec-encoding.md` — design-rationale captured
  for iter-179+. Includes verbatim Mathlib citations, the full
  refactor template, and the LOC budget.

Overall verdict: the placeholder `RelativeSpec := X` is wrong; the
Mathlib-aligned replacement is `(AffineZariskiSite.relativeGluingData
𝒜.coequifibered).glued` and is ~85 LOC away once the `QcohAlgebra`
carrier gains a `coequifibered` field.
