# Iter-059 objectives

Two `mathlib-build` prover lanes (both HARD GATE cleared by blueprint-reviewer iter-059).

## Lane 1 — `CechSectionIdentification.lean` (Stub-1 inductive assembly)
- Build `overProd_coproduct_distrib` (Over-S binary-product distributivity, from the built
  `prod_coproduct_distrib` via `Over.prodLeftIsoPullback` + `Over.forget` reflecting isos).
- Build `widePullback_coproduct_iso` (= `lem:coproduct_distrib_fibrePower`): induction on `p` from the
  built leaves; slice-product σ-normal-form.
- Close `cechBackbone_left_sigma` (Stub-1 sorry, line ~368), with the **Type-0 universe reduction**:
  reindex `𝒰.I₀ ≃ Fin n` (from `[Finite]`) before applying the Type-0 assembly. Do NOT widen the leaves.
- Leave Stubs 2/4/5/6 sorries for the next round.

## Lane 2 — `OpenImmersionPushforward.lean` (Need#1 jShriekOU transport → discharge `_acyclic`)
- Build the 5 transport sub-lemmas: `jshriek_transport_along_iso`, `pushforward_commutes_free`,
  `pushforward_commutes_sheafify`, `yoneda_transport_along_homeo`, `pushforward_iso_preserves_qcoh`.
- Build the Ext-identification bridge (`(preadditiveCoyoneda).rightDerived q ≅ Ext^q` via
  `extAddEquivCohomologyClass` ∘ `homologyAddEquiv`) + the EnoughInjectives connector (~6 LOC).
- Discharge the line-373 `_acyclic` leaf via `modulesIsoSpecExtTransport` landing on
  `affine_serre_vanishing_general_open` over `Spec Γ(U)`. Hand off a precise residual if blocked.

## Not dispatched
- `CechAugmentedResolution.lean` (`hSec`, gated on Lane 1 Sub-brick A completion).
- P5b / EnoughInjectives connector top / dead `CechAcyclic.affine` — future / non-blocking.
