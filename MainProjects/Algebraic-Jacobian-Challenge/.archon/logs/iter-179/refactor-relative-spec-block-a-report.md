# Refactor Report

## Slug
relative-spec-block-a

## Status
COMPLETE — `QcohAlgebra` carrier upgraded with `coequifibered` field;
`RelativeSpec` and `RelativeSpec.structureMorphism` bodies now consume
Mathlib's `AffineZariskiSite.relativeGluingData` (`.glued` / `.toBase`);
the three downstream theorems that previously discharged trivialized
goals against the placeholder now carry honest `sorry` bodies per the
directive's Block B plan. Full `lake build` is green.

## Directive

### Problem
`AlgebraicJacobian/Picard/RelativeSpec.lean` encoded the relative-spectrum
scheme via the placeholder `RelativeSpec _𝒜 := X`, silently discarding
`_𝒜`. The iter-177 lean-auditor flagged both `RelativeSpec` and
`RelativeSpec.structureMorphism` CRITICAL "weakened-wrong". The iter-178
mathlib-analogist consult (`analogies/relative-spec-encoding.md`) found
that Mathlib already ships the construction as
`Scheme.AffineZariskiSite.relativeGluingData`
(`Mathlib/AlgebraicGeometry/Sites/SmallAffineZariski.lean:293`).

### Changes
1. Add a third field `coequifibered` to `QcohAlgebra` whose type is
   `NatTrans.Coequifibered (Functor.whiskerLeft (AffineZariskiSite.toOpensFunctor X).op unit.hom)`.
2. Replace `RelativeSpec` body with
   `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).glued`.
3. Replace `RelativeSpec.structureMorphism` body with
   `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).toBase`.
4. Replace the bodies of `UniversalProperty`, `affine_base_iff`, and
   `base_change` (which previously discharged trivialized goals against
   the placeholder) with `sorry`; preserve their signatures.

## Changes Made

### File: `AlgebraicJacobian/Picard/RelativeSpec.lean`

- **What:** Added `coequifibered` field to `QcohAlgebra`. The field uses
  `Functor.whiskerLeft` (the project file has `open CategoryTheory` so
  `Functor.whiskerLeft` resolves; bare `whiskerLeft` does not). The
  natural-transformation handle is `unit.hom` (the directive suggested
  `unit.val` but Mathlib's `Sheaf.val` was deprecated to
  `ObjectProperty.obj`; the Hom-projection field is now `.hom` per the
  `InducedCategory.Hom` shape verified by `lean_run_code`).
  See `analogies/relative-spec-encoding.md` Decision 2.
- **Why:** This field is the exact predicate Mathlib's
  `AffineZariskiSite.relativeGluingData` consumes (Stacks 01LL form). The
  Mathlib `NatTrans.Coequifibered` is strictly weaker than the full
  `SheafOfModules.IsQuasicoherent` (no sheafified-tensor needed) but
  equivalent under the dense-subsite equivalence
  `AffineZariskiSite.sheafEquiv`, so no information is lost.
- **Cascading:** None outside this file (verified by `grep` — only
  `LineBundlePullback.lean` mentions `QcohAlgebra` and only in a comment).

- **What:** Replaced `RelativeSpec` body — was `X`, now is
  `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).glued`.
  Argument now named `𝒜` (used). Docstring refreshed to cite
  `relativeGluingData.glued` and the consult.
- **Why:** Per Decision 1 of the consult, this is the canonical Mathlib
  value that Mathlib's own `Hom.normalization`
  (`Mathlib/AlgebraicGeometry/Normalization.lean:120`) consumes as the
  relative-Spec template.
- **Cascading:** Forces the three downstream theorems below into `sorry`.

- **What:** Replaced `RelativeSpec.structureMorphism` body — was `𝟙 X`,
  now is `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).toBase`.
  Argument now named `𝒜` (used). Docstring refreshed to cite
  `relativeGluingData.toBase` and the consult.
- **Why:** Per Decision 3 of the consult, this is the canonical Mathlib
  value (`Mathlib/AlgebraicGeometry/RelativeGluing.lean:114`).
- **Cascading:** Forces the three downstream theorems below into `sorry`.

- **What:** Replaced bodies of `UniversalProperty` (L243),
  `affine_base_iff` (L271), and `base_change` (L306) with `sorry`,
  preserving each signature. Each body carries a multi-line comment
  pointing to the iter-179+ Block B rewrite plan from the consult:
  - `UniversalProperty`: `RelativeGluingData.cover` +
    `HasAffineProperty.iff_of_iSup_eq_top`;
  - `affine_base_iff`: adapt
    `Scheme.AffineZariskiSite.isColimitCocone`;
  - `base_change`: stability of `Coequifibered` under base change of
    rings + universal property of the gluing.
- **Why:** The previous proofs (`unfold ... 𝟙` for `UniversalProperty`,
  `change IsAffine (Spec R); infer_instance` for `affine_base_iff`,
  `refine ⟨⟨T.sheaf, 𝟙 _⟩, ...⟩` + `change pullback g (𝟙 X) ≅ T` for
  `base_change`) all relied on the placeholder collapse and become
  type-incorrect against the Mathlib-builder body. In particular, the
  `base_change` body constructed `⟨T.sheaf, 𝟙 _⟩ : T.QcohAlgebra` as a
  2-arg anonymous constructor that no longer typechecks now that
  `QcohAlgebra` has 3 fields.
- **Cascading:** None — these are downstream pins of the same file;
  `lean_diagnostic_messages` on all four consumer files
  (`LineBundlePullback.lean`, `RelPicFunctor.lean`,
  `FlatteningStratification.lean`, `FGAPicRepresentability.lean`)
  reports only pre-existing sorries, no new errors.

- **What:** Refreshed the file-level `## Status` section and the §1
  paragraph + structure docstring to honestly reflect the iter-179
  carrier (the iter-174 docstring's "iter-175+ will add a third field
  `isQcoh : Prop`" plan is now superseded; the third field landed as
  `coequifibered`, the Mathlib-aligned name).
- **Why:** Per the rule "Do NOT remove the file-level docstring /
  blueprint pointers", the existing structure was preserved; only the
  paragraphs whose claims had become stale were rewritten in place.
- **Cascading:** None.

The `functor` definition at L335-337 is unchanged — its body
`fun 𝒜 => Over.mk (RelativeSpec.structureMorphism 𝒜)` is correct under
the new bodies.

## New Sorries Introduced

- `AlgebraicJacobian/Picard/RelativeSpec.lean:243` —
  `UniversalProperty`: the structure morphism
  `(relativeGluingData _).toBase` is affine. The previous proof closed
  the trivialized goal `IsAffineHom (𝟙 X)` via instance synthesis;
  the genuine proof uses `RelativeGluingData.cover` +
  `HasAffineProperty.iff_of_iSup_eq_top` (consult Block B item 6).
- `AlgebraicJacobian/Picard/RelativeSpec.lean:271` —
  `affine_base_iff`: on `Spec R` the relative spectrum is affine. The
  previous proof closed the trivialized goal `IsAffine (Spec R)` via
  `infer_instance`; the genuine proof adapts
  `Scheme.AffineZariskiSite.isColimitCocone` (consult Block B item 7).
- `AlgebraicJacobian/Picard/RelativeSpec.lean:306` — `base_change`:
  the relative spectrum commutes with base change. The previous proof
  witnessed the existential with the trivial pullback algebra
  `⟨T.sheaf, 𝟙 _⟩` and closed the trivialized goal
  `pullback g (𝟙 X) ≅ T`; the genuine proof pulls back `𝒜` to `T` (the
  `Coequifibered` predicate is stable under base change because
  `IsLocalization.Away` is preserved by ring base change) and uses the
  universal property of the gluing (consult Block B item 8).

(Sorry count for this file goes from 0 → 3, matching the directive's
Expected Outcome.)

## Compilation Status

- `AlgebraicJacobian/Picard/RelativeSpec.lean`: ✓ compiles (3 sorry
  warnings as expected).
- `AlgebraicJacobian/Picard/LineBundlePullback.lean`: ✓ compiles (5
  pre-existing sorries, no new errors).
- `AlgebraicJacobian/Picard/RelPicFunctor.lean`: ✓ compiles (6
  pre-existing sorries, no new errors).
- `AlgebraicJacobian/Picard/FlatteningStratification.lean`: ✓ compiles
  (7 pre-existing sorries, no new errors).
- `AlgebraicJacobian/Picard/FGAPicRepresentability.lean`: ✓ compiles (7
  pre-existing sorries, no new errors).
- Full `lake build`: ✓ green (8355/8355 jobs, only pre-existing sorries
  plus the 3 new ones in RelativeSpec.lean).

## Notes for Plan Agent

1. **Directive deviation — `.hom` vs `.val`**: the directive proposed
   `whiskerLeft (AffineZariskiSite.toOpensFunctor X).op unit.val`, but
   `CategoryTheory.Sheaf.val` is deprecated at the pinned commit
   (`alias` to `ObjectProperty.obj`) and `unit.val` does not resolve
   (the Hom shape is `InducedCategory.Hom X.sheaf sheaf`, whose
   underlying-natural-transformation accessor is `.hom`). I used
   `unit.hom`. The mathematical content is identical and the directive
   anticipated this kind of adjustment ("if Mathlib uses a different
   formulation … use the canonical idiom").

2. **Directive deviation — `Functor.whiskerLeft` vs `whiskerLeft`**:
   the file has `open CategoryTheory Limits` but `CategoryTheory.whiskerLeft`
   does not exist as a bare alias (it lives at `Functor.whiskerLeft` and
   is *defined* under namespace `CategoryTheory.Functor`); bare
   `whiskerLeft` did not resolve under the current opens. I used the
   fully-qualified `Functor.whiskerLeft`.

3. **No `QcohAlgebra.mk`-style usages outside RelativeSpec.lean**: the
   directive asked me to grep for downstream `QcohAlgebra.mk`-style
   usages before landing. The only construction was the
   `⟨T.sheaf, 𝟙 _⟩` 2-arg pattern in `base_change`, which is in the
   same file and got sorry-fied along with the rest of that proof. No
   other file constructs `QcohAlgebra` values; the four consumer files
   only reference `QcohAlgebra` as a type / in comments.

4. **iter-179 Block B prover lane scope**: the three new sorries are
   independent and each is a small/medium Block B item per the consult.
   `affine_base_iff` may be the cleanest first lane because Mathlib's
   `SmallAffineZariski.isColimitCocone` is essentially the same proof
   with `α = 𝟙` — adapt with a non-trivial `F`. `UniversalProperty`
   needs the `RelativeGluingData.cover` API + `HasAffineProperty`.
   `base_change` is the biggest; it requires constructing the pullback
   `QcohAlgebra` (`Coequifibered` stability under ring base change) and
   may want its own helper `pullbackQcoh g 𝒜 : T.QcohAlgebra` even
   though the directive's Block A bound helpers to 0.

5. **Mathlib-analogist consult was accurate**: the consult predicted
   the exact field shape, the exact `.glued` / `.toBase` accessors, and
   the exact downstream-proof routes. The only deltas were the
   `unit.hom`/`Functor.whiskerLeft` naming touched on above; everything
   else landed verbatim from the recipe at
   `analogies/relative-spec-encoding.md`.

6. **Mathematical observation**: the directive correctly noted that
   `NatTrans.Coequifibered` is strictly weaker than the full
   sheaf-of-modules quasi-coherence predicate, but is equivalent for
   the geometric purpose (constructing the relative-spectrum scheme)
   via the dense-subsite equivalence `AffineZariskiSite.sheafEquiv`.
   The structure docstring records this honestly so future Block C
   (the `Functor.RepresentableBy` upgrade) inherits the same upgrade
   path.
