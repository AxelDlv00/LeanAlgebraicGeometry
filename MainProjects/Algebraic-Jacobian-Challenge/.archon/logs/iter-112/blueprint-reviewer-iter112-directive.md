# Blueprint Reviewer Directive

## Slug
iter112

## Strategy snapshot

The project formalizes the Jacobian of a smooth proper geometrically irreducible curve over a field, following Christian Merten's challenge. The 9 protected declarations (`Jacobian`, `Jacobian.ofCurve`, `Jacobian.instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`, `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp`, `genus`) are the deliverables.

End-state framing: **7 named Mathlib-gap sorries + 1 budget-deferral** on `BasicOpenCech.lean` L1846, total 16 sorries unchanged across the project. C1 promotion of `LineBundle` complete iter-109. Phase A (BasicOpenCech) DEFERRED (gated). **Phase B (Differentials) is the active prover phase**: L122 `relativeDifferentialsPresheaf_isSheaf` is the iter-112 candidate target; L718, L735 are the other two prover-viable Phase B sorries; L636 + L877 are off-limits (named gaps). Phase C2 verification round pending (cheap intel). Phase C3 deferred via JacobianWitness exit policy.

Iter-111 blueprint-writer-differentials-iter111 rewrote `\thm:relative_kaehler_isSheaf` proof block in `Differentials.tex` (L28-53): all Mathlib names `[verified]` + 1 honest `[gap]` for basis-to-opens descent (Routes (a) refinement-cofinality / (b) explicit gluing both documented).

## Routes

Multi-route handling is INTERNAL to one sorry (L122 basis-to-opens descent has Route (a) and Route (b)); both documented in chapter. Otherwise single-route per file.

## References
- `references/challenge.lean`: Original challenge — authoritative signatures.
- `analogies/c1-route.md`: C1 promotion rationale (LineBundle).
- `analogies/serre-duality.md`: L877 named-gap rationale.
- `analogies/finite-product-localisation-and-cech-r-linearity.md`: Phase A PAUSED context.

## Focus areas (optional)

- `Differentials.tex` — the iter-111 writer rewrote `\thm:relative_kaehler_isSheaf` proof block. Confirm this chapter is now `complete: true` AND `correct: true` for iter-112 L122 prover dispatch. **The HARD GATE on this chapter is the iter-112 critical gate.**
- `Modules_Monoidal.tex` — informational line-ref drift between `L166` (declaration) and `L173` (sorry) was flagged iter-111 across multiple chapters; check whether the iter-111 writer cleared this in any chapter touched.

## Known issues

- BasicOpenCech.lean is OFF-LIMITS (Phase A deferred); no prover work scheduled on its chapter this iter.
- LineBundle.lean L82 + L96 are OFF-LIMITS (named Mathlib gaps #5/#6); no prover work scheduled on its chapter this iter.
- Phase C3 deferred (Jacobian.lean L179 named gap #3, Picard/Functor.lean L181 named gap #4).
- The named-gap roster of 7 + 1 budget-deferral is stable; flag any chapter whose `\lean{...}` hint contradicts this roster.
