# Mathlib Analogist: snap-gcomm
**Mode:** api-alignment | **Iter:** 080

## Verdicts
- **`sectionsMul_assoc_unit` type**: ALIGN_WITH_MATHLIB (must-fix; this is what killed `snap-coherent`).
  It is NOT a single `GradedMonoid`-level Eq and NOT a raw `HEq`. It is the FOUR **`cast`-mediated
  component-level `Eq`s** mirroring `TensorPower.{one_mul,mul_one,mul_assoc}` (+ `mul_comm`):
  `sectionsCast L (add_assoc ..) (mul (mul a b) c) = mul a (mul b c)` etc., where `sectionsCast h`
  is the index-equality transport (Γ of `eqToIso (congrArg (tensorPow L) h)`). On ℕ `(i+j)+k ≠defeq i+(j+k)`,
  so the cast moves both sides into ONE module → honest `Eq`, provable by reduction to the strict-monoidal
  presheaf top-open. Cite: `Mathlib.LinearAlgebra.TensorPower.Basic:147,159,169`.
- **GMonoid/GSemiring/GCommSemiring assembly**: ALIGN_WITH_MATHLIB. Mirror `TensorPower.Basic:193-234`
  field-for-field. Sigma-Eq fields discharged by a project-local bridge
  `gradedMonoid_eq_of_cast (h) (cast-Eq)` (TensorPower's is reindex-specific; project's is a 1-line
  `cases h; simp` since `sectionsCast` is `eqToHom`-transport). `gnpow`/`gnpow_zero'`/`gnpow_succ'`
  use DEFAULTS — OMIT (TensorPower does). Bilinearity (`mul_zero/zero_mul/mul_add/add_mul`) is FREE
  from linearity of `Γ(μ)∘sectionsMul`. `natCast := n ↦ n • GOne.one`. `GCommSemiring` adds only
  `mul_comm := gradedMonoid_eq_of_cast (add_comm _ _) (sectionsMul_mul_comm _ _)`.
- **Which typeclass**: ALIGN — external `DirectSum.GSemiring → GCommSemiring`, and `DirectSum.Gmodule`
  for twisted sections (`GSMul.smul : A i → M j → M (i +ᵥ j)`, `+ᵥ`=`+` on ℕ; sigma-Eq fields via the
  same `gradedMonoid_eq_of_cast` idiom, precedent `GradedMonoid.GMulAction`). Do NOT use
  `DirectSum.toSemiring`/`GradedAlgebra`/`HomogeneousLocalization` — those are INTERNAL (submodule)
  gradings; the section pieces are external standalone modules.

## Key signatures (full code in analogies/snap-gcomm.md)
- `sectionDeg L m := ↥((tensorPow L m).val.obj (op ⊤))` (the ℕ-graded carrier family).
- `sectionsCast L (h : i = j) : sectionDeg L i ≃ₗ[Γ𝒪] sectionDeg L j` — the ONLY new brick (Γ of eqToIso).
- `sectionsMul_assoc_unit` ≡ `sectionsMul_{one_mul,mul_one,mul_assoc,mul_comm}` (4 cast-mediated Eqs).
- `gradedMonoid_eq_of_cast` — trivial project-local bridge to the GMonoid sigma-Eq fields.

## Persistent file
- `analogies/snap-gcomm.md` written (concrete signatures + field-by-field mapping with citations).

Overall verdict: ALIGN_WITH_MATHLIB — mirror `TensorPower.Basic` verbatim; state `sectionsMul_assoc_unit`
as `cast`-mediated component Eqs, not a sigma Eq / HEq.
