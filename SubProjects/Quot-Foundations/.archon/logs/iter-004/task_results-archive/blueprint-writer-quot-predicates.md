# Blueprint Writer Report

## Slug
quot-predicates

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Changes Made

Added a new section `\section{Support and freeness predicates}`
(`\label{sec:quot_predicates}`) between the graded-Hilbert-polynomial section and
the Quot-functor section, containing five new blocks, then wired the two existing
functor blocks to them.

- **Added definition** `def:modules_annihilator` /
  `\lean{AlgebraicGeometry.Scheme.Modules.annihilator}` — annihilator ideal sheaf
  of a sheaf of modules, `ofIdeals (U ↦ Module.annihilator Γ(F,U))`, mirroring
  `Scheme.Hom.ker`. Prose flags it as a project-built primitive (Mathlib has no
  `SheafOfModules` support), citing `IdealSheaf/Basic.lean` +
  `RingTheory/Ideal/Colon.lean`. NOT marked `\mathlibok`.
- **Added definition** `def:schematic_support` /
  `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupport}` —
  `(F.annihilator).subscheme` with closed immersion `subschemeι`, citing
  `IdealSheaf/Subscheme.lean`. `\uses{def:modules_annihilator}`.
- **Added Mathlib anchor** `lem:isProper_mathlib` /
  `\lean{AlgebraicGeometry.IsProper}` / `\mathlibok` — the `MorphismProperty`
  `(IsSeparated ⊓ UniversallyClosed) ⊓ LocallyOfFiniteType`, noting its
  `IsStableUnderBaseChange` instance discharges Nitsure's base-change clause. This
  is the ONLY `\mathlibok` added.
- **Added definition** `def:has_proper_support` /
  `\lean{AlgebraicGeometry.Scheme.Modules.HasProperSupport}` —
  `IsProper ((F.annihilator).subschemeι ≫ f)`.
  `\uses{def:schematic_support, lem:isProper_mathlib}`.
- **Added definition** `def:is_locally_free_of_rank` /
  `\lean{AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank}` — `Prop` on a
  sheaf of modules `M` with rank `r : ℕ`, `Nonempty` of local-trivialisation data
  against `SheafOfModules.free (Fin r)`, paralleling
  `IsQuasicoherent`/`IsFinitePresentation`. Encoding note states the rank is the
  parameter on `free (Fin r)` (NOT a rank-agnostic predicate + sheaf-level
  `rankAtStalk`, which does not exist), citing `Sheaf/Free.lean` +
  `Sheaf/Quasicoherent.lean` + `Sheaf/Generators.lean`. NOT marked `\mathlibok`.
- **Revised** `def:quot_functor` — added `\uses{..., def:has_proper_support}`;
  clause (1) now states coherence is `[F.IsQuasicoherent]` + `[F.IsFiniteType]`
  and proper support is `HasProperSupport F` along `X_T → T`.
- **Revised** `def:grassmannian_scheme` — added
  `\uses{..., def:is_locally_free_of_rank}`; the rank-`d` quotient now references
  `IsLocallyFreeOfRank F d`.

## New `\lean{}` pins introduced (for plan agent to scaffold)
- `AlgebraicGeometry.Scheme.Modules.annihilator` (`X.Modules → X.IdealSheafData`)
- `AlgebraicGeometry.Scheme.Modules.schematicSupport`
- `AlgebraicGeometry.Scheme.Modules.HasProperSupport`
- `AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank`
- `AlgebraicGeometry.IsProper` — Mathlib (`\mathlibok` anchor; no scaffold needed)

## Cross-references introduced
- `def:schematic_support` → `def:modules_annihilator` (same chapter, exists)
- `def:has_proper_support` → `def:schematic_support`, `lem:isProper_mathlib` (same chapter)
- `def:quot_functor` → `def:has_proper_support` (same chapter)
- `def:grassmannian_scheme` → `def:is_locally_free_of_rank` (same chapter)

## leandag verification
`leandag build --json` after edits:
- `isolated`: **0**
- `conflicts`: **0**
- `unknown_uses`: **0**
- `blueprint_nodes`: 67 → 72 (+5); `edges`: 102 → 107; `mathlib_ok`: 8 → 9
- `query --isolated --chapter Picard_QuotScheme`: none

The 5 new pins appear under `unmatched_lean` (no Lean decl yet) — expected; these
are exactly the decls the plan agent should scaffold (except the Mathlib anchor
`IsProper`, which is correctly counted in `mathlib_ok`).

## References consulted
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` —
  - L468–L471 (schematic support of a coherent sheaf proper over `S`): verbatim
    quote for `def:modules_annihilator` and `def:schematic_support`.
  - L407–L409 + L418–L419 (family-of-quotients condition: schematic support
    proper over `T`; properness preserved by base change): verbatim quote for
    `def:has_proper_support`.
  - L562–L564 + L584–L585 (rank-`d` locally free quotient): verbatim quote for
    `def:is_locally_free_of_rank`.
- `analogies/quot-predicates.md` — authoritative Lean shapes and the Mathlib
  build-on decl names (`IdealSheafData.ofIdeals`, `Module.annihilator`,
  `Scheme.Hom.ker`, `subscheme`/`subschemeι`, `IsProper` +
  `IsStableUnderBaseChange`, `SheafOfModules.free`/`freeFunctor`/`mapFree`,
  `IsQuasicoherent`/`IsFinitePresentation`/`IsFiniteType` idioms).

## Macros needed (if any)
None. Only standard `\mathrm`, `\operatorname`-free `\mathrm{...}`, `\texttt`,
`\Gamma`, and already-defined chapter macros were used. (`IdealSheafData`,
`Ann`, `Modules`, etc. are rendered via `\mathrm{...}`, which KaTeX/pdflatex both
accept.)

## Reference-retriever dispatches (if any)
None — all required source text was already present locally.

## Notes for Plan Agent
- `def:modules_annihilator`'s `\lean{}` pin (`...Scheme.Modules.annihilator`) is a
  genuine upstream gap-fill: it must be built in Lean before
  `schematicSupport`/`HasProperSupport` can be filled. Suggest scaffolding the
  three project pins in dependency order: `annihilator` → `schematicSupport` →
  `HasProperSupport`, and `IsLocallyFreeOfRank` independently.
- `def:is_locally_free_of_rank` is pinned on namespace
  `AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank` per the analogist's
  recommended shape (predicate on a `SheafOfModules`); if the project prefers the
  `X.Modules` object form, the pin namespace may need adjusting at scaffold time
  (the analogy explicitly allows either — "on a SheafOfModules (or X.Modules)").
- The `thm:grassmannian_representable` proof sketch and its deferred-open-question
  NOTE were left untouched, per directive out-of-scope.

## Strategy-modifying findings
None. The predicate encodings fit the existing strategy (Quot functor over
sheaf-of-modules; Grassmannian = Quot of rank-`d` locally free quotients) without
requiring any change to STRATEGY.md.
