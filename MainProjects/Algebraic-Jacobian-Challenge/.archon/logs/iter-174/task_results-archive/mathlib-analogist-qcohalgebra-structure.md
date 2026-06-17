# Mathlib Analogist Report

## Mode
api-alignment

## Slug
qcohalgebra-structure

## Iteration
174

## Question

What is the right Mathlib-aligned structure shape for
`AlgebraicGeometry.Scheme.QcohAlgebra X` (currently a type-level placeholder
`:= sorry` at `AlgebraicJacobian/Picard/RelativeSpec.lean:98`)?

Three candidates were proposed:

- (A) `SheafOfModules X.ringCatSheaf` + `QuasiCoherent` predicate
      + `Mon_Class` monoid + commutativity.
- (B) Functorial form: `X.openSets^op ⥤ CommAlgCat (Γ(X, O_X))`
      + qcoh predicate.
- (C) Typeclass form `[QcohAlgebraStr X 𝒜]`.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Carrier shape (module + monoid overlay vs. under-object in sheaves of CommRings) | NEEDS_MATHLIB_GAP_FILL + interim ALIGN_WITH_MATHLIB on under-object | critical |
| 2. Bundled `structure` vs. predicate-on-existing-object | ALIGN_WITH_MATHLIB (bundled) | informational |
| 3. Bracketed-field instances vs. positional `Mon_Class` field | ALIGN_WITH_MATHLIB (bracketed fields, induced via unit) | informational |
| 4. `UniversalProperty` Hom-set encoding | ALIGN_WITH_MATHLIB (`Functor.RepresentableBy`) | critical |
| (B) Functorial-form candidate | divergent-and-wrong (`CommAlgCat R` needs fixed base ring) | n/a — reject |
| (C) Typeclass-form candidate | divergent-and-wrong (no underlying `Type` to attach instance to) | n/a — reject |

## Must-fix-this-iter

The `:= sorry` at the type level is the iter-173 lean-auditor must-fix.
Iter-174 lane should land Encoding I (the relative-`Under` form) as a
concrete bundled `structure` — see "Recommendation" in
`analogies/qcohalgebra-structure.md`.

- Decision 1: project's docstring at `RelativeSpec.lean:90-96` proposes
  Encoding II (monoid-in-modules: `MonObj module` over `X.Modules`).
  This is the *long-term Mathlib-aligned* form but its prerequisite —
  a monoidal structure on `SheafOfModules R` — is **missing at pinned
  Mathlib `b80f227`** (only `PresheafOfModules` has tensor; see
  `Mathlib/Algebra/Category/ModuleCat/Presheaf/Monoidal.lean:13`).
  Building monoidal-`SheafOfModules` in-project is 200-500 LOC of
  orthogonal categorical scaffolding. **Use Encoding I instead** —
  `(sheaf : TopCat.Sheaf CommRingCat X, unit : X.sheaf ⟶ sheaf, isQcoh : …)`
  — which is itself the direct sheafified upgrade of Mathlib's
  `Under R` ≅ "commutative `R`-algebras" idiom
  (`Mathlib/Algebra/Category/Ring/Under/Basic.lean:13-18`).

- Decision 4: `UniversalProperty` is currently encoded as
  `IsAffineHom (structureMorphism 𝒜)` (a non-tautological consequence
  but not the universal property). Iter-174+ must upgrade to a
  `CategoryTheory.Functor.RepresentableBy` witness for the Stacks 01LQ
  functor `F : Schᵒᵖ ⥤ Type` of pairs `(g, φ : g^* 𝒜 → O_T)` — already
  flagged by the blueprint reviewer at `Picard_RelativeSpec.tex:145-149`.

## Informational

- Decision 2: project already plans a `structure` (bundled), aligning with
  `CommAlgCat`, `Mon_ C`, `CommMon C`. No action needed.

- Decision 3: under Encoding I, the `CommRing` / `Algebra` instances on
  each section `Γ(𝒜, U)` are **induced** by the unit `X.sheaf ⟶ 𝒜`
  (via `RingHom.toAlgebra`, mirroring
  `Mathlib/Algebra/Category/Ring/Under/Basic.lean:35`,
  `instance (A : Under R) : Algebra R A := RingHom.toAlgebra A.hom.hom`).
  No explicit `[MonObj]` overlay field is needed.

- The `Mon_Class` typeclass referenced in the docstring **does not exist
  at `b80f227`** — Mathlib's pinned name is `MonObj`
  (`Mathlib/CategoryTheory/Monoidal/Mon_.lean:74`). The
  `CategoryTheory.Mon_Class` hit from leansearch is from a later commit.
  This is a docstring fix (cosmetic) regardless of whether Encoding I or
  II is chosen.

- Mathlib **does** have the closest neighbour:
  `Mon_ (ModuleCat R) ≌ AlgCat R`
  (`Mathlib/CategoryTheory/Monoidal/Internal/Module.lean:14`). This proves
  the *categorical equivalence* the project's Encoding-II docstring
  implicitly invokes. The relative version
  `Mon_ (SheafOfModules X.ringCatSheaf) ≃ Under X.sheaf in Sheaf CommRingCat`
  is the bridge the project will use when migrating Encoding I → II.

## Recipe for the Yoneda Hom-set (`UniversalProperty`)

Under Encoding I, `Hom_{O_X-alg}(𝒜, g_* O_T)` for a morphism `g : T → X`
is concretely

```
{ φ : 𝒜.sheaf ⟶ (Sheaf.pushforward _ g.base).obj T.sheaf //
  𝒜.unit ≫ φ = (X.sheaf-to-g_*O_T canonical map) }
```

i.e. exactly a morphism in `Under X.sheaf` over `TopCat.Sheaf CommRingCat X`.
The universal property is then

```
theorem UniversalProperty (𝒜 : X.QcohAlgebra) :
    (UniversalFunctor X 𝒜).RepresentableBy (X.RelativeSpec 𝒜)
```

where `UniversalFunctor X 𝒜 : Schᵒᵖ ⥤ Type u` is the Stacks 01LQ functor.
`Functor.RepresentableBy` lives at
`Mathlib/CategoryTheory/Yoneda.lean` and is the Mathlib-canonical container
for natural-bijection statements.

## LOC estimate for iter-175+ body lane

| Item | LOC |
|---|---|
| Carrier `structure` (Encoding I) | 25 |
| `toQcohModule` + `IsQuasicoherent` plumbing | 30 |
| Section-level `CommRing`/`Algebra` instances | 25 |
| `UniversalFunctor` definition | 40 |
| `RelativeSpec` body via `Scheme.GlueData`/`AffineScheme.glueOpens` | 200 |
| `UniversalProperty` as `RepresentableBy` | 120 |
| `affine_base_iff` (Stacks 01LO) | 70 |
| `base_change` (Stacks 01LS) | 120 |
| `functor` (object + morphism action) | 50 |
| **Total** | **~680 LOC** |

(Higher than the file-skeleton's 56-LOC plan because that estimate assumed
the carrier was a `sorry` — every theorem grew once the carrier is
concrete and the universal-property type is the real `RepresentableBy`
witness instead of a placeholder consequence.)

## Persistent file
- `analogies/qcohalgebra-structure.md` — design-rationale captured for
  future iters (full Mathlib citation table, decision-by-decision
  analysis, candidate rejection rationale, body-skeleton sketch).

Overall verdict: **use Encoding I (sheafified `Under`-object form) for
iter-174+ — it is Mathlib-aligned (direct sheaf upgrade of
`Mathlib/Algebra/Category/Ring/Under/Basic.lean`'s "Under R = commutative
R-algebras"), uses only existing infrastructure at `b80f227`, and is
forward-compatible with the monoidal-`SheafOfModules` form that will land
upstream eventually; reject candidates (B) and (C) as divergent-and-wrong.**
