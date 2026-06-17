# Blueprint Writer Report

## Slug
rigiditykbar-iter146

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/RigidityKbar.tex

## Changes Made

### Item A — KDM step (p1) 4-substep recipe
- **Revised** proof block of `\lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`,
  step (p1): expanded the iter-145 placeholder "by hand from the
  standard-smooth presentation" into a 4-substep recipe (p1.a)–(p1.d).
  - (p1.a) Subring structure of `ker D` via `KaehlerDifferential.D_add` +
    `KaehlerDifferential.D_mul` / `Derivation.leibniz` +
    `Derivation.map_algebraMap`.
  - (p1.b) Standard-smooth chart presentation (the Jacobian-invertible
    presentation `B ≅ k[x,y]/(f)`) and `D`-coefficient calculus, with
    explicit expansion of `D b` in the `{dx_i}` basis. Cited
    `Algebra.IsStandardSmoothOfRelativeDimension` + the freeness lemmas
    of `Mathlib.RingTheory.Smooth.StandardSmoothCotangent`.
  - (p1.c) Conclusion that `b` is a polynomial in `x_i^p` modulo
    relations, rigorously justified by the freeness of `Ω_{B/k}`.
  - (p1.d) Lift back to `b ∈ B^p` with explicit construction of the
    `c` with `c^p = b`, citing Stacks Tag 07F4 (Cartier-direction).
  - Char-0 treatment unchanged per directive.

### Item B — Integrally-closed-constants extraction
- **Added lemma** `\lem:KaehlerDifferential_constants_in_chart_of_proper_curve`
  immediately before the KDM theorem. The lemma states: for `X`
  smooth proper geometrically irreducible over `k` and `V ⊆ X.left`
  affine, `range(algebraMap k B)` is integrally closed in
  `B := Γ(X, V)`. Proof sketch cites
  `\lem:constants_integral_over_base_field` for the global-sections
  identification + standard ring-theoretic chase
  (chart-to-function-field embedding `B ↪ K(X)` + integral closure
  of `k` in `K(X)` equals constants).
  - No `\lean{...}` hint added: this is a new blueprint declaration
    not yet formalized, per writer descriptor (no in-tree Lean target
    named).
- **Revised** KDM theorem block `\uses` field: added
  `lem:KaehlerDifferential_constants_in_chart_of_proper_curve`.
- **Revised** KDM proof's `\uses` field: added the new lemma.
- **Revised** KDM proof step (p3): now invokes
  `\cref{lem:KaehlerDifferential_constants_in_chart_of_proper_curve}`
  as a black box instead of inlining the chart-of-proper-curve
  reasoning. Added a signature-vs-proof reconciliation paragraph at
  the end of the proof body documenting the (B.preferred) split (KDM
  signature stays general, helper carries the chart-of-proper-curve
  hypothesis).

### Item C — β-core Step 3 rewrite + Step 3.aux
- **Revised** proof block of
  `\lem:chart_algebra_df_zero_factors_through_constant_on_chart`,
  Step 3 + neighbours:
  - **Added Step 3.aux paragraph** immediately preceding Step 3,
    documenting the 2-chart-affine-cover existence concretely. Cites
    `Mathlib.AlgebraicGeometry.AffineScheme` (the `IsAffineOpen` +
    `IsBasicOpen` API), `Mathlib.RingTheory.Localization.Away.Basic`,
    and Stacks Tag 0F8L for the construction (refining a finite affine
    cover to a 2-chart cover with affine intersection on a 1-D smooth
    proper curve).
  - **Rewrote Step 3** to articulate the chart-Čech proof shape
    concretely (2-term Čech complex `Γ(V_1) ⊕ Γ(V_2) → Γ(V_1 ∩ V_2)`;
    kernel-equals-global-sections via the chart-algebra (α) helper
    `\cref{lem:chart_algebra_isPushout_of_affine_product}` plus the
    abstract MV sequence
    `\thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`).
  - **Dropped** the "running model in Genus.lean" framing entirely;
    replaced by the chart-algebra (α) gluing pattern as the running
    argument, with an iter-146 honest correction paragraph noting
    that the earlier `Genus.lean` reference was inaccurate.
  - **Preserved** the iter-145 strategy-critic Q3 honesty disclaimer:
    no named Serre duality, but the cohomological content
    `H^0(C, Ω_{C/k}^{⊕g}) = 0` IS invoked in chart-Čech kernel form.
  - **Revised** Mathlib status paragraph at the end of the proof:
    replaced the "Genus.lean is the running model" sentence with a
    citation chain through the chart-algebra (α) helper, the abstract
    MV theorem, and the `AffineCover` + `LocalizationAway` API for
    the 2-chart cover construction.

### Item D — 8 broken `\lean{...}` hints stripped
- **Revised** `\lem:GrpObj_cotangent_bridge` (was L192): stripped
  `\lean{...cotangentSpaceAtIdentity_iso_localRingCotangent}` (no
  in-tree declaration); added iter-146 disposition comment; `\notready`
  retained.
- **Revised** `\lem:GrpObj_omega_free` (was L1728): stripped
  `\lean{...omega_free}`; iter-146 disposition comment; `\notready`
  retained.
- **Revised** `\lem:GrpObj_omega_rank_eq_dim` (was L1741): stripped
  `\lean{...omega_rank_eq_dim}`; iter-146 disposition comment;
  `\notready` retained.
- **Added EXCISE disposition paragraph** above
  `\lem:GrpObj_omega_basechange_proj` (was L473) covering the 5
  iter-145-EXCISED declarations as a group. For each of the 5 blocks:
  - **Revised** `\lem:GrpObj_omega_basechange_proj` (was L473):
    stripped `\lean{...relativeDifferentialsPresheaf_basechange_along_proj_two}`;
    iter-146 NOTE; added `\notready`.
  - **Revised** `\lem:GrpObj_omega_basechange_proj_inv_derivation`
    (was L1473): stripped
    `\lean{...basechange_along_proj_two_inv_derivation}`; iter-146
    NOTE; added `\notready`.
  - **Revised** `\lem:GrpObj_omega_basechange_proj_inv` (was L1558):
    stripped `\lean{...basechange_along_proj_two_inv}`; iter-146
    NOTE; added `\notready`.
  - **Revised** `\lem:GrpObj_basechange_along_proj_two_inv_app_isIso`
    (was L1629): stripped
    `\lean{...basechange_along_proj_two_inv_app_isIso}`; iter-146
    NOTE; added `\notready`. (The pre-existing `\leanok` on this block
    is left untouched per writer descriptor — `sync_leanok` will
    reconcile against the now-deleted target.)
  - **Revised** `\lem:GrpObj_mulRight_globalises` (was L361): stripped
    `\lean{...mulRight_globalises_cotangent}`; iter-146 NOTE; added
    `\notready`.

### Item E — Soon items
- **E.1**: stripped stray `\uses{def:relative_kaehler_presheaf}` from
  both the statement and the proof of
  `\lem:chart_algebra_isPushout_of_affine_product` (the lemma is
  purely algebra-level; no Kähler presheaf appears in the statement
  or the proof).
- **E.2**: updated two citations of `Mathlib.RingTheory.IsPushout`
  to `Mathlib.RingTheory.IsTensorProduct` in the proof of
  `\lem:chart_algebra_isPushout_of_affine_product`: (1) the step-3
  bullet's parenthetical claim that `Algebra.IsPushout` lives in
  `Mathlib.RingTheory.IsPushout`; (2) the Mathlib-status paragraph's
  citation of the same file. Both now point at the iter-145-verified
  upstream home `Mathlib.RingTheory.IsTensorProduct` per the iter-145
  NOTE in `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:10–15`.

## Cross-references introduced
- `\uses{lem:KaehlerDifferential_constants_in_chart_of_proper_curve}`
  added to KDM theorem block and proof block — the new lemma is
  introduced in the same chapter immediately above KDM, so the
  reference resolves locally.
- All eight stripped `\lean{...}` hints leave the corresponding
  `\label{...}` and `\uses{...}` entries intact, so the blueprint
  dependency graph is unchanged except for the explicit Lean-target
  hints being removed.

## Macros needed (if any)
None. All commands used (`\lean`, `\uses`, `\notready`, `\leanok`,
`\cref`, `\emph`, `\paragraph`, etc.) are pre-existing macros in
`macros/common.tex`.

## Reference-retriever dispatches (if any)
None. The directive's references (Stacks Tag 07F4, Stacks Tag 0F8L,
`analogies/chart-algebra-vs-bundled-iter144.md`, the iter-146
blueprint-reviewer report, and the iter-145 lean-vs-blueprint-checker
report) were sufficient. No new external sources required.

## Notes for Plan Agent

1. **Sibling chapter drift carryover.** Directive scope excluded
   editing `AlgebraicJacobian_Cotangent_GrpObj.tex` (pointer chapter
   with the iter-144 disposition paragraph + 5 stale `\item`
   bullets). The iter-146 blueprint-reviewer flagged that chapter as
   `complete: partial / correct: partial` independently. Plan agent
   should dispatch a separate writer for that chapter (it has its own
   slug — likely `cotangent-grpobj-iter146`).

2. **`\leanok` reconciliation expected.** Several blocks I added
   `\notready` to (the 5 EXCISED-iter-145 GrpObj_omega/inv blocks)
   may still carry `\leanok` from prior `sync_leanok` runs (which
   were against the iter-144 sorry-bodied versions of the targets,
   before the iter-145 EXCISE). The next `sync_leanok` run will
   correctly detect that the Lean targets are now gone and remove
   the `\leanok` markers, leaving `\notready` as the sole marker.
   No writer action needed; flagging so the plan agent is not
   surprised by the brief overlap.

3. **Iter-146 KDM signature loose-end.** The (B.preferred) split
   leaves KDM's signature at finite-type-`k`-algebra generality
   while its proof's step (p3) tacitly relies on a chart-of-proper-curve
   hypothesis (via `\cref{lem:KaehlerDifferential_constants_in_chart_of_proper_curve}`).
   The signature-vs-proof reconciliation paragraph in the KDM proof
   documents this as an iter-146 design decision; a future iter
   (when the iter-147+ KDM ring-side prover lane is ready to land
   the Lean signature) may need to either inflate KDM's signature
   to include the chart-of-proper-curve hypothesis explicitly, or
   route the integrally-closed-constants step at the consumer site
   (so KDM's body proves only the chart-uniform Frobenius-iteration
   reduction up to integral-closure data). Mathematically equivalent;
   recording the architectural choice for the next prover lane.

4. **Stacks Tag 0BUG citation in the new lemma.** The proof of
   `\lem:KaehlerDifferential_constants_in_chart_of_proper_curve`
   cites Stacks Tag 0BUG for "integral closure of `k` in `K(X)`
   equals `Γ(X, O_X)` for smooth proper geom-irr `X`". This is
   identified as a `[gap]` in Mathlib snapshot `b80f227` with a thin
   in-tree wrapper expected. The wrapper itself is small (chains
   `\lem:constants_integral_over_base_field` with the smooth-implies-normal
   instance), but if the project's references summary expands later
   with Stacks Tag 0BUG, a reference-retriever dispatch would be
   appropriate. Not blocking for this iter.

5. **Subsection intro paragraph at L1778 still references Genus.lean.**
   The iter-145 "Strategy-critic Q3 absorption" paragraph (the
   subsection intro at what was L1778) still contains the misleading
   "already consumed by Genus.lean's H¹(C, O_C) = 0 computation on
   a genus-0 curve" framing. Per directive Out-of-scope ("all other
   prose in the subsection is acceptable as-is"), I did not touch
   it. The iter-146 in-block correction in Step 3 of the proof of
   `\lem:chart_algebra_df_zero_factors_through_constant_on_chart`
   now contains an explicit iter-146 honesty note that retroactively
   corrects the framing. Flagging for the iter-147 plan agent in
   case a future scope refresh wants to also tighten the subsection
   intro paragraph.

## Strategy-modifying findings

None. The chart-algebra route's mathematical content is unchanged;
the (B.preferred) split of the integrally-closed-constants step into
a named helper is a refactor of the proof exposition, not a strategy
modification. The piece (i.b) EXCISE-iter-145 disposition notes I
added re-affirm the iter-144 chart-algebra pivot commitment recorded
in STRATEGY.md (which still owns the routing decision).
