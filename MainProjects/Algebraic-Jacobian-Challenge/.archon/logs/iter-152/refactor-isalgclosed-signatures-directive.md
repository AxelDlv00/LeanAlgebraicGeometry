# Refactor Directive

## Slug
isalgclosed-signatures

## Problem
A prover lane proved `AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
(in `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`) is mathematically FALSE as
currently stated: hypotheses `[Field k] [CharZero k] [Algebra.FiniteType k B]
[Algebra.IsStandardSmoothOfRelativeDimension n k B]` + `D b = 0` do NOT imply
`b ∈ (algebraMap k B).range`. Counterexamples: B = k×k (finite étale, n=0) and
B = ℚ(√2)/ℚ (finite separable, n=0) — both make Ω = 0 ⟹ D = 0 ⟹ hypothesis holds
for every b, yet `range(algebraMap) ⊊ B`. The missing content is "k algebraically
closed in B". The project has committed to proving rigidity over an algebraically
closed base field, so the fix is to add `[IsAlgClosed k]` + `[IsDomain B]` to this
lemma (and propagate the alg-closed setting to its siblings + the over-k̄ rigidity
statement). This is the executed corrective for a STUCK route; both the
strategy-critic (SOUND) and progress-critic (STUCK→pivot correct) endorse it.

You are doing the SIGNATURE SURGERY only. You do NOT fill proofs — leave `sorry`
at every body that becomes a genuine to-prove goal under the corrected signature.

## Mathematical Justification
Over an algebraically closed field k of characteristic 0, with B an integral
domain that is finite-type and standard-smooth over k:
- `[IsDomain B]` excludes the disconnected counterexample (B = k×k).
- `[IsAlgClosed k]` excludes the ℚ(√2)/ℚ counterexample (no proper finite field
  extension of k; and k is algebraically closed in Frac(B) for a geometrically
  integral B, so the field of constants ker(d_{Frac B / k}) = k in char 0).
Jointly the corrected statement is TRUE. The previously-closed FREE-CASE helpers
`_mvPoly_*`, the `SubmersivePresentation` lift, and the `KaehlerDifferential.map_D`
functoriality remain valid and should be PRESERVED in the body (they compile and
are reusable); only the residual transfer `sorry` remains — now a genuine
to-prove goal, not a false one.

Under `[IsAlgClosed k]`, `constants_integral_over_base_field` collapses: Γ(X,O_X)
is a finite (integral) field extension of k, and
`IsAlgClosed.algebraMap_bijective_of_isIntegral`
(`Mathlib.FieldTheory.IsAlgClosed.Basic`, verified to exist) gives surjectivity.
So its body no longer needs the four (S3.*) lemmas from `ChartAlgebraS3.lean`.
Leave its body as `sorry` (the ~15-LOC alg-closed proof is for the prover).

The corrected blueprint prose is in `blueprint/src/chapters/RigidityKbar.tex`
(rewritten this iter); read it for the intended structure.

## Changes Requested

- File: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
  - Decl: `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
    - Old binders: `{k : Type u} [Field k] [CharZero k] {B : Type u} [CommRing B]
      [Algebra k B] [Algebra.FiniteType k B] {n : ℕ}
      [Algebra.IsStandardSmoothOfRelativeDimension n k B] {b : B} (hDb : … = 0)`
    - New binders: ADD `[IsAlgClosed k]` (right after `[Field k]`) and
      `[IsDomain B]` (right after `[CommRing B]`). Everything else unchanged.
    - Body: keep the (C.a)–(C.c) scaffold; KEEP the final `sorry`. Replace the
      long "iter-151 FINDING: THE LEMMA IS FALSE AS STATED" comment block with a
      concise comment: the lemma is now TRUE under `[IsAlgClosed k]`+`[IsDomain B]`;
      the residual `sorry` is the genuine constants-of-derivation transfer step
      (ker d_{Frac B/k} = k for a char-0 geometrically-integral B over alg-closed
      k). Cite the two counterexamples + which hypothesis excludes each, so the
      geometric content is not silently re-lost.
  - Decl: `GrpObj.df_zero_factors_through_constant_on_chart`
    - ADD `[IsAlgClosed k]` and `[IsDomain B]` binders (same positions). Keep the
      existing scheme-level hypotheses on C. Body stays the one-line delegate
      `AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero (n := n) hDb`
      (now delegating to the corrected, true lemma — no longer launders a false
      statement).
  - Decl: `constants_integral_over_base_field`
    - ADD `[IsAlgClosed k]` binder (right after `[Field k] {X : Scheme.{u}}` →
      i.e. `{k : Type u} [Field k] [IsAlgClosed k] {X : Scheme.{u}} …`).
    - Body: the current proof consumes the four (S3.*) lemmas via the
      `have ⟨hPI, hSep⟩` block. REMOVE that (S3.*)-dependent reasoning and replace
      the whole proof body with `sorry` (the prover will fill the ~15-LOC
      alg-closed proof next iter via `IsAlgClosed.algebraMap_bijective_of_isIntegral`).
      Keep substeps (1)–(2) (`IsIntegral`, `isField_of_universallyClosed`,
      `finite_appTop_of_universallyClosed`) IF they still compile cleanly as a
      preamble; if they entangle with the removed block, it is fine to reduce the
      whole body to `sorry`. Goal: the file compiles with one clean `sorry` here.
    - This removes the only consumption of `ChartAlgebraS3.lean`'s (S3.*) lemmas.
      The `import AlgebraicJacobian.Cotangent.ChartAlgebraS3` may now be unused;
      LEAVE the import in place (ChartAlgebraS3.lean is retained as off-path
      scaffolding and removing the import is unnecessary churn).

- File: `AlgebraicJacobian/RigidityKbar.lean`
  - Decl: `rigidity_over_kbar`
    - Old: `variable {kbar : Type u} [Field kbar]` (the theorem uses this variable).
    - New: the theorem must carry `[IsAlgClosed kbar]` AND `[CharZero kbar]`. Add
      these either to the `variable` line or as explicit instance binders on the
      theorem — whichever keeps the existing body (`sorry`) compiling and does
      not add the hypotheses to OTHER declarations in the file that don't want
      them. Body stays `sorry`.

- File: `AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean`
  - NO changes. It is retained as off-critical-path scaffolding (its four (S3.*)
    lemmas keep their `sorry` bodies). Just confirm it still compiles after the
    `constants_integral_over_base_field` body change (it should — nothing in it
    depends on the consumer).

## Affected Files
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` (primary).
- `AlgebraicJacobian/RigidityKbar.lean`.
- Check (do not assume): does `AlgebraicJacobian/Jacobian.lean`'s
  `genusZeroWitness` body currently CALL `rigidity_over_kbar`? It is a `sorry`
  body, so it likely does not — but verify. If it does and adding `[IsAlgClosed
  kbar]` breaks it, insert `sorry` at the broken site (do NOT remove the
  hypothesis; the descent wiring is future prover work).

## Expected Outcome
- All touched files compile. `lean_diagnostic_messages` clean (only `sorry`
  warnings, no errors) on ChartAlgebra.lean, RigidityKbar.lean, ChartAlgebraS3.lean,
  and any importer.
- Sorry sites after the refactor (no NET change expected; the reduction is the
  next iter's prover work):
  - `ChartAlgebra.lean`: `mem_range_algebraMap_of_D_eq_zero` (now TRUE, residual
    transfer `sorry`); `constants_integral_over_base_field` (single clean `sorry`,
    alg-closed re-route target).
  - `RigidityKbar.lean`: `rigidity_over_kbar` (`sorry`, now with `[IsAlgClosed
    kbar]`+`[CharZero kbar]`).
  - `ChartAlgebraS3.lean`: four (S3.*) `sorry`s unchanged (off-path).
- No new axioms. No protected signature changed (none of these four decls is in
  `archon-protected.yaml`; verify).
