# Lean ↔ Blueprint Checker Directive

## Slug
differentials-iter113

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Differentials.tex

## Known issues
- The iter-112 review-phase checker (`lean-vs-blueprint-checker-differentials-iter112`)
  flagged three must-fix signature mismatches: `smooth_iff_locally_free_omega`
  (L816, free `n : ℕ`), `cotangent_at_section` (L832, same), and
  `serre_duality_genus` (L976, `H^0 = H^0`). These were **all fixed THIS
  iter** via the `refactor-differentials-signatures-iter113` dispatch in
  the plan phase. Do not re-flag them as must-fix unless the refactor
  is itself defective.
- The 5 sorry sites are named-deferred per prior iters; no need to
  re-flag.
- The iter-113 prover round (a) closed helper #1's body
  (`relativeDifferentialsPresheaf_isSheafOpensLeCover_type`, L209) via
  the Mathlib chain `isSheaf_of_isSheafUniqueGluing_types →
  IsSheaf.isSheafOpensLeCover` and (b) introduced a NEW top-level
  helper `relativeDifferentialsPresheaf_isSheafUniqueGluing_type`
  (L168) carrying the residual sorry.
- The new helper is documented with an iter-114+ recipe in its
  docstring (universal property of `KaehlerDifferential` +
  `span_range_derivation` + structure-sheaf gluing).

## Specific questions for this iter
1. The new helper `_isSheafUniqueGluing_type` (L168) has signature
   `TopCat.Presheaf.IsSheafUniqueGluing ((relativeDifferentialsPresheaf f).presheaf ⋙ forget AddCommGrpCat)`.
   The blueprint chapter L33–53 lays out the proof as a 3-step recipe
   that pins **Route (a)** through `IsSheafOpensLeCover` and explicitly
   notes at L53 that "the previous draft cited
   `TopCat.Presheaf.IsSheaf.isSheafUniqueGluing` as a basis-to-opens
   hook; that direction is wrong". The iter-113 prover routes through
   the UniqueGluing form in the OTHER direction (UniqueGluing →
   IsSheaf → IsSheafOpensLeCover, all framework Mathlib lemmas, no
   wrong direction). Is the chapter prose still consistent with the
   Lean's new shape, or does it need an update?

2. Is the chapter's `[gap]` callout at L51 (no off-the-shelf
   "sheaf-on-affine-basis ⇒ sheaf" lemma for Scheme.PresheafOfModules)
   still load-bearing now that the Lean has pivoted to the
   unique-gluing form?

3. Does the 3 refactored signatures (L818, L835, L976–982 — see
   plan.md) now match the blueprint prose at L189 (smooth iff Ω
   locally free), L213 (cotangent_at_section), L260 (Serre duality
   genus)? Spot-check each.

Report destination: `task_results/lean-vs-blueprint-checker-differentials-iter113.md`
