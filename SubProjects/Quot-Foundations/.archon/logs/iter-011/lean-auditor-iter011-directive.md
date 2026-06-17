# Lean Auditor — iter-011

Audit the four `.lean` files that received prover work this iteration. Read them as Lean,
with no bias toward what any strategy or blueprint claims should be true. Flag: outdated /
misleading comments, suspect or weakened definitions, fake/placeholder statements dressed as
real, dead-end proofs, `sorry` whose surrounding docstring overclaims, bad Lean practices,
and any declaration whose stated type is trivially satisfiable (vacuous) or narrower than its
name implies.

## Files to read (absolute paths)

- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean

## Focus areas

- **GrassmannianCells.lean**: 16 new declarations landed this iter (universalMatrix, minorDet,
  universalMinor, universalMinorInv, imageMatrix, transitionPreMap, transitionMap,
  transitionMap_self, plus minor/det helper lemmas), all reported axiom-clean and `sorry`-free.
  Scrutinize whether the statements are genuine (e.g. `transitionMap_self` really proves the
  identity, `isUnit_transitionPreMap_minorDet` is not vacuous, the Cramer-inverse construction
  is well-typed and not a degenerate placeholder).
- **FlatBaseChange.lean**: a route swap renamed `base_change_mate_generator_trace_eq` →
  `base_change_mate_section_identity` and rebuilt `base_change_mate_regroupEquiv` to be
  `sorry`-free via a pushout-cancellation. Check the renamed decl's statement is unchanged in
  substance and the remaining `sorry`s (section-identity crux, affine reduction, FBC-B) are
  honestly scoped, not overclaimed by their docstrings.
- **FlatteningStratification.lean**: 3 new non-private sub-lemmas (gf_torsion_annihilator,
  gf_nagata_monic_lastVar, mvPolynomial_quotient_finite_of_monic_lastVar) plus a block of
  private Nagata-normalization helpers transcribed/adapted from Mathlib's field-only private
  lemmas to a domain base. Verify the domain adaptation is sound (not silently assuming a field)
  and `gf_torsion_reindex`'s remaining `sorry` is honestly the assembly glue.
- **QuotScheme.lean**: 5 new decls (annihilator ideal sheaf def + ofIdeals-inclusion lemma +
  schematic-support / proper-support predicates). Check the predicates are non-vacuous and the
  4 remaining skeleton `sorry`s are not masquerading as proved.

Produce a per-file checklist plus a flagged-issues block (severity CRITICAL/HIGH/MEDIUM/LOW).
