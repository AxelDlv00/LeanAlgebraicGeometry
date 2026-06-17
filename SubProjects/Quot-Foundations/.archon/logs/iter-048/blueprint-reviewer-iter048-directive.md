# Blueprint-reviewer directive — iter-048

Whole-blueprint audit (all chapters; the cross-chapter view is the point). Per-chapter completeness + correctness checklist + HARD-GATE verdicts.

## Focus this iter (do not scope-limit; just prioritize)
1. `Picard_SectionGradedRing.tex` — `def:sectionMul` (`sectionsMul`) is this iter's prover target: confirm its block is complete+correct (statement + proof sketch detailed enough to formalize the lax-Γ section multiplication). Also flag the `lem:sheafTensorPow_add` / associator block: the iter-047 prover proved it needs the Mathlib-absent sheaf-level associator (strong-monoidality of module sheafification), which the current proof sketch glosses ("preserved by sheafification"). It is being effort-broken this iter — note whether the current block adequately sets up that decomposition.
2. `Picard_FlatteningStratification.tex` — seam-1 `lem:gf_finiteType_affine_finite_cover_generated` is being effort-broken this iter (3 primitives). G3 `lem:gf_flat_locality_assembly` was flagged thin (must-fix-1 iter-047) — re-check whether it still needs expansion now that G1 is partial. Also: lean-vs-blueprint iter-047 flagged the `\lean{}` pin on `lem:gf_qcoh_finite_sections_globally_generated` as mislabelled (Lean is more general than prose; the free-epi helper `gf_qcoh_finite_sections_of_free_epi` is unpinned).
3. Coverage debt: 11 unmatched Lean decls (10 SNAP layer-1 helpers + GF free-epi). Being added this iter — confirm which need real blueprint blocks vs `private`.

## Output
Per-chapter checklist (complete?/correct? + must-fix-this-iter). HARD-GATE verdict for `Picard_SectionGradedRing.tex` and `Picard_FlatteningStratification.tex` specifically. List any unstarted-phase blueprint proposals.
