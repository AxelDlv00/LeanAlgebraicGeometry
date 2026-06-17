# Blueprint Writer Report

## Slug
fbc-seams

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made
Enrichment-only round (no statement/pin/label/`\uses`/marker changes), as the directive required.

- **Added `% RECIPE (iter-015, LSP-validated):` comment** to `lem:base_change_mate_fstar_reindex`
  (Seam 2), immediately after the existing LEAN SIGNATURE comment. Records the four-step
  "Mathlib-absent mate-unwinding over the generic pullback square" route with the validated
  Mathlib lemma names: leg identification via `pullback_fst_snd_specMap_tensor`; unit transport
  via the conjugate calculus (`Scheme.Modules.conjugateEquiv_pullbackComp_inv` +
  `CategoryTheory.unit_conjugateEquiv` / `unit_conjugateEquiv_symm`, with `e = pullbackSpecIso`);
  collapse of the transparent coherences (`pushforwardComp_hom_app_app`/`_inv_app_app = 𝟙`,
  `pushforwardCongr_hom_app_app = presheaf.map (eqToHom …).op`); reduction to Seam 1
  (`base_change_mate_unit_value`) + codomain reconciliation (`base_change_mate_codomain_read`,
  `base_change_mate_inner_value`). Includes the recorded DEAD END (naive `rw`/`simp` with leg
  equalities `hfst`/`hsnd` → "motive is not type correct"; the reindex must go through the
  abstract conjugate calculus).
- **Revised the proof prose** of `lem:base_change_mate_fstar_reindex` — restructured into the
  four named steps (leg identification, unit transport via the mate/conjugate calculus, collapse
  of the transparent coherences, reduction to Seam 1 + codomain reconciliation), all in
  mathematical (non-Lean) language; added the abstract-not-by-rewriting framing of why the legs
  are handled through the mate calculus.
- **Added `% RECIPE:` comment** to `lem:base_change_mate_gstar_transpose` (Seam 3), immediately
  after the existing LEAN SIGNATURE comment. Records the distinct crux: Seam 3 = `extendScalars ψ`
  of Seam 2's inner value `ρ`; counit split (`Adjunction.homEquiv_counit`); conjugation by
  `Θ_src = base_change_mate_domain_read` (which already bakes in `pullback_spec_tilde_iso ψ`) /
  `Θ_tgt = base_change_mate_codomain_read`, residual = counit-triangle / dictionary naturality
  giving `extendScalars ψ ∘ ρ`; final `R'`-linear identification with `regroupEquiv.inv` on
  generators.
- **Revised the proof prose** of `lem:base_change_mate_gstar_transpose` — restructured into
  three named steps (counit factorization, conjugation by the section dictionaries with the
  pullback dictionary baked into the domain read, identification on generators), framed as the
  pullback-side companion of Seam 2.

## Cross-references introduced
All `\ref`s I added point at labels that already exist and (where in a proof block) were already
in scope:
- Seam 2 proof: `Definition~\ref{def:base_change_mate_inner_value}` — `def:base_change_mate_inner_value`
  is already in this proof's `\uses` set.
- Seam 3 proof: `Definition~\ref{def:pushforward_base_change_map}` — label exists (matches the
  pre-existing reference in the same lemma's statement block; this lemma's `\uses` set is frozen
  by the directive, so I did not add the edge).
- `leandag build --json`: `unknown_uses: []`, `conflicts: []`. No broken refs, no new isolated
  nodes from these blocks.

## References consulted
No new citation blocks were written; the existing `% SOURCE`/`% SOURCE QUOTE`/`\textit{Source:}`
lines (Stacks Project, Cohomology of Schemes, "Affine base change") were left intact. No
reference files were opened this session (enrichment of proof prose + Mathlib-mechanism comments
only).

## Macros needed (if any)
None. Prose uses only existing macros (`\operatorname`, `\widetilde`, `\otimes`, etc.).

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- The `% RECIPE` blocks deliberately carry the Mathlib lemma names (per directive style: names
  in comments, mathematical prose in the rendered body). A prover picking up either seam should
  read the RECIPE comment first — Seam 2's records the exact conjugate-calculus route and the
  `rw`-on-legs dead end the iter-015 prover already hit.
- `lem:base_change_mate_gstar_transpose`'s `\uses` set does not include
  `def:pushforward_base_change_map`, although both its statement and (now) proof prose reference
  that definition. This predates my edit; the directive froze the `\uses` set, so I left it. If
  the reviewer wants the dependency edge explicit, adding `def:pushforward_base_change_map` to
  that lemma's `\uses` would be the fix.

## Strategy-modifying findings
None.
