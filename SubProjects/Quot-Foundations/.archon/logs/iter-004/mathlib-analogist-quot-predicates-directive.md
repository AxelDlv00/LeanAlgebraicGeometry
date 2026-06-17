## Mode: api-alignment

# QUOT predicate shapes — Mathlib idiom alignment

The Quot functor and the Grassmannian foundations need two project-side predicates that
do not exist at their intended Lean pins. Before a blueprint-writer adds the predicate
blocks and a prover scaffolds them, I need to know the correct Mathlib-aligned shape for
each so we do not build a parallel API.

Read these for context:
- `blueprint/src/chapters/Picard_QuotScheme.tex` — the `def:quot_functor` and the coherence
  encoding used elsewhere (`thm:generic_flatness` uses `[F.IsQuasicoherent]` + `[F.IsFiniteType]`).
- `references/nitsure-hilbert-quot.md` (pointer) and, for verbatim text,
  `references/nitsure-hilbert-quot-src/*.tex` — §2 (the Quot functor) defines the families
  the functor classifies; §5 (Grassmannian) the rank-d quotient.

## Predicate 1 — "coherent sheaf with schematic support proper over the base"

Context: `def:quot_functor` classifies quotients `F ↠ G` on `X/S` where `G` is `S`-flat,
coherent, with **schematic support proper over the base** T (Nitsure §2). The project already
encodes "coherent" as `[F.IsQuasicoherent]` + `[F.IsFiniteType]` over a locally Noetherian base.
The missing piece is the **proper-support** condition for a `SheafOfModules` / `Scheme.Modules` object.

Questions:
- Does Mathlib have a notion of the (schematic / scheme-theoretic) support of a quasi-coherent
  or coherent module, and/or a "support proper over S" predicate? Search
  `AlgebraicGeometry`, `Mathlib.AlgebraicGeometry.Sites`, the `Scheme.Modules` /
  `SheafOfModules` API, and the `IsProper` / `UniversallyClosed` morphism-property files.
- If absent, what is the Mathlib-idiomatic shape to introduce it: a `Prop`-valued predicate on
  the module object, a structure, or a property of the closed-immersion of the support
  subscheme composed with `f : X → S`? Should it be phrased via the existing
  `MorphismProperty IsProper` applied to `support ↪ X → S`?
- Name the exact existing Mathlib declarations (support of a sheaf of modules, schematic
  support / `Module.support`, scheme-theoretic image / closed subscheme of vanishing) that the
  predicate should be built on, with their fully-qualified names verified via search.

## Predicate 2 — "rank-d locally free SheafOfModules" (the tautological Grassmannian quotient)

Context: the Grassmannian `Gr_S(V,d)` classifies rank-`d` locally free quotients of a fixed
locally free `V` (Nitsure §5). The project notes `IsLocallyFree` is upstream-only / rank-agnostic
at the pin — we need a **rank-`r` local-freeness** predicate for `SheafOfModules` / `Scheme.Modules`.

Questions:
- What does Mathlib currently provide for local freeness of a `SheafOfModules` / bundle on a
  scheme, and is there any rank-indexed version (constant rank `r`)? Search the
  `SheafOfModules`, `Scheme.Modules`, vector-bundle, and `Module.Free` / `Module.finrank` /
  `Module.rankAtStalk` areas.
- If only a rank-agnostic `IsLocallyFree` exists, what is the idiomatic way to add the rank
  constraint — a separate `Prop` `IsLocallyFreeOfRank r`, a conjunction with a `rankAtStalk = r`
  condition, or a bundled structure? How does Mathlib handle constant-rank for finite locally
  free modules over a ring (e.g. `Module.finrank` constancy on `Spec`)? Name the closest
  Mathlib idiom verbatim.

## Output I need
For each predicate: (1) does Mathlib already supply it (exact name) or is it genuinely absent;
(2) the recommended idiomatic Lean shape (predicate vs structure vs morphism-property), with the
specific Mathlib declarations it should be built on; (3) the cost of a wrong/parallel choice.
Persist the rationale to `analogies/quot-predicates.md`.
