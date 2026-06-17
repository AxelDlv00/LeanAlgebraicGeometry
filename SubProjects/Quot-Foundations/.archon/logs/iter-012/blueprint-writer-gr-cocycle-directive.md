# Blueprint-writer — pin `lem:gr_cocycle` signature + fix the isolated anchor

Chapter: `blueprint/src/chapters/Picard_GrassmannianCells.tex`. You edit ONLY this chapter.

## Strategy context (the slice that matters)

The Grassmannian-over-ℤ is built by gluing affine big cells `U^I` along transition maps `θ_{I,J}`.
The full transition chain `universalMatrix → … → transitionMap` (`def:gr_transition`) + the diagonal
`transitionMap_self` (`lem:gr_transition_self`) are FORMALIZED axiom-clean in
`AlgebraicJacobian/Picard/GrassmannianCells.lean`. The next leaf is the **cocycle condition**
`lem:gr_cocycle` (`AlgebraicGeometry.Grassmannian.cocycleCondition`) — the compatibility datum that
lets the charts glue. Its block (≈ line 478) has a full statement, source quote (Nitsure §1), and a
correct matrix-computation proof sketch, but **NO `% LEAN SIGNATURE`** — so a prover cannot determine
the exact Lean type. This is the HARD-GATE blocker (blueprint-reviewer iter-012, F-4a).

## Required edit 1 (must-fix F-4a): author the `% LEAN SIGNATURE` for `lem:gr_cocycle`

Add a `% LEAN SIGNATURE (intended scaffold target).` comment block to the `lem:gr_cocycle`
statement, in the same style as the other GR blocks (e.g. `def:gr_transition`, `lem:gr_transition_self`),
pinning the exact ring-hom identity. To pin it FAITHFULLY, read the existing landed Lean decls in
`AlgebraicJacobian/Picard/GrassmannianCells.lean` (you may read Lean; you write only the blueprint):
- `transitionMap d r I J hI hJ : Localization.Away (minorDet d r I J hI hJ) →+* Localization.Away (minorDet d r J I hJ hI)` (CHECK the actual codomain ring direction in the source — read the decl).
- `transitionMap_self d r I hI : transitionMap d r I I hI hI = RingHom.id _`.
- The Mathlib lift used is `IsLocalization.Away.lift`.

The cocycle identity is, for three `d`-subsets `I, J, K` of `Fin r` (with `card = d` hyps), the
composition of transition ring-homs over the relevant `Localization.Away (minorDet …)` rings:
`θ_{I,K} = θ_{I,J} ∘ θ_{J,K}` as ring homs (equivalently `θ_{J,K} ∘ θ_{I,J}` on schemes — the
Spec order-reversal; STATE WHICH composition direction the Lean target uses and make it match how
`transitionMap`'s domain/codomain are oriented). Spell out, in the signature comment:
- the three cardinality hypotheses (`hI hJ hK : _.card = d`);
- the exact source and target localization rings of each `transitionMap` factor and how their
  codomains/domains line up for composition (the two `IsLocalization.Away.lift` codomains differ —
  say explicitly how they compose, e.g. via an intermediate doubly-localized ring or an algebra map);
- the conclusion as a propositional equality `RingHom`-level (`… = …`).

If composing the two `IsLocalization.Away.lift`s requires an auxiliary doubly-localized ring
`R^I[1/P^I_J, 1/P^I_K]` or an `algebraMap`, NAME that object in the signature so the prover knows the
intended formalization shape (the iter-011 prover flagged exactly this ambiguity). It is acceptable
to pin the conclusion over the chart ring on the triple-overlap open as the prose describes, but the
Lean type must be unambiguous.

## Required edit 2 (must-fix F-4b): fix the isolated `lem:mathlib_isUnit_iff_isUnit_det` anchor

The `\mathlibok` anchor `lem:mathlib_isUnit_iff_isUnit_det` (`Matrix.isUnit_iff_isUnit_det`, ≈ line 83)
is ISOLATED in the DAG (0 edges — used in no `\uses{}`). Read the Lean proofs of `lem:gr_minorDet_unit`
(`isUnit_det_universalMinor`) and `lem:gr_universalMinorInv_identities` (`universalMinorInv_mul_cancel`):
- If either Lean proof actually uses `Matrix.isUnit_iff_isUnit_det`, ADD `lem:mathlib_isUnit_iff_isUnit_det`
  to that lemma's `\uses{}`.
- If neither uses it, REMOVE the orphaned `\mathlibok` anchor block entirely.
(iter-011's stale `\uses` in `lem:gr_transition_pre_unit` is already resolved per the reviewer — the
only residual is this isolation.)

## Out of scope
- Do NOT touch `def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper` (downstream of cocycle).
- Do NOT add `\leanok` anywhere (the deterministic sync owns it).
- Do NOT author blueprint blocks for the GR helper lean_aux nodes (deferred; GR-repr is blocked).
- The cocycle PROOF sketch is already adequate — only ADD the `% LEAN SIGNATURE`; do not rewrite the
  proof unless the signature pin reveals a genuine mismatch with the sketch.

## Report
State the exact `% LEAN SIGNATURE` you pinned for `cocycleCondition` (composition direction + the
localization rings) and whether you wired-up or removed `lem:mathlib_isUnit_iff_isUnit_det`. Flag any
"Strategy-modifying finding" if the composition direction reveals a problem with `def:gr_transition`.
