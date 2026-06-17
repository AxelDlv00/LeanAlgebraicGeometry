# Mathlib Analogist Report

## Mode
api-alignment

## Slug
quot-predicates

## Iteration
004

## Question
For the two project-side predicates needed by the Quot functor and Grassmannian
foundations — (1) "coherent sheaf with schematic support proper over the base" and
(2) "rank-`d` locally free `SheafOfModules`" — for each: (1) does Mathlib already supply it
(exact name) or is it absent; (2) the recommended idiomatic Lean shape (predicate vs
structure vs morphism-property) and the specific Mathlib declarations to build on; (3) the
cost of a wrong/parallel choice.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1a. Schematic support of a `Scheme.Modules` object | NEEDS_MATHLIB_GAP_FILL | informational (upstream gap) |
| 1b. "Support proper over `S`" wrapper | ALIGN_WITH_MATHLIB | major (in-proposal) |
| 2. Rank-`d` locally free `SheafOfModules` | NEEDS_MATHLIB_GAP_FILL (shape dictated by idiom) | major (in-proposal) |

No shipped code diverges yet (the `.lean` declarations are typed `sorry` skeletons that omit
both conditions), so there is no must-fix-this-iter item — these are adopt-the-idiom-now
calls before the blueprint-writer/prover scaffold them.

## Major

These are ALIGN-style obligations on code not yet written — adopt the idiom directly rather
than refactor later.

- **1b — proper-over-S wrapper**: phrase it as
  `IsProper ((F.annihilator).subschemeι ≫ f)` using `AlgebraicGeometry.IsProper`
  (`Mathlib/AlgebraicGeometry/Morphisms/Proper.lean:42`), the `MorphismProperty Scheme`
  `= (@IsSeparated ⊓ @UniversallyClosed) ⊓ @LocallyOfFiniteType`. Do **not** hand-roll a
  separate "universally-closed + separated + finite-type" support bundle: `IsProper` already
  carries `RespectsIso`, `IsStableUnderComposition`, `IsMultiplicative`,
  **`IsStableUnderBaseChange`** (`Proper.lean:68`), `IsZariskiLocalAtTarget`. Nitsure's
  "properness is preserved by base change" (needed for the Quot functor's pullback action) is
  then `IsProper.isStableUnderBaseChange` for free; a parallel bundle would re-prove it.

- **2 — rank-`d` locally free**: define one `Prop` class
  `SheafOfModules.IsLocallyFreeOfRank (M : SheafOfModules R) (r : ℕ) : Prop` (or on
  `X.Modules`), witnessed by `Nonempty` of local-trivialization data exhibiting `M`, on each
  element of an open cover, as `SheafOfModules.free (Fin r)`. This copies the existing
  object-predicate idiom verbatim:
  `IsQuasicoherent (M) := Nonempty (QuasicoherentData M)`
  (`…/Sheaf/Quasicoherent.lean:249`),
  `IsFinitePresentation (M) := ∃ σ : QuasicoherentData M, σ.IsFinitePresentation`
  (`…/Sheaf/Quasicoherent.lean:262`),
  `IsFiniteType (M) := ∃ σ : M.LocalGeneratorsData, σ.IsFiniteType`
  (`…/Sheaf/Generators.lean:130`). Build the local model on
  `SheafOfModules.free`/`freeFunctor`/`mapFree` (`…/Sheaf/Free.lean`). Carry the rank as the
  parameter on `free (Fin r)` — **not** as a separate rank-agnostic `IsLocallyFree` plus a
  sheaf-`rankAtStalk = r` conjunction (no sheaf-level `rankAtStalk` exists; that route
  doubles the gap-fill). If iso data is needed downstream, split `…Data`/`Is…` as Mathlib
  does for `QuasicoherentData`/`IsQuasicoherent`. Optionally expose
  `isLocallyFreeOfRank r : ObjectProperty (SheafOfModules R)`.

## Informational

- **1a — schematic support primitive (genuine upstream gap)**: Mathlib has the *target*
  closed-subscheme-of-vanishing machinery but **no support of a `SheafOfModules` /
  `Scheme.Modules`** (neither a topological `Closeds X` nor a schematic ideal sheaf). The
  project must build it, but on existing primitives, not as a parallel API:
  - Template to mirror: `AlgebraicGeometry.Scheme.Hom.ker (f : X ⟶ Y) : IdealSheafData Y`
    `:= ofIdeals fun U ↦ RingHom.ker (f.app U).hom` (`…/IdealSheaf/Basic.lean:689`).
  - Build `Scheme.Modules.annihilator : X.Modules → X.IdealSheafData :=`
    `IdealSheafData.ofIdeals fun U ↦ Module.annihilator _ (Γ(F,U))`
    (`IdealSheafData.ofIdeals` at `…/IdealSheaf/Basic.lean:104`; ring-level
    `Module.annihilator` at `Mathlib/RingTheory/Ideal/Colon.lean`; `Module.support` at
    `Mathlib/RingTheory/Support.lean`).
  - Then `schematicSupport F := (F.annihilator).subscheme`
    (`…/IdealSheaf/Subscheme.lean:452`) with closed immersion
    `(F.annihilator).subschemeι` (`…/Subscheme.lean:472`, `IsPreimmersion`+`QuasiCompact` at
    `…/Subscheme.lean:484,488`); underlying closed set `IdealSheafData.support : Closeds X`
    (`…/Basic.lean:327`), `range_subschemeι` (`…/Subscheme.lean:493`). If only the *reduced*
    support is wanted, `IdealSheafData.vanishingIdeal (Z : Closeds X)` (`…/Basic.lean:563`)
    gives the reduced induced structure.
  - Properness is insensitive to the support's scheme structure (universally-closed /
    separated / finite-type ignore nilpotents), so the reduced and annihilator structures
    give the same `HasProperSupport`; the annihilator route is the "schematic support" of
    Nitsure and is preferred for fidelity.

- **Directive premise correction**: the note that `IsLocallyFree` is "upstream-only /
  rank-agnostic at the pin" is inaccurate — a whole-Mathlib grep for
  `IsLocallyFree|isLocallyFree|LocallyFree` returns **zero** hits. There is nothing to
  extend; the predicate is fully absent at the `SheafOfModules` level. The ring-level
  free-locus API does exist (`Module.freeLocus`, `Module.rankAtStalk`,
  `freeLocus_eq_univ_iff`, `isLocallyConstant_rankAtStalk` in
  `Mathlib/RingTheory/Spectrum/Prime/FreeLocus.lean`), and the ring idiom for "finite
  locally free of constant rank `d`" is `Module.Finite` + `Module.Projective` with
  `Module.rankAtStalk M = fun _ ↦ d` — there is no bundled `Module.LocallyFreeOfRank`.

## Persistent file
- `analogies/quot-predicates.md` — full decision-by-decision rationale and citations for
  future iters.

Overall verdict: both predicates are genuinely absent upstream but must be built along
existing idioms — Predicate 1 = `IsProper ((Modules.annihilator F).subschemeι ≫ f)` over a
new `Hom.ker`-style annihilator ideal sheaf; Predicate 2 = a single `Prop`
`IsLocallyFreeOfRank M r` witnessed by `Nonempty` local-trivialization data against
`SheafOfModules.free (Fin r)`, mirroring `IsQuasicoherent`/`IsFinitePresentation`.
