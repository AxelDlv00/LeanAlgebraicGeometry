# blueprint-clean bc263 — purity gate on the iter-263 writer edits

Two chapters were edited this iter by blueprint-writers. Enforce blueprint purity (math-only) on the
edited regions: strip any Lean tactic syntax, Lean identifier leakage in visible prose (the `\lean{}`
tags themselves are fine; bare Lean names like `coverArrow`/`Gobj`/`hom_ext` in rendered prose are
not), project-history phrasing ("iter-NNN", "the prover found", slugs), and verbosity. Validate that
`% SOURCE`/`% SOURCE QUOTE` blocks are intact and any newly quoted source text is genuinely present in
the cited local file. Do NOT add or remove `\leanok`/`\mathlibok` markers. Do NOT change the
mathematical content; only purify.

## Files (edited regions)
1. `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — ONLY the `lem:slice_dual_transport` block
   (proof "Inverse, linearity, and naturality" paragraph, now a two-step `enumerate`; leg-B paragraph
   with two new `\lean{}` hints). Leave the rest of this large chapter untouched.
2. `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` — the revised `def:cech_nerve`
   (cosimplicial terminology + variance paragraph), the new subsection `sec:cech_three_part` (three
   `\paragraph`s on backbone / push-pull functor `G` / plumbing), and the appended absent-Mathlib
   notes on `lem:cech_acyclic_affine` / `lem:cech_computes_cohomology` / `lem:cech_flat_base_change`.
   In particular, confirm the push-pull `\paragraph` describes the MATH (covariant direct image of the
   nerve, the `(p∘q)_*≅p_*q_*` / `(p∘q)^*≅q^*p^*` coherence) and does NOT leak Lean helper names
   (`coverArrow`, `Gobj`, `Gmap`, `relativeCechComplexOfNerve`) into rendered prose.

You have `references/**` in your write-domain in case a child reference-retriever is needed to confirm
a quote, but no new sources are expected.
