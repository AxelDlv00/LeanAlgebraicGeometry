# lean-vs-blueprint-checker — FlatteningStratification

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex

Focus on the 3 GF-G1 base-case decls added this iter (~L2273-2328):
- gf_affine_qcoh_Gamma_epi (seam 2) vs lem:gf_affine_qcoh_Gamma_epi
- gf_qcoh_finite_sections_globally_generated (seam 3) vs lem:gf_qcoh_finite_sections_globally_generated
- gf_qcoh_finite_sections_of_free_epi — NEW helper, no blueprint block (coverage debt; suggest pin)
Verify statements match blueprint (hypotheses, conclusion). Confirm lem:gf_finiteType_affine_finite_cover_generated (seam 1) and lem:gf_qcoh_fintype_finite_sections (G1 assembly) are correctly UNformalized (decls absent — blocked). Is the chapter detailed enough for these seams?
