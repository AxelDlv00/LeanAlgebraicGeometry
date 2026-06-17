# lean-vs-blueprint-checker coe-iter201 directive

## Scope

Bidirectional verification:

- Lean: `AlgebraicJacobian/Albanese/CodimOneExtension.lean`
- Blueprint: `blueprint/src/chapters/Albanese_CodimOneExtension.tex`

## What to check

1. **Lean → blueprint**: iter-201 added 3 new `private` theorems in
   `namespace AlgebraicGeometry.Scheme`:
   - `submersivePresentation_relation_cotangent_mk_linearIndependent`
   - `submersivePresentation_relation_cotangent_mk_linearIndependent_localized`
   - `ringKrullDim_quotient_localization_MvPolynomial_of_regular`

   The chapter has `\subsec:stage6_iib_substrate_iter200` for the
   iter-200 7-decl substrate batch. Determine whether the chapter's
   Stage 6.B narrative should be expanded to mention the new
   iter-201 Step A2 substrate sub-pieces (no `\lean{...}` pin
   expected — they are `private`).

2. **Blueprint → Lean**: every `\lean{...}` pin resolves to an
   existing project declaration. In particular
   `lem:smooth_to_regular_local_ring` →
   `AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth`
   (L1061 sorry remains).

3. **Recipe vs implementation**: the chapter's Jacobian-witness
   recipe (`coe-stacks00sw` analogist 3-step A1+A2+A3 chain) names
   `IsRegularLocalRing → IsDomain` (Stacks 00NQ) as substrate for
   Step A1. The prover task report (see
   `task_results/AlgebraicJacobian_Albanese_CodimOneExtension.lean.md`)
   confirms Mathlib b80f227 lacks `IsRegularLocalRing → IsDomain`
   AND the `A / (f₁)` regular-local-ring-of-dim-(n-1) bridge AND
   `IsRegularLocalRing.localization`. Flag whether the chapter
   prose acknowledges these Mathlib gaps as the iter-201 binding
   blocker.

4. **Severity tags**: `must-fix-this-iter`, or `soon`.

## Output

Per-file report. Write to
`task_results/lean-vs-blueprint-checker-coe-iter201.md`.
