# Blueprint-writer — QuotScheme predicate encodings

## Target chapter
`blueprint/src/chapters/Picard_QuotScheme.tex` (ONLY this file).

## Strategy context (the slice that matters)
The Quot functor `def:quot_functor` (Nitsure §2) classifies quotients `F ↠ G` on `X/S` that are
`S`-flat, coherent, and have **schematic support proper over the base**. The Grassmannian
foundations (`def:grassmannian_scheme`, Nitsure §5) classify **rank-`d` locally free** quotients
of a fixed locally free `V`. The blueprint-reviewer (iter-004) flagged this chapter `complete:
partial` because two project-side predicates have no Lean encoding at their pins:
(P1) "coherent sheaf with schematic support proper over `S`" and (P2) "rank-`d` locally free
`SheafOfModules`". A `mathlib-analogist` (api-alignment) pass has now fixed the idiomatic Lean
shapes. Your job is to add the blueprint blocks encoding these, so the QUOT track becomes
prover-actionable next iter.

## REQUIRED READING before writing
1. `analogies/quot-predicates.md` — the analogist's full decision-by-decision rationale and the
   exact Mathlib declarations each predicate must be built on. This is the authoritative source
   for the Lean shapes below. Use its citations verbatim for the `\lean{}` pins and the
   build-on lemma names.
2. `references/nitsure-hilbert-quot-src/*.tex` — §2 (the Quot functor families: flat, coherent,
   proper support) and §5 (the rank-`d` quotient defining the Grassmannian). Pull the verbatim
   `% SOURCE QUOTE` text for the families condition (proper support) and the rank-`d` condition.
3. The existing `def:quot_functor` block and the coherence-encoding pattern already used by
   `thm:generic_flatness` (`[F.IsQuasicoherent]` + `[F.IsFiniteType]`) so the new predicate
   blocks match the project's encoding conventions.

## TASK 1 — schematic-support annihilator ideal sheaf (new primitive, P1a)
Add a definition block `def:modules_annihilator` for the annihilator ideal sheaf of a
`Scheme.Modules` object, mirroring `AlgebraicGeometry.Scheme.Hom.ker`:
- `\lean{AlgebraicGeometry.Scheme.Modules.annihilator}` — `X.Modules → X.IdealSheafData`,
  `:= IdealSheafData.ofIdeals fun U ↦ Module.annihilator _ Γ(F,U)`.
- Note in the prose (NOT as a `\mathlibok`) that this is a project-built primitive: Mathlib has
  no support of a `SheafOfModules`; it is built on `IdealSheafData.ofIdeals`, ring-level
  `Module.annihilator`, mirroring `Scheme.Hom.ker`. Cite the exact Mathlib decls from
  `analogies/quot-predicates.md` (`IdealSheaf/Basic.lean`, `RingTheory/Ideal/Colon.lean`).
- Add `def:schematic_support` for `schematicSupport F := (F.annihilator).subscheme` with closed
  immersion `(F.annihilator).subschemeι`.

## TASK 2 — "proper support over S" predicate (P1b, ALIGN with Mathlib `IsProper`)
Add a definition block `def:has_proper_support`:
- `\lean{AlgebraicGeometry.Scheme.Modules.HasProperSupport}` — for `F : X.Modules` and
  `f : X ⟶ S`, defined as `IsProper ((F.annihilator).subschemeι ≫ f)`.
- Add a `\mathlibok` Mathlib dependency anchor block `lem:isProper_mathlib` stating
  `AlgebraicGeometry.IsProper` (the `MorphismProperty` = `(IsSeparated ⊓ UniversallyClosed) ⊓
  LocallyOfFiniteType`) with `\lean{AlgebraicGeometry.IsProper}`, and note its
  `IsStableUnderBaseChange` instance discharges Nitsure's base-change clause for the functor's
  pullback action for free. (This anchor is the ONLY `\mathlibok` you add — it names a genuine
  Mathlib declaration. Do NOT mark any project-built block `\mathlibok`.)
- `\uses{def:schematic_support, lem:isProper_mathlib}`.

## TASK 3 — rank-`d` locally free predicate (P2)
Add a definition block `def:is_locally_free_of_rank`:
- `\lean{AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank}` — a `Prop` on a `SheafOfModules`
  (or `X.Modules`) object `M` with a rank parameter `r : ℕ`, witnessed by `Nonempty` of
  local-trivialization data exhibiting `M`, on each element of an open cover, as
  `SheafOfModules.free (Fin r)`. Mirror the existing object-predicate idiom
  (`IsQuasicoherent := Nonempty (QuasicoherentData M)`; `IsFiniteType := ∃ σ, …`).
- Prose must state the rank is carried as the parameter on `free (Fin r)` — NOT a rank-agnostic
  predicate plus a sheaf-level `rankAtStalk = r` conjunction (no sheaf-level `rankAtStalk`
  exists). Cite the Mathlib build-on decls from `analogies/quot-predicates.md`
  (`SheafOfModules.free`/`freeFunctor`/`mapFree`; the `IsQuasicoherent`/`IsFinitePresentation`
  idiom in `Sheaf/Quasicoherent.lean`).

## TASK 4 — wire `def:quot_functor` and `def:grassmannian_scheme` to the new predicates
- Update `def:quot_functor`'s statement/prose to state the classified quotients carry
  `[G.IsQuasicoherent]` + `[G.IsFiniteType]` (coherent) and `HasProperSupport G (the structure
  morphism to T)`, and add `\uses{def:has_proper_support}`.
- Update `def:grassmannian_scheme` (or the relevant rank-`d` quotient block) to reference
  `def:is_locally_free_of_rank` with rank `d`, adding `\uses{def:is_locally_free_of_rank}`.

## OUT OF SCOPE (do NOT touch)
- The `thm:grassmannian_representable` **proof sketch** and its "deferred open question" NOTE
  about the RepresentableBy closing argument. That is a separate strategic item (depends on the
  RelativeSpec strengthening decision and the not-yet-built GR-cells/glue/quot); it is being
  deferred this iter by plan-agent decision. Leave it exactly as is.
- Any `\leanok` marker (never add or remove — owned by the deterministic sync phase).
- Any other chapter.

## Citation discipline
Every new block deriving from Nitsure needs `% SOURCE:` + verbatim `% SOURCE QUOTE:` (original
English, character-for-character from the §2/§5 source) + a visible `\textit{Source: Nitsure,
§…}` line. The Mathlib-idiom citations (decl names) come from `analogies/quot-predicates.md`;
the mathematical content + quotes come from the Nitsure source you read.

## Verification
Report leandag cleanliness (0 unknown_uses, 0 isolated, 0 conflicts) after your edits, and list
the `\lean{}` pins you introduced so the plan agent can track the new Lean decls to scaffold.
