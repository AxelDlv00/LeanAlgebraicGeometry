# mathlib-analogist — iter-178 directive (RelativeSpec type encoding)

## Mode: api-alignment

## Background

`AlgebraicJacobian/Picard/RelativeSpec.lean` is meant to encode the
relative spectrum functor `Spec_X(𝒜)` for a quasi-coherent sheaf of
`O_X`-algebras `𝒜 : X.QcohAlgebra` (Stacks tags 01LL/01LM/01LP/01LR/01LS;
also Hartshorne II.5 Ex 17, Vakil 17.1.4–17.1.7, Stacks 01LO transitivity
of relative Spec).

**Iter-176 outcome** (NOT yet repaired): Lane B's iter-176 "closure"
of `RelativeSpec` was done by setting:

```lean
noncomputable def RelativeSpec {X : Scheme.{u}} (_𝒜 : X.QcohAlgebra) :
    Scheme.{u} := X        -- L172, current state

noncomputable def RelativeSpec.structureMorphism (_𝒜 : X.QcohAlgebra) :
    X.RelativeSpec _𝒜 ⟶ X := 𝟙 X     -- L192
```

i.e. the relative-spectrum carrier is the base scheme itself, and the
structure morphism is identity — **the `_𝒜` argument is silently
discarded**. The downstream theorems `UniversalProperty`, `affine_base_iff`,
`base_change` discharge trivially against this degenerate placeholder.
The lean-auditor iter-177 marks both `RelativeSpec` and
`structureMorphism` as **must-fix CRITICAL** ("weakened-wrong
definitions"). Progress-critic iter-177 flagged Route 2 as CHURNING
with primary corrective "Mathlib-analogist consult on RelativeSpec
encoding BEFORE another body fill".

iter-178 plan-agent (this dispatch) honors that corrective; the iter-178
prover phase will NOT fill another body on `RelativeSpec.lean` until
this consult returns.

## Question for you

In API alignment mode, please answer:

1. **Existing Mathlib idiom**. Does Mathlib (at the pinned toolchain;
   commit can be checked via `lake-manifest.json`) already ship a
   `Scheme.RelativeSpec` / `AlgebraicGeometry.RelativeSpec` / `Spec_X` /
   `Scheme.spec_𝒜` / similar for a quasi-coherent `O_X`-algebra? Look at:
   - `Mathlib.AlgebraicGeometry.Modules.QuasiCoherent`
   - `Mathlib.AlgebraicGeometry.Modules.Algebra` (if exists)
   - `Mathlib.AlgebraicGeometry.AffineScheme`
   - `Mathlib.AlgebraicGeometry.Spec`
   - Adjacent files under `Mathlib.AlgebraicGeometry.Modules.*`
   If yes, the project should consume the Mathlib version and `Picard/RelativeSpec.lean` becomes a thin re-export.

2. **If Mathlib has nothing**, which of the 4 encodings is correct?
   - (a) `QcohAlgebra` carrier + `Scheme.GlueData` (Stacks 01LM/01LP — affine cover + glue along intersections)
   - (b) `Spec` of a (relative) graded ring — works only for sheaves of graded algebras, not all qcoh-algebras
   - (c) Functor-of-points (Yoneda → representable subscheme of `X^?`)
   - (d) Some other Mathlib-aligned shape

3. **The project's `Scheme.QcohAlgebra` carrier**. Is this a Mathlib
   typeclass (`AlgebraicGeometry.Scheme.QcohAlgebra`) or a project
   bespoke alias for `Algebra`-typed quasi-coherent sheaf? If bespoke,
   does Mathlib have the canonical name and shape?

4. **The minimum useful API surface**. iter-178+ needs:
   - The carrier `RelativeSpec 𝒜 : Scheme`
   - The structure morphism `structureMorphism 𝒜 : RelativeSpec 𝒜 ⟶ X`
   - `IsAffineHom (structureMorphism 𝒜)`
   - The universal property (RelativeSpec is final among schemes `T → X` carrying an `𝒜 ⟶ structure_sheaf` map)
   - Base change: `RelativeSpec 𝒜 ×_X T ≅ RelativeSpec (𝒜.pullback ...)`
   - The `affine_base_iff`: when `X = Spec R`, `RelativeSpec 𝒜 = Spec (algebra-of-global-sections of 𝒜)`
   What is the cleanest Mathlib-aligned way to expose these?

5. **A "build it minimally" path**: if Mathlib has nothing usable, can
   we encode `RelativeSpec` via the **affine-cover construction**
   (Stacks 01LM/01LP/01LT) directly:
   - Step 1: For affine `X = Spec R`, `𝒜` corresponds to an `R`-algebra `A`; define `RelativeSpec 𝒜 := Spec A`, `structureMorphism := Spec(R → A)`.
   - Step 2: For general `X`, use `Scheme.GlueData` over an affine open cover, with the affine pieces produced by Step 1, glued via the descent data from `𝒜`'s sheaf structure on intersections.
   Where in Mathlib is the most-Mathlib-aligned `GlueData` builder for this style?

## Output

Standard api-alignment output: `## Verdict` (PROCEED / ALIGN-WITH-MATHLIB),
`## Recommendation` (named Mathlib types/lemmas/builders with citations),
`## Pivot plan` (concrete steps to retire the `RelativeSpec := X` placeholder
and land a substantive encoding), `## LOC estimate` for the minimum substantive
landing.

Persist findings to `analogies/relative-spec-encoding.md` so iter-179+ planners can
build on it.

## What NOT to do

- Do NOT propose adding new project axioms to bypass the construction.
- Do NOT propose another placeholder body. The encoding question is exactly
  the question.
- Do NOT report "PROCEED" if the current `:= X` body is in any way salvageable
  by adding more downstream typeclass instances — the carrier is wrong, and
  the auditor's verdict stands.
