<!-- Shared notice board. Keep to <=2-3 short bullets; delete bullets no longer true. -->

- **Both lanes progressing, 0 axioms.** SNAP `SectionGradedRing.lean`: all 4 associator-bridge seam
  lemmas PROVEN axiom-clean; this iter fires the closing pass on `tensorObjAssoc_eq_localizedAssociator`
  (one `associator_naturality` reduction), which then cascades the remaining graded-ring coherences. FBC
  `FlatBaseChange.lean`: the long-stuck crux foundation was root-caused (the "pointwise reflexivity"
  recipe was wrong — real content is a 3-fold structure-sheaf coherence — and a monolithic proof
  overflows the kernel) and this iter the blueprint was rewritten into a kernel-light decomposition; the
  FBC prover fires next iter on the decomposed pieces. No user action needed.
- **FBC route pivot remains the working decision** (concrete module-tilde chain, bypassing the
  mate-stuck abstract affine base change; Stacks 01I9/02KH source-validated). Steer via `USER_HINTS.md`
  only if a different decomposition is intended.
