# Blueprint-reviewer directive — FBC fast-path scoped re-review (iter-017)

## Scope (same-iter fast path)
This is the sanctioned same-iter fast-path re-review scoped to ONE chapter:
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (the FBC-A chapter), against its Lean file
`AlgebraicJacobian/Cohomology/FlatBaseChange.lean`. You may still read sibling chapters for
cross-reference resolution, but the VERDICT requested is specifically for the FBC chapter.

## Why
The iter-016 lean-vs-blueprint-checker (`fbc`) flagged THREE chapter gaps gating the next FBC prover:
1. `pullbackPushforward_unit_comp` (proved, axiom-clean, line ~1140) had NO `\lean{}` blueprint pin
   (coverage debt).
2. Seam 2 (`lem:base_change_mate_fstar_reindex`) proof sketch under-specified: missing the
   dependent-type-wall restructuring (abstract the two pullback legs as subst-able variables).
3. Seam 3 (`lem:base_change_mate_gstar_transpose`) proof sketch under-specified: the concrete
   counit-naturality coherence for `pullback_spec_tilde_iso ψ` (built via `conjugateIsoEquiv`).

A blueprint-writer (`fbc-seams2`) + blueprint-clean (`fbc-iter017`) round just addressed all three:
pinned the helper + 3 Mathlib `\mathlibok` anchors; rewrote the Seam-2 proof into a (i) abstract
variable-legs restatement / (ii) Γ-collapse / (iii) Seam-1-reduction decomposition; rewrote the
Seam-3 step naming the composed-adjunction counit-triangle coherence.

## Verdict requested
For the FBC chapter ONLY, report `complete: true|false` and `correct: true|false`, and whether ANY
must-fix-this-iter finding remains. Specifically confirm:
- Is `lem:pullbackPushforward_unit_comp` now pinned with an accurate statement + `\uses` + at least a
  one-line informal proof, and is it wired as a `\uses` of `lem:base_change_mate_fstar_reindex`?
- Does the Seam-2 proof sketch now give a prover enough to formalize the dependent-type-wall
  restructuring (the abstract variable-legs lemma + Γ-collapse + Seam-1 reduction), rather than
  stalling at the documented DEAD END?
- Does the Seam-3 proof sketch now name the concrete counit coherence route (homEquiv_counit +
  composed-adjunction counit-triangle) sufficiently to formalize?
If all three clear, state the FBC chapter satisfies the HARD GATE for an iter-017 prover.
