# Blueprint Reviewer Directive

## Slug
iter113

## Strategy snapshot

The project formalizes the Jacobian of a smooth proper geometrically irreducible
curve over a field, per Christian Merten's challenge file
(`references/challenge.lean`). The 9 protected declarations
(`archon-protected.yaml`: `AlgebraicGeometry.genus`, the 5 `Jacobian.*`
signatures, and 3 `AbelJacobi.*` signatures) are the deliverables. The
end-state ships the protected chain modulo **1 load-bearing named gap**
(`nonempty_jacobianWitness`, Hilbert/Quot schemes Mathlib gap) and ships
**6 orphan-disclosure named gaps + 1 budget-deferral** as blueprint-content
commitments not required for the protected chain.

Active work this iter (iter-113):

- Phase B prover work on `Differentials.lean`. The iter-112 prover round
  hit Bar B on L122 `relativeDifferentialsPresheaf_isSheaf`: the main
  theorem body is now fully closed, but the residual sorry was moved
  into a new load-bearing helper
  `relativeDifferentialsPresheaf_isSheafOpensLeCover_type` (now L159,
  body sorry at L177). Iter-113 prover lane is on **closing helper #1**
  (Bar A — file sorry 5 → 4).
- **Iter-112 review surfaced 3 pre-existing must-fix signature
  mismatches** in Differentials.lean (smooth_iff_locally_free_omega L816,
  cotangent_at_section L832, serre_duality_genus L976). The review agent
  applied `% NOTE:` annotations to the corresponding blueprint blocks in
  `Differentials.tex`. The iter-113 plan is to dispatch a **refactor
  lane** to align the Lean signatures with the blueprint prose before
  any future prover work on those targets.
- Phase A (`BasicOpenCech.lean`) is PAUSED. Picard arc (`LineBundle.lean`,
  `Picard/Functor.lean`, `Modules/Monoidal.lean`) carries named-deferred
  Mathlib-gap sorries. `Jacobian.lean:179` carries the C3-exit-policy
  witness sorry.

## Routes

Single route per phase. Iter-113 active route is the L122 helper #1
closure on `Differentials.lean` plus the 3-signature-mismatch refactor.

## References

`references/summary.md` lists only `challenge.lean` (the formal
statement file). Read it if you need to confirm a protected signature
shape; otherwise rely on the blueprint chapter content.

## Specific concerns

1. **`Differentials.tex` adequacy for the helper #1 closure round**:
   the chapter's `\thm:relative_kaehler_isSheaf` block was rewritten
   iter-111 with all `[verified]` Mathlib names + 1 honest `[gap]` for
   the basis-to-opens descent. Iter-112 prover landed Bar B against
   this. **For iter-113, the chapter must give the prover enough detail
   on the basis-to-opens descent (Route (a) refinement-cofinality)**:
   - Sub-lemma A: affine restriction of the type-valued presheaf to
     the tilde quasi-coherent sheaf (via
     `KaehlerDifferential.isLocalizedModule_map` +
     `IsAffineOpen.isLocalization_basicOpen`).
   - Sub-lemma B: sheaf-on-affine-basis ⇒ sheaf via the cofinality of
     the affine-basis refinement in `OpensLeCover`.
   Check whether the chapter's Step 2 + Step 3 prose provides enough
   structure for the prover to formalize each sub-lemma without
   guessing.

2. **`Differentials.tex` % NOTE annotations**: the review-iter-112
   added 3 `% NOTE:` annotations flagging the signature mismatches.
   Confirm these are well-placed and that the prose itself remains
   correct (the prose names `IsSmoothOfRelativeDimension n f` and
   `H^0(Ω_{C/k}) = H^1(O_C)` — these are the corrections the refactor
   will apply to the Lean side).

3. **All other chapters**: standard cross-chapter audit. The
   `Cohomology_MayerVietoris.tex` had a stale gap-list at L1198
   fixed iter-112; confirm it's clean now.

## Prior critique status

Iter-112 reviewer reported:

- `Differentials.tex`: `complete: true × correct: true` (GREEN for L122
  dispatch).
- `Cohomology_MayerVietoris.tex`: 1 must-fix at L1198 (stale 6-entry
  gap-list missing `serre_duality_genus`) — **fixed iter-112 by
  blueprint-writer-mv-iter112**.
- 12 other chapters: clean.

Re-verify the iter-112 fixes landed and re-audit all chapters.
