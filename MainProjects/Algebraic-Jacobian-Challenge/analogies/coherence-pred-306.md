# Analogy: coherence predicate for `genericFlatness` + 6 sibling decls

## Mode
api-alignment

## Slug
coherence-pred-306

## Iteration
306

## Question
We must re-sign `AlgebraicGeometry.genericFlatness` and 6 siblings in
`AlgebraicJacobian/Picard/FlatteningStratification.lean` (currently bare `(F : X.Modules)`
with no coherence/finite-type hypothesis, making generic flatness false as stated). What is
the right coherence predicate to add? Proposed project-local:
`Scheme.Modules.IsCoherent F := F.IsQuasicoherent ∧ ∀ {V}, IsAffineOpen V → Module.Finite Γ(X,V) Γ(F,V)`.

## Project artifact(s)
- `AlgebraicJacobian/Picard/FlatteningStratification.lean:287-294` — `genericFlatness` (bare `F`).
- `…:331-530` — 6 siblings: `flatLocusStratification`, `flatLocusReduction`, `flatLocusAssembly`,
  `flatteningStratification`, `flatteningStratification_universal`, `flatteningStratification.ofCurve` (all bare `F`).
- `…:160-212` — `GenericFreeness` section: finite-module generic-freeness already landed.
- Note: `genericFlatness` etc. are **not** in `archon-protected.yaml` (only Genus/Jacobian/AbelJacobi) → re-signing is allowed.

## Key fact: the project's `IsQuasicoherent` IS Mathlib's
`X.Modules = SheafOfModules X.ringCatSheaf`. `F.IsQuasicoherent` used throughout the project
(e.g. `QcohTildeSections.lean:1446`) is literally `Mathlib …Sheaf.Quasicoherent.SheafOfModules.IsQuasicoherent`
— there is no project-local IsQuasicoherent. So the same Mathlib file already gives the rest of the hierarchy.

## Decisions identified

### Decision: build a new `IsCoherent` predicate vs reuse Mathlib's finite-type / finite-presentation hierarchy

- **Mathlib idiom**: a full typeclass hierarchy of sheaf-of-modules predicates exists.
  Cite `Mathlib.Algebra.Category.ModuleCat.Sheaf.Quasicoherent` and
  `Mathlib.Algebra.Category.ModuleCat.Sheaf.Generators`:
  - `SheafOfModules.IsQuasicoherent` (typeclass `Prop`)  ← project already uses this
  - `SheafOfModules.IsFiniteType` (typeclass `Prop`, `…Sheaf.Generators`)
  - `SheafOfModules.IsFinitePresentation` (typeclass `Prop`, `…Sheaf.Quasicoherent`)
  - `SheafOfModules.instIsFiniteTypeOfIsFinitePresentation` : `IsFinitePresentation → IsFiniteType`
  - `SheafOfModules.instIsQuasicoherentOfIsFinitePresentation` : `IsFinitePresentation → IsQuasicoherent`
  All three resolve for `X.Modules` (verified by compilation: `example (F : X.Modules)
  [F.IsFinitePresentation] : F.IsFiniteType := inferInstance` and `… : F.IsQuasicoherent := inferInstance`
  both succeed; the site instances `HasWeakSheafify/WEqualsLocallyBijective/HasSheafCompose` resolve
  for `X.ringCatSheaf` exactly as they already do for the project's `IsQuasicoherent` uses).
  Why Mathlib chose typeclasses: matches the instance-driven QC style, lets downstream code pick up
  coherence/finite-type by inference rather than threading a `Prop` argument, and lets
  `IsFinitePresentation` bundle both quasicoherence and finite type via the two instances above.
- **`SheafOfModules.IsCoherent` does NOT exist** (loogle empty). So "coherent" must be expressed as
  the combination. On a locally-noetherian scheme, **coherent = finitely presented = (finite type + quasicoherent)**;
  Mathlib's `IsFinitePresentation` is exactly that combination as a single typeclass.
- **Project's proposed path**: a bundled `Prop` conjunction `IsQuasicoherent ∧ affine-local Module.Finite Γ(X,V) Γ(F,V)`,
  passed as an explicit hypothesis.
- **Gap**: divergent-with-cost (parallel API).
  1. It re-invents `IsFinitePresentation`/`IsFiniteType` as a fresh bundled `Prop`, off the instance-resolution graph
     (downstream can't `inferInstance` coherence; every consumer must thread the hypothesis and re-destructure the ∧).
  2. The finiteness leg is written affine-locally as `Module.Finite Γ(X,V) Γ(F,V)`, which is **not** how Mathlib
     states finite type (Mathlib: local *generating sections* via `LocalGeneratorsData`/`GeneratingSections.IsFiniteType`).
     So the proposed predicate needs its own bridge to Mathlib (`IsFiniteType ↔ affine-locally Module.Finite`) to
     ever interoperate — a bridge you'd have to build regardless. Building it once *against the Mathlib typeclass* is strictly better.
- **Verdict**: **ALIGN_WITH_MATHLIB**.

### Decision: `Module.Finite` vs `Module.FinitePresentation` for the finiteness leg
- The base is `[IsLocallyNoetherian S]` and `X` is finite-type over it (locally noetherian), so finite type ⟺
  finite presentation for QC sheaves; "coherent" is the standard label. Pick `IsFinitePresentation` because
  (a) it bundles `IsQuasicoherent` *and* `IsFiniteType` for free via the two instances, so it is a *single*
  hypothesis equal to "coherent"; (b) Mathlib's downstream generic-freeness tool
  `Module.FinitePresentation.exists_free_localizedModule_powers` (and the project's own `GenericFreeness` lemmas)
  are stated for finite presentation; (c) the project's existing `GenericFreeness` section already runs on
  `Module.FinitePresentation` (it calls `Module.finitePresentation_of_finite`). **Verdict: use `[F.IsFinitePresentation]`.**

### Decision: typeclass instance-binder vs explicit `Prop` argument
- The whole Mathlib hierarchy is instance-driven and the project already consumes `[F.IsQuasicoherent]` as an
  instance binder. Add coherence as an **instance binder** `[F.IsFinitePresentation]`, not an explicit `(h : …)` arg.
  This keeps re-signing minimal and lets downstream `inferInstance`. **Verdict: instance binder.**

### Decision: is there a Mathlib algebraic generic-flatness theorem to target?
- **No full theorem** (noetherian domain `A` + finite-type `A`-algebra `B` + finite `B`-module `M` ⇒ `∃ f≠0, M_f` free over `A_f`).
  loogle `genericFlatness` empty; no `Algebra`/`Module` lemma of that shape.
- Closest building block (already used by the project): `Module.FinitePresentation.exists_free_localizedModule_powers`
  (`Mathlib.RingTheory.Localization.Free`) — but it *requires* `Module.Free Rₛ M'` at the localization, so it only
  delivers the **finite-module / finite-morphism case** (the project's `GenericFreeness.exists_free_localizationAway_of_finite`).
  The polynomial-ring core (d > 0 dévissage / Noether normalisation) is a genuine Mathlib gap, as the file's own
  comment (lines 135-158) already records. **Verdict: NEEDS_MATHLIB_GAP_FILL** for the general algebraic statement;
  the finite case is already landed.

## Recommendation
Do **not** define `Scheme.Modules.IsCoherent`. Re-sign `genericFlatness` and the 6 siblings by adding the Mathlib
typeclass instance binder **`[F.IsFinitePresentation]`** (on a noetherian base this is exactly "coherent" and it
auto-provides `[F.IsFiniteType]` and `[F.IsQuasicoherent]` via existing Mathlib instances; all resolve for `X.Modules`).
Where `F` lives on the relative scheme (e.g. `flatteningStratification.ofCurve`'s `F : (pullback …).Modules`), put the
binder on that `F`. If a proof body needs the affine-local module-finite form `Module.Finite Γ(X,V) Γ(F,V)`, prove it as
a *lemma from* `[F.IsFiniteType] [F.IsQuasicoherent]` (bridge `IsFiniteType → affine-local Module.Finite`) rather than
baking it into the signature — this bridge is the one piece of new API worth adding, and it is reusable. For the
algebraic engine of `genericFlatness`, target the project's existing `GenericFreeness` lemmas for the finite case and
treat the polynomial-ring core as the standing Mathlib gap (no Mathlib `genericFlatness` to reuse).
