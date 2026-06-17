# Refactor Report

## Slug
scaffold-av-rigidity

## Status
COMPLETE

## Directive
**Problem/Goal:** Create a NEW upstream Lean file `AlgebraicJacobian/AbelianVarietyRigidity.lean`
scaffolding the committed route-(c) AV-rigidity stack as `sorry`-bodied declarations, breaking
the `RigidityKbar → Rigidity → Jacobian` import cycle. Signatures + `sorry` bodies only — no
proofs. Four `\lean{}` targets from `blueprint/src/chapters/AbelianVarietyRigidity.tex` must
resolve.

## Changes Made

### File: `AlgebraicJacobian/AbelianVarietyRigidity.lean` (NEW)
- **What:** Created the file with the Apache header, a module docstring pointing at the
  blueprint chapter, `set_option autoImplicit false`, `universe u`, `namespace
  AlgebraicGeometry`, `variable {kbar : Type u} [Field kbar]`, and the `open` lines mirrored
  from `RigidityKbar.lean` (`CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory
  MonObj`). Imports **only** `AlgebraicJacobian.Genus` (which itself does `import Mathlib`, so
  `CartesianMonoidalCategory`/`GrpObj`/`⊗`/`toUnit`/`η[]`/`Iso` are all in scope). Does NOT
  import `Rigidity`, `Jacobian`, or `RigidityKbar`.
- **Declarations (all `:= sorry`):**
  1. `rigidity_lemma` — Rigidity Lemma (Mumford Form I). Encoded with the project's monoidal
     product: `f : (X ⊗ Y) ⟶ Z`, `[IsProper X.hom]` ("complete"); the "`f(X×{y₀})` a single
     point" hypothesis is `lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀`; conclusion
     `∃ g : Y ⟶ Z, f = snd X Y ≫ g` (`snd`/`lift` from `CartesianMonoidalCategory`). Marked
     `SCAFFOLD`. Used `⊗`/`CartesianMonoidalCategory.{lift,snd}` rather than
     `Limits.prod`/`prod.snd` because the project's whole categorical surface (and the existing
     `CartesianMonoidalCategory (Over (Spec _))` instance the codebase already relies on) is the
     cartesian-monoidal one — this guarantees instance resolution. Directive permitted "whatever
     well-typed form compiles."
  2. `morphism_P1_to_grpScheme_const` — every `f : ℙ¹ ⟶ A` is constant
     (`∃ a₀, f = toUnit P1 ≫ a₀`). `ℙ¹` encoded by the project's abstract genus-`0`-curve
     proxy (per `RigidityKbar` precedent). Added `[IsAlgClosed kbar]`. Marked `SCAFFOLD`.
  3. `genusZero_curve_iso_P1` — `Nonempty (C ≅ P1)` for genus-`0` curves `C`, `P1`. Both
     encoded by the genus-`0`-curve proxy, so it provisionally reads "any two genus-`0` curves
     are isomorphic". Added `[IsAlgClosed kbar]`. Marked `SCAFFOLD`.
  4. `rigidity_genus0_curve_to_grpScheme` — THE HEADLINE. Pinned **verbatim** to
     `rigidity_over_kbar` (RigidityKbar.lean:75–88) with the single change of dropping
     `[CharZero kbar]`. Same curve/AV typeclasses, same `(_hgenus : genus C = 0)`, same
     `(f : C ⟶ A) (p : 𝟙_ ⟶ C) (_hf : p ≫ f = η[A])`, same conclusion
     `f = (toUnit C ≫ η[A])`. This is the signature `genusZeroWitness.key` will consume.
- **Cascading:** none (new upstream file).

### File: `AlgebraicJacobian.lean` (root)
- **What:** Added `import AlgebraicJacobian.AbelianVarietyRigidity` between `Genus` and
  `Jacobian`.
- **Cascading:** none.

`Jacobian.lean`, `RigidityKbar.lean`, `Rigidity.lean`, and `genusZeroWitness` left UNTOUCHED, as
directed. No protected signature modified. No `archon-protected.yaml` change (no protected decl
moved).

## New Sorries Introduced
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:69` — `rigidity_lemma` body
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:93` — `morphism_P1_to_grpScheme_const` body
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:117` — `genusZero_curve_iso_P1` body
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:142` — `rigidity_genus0_curve_to_grpScheme` body

## Compilation Status
- `AlgebraicJacobian/AbelianVarietyRigidity.lean`: compiles (4 `sorry` warnings only, no errors).
- `lake build` (full project): GREEN — `Build completed successfully (8332 jobs)`. New file
  appears in the build. Only other warning is a pre-existing `longLine` style warning in
  `AbelJacobi.lean:22` (not touched by this refactor).
- No new `axiom` declarations.

## Notes for Plan Agent
- **Divergence from directive (minor, well within "whatever compiles" latitude):**
  - Decl 1 uses the cartesian-**monoidal** product `X ⊗ Y` + `CartesianMonoidalCategory.snd`/
    `lift` instead of `Limits.prod`/`prod.snd`. Reason: the project's entire categorical idiom
    (`𝟙_`, `toUnit`, `η[]`, `G ⊗ G` in `Cotangent/GrpObj.lean`) is cartesian-monoidal, and that
    instance on `Over (Spec _)` is the one guaranteed resolvable; `Limits.prod` would have
    needed a separately-checked `HasBinaryProduct` instance. The statements are mathematically
    equivalent (cartesian monoidal product = categorical product). The prover can switch to
    `Limits.prod` if preferred when filling the body.
  - Added `[IsAlgClosed kbar]` to decls 2 and 3. The chapter prose explicitly takes `k̄`
    algebraically closed for both (every closed point is rational; `ℙ¹` classification). The
    headline (decl 4) already carries `[IsAlgClosed kbar]` via the verbatim mirror. Decl 1
    (Rigidity Lemma) is stated without `[IsAlgClosed]` since the lemma itself does not need it.
- **ℙ¹ encoding is the live design question for the prover.** Decls 2 & 3 both encode `ℙ¹` via
  the genus-`0`-curve proxy (consistent with `RigidityKbar`'s documented Option B). This makes
  decl 3 provisionally "any two genus-`0` curves are isomorphic". When a real `ℙ¹` object lands
  (e.g. via `AlgebraicGeometry.Proj` of `kbar[X,Y]`, currently absent from Mathlib `b80f227`),
  decls 2–3 should be re-pointed at it; the headline (decl 4) is unaffected because it never
  mentions `ℙ¹`.
- **The cycle is broken as intended.** The file imports only `Genus`; wiring
  `genusZeroWitness.key` to consume `rigidity_genus0_curve_to_grpScheme` (adding
  `import AlgebraicJacobian.AbelianVarietyRigidity` to `Jacobian.lean`) is left for the prover,
  per directive.
- Mathematical justification in the directive + blueprint was sufficient to pin all four
  signatures; no further structural changes are needed before a prover starts on the bodies.
