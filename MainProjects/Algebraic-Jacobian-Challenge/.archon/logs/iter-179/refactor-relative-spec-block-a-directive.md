# Refactor Directive

## Slug
relative-spec-block-a

## Problem

`AlgebraicJacobian/Picard/RelativeSpec.lean` currently encodes
the relative spectrum scheme as the placeholder

```lean
noncomputable def RelativeSpec {X : Scheme.{u}} (_𝒜 : X.QcohAlgebra) : Scheme.{u} := X
noncomputable def RelativeSpec.structureMorphism {X : Scheme.{u}}
    (_𝒜 : X.QcohAlgebra) : X.RelativeSpec _𝒜 ⟶ X := 𝟙 X
```

The argument `_𝒜` is silently discarded. The auditor flagged both
declarations CRITICAL "weakened-wrong" iter-177; downstream
`UniversalProperty`, `affine_base_iff`, `base_change` trivialize against
the placeholders. The iter-178 mathlib-analogist consult identified
that **Mathlib already ships the construction** under a different name —
`AffineZariskiSite.relativeGluingData` in
`Mathlib/AlgebraicGeometry/Sites/SmallAffineZariski.lean:293` produces
a `Cover.RelativeGluingData` whose `.glued` is the glued scheme over `X`,
with `.toBase` the structure morphism. Mathlib uses this in
`Hom.normalization` (`Mathlib/AlgebraicGeometry/Normalization.lean:120`).

Consult report at `analogies/relative-spec-encoding.md` (iter-178).

## Mathematical Justification

The Stacks 01LL–01LR construction packages the relative-spectrum scheme
as the gluing of `Spec(𝒜(U))` along the canonical affine open cover of
`X`, with transition isomorphisms determined by the quasi-coherence
predicate. Mathlib captures the same construction via
`AffineZariskiSite.relativeGluingData`, which takes:

- `F : X.AffineZariskiSiteᵒᵖ ⥤ CommRingCat` — the affine restriction
  of the algebra's underlying sheaf;
- `α : (toOpensFunctor X).op ⋙ X.presheaf ⟶ F` — the algebra unit
  restricted to the affine site;
- `H : α.Coequifibered` — the Stacks 01LL form of quasi-coherence
  (`F(D(f)) = F(U)[1/f]` for every affine open `U` and section `f`).

The Mathlib `Coequifibered` predicate is *strictly weaker* than the full
`SheafOfModules.IsQuasicoherent` (which needs sheafified-tensor
infrastructure not yet in Mathlib); it is equivalent under the
dense-subsite equivalence `Scheme.AffineZariskiSite.sheafEquiv`, so
**no information is lost** by using the Mathlib idiom.

The project's `QcohAlgebra` structure currently carries `sheaf` + `unit`
(parts 1 + 2). Adding the third field `coequifibered : (affineUnit).Coequifibered`
makes the project's carrier accept the Mathlib `relativeGluingData`
verbatim — no parallel API, no waiting for upstream sheafified-tensor.

After this refactor, `RelativeSpec 𝒜 := (relativeGluingData 𝒜.coequifibered).glued`
and `structureMorphism 𝒜 := (relativeGluingData 𝒜.coequifibered).toBase`
are the canonical Mathlib values, NOT placeholders. The downstream
theorems `UniversalProperty`, `affine_base_iff`, `base_change` will be
broken by the body change (their current "proofs" exploit the placeholder
collapse `X ×_X X ≅ T`); leave them as `sorry` after this refactor —
iter-179's prover lane (Block B) rewrites them against the Mathlib builder.

## Changes Requested

### File: `AlgebraicJacobian/Picard/RelativeSpec.lean`

#### Imports

Verify (or add) at the top of the file:

```lean
import Mathlib.AlgebraicGeometry.Sites.SmallAffineZariski
import Mathlib.AlgebraicGeometry.RelativeGluing
```

(If `import Mathlib` is already present, these are transitive — verify by
`lean_completions` for `AlgebraicGeometry.AffineZariskiSite.relativeGluingData`.)

#### Replace `QcohAlgebra` structure (currently at L131-136)

Old:
```lean
structure QcohAlgebra (X : Scheme.{u}) where
  /-- The underlying sheaf of commutative rings on `X`. -/
  sheaf : TopCat.Sheaf CommRingCat.{u} X.toPresheafedSpace
  /-- The `O_X`-algebra unit `X.sheaf ⟶ sheaf` exhibiting `sheaf` as a sheaf
  of `O_X`-algebras. -/
  unit : X.sheaf ⟶ sheaf
```

New:
```lean
structure QcohAlgebra (X : Scheme.{u}) where
  /-- The underlying sheaf of commutative rings on `X`. -/
  sheaf : TopCat.Sheaf CommRingCat.{u} X.toPresheafedSpace
  /-- The `O_X`-algebra unit `X.sheaf ⟶ sheaf` exhibiting `sheaf` as a sheaf
  of `O_X`-algebras. -/
  unit : X.sheaf ⟶ sheaf
  /-- **Stacks 01LL quasi-coherence overlay (`Coequifibered` form)**: every
  restriction of `sheaf` to a basic-open `D(f) ⊆ U` is `IsLocalization.Away f`.
  Strictly weaker than `SheafOfModules.IsQuasicoherent` (which needs
  sheafified-tensor infrastructure not yet in Mathlib); equivalent under the
  dense-subsite equivalence `Scheme.AffineZariskiSite.sheafEquiv`. -/
  coequifibered : NatTrans.Coequifibered
    (whiskerLeft (AffineZariskiSite.toOpensFunctor X).op unit.val)
```

(The shape exactly matches the Mathlib `relativeGluingData` input. The
`NatTrans.Coequifibered` predicate's argument-order — F, G, the natural
transformation — should follow whatever `AffineZariskiSite.toOpensFunctor` /
`whiskerLeft` syntax Mathlib expects at the pinned commit. Verify via
`lean_completions` BEFORE typing; if Mathlib uses a different formulation
(e.g. the `coequifibered_iff_forall_isLocalizationAway`-form), use the
canonical idiom; mathematical content is identical.)

#### Replace `RelativeSpec` body (currently at L172-173)

Old:
```lean
noncomputable def RelativeSpec {X : Scheme.{u}} (_𝒜 : X.QcohAlgebra) : Scheme.{u} :=
  X
```

New:
```lean
noncomputable def RelativeSpec {X : Scheme.{u}} (𝒜 : X.QcohAlgebra) : Scheme.{u} :=
  (AffineZariskiSite.relativeGluingData 𝒜.coequifibered).glued
```

Note: argument now `𝒜` (named, used). Update the docstring to remove
the iter-176 placeholder comment block and replace with a one-paragraph
"Mathlib-builder body" comment citing `relativeGluingData.glued` and the
consult.

#### Replace `RelativeSpec.structureMorphism` body (currently at L192-194)

Old:
```lean
noncomputable def RelativeSpec.structureMorphism {X : Scheme.{u}}
    (_𝒜 : X.QcohAlgebra) : X.RelativeSpec _𝒜 ⟶ X :=
  𝟙 X
```

New:
```lean
noncomputable def RelativeSpec.structureMorphism {X : Scheme.{u}}
    (𝒜 : X.QcohAlgebra) : X.RelativeSpec 𝒜 ⟶ X :=
  (AffineZariskiSite.relativeGluingData 𝒜.coequifibered).toBase
```

Update the docstring similarly.

#### Break the 3 downstream theorems by inserting `sorry`

`UniversalProperty` (L227-237), `affine_base_iff` (L259-267), `base_change`
(L295-311) currently have bodies that work BECAUSE the placeholders make
the goal trivial. After the body swap, these bodies will fail to compile.
Replace each one's body with `by sorry` (the `theorem` / `def` signature
preserved). Update the docstrings to remove the iter-176 placeholder
comment blocks; replace with:

```text
iter-179+ body: rewrite against the Mathlib `relativeGluingData` builder
per `analogies/relative-spec-encoding.md` Block B.
```

The `functor` definition at L335-337 stays as-is — its body
`fun 𝒜 => Over.mk (RelativeSpec.structureMorphism 𝒜)` is correct
under the new body and needs no change.

## Affected Files

- `AlgebraicJacobian/Picard/RelativeSpec.lean` only (this is a self-contained
  carrier upgrade).

Consumers downstream of `QcohAlgebra` outside this file: NONE at the
moment (the structure is currently only referenced within RelativeSpec.lean
plus the file-skeleton chain in `Picard/RelPicFunctor.lean` /
`Picard/FlatteningStratification.lean` / `Picard/FGAPicRepresentability.lean`,
all of which use `RelativeSpec _𝒜` in opaque `:= sorry` bodies). Verify
no downstream signature mutation is needed by grepping
`QcohAlgebra.mk`-style usages BEFORE landing the structure change. If any
turn up, instantiate the `coequifibered` field appropriately or factor
the upgrade.

## Expected Outcome

- `lake build AlgebraicJacobian.Picard.RelativeSpec` → green.
- File sorry count: 0 → 3 (the three downstream theorems
  `UniversalProperty`, `affine_base_iff`, `base_change` now carry honest
  scaffold `sorry`s instead of placeholder-discharged trivializations).
- The `RelativeSpec` body is now the canonical Mathlib value, not `X`.
- The `structureMorphism` body is now the canonical Mathlib value, not `𝟙 X`.
- `QcohAlgebra` carrier has the third `coequifibered` field — downstream
  file-skeleton constructors of `QcohAlgebra` need to be re-verified
  (likely they're all `sorry` bodies that don't instantiate the structure
  yet; no breakage expected, but check).

## Helper budget

0 new helpers. The Mathlib construction IS the implementation.

## Hard NOs

- Do NOT touch `functor` (L335-337) — its body is correct.
- Do NOT define a "pullback algebra" or "g^* 𝒜" operation; that's Block B
  / Block C work, deferred to iter-179 prover lane and iter-180+.
- Do NOT instruct iter-179 to "transport" sheaf-of-modules quasi-coherence
  — `Coequifibered` is the Mathlib idiom and the consult verifies it's
  sufficient for the geometric content.
- Do NOT remove the file-level docstring / `% archon:covers` markers / blueprint pointers.

## Reversal trigger

If the `NatTrans.Coequifibered` formulation doesn't match Mathlib's
`relativeGluingData` input shape verbatim (e.g. Mathlib expects an
existential wrapping or a different functor-as-domain), use whichever
Mathlib-canonical idiom the `relativeGluingData` signature requires.
If `relativeGluingData` requires a different input shape entirely
(unlikely — the consult verified it), REPORT honestly and the iter-180
plan-agent will re-route.

If the new `coequifibered` field forces a re-statement of any existing
`QcohAlgebra` constructor in another file, do that re-statement
inline (mark with `% NOTE` for review) and report it in the task result.
