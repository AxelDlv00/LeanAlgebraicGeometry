# Blueprint Writer Report

## Slug
RiemannRoch_OCofP-cov273

## Status
COMPLETE — all 14 uncovered Lean declarations now carry exactly one
`\lean{}`-pinned blueprint block, each wired into the chapter's dependency
cone; all 35 literal `REF` placeholders in the chapter replaced.

## Target chapter
blueprint/src/chapters/RiemannRoch_OCofP.tex

## Changes Made (14 coverage blocks added)

Construction substrate (inserted before the existing `carrierPresheaf`
definition):

- **Added definition** `def:lineBundleAtClosedPoint_carrierSet` /
  `\lean{…lineBundleAtClosedPoint.carrierSet}` — the order-condition carrier set
  of `O_C(P)` over an open `U`.
- **Added lemma** `lem:lineBundleAtClosedPoint_carrierSet_mono` /
  `\lean{…carrierSet_mono}` — antitone monotonicity of the carrier set in `U`.
- **Added definition** `def:lineBundleAtClosedPoint_instNonemptyTopOpen` /
  `\lean{…instNonemptyTopOpen}` — nonemptiness of the top open of an integral
  scheme.
- **Added definition** `def:lineBundleAtClosedPoint_instAlgebraKbarFunctionField`
  / `\lean{…instAlgebraKbarFunctionField}` — the `k̄`-algebra structure on `K(C)`.
- **Added definition** `def:lineBundleAtClosedPoint_carrierSubmodule` /
  `\lean{…carrierSubmodule}` — upgrade of the carrier set to a `k̄`-submodule.
- **Added definition** `def:lineBundleAtClosedPoint_trivAtBot` /
  `\lean{…trivAtBot}` — the bot-trivialisation submodule enforcing `F(∅)=0`.
- **Added lemma** `lem:lineBundleAtClosedPoint_carrierSubmoduleSheaf_le` /
  `\lean{…carrierSubmoduleSheaf_le}` — monotonicity of the sheaf-corrected
  carrier submodule on nonempty opens.
- **Added definition** `def:lineBundleAtClosedPoint_carrierTypeSubfunctor` /
  `\lean{…carrierTypeSubfunctor}` — type-level subfunctor presentation of the
  carrier.

Global-sections / Riemann–Roch side:

- **Added lemma** `lem:lineBundleAtClosedPoint_globalSections_iff_mp` /
  `\lean{…globalSections_iff_mp}` — forward direction of `globalSections_iff`
  (build a section from the order conditions). Proof sketch: Y.
- **Added theorem** `thm:lineBundleAtClosedPoint_h0_sub_h1_eq_two` /
  `\lean{…h0_sub_h1_lineBundleAtClosedPoint_eq_two}` — the integer χ-bridge
  `H⁰ − H¹ = 2` at `D=[P]`. Proof sketch: Y.
- **Added theorem**
  `thm:lineBundleAtClosedPoint_exists_nonconstant_rational_from_dim_eq_two` /
  `\lean{…exists_nonconstant_rational_from_dim_eq_two}` — genus-free substrate
  for the non-constant-rational corollary. Proof sketch: Y.
- **Added lemma** `lem:lineBundleAtClosedPoint_localLift_of_log_ordFrac_eq_zero`
  / `\lean{…localLift_of_log_ordFrac_eq_zero}` — DVR unit lift from vanishing
  order. Proof sketch: Y.
- **Added lemma**
  `lem:lineBundleAtClosedPoint_algebraMap_bijective_of_finite_isDomain_isAlgClosed`
  / `\lean{…algebraMap_bijective_of_finite_isDomain_isAlgClosed}` — finite
  integral-domain `k̄`-algebra is `k̄` (re-export of Mathlib's
  `IsAlgClosed.algebraMap_bijective_of_isIntegral`; kept as a project lemma so
  the `\lean{}` pin covers the project decl). Proof sketch: Y.
- **Added lemma**
  `lem:lineBundleAtClosedPoint_functionField_localUnit_of_orderZero_at_primeDivisor`
  / `\lean{…functionField_localUnit_of_orderZero_at_primeDivisor}` — stalk-unit
  lift from `ord_Q f = 0`. Proof sketch: Y.

## Cross-references introduced (wiring — verified with leandag)

Incoming edges added to existing blocks so the public results transitively
`\uses{}` every new helper:

- `def:lineBundleAtClosedPoint_carrierPresheaf` — added
  `\uses{def:…carrierSubmoduleSheaf, lem:…carrierSubmoduleSheaf_le}` (was edgeless).
- `lem:lineBundleAtClosedPoint_carrierPresheaf_isSheaf` — appended
  `def:…carrierTypeSubfunctor, def:…trivAtBot` to its `\uses{}`.
- `def:lineBundleAtClosedPoint_carrierSubmoduleSheaf` — **corrected** its
  `\uses{}` from the mathematically-backwards `def:…carrierPresheaf` to the real
  dependencies `def:…carrierSubmodule, def:…trivAtBot` (carrierSubmoduleSheaf =
  carrierSubmodule ⊓ trivAtBot). This removes a would-be cycle and wires two new
  helpers.
- `thm:lineBundleAtClosedPoint_dim_eq_two_of_genusZero` — added
  `thm:…h0_sub_h1_eq_two` to its `\uses{}`.
- `cor:lineBundleAtClosedPoint_exists_nonconstant_genusZero` — added
  `thm:…exists_nonconstant_rational_from_dim_eq_two`.
- `lem:…functionField_const_of_complete_curve_of_orderZero` (proof block) — added
  `lem:…functionField_localUnit_of_orderZero_at_primeDivisor,
  lem:…algebraMap_bijective_of_finite_isDomain_isAlgClosed`.

Outgoing edges declared inside the new blocks chain them downward (acyclic):
carrierSet_mono→carrierSet; instAlgebra→instNonemptyTopOpen;
carrierSubmodule→{carrierSet,instAlgebra}; trivAtBot→instAlgebra;
carrierSubmoduleSheaf_le→{carrierSubmoduleSheaf,carrierSet_mono};
carrierTypeSubfunctor→carrierSubmoduleSheaf; globalSections_iff_mp→
globalSections_iff (mirrors the existing mpr convention) plus the construction
defs; functionField_localUnit→localLift; exists_nonconstant_rational→
{globalSections_iff_mp, globalSections_iff_mpr, toFunctionField_injective,
functionField_const, principal_divisor}.

leandag verification after edits: `isolated` in chapter = 0,
`unknown_uses` = 0, `conflicts` = 0; all 14 `\lean{}` pins now resolve to
matched blueprint nodes (previously uncovered `lean-aux`).

## REF placeholders fixed (35 total)

Every literal `REF` in the chapter was replaced with a real `\cref{…}`:
- intro/standing-hypotheses (RR.1/RR.2/genus/divisor): →
  `def:divisor_closed_point`, `thm:euler_char_eq_deg_plus_one_minus_genus`,
  `def:genus`, `def:principal_divisor`.
- `lineBundleAtClosedPoint` / `toFunctionField` definition scopes →
  `def:lineBundleAtClosedPoint`, `def:divisor_closed_point`.
- `globalSections_iff` statement+proof → `def:lineBundleAtClosedPoint`,
  `def:principal_divisor`, `def:divisor_closed_point`.
- H¹-vanishing proof → `def:lineBundleAtClosedPoint`, `def:Scheme_HModule`,
  `def:genus`.
- dimension-formula proof → `thm:euler_char_eq_deg_plus_one_minus_genus`,
  `def:divisor_closed_point`, `def:divisor_degree`, `def:genus`,
  `def:eulerChar_curve`, `lem:H1_vanishing_lineBundleAtClosedPoint_genusZero`.
- non-constant corollary proof →
  `thm:lineBundleAtClosedPoint_dim_eq_two_of_genusZero`,
  `lem:lineBundleAtClosedPoint_globalSections_iff`,
  `thm:lineBundleAtClosedPoint_exists_nonconstant_rational_from_dim_eq_two`.
- Mathlib-status + out-of-scope sections →
  `lem:H1_vanishing_lineBundleAtClosedPoint_genusZero`, `def:Scheme_HModule`,
  `thm:euler_char_eq_deg_plus_one_minus_genus`,
  `thm:lineBundleAtClosedPoint_dim_eq_two_of_genusZero`,
  `cor:lineBundleAtClosedPoint_exists_nonconstant_genusZero`,
  `lem:lineBundleAtClosedPoint_globalSections_iff`.

One sub-clause (the "order `ord_Q(f)`" reference in the standing-hypotheses
paragraph) had no existing blueprint label for the order/valuation map; it was
rephrased to "the standard discrete valuation of the project's Weil-divisor
order API" rather than left as a dangling `REF`.

All seven distinct cross-chapter `\cref` targets were confirmed to have a real
`\label{}` in a sibling chapter.

## References consulted
None — every added block is an internal helper proved sorry-free in Lean; no
external `% SOURCE` citation block was added (per directive, helpers need none).
The one Mathlib re-export
(`algebraMap_bijective_of_finite_isDomain_isAlgClosed`) names its Mathlib origin
in prose but was kept as a project lemma block (not a `\mathlibok` anchor),
because the `\lean{}` must pin the project's own decl to clear it from the
uncovered `lean-aux` list.

## Macros needed
None. All prose uses existing macros (`\ord`, `\div`, `\cref`, etc.).

## Notes for Plan Agent
- I corrected one pre-existing **backwards** `\uses{}` edge on
  `def:lineBundleAtClosedPoint_carrierSubmoduleSheaf` (it pointed "up" to
  `carrierPresheaf`; the real dependency is the reverse). This was necessary to
  keep the construction sub-DAG acyclic once the new helpers were wired. The
  block's prose still contains a `\cref{def:…carrierPresheaf}` mention, which is
  harmless (a cross-reference, not a dependency edge).
- `h0_sub_h1_lineBundleAtClosedPoint_eq_two` and
  `functionField_const_of_complete_curve_of_orderZero` carry typed `sorry`s in
  Lean (standing Mathlib gaps: RR.2 χ-substrate and the global algebraic-Hartogs
  / Γ=k̄ step). Their blueprint blocks state this faithfully; `\leanok` is left
  to `sync_leanok`. This is consistent with the chapter being on the
  permanently USER-paused Riemann–Roch route.

## Strategy-modifying findings
None.
