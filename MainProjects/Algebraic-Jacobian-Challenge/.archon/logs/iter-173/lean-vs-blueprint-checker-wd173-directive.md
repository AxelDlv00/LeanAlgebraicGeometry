# Lean ↔ Blueprint Checker — RiemannRoch/WeilDivisor.lean × RiemannRoch_WeilDivisor.tex

## Slug
wd173

## Iteration
173

## File pair

- Lean: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- Blueprint: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`

## Iter-173 prover edits

- `Scheme.PrimeDivisor` (L93–L98) — REFACTORED axiom-clean (placeholder `isCodim1AndIntegral : True := trivial` replaced with `coheight : Order.coheight point = 1`).
- `Scheme.WeilDivisor.degree_hom` (L207–L208) — CLOSED axiom-clean (`Finsupp.liftAddHom (fun _ ↦ AddMonoidHom.id ℤ)`).
- `Scheme.WeilDivisor.degree_hom_apply` (L210–L213) — NEW `@[simp]` lemma (axiom-clean).

5 sorries remain (NOT ATTEMPTED iter-173, gated):
- `RationalMap.order` (L141)
- `WeilDivisor.ofClosedPoint` (L171)
- `WeilDivisor.principal` (L233)
- `WeilDivisor.principal_hom` (L248)
- `WeilDivisor.principal_degree_zero` (L269)

## Verification questions

1. **Lean → Blueprint**: Does the refactored `Scheme.PrimeDivisor` structure match the chapter's `def:prime_divisor` block? The blueprint-writer (iter-173 `wd-spec-refine`) added a new `def:prime_divisor` pin recommending `Order.coheight point = 1`. Confirm exact match (including the order of fields).
2. **Blueprint → Lean**: The iter-173 blueprint-reviewer `route173` flagged the chapter as under-specifying (i) prime-divisor data and (ii) hypothesis sets on `degree`, `principal`, `ofClosedPoint`. Does the refactor close (i)? Is (ii) still open for `ofClosedPoint` (L171) — i.e. does the chapter clearly specify the `_hP : IsClosed ({P} : Set C)` shape?
3. Does the NEW `degree_hom_apply` `@[simp]` lemma need a chapter pin, or is it acceptable as a downstream-helper-only declaration?
4. The umbrella `AlgebraicJacobian.lean` does not reference WeilDivisor explicitly via a `\lean{...}` — confirm the file's umbrella import is still correct.

## Output

`task_results/lean-vs-blueprint-checker-wd173.md`
