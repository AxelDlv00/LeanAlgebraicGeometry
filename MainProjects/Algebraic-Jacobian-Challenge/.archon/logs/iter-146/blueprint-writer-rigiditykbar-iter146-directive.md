# Blueprint Writer Directive

## Slug
rigiditykbar-iter146

## Target chapter
blueprint/src/chapters/RigidityKbar.tex

## Strategy context

This chapter owns the M2.a `rigidity_over_kbar` declaration (k-agnostic
per the iter-127 over-k commitment) plus the iter-145 NEW subsection
"Chart-algebra piece (ii) first-class decomposition" (L1773–L1956) that
mirrors the 5 sorry-bodied declarations scaffolded iter-145 in
`AlgebraicJacobian/Cotangent/ChartAlgebra.lean`.

The iter-146 plan agent intends to fire the FIRST chart-algebra prover
lane on 3 of 5 sub-pieces (the ones flagged blueprint-adequate by
iter-145 `lean-vs-blueprint-checker-chart-algebra-review145`):
* `algebra_isPushout_of_affine_product` (α)
* `constants_integral_over_base_field` (integrally-closed helper)
* `Scheme.Over.ext_of_diff_zero` (scheme-level lift)

The other 2 sub-pieces (`df_zero_factors_through_constant_on_chart`
β-core; `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` algebra-
level core) are deferred to iter-147+ pending the absorption of the
iter-146 blueprint-reviewer's must-fix items in your scope below.

The iter-145 bundled-route excise in `Cotangent/GrpObj.lean` deleted 5
declarations (`relativeDifferentialsPresheaf_basechange_along_proj_two`,
`basechange_along_proj_two_inv_derivation`,
`basechange_along_proj_two_inv`,
`basechange_along_proj_two_inv_app_isIso`,
`mulRight_globalises_cotangent`). The corresponding piece (i.b)
declaration blocks in `RigidityKbar.tex` are now stale: their
`\lean{...}` hints point at NON-EXISTENT Lean declarations. They
currently have iter-144-DESCOPED disposition paragraphs but the
`\lean{...}` hints still resolve to deleted Lean names.

## Required content

### A. KDM step (p1) expansion (must-fix MAJOR per iter-146 blueprint-reviewer)

In the proof of `\lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`
(currently lines ~1900–1944), the char-`p` case sub-step (p1) reads
roughly "reduce to `B^p` by hand from the standard-smooth presentation"
with no concrete sub-step recipe. The plan-agent's iter-146+ KDM ring-
side prover lane needs a 3–5 sub-step recipe here. The mathematical
content to expand:

* Setup: `k` is a field of characteristic `p > 0`; `B` is finite-type
  over `k` (or, more sharply, `B` is the chart-side ring of a
  standard-smooth-of-relative-dimension `n` chart). `b ∈ B` satisfies
  `D b = 0` in `Ω_{B/k}` where `D` is the universal derivation.
* The Cartier-direction goal is to show `b ∈ B^p` (i.e. `b = c^p` for
  some `c ∈ B`). Stacks Tag 07F4 is the canonical reference (it's
  stated for smooth morphisms; restricting to standard-smooth charts
  is the in-tree concretisation).
* Sub-step (p1.a) — Translate `D b = 0` to a statement about the
  `B`-bilinear form `d : B → Ω_{B/k}` (Mathlib's
  `KaehlerDifferential.D`). The kernel of `d` is a subring of `B`
  (`KaehlerDifferential.D_ker_subring`-shape statement; build it from
  `KaehlerDifferential.D_add` + `KaehlerDifferential.D_mul` if not
  in Mathlib).
* Sub-step (p1.b) — Use the standard-smooth chart presentation
  `B = k[x_1, …, x_n] / (f_1, …, f_m)` with the Jacobian condition.
  For any `b = Σ c_α x^α + (relations)`, compute `D b = Σ c_α D(x^α)`.
  In characteristic `p`, `D(x^α) = (α_1 x_1^{α_1 - 1} dx_1 + ⋯)`;
  the coefficient is zero iff every `α_i` is divisible by `p` (modulo
  the relations, which interact via the standard-smooth chart's
  freeness of `Ω` on `dx_i`'s).
* Sub-step (p1.c) — Conclude `b` is a polynomial in `x_i^p` (modulo
  relations); the standard-smooth-chart's freeness of `Ω_{B/k}` on
  `dx_i`'s (Mathlib's `Algebra.IsStandardSmoothOfRelativeDimension.free_kaehlerDifferential`
  or its equivalent) makes this rigorous.
* Sub-step (p1.d) — Lift back to `B = B^p[x_1, …, x_n] / …` and
  exhibit `b ∈ B^p`. Cite Stacks Tag 07F4 for the in-tree concretisation
  pattern.

The expanded recipe should appear as numbered sub-steps inside the
existing `\begin{proof}` block of `\lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`
without changing the lemma statement. Keep the existing char-0
treatment unchanged.

### B. KDM step (p3) statement-vs-proof reconciliation (must-fix MAJOR per iter-146 blueprint-reviewer)

The lemma's statement (around L1900) currently posits only "`k` field,
`B` finite-type over `k`" (or more generally "standard-smooth of
relative dimension `n`"). Step (p3) of the proof appeals to "`B` is
the chart-side ring of a smooth proper geometrically irreducible
scheme (the standing chart-side hypothesis)" — a hypothesis NOT in
the signature. There are two acceptable resolutions:

* **(B.preferred)** Lift the integrally-closed-constants step out of
  the KDM proof into its own named lemma (e.g.
  `\lem:KaehlerDifferential_constants_in_chart_of_proper_curve`),
  state that lemma with the chart-of-smooth-proper-geom-irr
  hypothesis explicit, and have the KDM proof's step (p3) invoke it
  as a black box `\cref`. This preserves the KDM lemma's generality
  (finite-type `k`-algebra) and concentrates the curve-specific
  hypothesis at the new lemma's signature.
* **(B.alternative)** Tighten the KDM lemma's signature to explicitly
  carry the "`B = Γ(V, O_C)` for `V` an affine chart of a smooth
  proper geom-irr `C/k`" hypothesis. Less preferred because it
  conflates the algebra-level core with the curve-specific descent
  step.

Use **(B.preferred)**: introduce a new lemma block
`\lem:KaehlerDifferential_constants_in_chart_of_proper_curve` immediately
before the KDM lemma, state it precisely (the result is: under the
chart-of-smooth-proper-geom-irr hypothesis, `range (algebraMap k B)` is
integrally closed in `B`), and a one-paragraph proof sketch citing
`\lem:constants_integral_over_base_field` for the global-section
identification + standard ring-theoretic descent. The KDM proof's
step (p3) then invokes this lemma by `\cref{lem:KaehlerDifferential_constants_in_chart_of_proper_curve}`.
Update the KDM lemma's `\uses{...}` field to include the new lemma's
label.

### C. Chart-algebra (β-core) Step 3 reference fix (must-fix MAJOR per iter-146 blueprint-reviewer)

In the proof of `\lem:chart_algebra_df_zero_factors_through_constant_on_chart`
(around lines 1830–1860), Step 3 ("chart-Čech / Mayer–Vietoris promotion")
currently cites "the project's `Genus.lean` H¹(C, O_C) = 0 computation
as a running model". That citation is wrong: `AlgebraicJacobian/Genus.lean`
is 45 LOC and only DEFINES the genus — it contains no `H¹ = 0`
computation. The MV abstract LES exists at
`\thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact`
(`Cohomology_MayerVietoris.tex:520`) but its application to the
structure sheaf on a 2-chart cover has not been wired up in the
project.

Rewrite Step 3 to do BOTH:

1. **Drop the "running model in Genus.lean" framing.** Replace with a
   direct statement of what the cohomological content is: on a smooth
   proper geometrically irreducible curve `C/k` of genus 0, the
   global sections of `Ω_{C/k}^{⊕n}` are zero
   (`H^0(C, Ω_{C/k}^{⊕n}) = 0`). This is the cohomological content
   referenced by the iter-145 Q3 honesty disclaimer in STRATEGY.md
   § Soundness rules; per that disclaimer the named theorem Serre
   duality is NOT invoked, but the equivalent content IS invoked.
2. **Articulate the chart-Čech proof shape concretely.** A 2-chart
   affine cover `C = V_1 ∪ V_2` (existence per Step 3.aux below) gives
   a 2-term Čech complex `Γ(V_1, Ω_C^{⊕n}) ⊕ Γ(V_2, Ω_C^{⊕n}) → Γ(V_1 ∩ V_2, Ω_C^{⊕n})`.
   The chart-local kernel-extraction (Step 1 of this proof) gives
   `Γ(V_i, Ω_C^{⊕n}) ∩ (range of f^♯) = 0` for each chart; the chart-
   algebra (α) `\lem:chart_algebra_isPushout_of_affine_product` gives
   the Čech d⁰ kernel is exactly the global sections. Combine: the
   chart-Čech d⁰ kernel of `Ω_C^{⊕n}` lands inside `range f^♯ ∩` over
   `k`-constants, hence is killed by Step 2's extension.
3. **Add a Step 3.aux** (a paragraph immediately preceding Step 3)
   that names the 2-chart-cover-of-smooth-proper-curve existence
   precisely: cite `Mathlib.AlgebraicGeometry.AffineCover` (the
   `IsAffineOpen` + `IsBasicOpen` API) for the underlying construction,
   and the project's `Genus.lean` consumer (line ~30) for the
   quasi-compact-separated-curve specialisation that already exists
   in-tree under `AlgebraicGeometry.Scheme.affineCover_card_two`-shape.
   If the project does NOT have a 2-chart-of-curve named lemma,
   articulate the construction in 2–3 sentences (a smooth proper
   geom-irr curve over `k` is quasi-compact + quasi-separated, so it
   admits a finite affine cover; refining to a 2-chart cover whose
   intersection is also affine is a `Spec` of a `LocalizationAway`
   construction, see Stacks Tag 0F8L for the construction).

DO NOT introduce a new top-level vanishing lemma about `H^0(C, Ω_C)`
(that would amount to a Serre-duality-shaped named theorem, contrary
to the iter-145 Q3 disclaimer). Keep the cohomological content folded
inside this proof's Step 3.

### D. Eight broken `\lean{...}` hints (must-fix MAJOR per iter-146 blueprint-reviewer)

The iter-146 blueprint-reviewer enumerated 8 broken `\lean{...}` hints
pointing at iter-145-EXCISED or never-introduced declarations. These
must either be stripped, marked `\notready`-with-no-`\lean{...}`, or
re-pointed at the standalone-utility declarations that survived the
excise. For each:

1. `\lem:GrpObj_cotangent_bridge` (L192) — `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_iso_localRingCotangent}`.
   This declaration was never introduced (it was Replacement (A) bridge
   from `analogies/lieAlgebra-rank-bridge.md` iter-129, never built).
   Tagged `\notready` already, but the `\lean{...}` is misleading.
   **Action**: STRIP the `\lean{...}` hint entirely; keep `\notready`.
2. `\lem:GrpObj_omega_free` (L1728) — `\lean{AlgebraicGeometry.GrpObj.omega_free}`.
   Never introduced; DESCOPED iter-144 under chart-algebra. Tagged
   `\notready`. **Action**: STRIP `\lean{...}`; keep `\notready`.
3. `\lem:GrpObj_omega_rank_eq_dim` (L1741) — `\lean{AlgebraicGeometry.GrpObj.omega_rank_eq_dim}`.
   Same situation. **Action**: STRIP `\lean{...}`; keep `\notready`.
4. `\lem:GrpObj_omega_basechange_proj` (L473) — `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two}`.
   EXCISED iter-145 from `Cotangent/GrpObj.lean`. **Action**: STRIP
   `\lean{...}`; add `\notready` if not present; add a one-paragraph
   EXCISED-iter-145 disposition note above the block citing the
   bundled-route DESCOPE per the iter-144 chart-algebra pivot. (The
   block itself stays in the chapter as traceable iter-141 → iter-143
   decision history; do NOT delete the block.)
5. `\lem:GrpObj_omega_basechange_proj_inv_derivation` (L1473) —
   `\lean{...basechange_along_proj_two_inv_derivation}`. Same situation
   as (4). **Action**: same as (4).
6. `\lem:GrpObj_omega_basechange_proj_inv` (L1558) —
   `\lean{...basechange_along_proj_two_inv}`. Same. **Action**: same.
7. `\lem:GrpObj_basechange_along_proj_two_inv_app_isIso` (L1629) —
   `\lean{...basechange_along_proj_two_inv_app_isIso}`. Same. **Action**:
   same.
8. `\lem:GrpObj_mulRight_globalises` (L361) —
   `\lean{...mulRight_globalises_cotangent}`. Same. **Action**: same.

### E. Two `soon` items on chart-algebra (α) (per iter-146 blueprint-reviewer)

* **(E.1)** `\lem:chart_algebra_isPushout_of_affine_product` carries
  `\uses{def:relative_kaehler_presheaf}` but its statement is purely
  algebra-level. STRIP the stray `\uses` cross-reference.
* **(E.2)** The chart-algebra envelope text at around L1803 cites
  `Mathlib.RingTheory.IsPushout` as the file containing `Algebra.IsPushout`.
  The actual file is `Mathlib.RingTheory.IsTensorProduct` (verified
  iter-145 by the refactor; documented in
  `Cotangent/ChartAlgebra.lean:10–15`). UPDATE the citation.

## Out of scope

* DO NOT touch the iter-145 NEW subsection's 5 first-class blocks at
  L1773–L1944 EXCEPT for items A (KDM expansion) + B (KDM signature
  decomposition) + C (β-core Step 3 fix) + E.1 (α stray `\uses` strip)
  + E.2 (Mathlib filename fix). All other prose in the subsection is
  acceptable as-is per the iter-146 blueprint-reviewer.
* DO NOT alter the chapter-level `rigidity_over_kbar` declaration block
  or its iter-126/127 status banner — those are unrelated to the
  iter-146 must-fix items.
* DO NOT touch any `\leanok` or `\mathlibok` markers anywhere in the
  chapter. The `sync_leanok` phase between prover and review handles
  `\leanok` deterministically; `\mathlibok` is the review agent's
  domain.
* DO NOT introduce new sub-piece-level helper lemmas beyond the
  one in item B (the `\lem:KaehlerDifferential_constants_in_chart_of_proper_curve`
  extraction).
* DO NOT touch the iter-144 chart-algebra disposition NOTE at L88 or
  the chart-algebra envelope at L99–L114 (those are already aligned
  with the iter-144 commitment).

## References

* iter-146 blueprint-reviewer report at
  `.archon/task_results/blueprint-reviewer-iter146.md` —
  the full must-fix list with line-number citations.
* iter-145 lean-vs-blueprint-checker report at
  `.archon/task_results/lean-vs-blueprint-checker-chart-algebra-review145.md` —
  per-block sketch-adequacy assessment.
* `analogies/chart-algebra-vs-bundled-iter144.md` — the iter-144
  pivot rationale + chart-algebra decomposition.
* Stacks Project Tag 07F4 — Cartier direction for the chart-side
  `ker D = B^p` claim in item A.
* Stacks Project Tag 0F8L — 2-chart-of-curve cover existence (for
  item C Step 3.aux).

## Expected outcome

After this edit, `RigidityKbar.tex` becomes `complete: true / correct: true`
with the following structural changes:

* KDM proof step (p1) carries a 4-substep recipe (p1.a–p1.d).
* A new lemma `\lem:KaehlerDifferential_constants_in_chart_of_proper_curve`
  is introduced before KDM, carrying the chart-of-proper-curve
  hypothesis explicitly; KDM step (p3) invokes it by `\cref`.
* Chart-algebra (β-core) Step 3 cites the chart-Čech argument
  concretely (no Genus.lean reference; no named Serre duality), with
  a Step 3.aux paragraph on 2-chart cover existence.
* All 8 broken `\lean{...}` hints are stripped (the blocks themselves
  remain as traceable decision-history with `\notready` markers and
  EXCISED-iter-145 disposition notes where applicable).
* Chart-algebra (α) `\uses` field is cleaned (`def:relative_kaehler_presheaf`
  removed).
* Chart-algebra envelope text updates `Mathlib.RingTheory.IsPushout` →
  `Mathlib.RingTheory.IsTensorProduct`.

Expected LOC delta: ~+120 LOC (item A's recipe ~30 LOC + item B's new
lemma ~25 LOC + item C's Step 3 rewrite ~30 LOC + item D's 8
dispositions ~35 LOC, minus ~0 LOC from item E strip/replace). The
chapter grows from ~1971 LOC to ~2090 LOC.
