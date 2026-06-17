Target: `AlgebraicJacobian/Picard/SectionGradedRing.lean`

Action: Scaffold the SNAP graded-ring bricks with `sorry` bodies (do NOT prove). The file currently
ends at `tensorPowAdd` (~L1785). Append these after it. The file is 0-real-sorry → without stubs the
prover noop-drops; your stubs give it real sorries.

Source of truth — TWO files, read both:
- `analogies/snap-gcomm.md` — has the CONCRETE signatures (Recommendation section, L83–117): `sectionsCast`,
  `sectionsCast_refl`, and the 4 split coherence lemmas `sectionsMul_{one_mul,mul_one,mul_assoc,mul_comm}`,
  plus the GMonoid→GSemiring→GCommSemiring→Gmodule chain (gnpow DEFAULTED, mirror `TensorPower.Basic`).
- `blueprint/src/chapters/Picard_SectionGradedRing.tex` (L1299–1478) — `def:sectionsCast`,
  `lem:sectionsCast_refl`, `lem:gradedMonoid_eq_of_cast`, `lem:sectionMul_coherent` (the 4 Eqs).

Scaffold these decls (names from blueprint `\lean{}` pins, all in namespace
`AlgebraicGeometry.Scheme.Modules`):
1. `sectionsCast` (def) — Γ-image of the tensor-power index-cast iso; `≃ₗ[Γ𝒪]` per analogies L93.
2. `sectionsCast_refl` (@[simp] lemma) — refl case = identity.
3. `gradedMonoid_eq_of_cast` (lemma) — cast-mediated dependent-pair equality bridge (TensorPower.Basic L123 analogue).
4. `sectionsMul_one_mul`, `sectionsMul_mul_one`, `sectionsMul_mul_assoc`, `sectionsMul_mul_comm` (4 lemmas)
   — the cast-mediated coherence Eqs, signatures verbatim from analogies L106–117.

Strategy comment (inject `/- Planner strategy: -/` above the block): these are the bottom bricks of the
graded-ring assembly. The prover (mathlib-build mode) will prove them THEN build
`sectionGradedRing_gcommSemiring`/`sectionGradedModule_gmodule` instances on top — so leave the instance
defs UNSCAFFOLDED (the mathlib-build prover creates them). Pattern: field-for-field port of
`Mathlib.LinearAlgebra.TensorPower.Basic` (GradedMonoid.GMonoid → DirectSum.GSemiring →
DirectSum.GCommSemiring; separate DirectSum.Gmodule), with `sectionsCast` in place of `TensorPower.cast`
and `gradedMonoid_eq_of_cast` producing the GMonoid sigma-Eq fields. Crux inputs `tensorObjAssoc`,
`tensorPowAdd` are DONE/\leanok above in this file.

Constraints: `sorry` bodies only, no proofs. Carrier is value-`AddCommGrpCat` (see ARCHON_MEMORY); spell
tensor objects `MonoidalCategory.tensorObj (C := MonoidalPresheaf X) P Q` if needed. Verify signatures
typecheck against `tensorPowAdd`/`tensorObjAssoc` and `DirectSum.GCommSemiring`/`Gmodule` field shapes
via lean search. Do NOT edit any other file.
