# Blueprint review directive — iter-029 (HARD GATE for the 02KG affine lane)

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`) per your standard per-chapter
completeness + correctness checklist. This is the HARD GATE before a prover is dispatched at the
NEW file `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`.

Focus this iter (but still review the whole blueprint):
- `Cohomology_CechHigherDirectImage.tex` was substantially edited this iter:
  (1) `def:basis_cov_system` reconciled to the real 5-field Lean structure (B, Cov, faces_mem,
      surj_of_vanishing, injective_acyclic); `[EnoughInjectives X.Modules]` disclosure added to
      `lem:absolute_cohomology_pos_vanishing`, `lem:cech_to_cohomology_on_basis`,
      `lem:affine_serre_vanishing`; coverage-debt `\lean{}` pins bundled (CovDatum, sectionsFunctor,
      injSES/injSES_shortExact); dead `CechAcyclic.affine` de-pinned from `lem:cech_acyclic_affine`.
  (2) `lem:affine_serre_vanishing` (Tag 02KG Serre vanishing on affines) decomposed into an 8-block
      `\uses`-chain (scaffold targets in the planned `AffineSerreVanishing.lean`):
      `def:affine_cover_system`, `lem:affine_faces_mem`, `lem:standard_cover_cofinal`,
      `lem:affine_surj_of_vanishing`, `lem:cover_datum_bridge`, `lem:affine_injective_acyclic`,
      `lem:qcoh_iso_tilde_sections`, `lem:affine_cech_vanishing_qcoh`.

Decide, per chapter, `complete: true|false · correct: true|false` and list any must-fix-this-iter
findings. The critical question for the gate: are the eight new 02KG sub-lemmas (and the top
`lem:affine_serre_vanishing`) FORMALIZE-READY — statements well-formed, signatures faithful to the
math, `\uses{}` accurate and acyclic, source quotes verbatim, informal proofs detailed enough that a
prover can build them piece by piece? Flag any block whose proof sketch is too thin, whose Lean
target signature would be false-as-stated, or whose source citation is missing/paraphrased.
Also confirm the `def:basis_cov_system` prose now matches the Lean encoding.

Write your per-chapter checklist and severity summary to your task_results report.
