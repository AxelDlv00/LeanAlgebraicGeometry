# Blueprint-reviewer directive — iter-044 (full audit)

Audit the WHOLE blueprint per your standard per-chapter checklist (complete? correct? Lean targets
well-formed? `\uses` accurate?).

## HARD-GATE chapters feeding live prover lanes this iter (report complete/correct + any must-fix)
1. `Picard_QuotScheme.tex` — gap2 Piece A was just decomposed into a route-1 `\uses`-chain of 6 new
   project sub-lemmas (L1 `over_restrict_unit_iso_inv` → L6 `isQuasicoherent_pullback_of_isOpenImmersion`)
   + 2 Mathlib anchors, feeding `lem:qcoh_pullback_fromSpec`. Also a new bridge block
   `lem:isLocalizedModule_basicOpen_of_hP1`. Confirm the chain is mathematically complete and each new
   block is formalizable (signature realistic, `\uses` accurate).
2. `Cohomology_FlatBaseChange.tex` — the keystone `lem:base_change_mate_fstar_reindex_legs_conj` is the
   target of an FBC mathlib-build lane this iter via the factored `conjugateEquiv_symm_comp` route. Confirm
   its block + the three legs (conj-2b/2c/2d) + the cited Mathlib conjugate lemmas are coherent and the
   proof sketch is a faithful, formalizable recipe (no false/placeholder statements).

Report per-chapter verdicts; flag any must-fix-this-iter that would block a prover on the two chapters above.
