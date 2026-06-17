# Mathlib Analogist Report

## Slug
cotangent-body-shape-iter131

## Iteration
131

## Question

(Q1) Does the iter-131 proposed `Classical.choose`-chain refactor of
`AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`
(`AlgebraicJacobian/Cotangent/GrpObj.lean:131-170`) fix the iter-130
structural-opacity defect, where the outer form
`Classical.choice (α := ModuleCat k) ⟨X⟩` hides the chart-base-changed
Kähler module from the deferred rank lemma?

(Q2) Should iter-131 instead pivot to Replacement (B′) chart-level
`m_V / m_V² = IsLocalRing.CotangentSpace (Γ(G, V))_p` (chart ring
localized at the prime corresponding to the identity-section image)?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Iter-130 body shape `Classical.choice (Nonempty.intro X)` is structurally defective for the rank-lemma consumer | ALIGN_WITH_MATHLIB | critical (shipped code) |
| 1. Iter-131 proposed `Classical.choose`-chain pure-term body is the correct fix | PROCEED | major (not yet shipped) |
| 2. Rank-lemma closure chain under refactored (B) body | PROCEED | informational |
| 3. Pivot to (B′) chart-level `m_V / m_V²` | DIVERGE_INTENTIONALLY (stay on B) | informational |

## Must-fix-this-iter

- **Iter-130 body of `cotangentSpaceAtIdentity` (`Cotangent/GrpObj.lean:131-170`) is
  structurally defective.** The outermost head symbol after
  elaboration is `Classical.choice` applied to a
  `Nonempty (ModuleCat k)`; this hides the explicit
  `(ModuleCat.extendScalars ψV.hom).obj (ModuleCat.of … Ω[…])`
  structure from kernel reduction (`Classical.choice` has no reduction
  rule beyond eta — verified at the toolchain source
  `Init/Classical.lean:19-32`). Downstream rank lemma
  `cotangentSpaceAtIdentity_finrank_eq` cannot consume the chart's
  Kähler module past `Nonempty (ModuleCat k)` against this body.

  **Refactor obligation**: rewrite as a pure-term `noncomputable def`
  with `let`-bound `Classical.choose` / `Classical.choose_spec`
  extractions for `U, V, e, hxV` and an explicit outer
  `(ModuleCat.extendScalars _).obj (ModuleCat.of _ Ω[_ ⁄ _])` form (see
  `analogies/cotangent-body-shape.md` § Recommendation for the
  concrete Lean shape). This is a single-file edit on
  `AlgebraicJacobian/Cotangent/GrpObj.lean` with no signature change
  and no new axioms.

## Major

- **Add an `cotangentSpaceAtIdentity_eq_extendScalars` bridge lemma**
  as a defensive companion to the refactored body. Body becomes
  `rfl`-closable if the def is a pure term. This protects downstream
  consumers (rank lemma, piece (i.b) shear-iso globalisation) from
  potential `unfold`-exposure brittleness on `let`-bound
  `Classical.choose` extractions. **Recommended but not strictly
  required** — pure-term body alone should suffice.

- **Rank-lemma closure chain (Wave 2 if budget remains)** is fully
  `[verified]` end-to-end under the refactored body — see Decision 2
  in `analogies/cotangent-body-shape.md`. Step 5
  (`Module.finrank_baseChange`, previously `[expected]` per iter-129
  analogist) is now exact-match `[verified]` at
  `Mathlib.LinearAlgebra.Dimension.Constructions`:

  ```
  Module.finrank R (TensorProduct S R M') = Module.finrank S M'
  ```

  applying with `S = Γ(G, V)`, `R = k`, `M' = Ω[Γ(G, V) ⁄ Γ(Spec k, U)]`.

## Informational

- **Reject Replacement (B′) chart-level `m_V / m_V²` for iter-131.**
  Reason: the iter-129 analogist identified the load-bearing [gap] for
  the stalk-side cotangent (Replacement (A)) as the "standard-smooth
  over field at a prime ⇒ `IsRegularLocalRing` of dim `n`" bridge,
  estimated at 500–1000 LOC. **This iter's Mathlib search confirms the
  gap persists in b80f227**:

  - `Loogle: IsRegularLocalRing, Algebra.IsStandardSmooth` → empty.
  - `Loogle: IsRegularLocalRing, Smooth` → empty.
  - `Loogle: IsRegularLocalRing, IsSmoothAt` → empty.
  - `grep "RegularLocalRing"
    .lake/packages/mathlib/Mathlib/RingTheory/Smooth/*.lean` → empty.

  (B′) shares the same gap with (A); the only LOC saving comes from
  skipping the geometric-stalk identification (~100–200 LOC of a
  500–1000 LOC bridge). (B′) is **not** intermediate between (A) and
  (B); it is closer to (A) on cost. The directive's premise that (B′)
  might dominate (B) on bridge cost is **incorrect**.

  Decision: stay on (B), defer (B′)/(A) until trigger (a') fires
  (per `PROGRESS.md` iter-130 watch criteria — re-opens at iter-133+
  if piece (i.b) `mulRight_globalises_cotangent` closure under (B)
  requires inline (B)→(A) bridge construction).

- **Iter-129 analogist's recommendation survives this iter intact at
  the choice-of-replacement level.** What failed in iter-130 was the
  **realization** (the `Classical.choice (Nonempty.intro _)` wrapping
  trick), not the replacement choice. The iter-129 analogist's
  framing — "for the rigidity consumer, canonicity is not load-bearing"
  — was correct for the rigidity consumer, but the analogist did not
  consider that the **rank lemma** itself needs structural access to
  the chart-base-changed term, and the iter-130 prover took
  "canonicity not needed" too literally and hid the structure entirely.
  The iter-131 refactor restores structural access without restoring
  canonicity.

## Persistent file

- `analogies/cotangent-body-shape.md` — design-rationale captured for
  future iters: full decision blocks for Q1 (body shape), Q2 (rank
  lemma closure chain end-to-end), and Q3 (B′ rejection); concrete
  Lean shape for the refactored body; bridge-lemma list with
  iter-131 verification status; caveat on `unfold` exposure and
  defensive bridge-lemma recommendation.

## Overall verdict

The iter-130 body shape is structurally defective and must be
refactored this iter; the iter-131 plan's `Classical.choose`-chain
proposal is the correct fix and the rank-lemma closure chain against
it is fully `[verified]` end-to-end; (B′) does not dominate (B) on
bridge cost and should be rejected for this iter.
