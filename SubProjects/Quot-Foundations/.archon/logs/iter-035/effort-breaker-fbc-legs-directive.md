# Effort-breaker directive — FBC-A conjugate route (`_legs`) atomization (iter-035)

## Chapter
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex`.

## Target
`\label{lem:base_change_mate_fstar_reindex_legs}` (Lean
`AlgebraicGeometry.base_change_mate_fstar_reindex_legs`). The central project blocker (`_legs` crux):
the coherence identifying the abstractly-built conjugate comparison iso with the concretely-assembled
sheaf morphism. It has resisted closure for 5 iters. The prior coarse break (conj-0 foundation / conj-1
codomain-read recut / conj-2 discharge) landed conj-0 (2 axiom-clean lemmas) but left conj-1+conj-2 as a
single step too large for the fine-grained prover ("a new-def-then-bridge sequence larger than a
fine-grained per-sentence step"). This is the iter-035 STUCK structural corrective: re-break conj-1+conj-2
into atomic, individually-provable sub-lemmas.

## Granularity
**Fine — one mathematical claim per lemma.** The coarse break already happened; this is the second,
finer pass. Each emitted sub-lemma must be small enough for a fine-grained prover to close or fail-fast
in one attempt.

## Proof structure to cut along (recipe: analogies/fbc-mate-reencode.md "Top suggestion", L128–146)
The route discharges `_legs` ENTIRELY on the conjugate side — never as a positional equation under the
`X.Modules` diamond. Cut into this `\uses`-linked chain (give each its own `\label`/`\lean{}`/`\uses` +
one-line informal proof; the `\lean{}` decls do NOT exist yet — these are build targets the prover creates):

1. **conj-1a — re-cut codomain read (proof-free, `leftAdjointCompIso`-native).** A NEW comparison object
   `base_change_mate_codomain_read_legs_conj` built from `Scheme.Modules.leftAdjointCompIso` of the FREE
   morphisms `e.hom`, `Spec.map inclA` (square enters via `pushforwardCongr comm` / `pushforwardComp`),
   carrying NO `hfst/hsnd` leg-equality data (legs = the explicit composite `e.hom ≫ Spec.map inclA`).
   `\uses` the conj-0 blocks `pullbackComp_eq_leftAdjointCompIso` + the `leftAdjointCompIso` Mathlib anchor.
2. **conj-1b — bridge new↔old read.** `base_change_mate_codomain_read_legs_conj` equals (is defeq-bridged
   to) the existing concrete `base_change_mate_codomain_read` consumed by the green
   `base_change_mate_fstar_reindex`. One lemma so the existing green `exact` does not break. `\uses` 1.
3. **conj-2a — restate `_legs` at the explicit composite.** The `_legs` statement re-expressed at
   `e.hom ≫ Spec.map inclA` against the conj read. `\uses` 1.
4. **conj-2b — pullbackComp leg via `conjugateEquiv_pullbackComp_inv`.** After
   `apply (conjugateEquiv …).injective`, the pullback-side leg rewrites by the project
   `conjugateEquiv_pullbackComp_inv` + `conjugateEquiv_leftAdjointCompIso_inv`. Isolate this as one claim.
5. **conj-2c — pushforward-side collapse.** The `gammaMap_pushforwardComp_*` / `gammaMap_pushforwardCongr_hom`
   collapse on the pushforward side. One claim.
6. **conj-2d — cross-layer `gammaPushforwardIso ψ` transport.** The F2 unit factor cancels the codomain
   read's `unit_iso.symm` via `unit_conjugateEquiv_symm`, and the "through `(Spec φ)_*`" transport is a
   `conjugateEquiv_comp` (NOT a positional rewrite). This is the historical bottom of the term-mode route;
   isolating it as its own conjugate-side claim is the whole point. `\uses` Seam-1's `base_change_mate_unit_value`.
7. **conj-2e — assemble `_legs`.** `_legs` = `(conjugateEquiv …).injective` applied, closed by the reassoc
   conjugate simp set (`conjugateEquiv_comp`/`_symm_comp`/`_whiskerLeft`/`_whiskerRight`/`_associator_hom`)
   + 4,5,6. `\uses` 2,3,4,5,6.

Then `gstar_transpose` cascades off `_legs` by the same mechanism — note this in the chapter but do NOT
break it further this pass (it is a separate target).

## Constraints
- Do NOT add `\leanok`. `\mathlibok` only on genuine Mathlib anchors (`leftAdjointCompIso`,
  `conjugateEquiv_*` from Mates.lean) if not already anchored by the FBC coverage writer this iter.
- Do NOT modify the existing `_legs`/`gstar_transpose`/affine proof bodies in Lean (you write blueprint only).
- The FBC coverage writer ran first this iter and added the conj-0 blocks + cleaned stale `_link_*` pins;
  build your chain on top of `pullbackComp_eq_leftAdjointCompIso`. Grep to confirm its exact label before wiring.
- If a needed conjugate lemma genuinely has no Mathlib/project home, flag it under "Could not complete"
  rather than inventing a label — that becomes a strategy item.
- Minor: the chapter has an ISOLATED `\mathlibok` anchor `lem:iterated_mateEquiv_conjugateEquiv_mathlib`
  (`CategoryTheory.iterated_mateEquiv_conjugateEquiv`, the Beck–Chevalley "iterated mate = conjugate"
  principle). If your conjugate chain naturally consumes it (it is the abstract certificate that the
  comparison is a conjugate), wire it into the relevant sub-lemma's `\uses{}` so it stops being isolated.
