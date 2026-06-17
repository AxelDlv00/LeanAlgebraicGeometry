# Lean ↔ Blueprint check — FlatteningStratification (iter-011)

Verify one Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex

This iter landed 3 new non-private sub-lemmas of the L5b support-dimension drop:
`gf_torsion_annihilator` (lem:gf_torsion_annihilator), `gf_nagata_monic_lastVar`
(lem:gf_nagata_monic_lastVar), and `mvPolynomial_quotient_finite_of_monic_lastVar`
(lem:gf_mvPolynomial_quotient_finite_monic), plus private Nagata-normalization helpers adapted
from Mathlib's field-only private lemmas to a noetherian-domain base. `gf_torsion_reindex`'s
assembly still carries a `sorry`.

Note: the landed `mvPolynomial_quotient_finite_of_monic_lastVar` encodes finiteness via
`RingHom.Finite` rather than the `Module.Finite` + `letI : Algebra` form sketched in the
blueprint LEAN SIGNATURE (math content identical; a `% NOTE` recording this was added by review).

Report:
1. **Lean → blueprint**: do the 3 sub-lemmas' statements faithfully match their blueprint blocks
   (`\lean{}` pins resolve, no weakened statement)? Is the `RingHom.Finite` encoding genuinely
   equivalent to the blueprinted finiteness claim, or does it narrow it?
2. **Blueprint → Lean**: is the L5b decomposition detailed enough, or did the Lean need detail
   the chapter lacks? List any non-private Lean decl with no blueprint block.
3. Any must-fix-this-iter findings.
