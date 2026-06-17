# Blueprint-writer directive — chapter `Picard_QuotScheme.tex` — slug `quot-bridgeC`

## Scope
ONE chapter: `blueprint/src/chapters/Picard_QuotScheme.tex`. Two jobs: (1) add coverage blocks for the 6
new project-local infra declarations the iter-030 prover landed (currently `dag-query unmatched` coverage
debt), and (2) expand the `lem:over_restrict_iso` (bridge C) proof into the concrete 4-step decomposition
the prover discovered, so the iter-031 prover has a precise guide for step 2. Do NOT touch other blocks.
Do NOT add `\leanok`. You MAY add `\mathlibok` only on genuine Mathlib dependency anchors (see below).

## Job 1 — coverage blocks for the 6 new infra decls (the topos-theoretic layer of bridge C)
The iter-030 prover filled the explicit `Mathlib/Topology/Sheaves/Over.lean` TODO: the over-site ↔
open-subspace **sheaf-category equivalence** induced by `Opens.overEquivalence U`. These 6 axiom-clean
decls are project-local infrastructure with no blueprint block. Add a short sub-section (place it
immediately BEFORE `lem:over_restrict_iso`, ~line 2875, titled e.g. "The over-site/open-subspace sheaf
equivalence (bridge C, topological layer)"), one block per decl, each with `\label`, `\lean{}`, accurate
`\uses{}`, and a one-line informal proof. These are project-bespoke infra (no external source line needed):

- `\lean{AlgebraicGeometry.overEquivalence_functor_isCocontinuous}` (instance) — the functor of
  `Opens.overEquivalence U` is cocontinuous: a sieve covers in `(gT X).over U` iff its `Sieve.overEquiv`
  image covers in `gT X` (`GrothendieckTopology.mem_over_iff`), and `Opens.grothendieckTopology` covering
  is pointwise; transport a cover member across `Subtype.val : ↥U → X` (open embedding, injective).
- `\lean{AlgebraicGeometry.overEquivalence_inverse_isCocontinuous}` (instance) — same for the inverse.
- `\lean{AlgebraicGeometry.overEquivalence_inverse_isDenseSubsite}` (instance) — from the two
  cocontinuities via `Equivalence.isDenseSubsite_inverse_of_isCocontinuous`.
- `\lean{AlgebraicGeometry.overEquivalence_functor_isContinuous}` (instance) — via
  `Adjunction.isContinuous_of_isCocontinuous` on the equivalence adjunction.
- `\lean{AlgebraicGeometry.overEquivalence_inverse_isContinuous}` (instance) — same for the inverse.
- `\lean{AlgebraicGeometry.overEquivalence_sheafCongr}` (def) — the sheaf-category equivalence
  `Sheaf ((gT X).over U) A ≌ Sheaf (gT ↥U) A` via `Equivalence.sheafCongr`. This is the keystone of the
  topological layer; `lem:over_restrict_iso` must `\uses{}` it.

Give the sub-section a one-line intro noting these fill the Mathlib `Topology/Sheaves/Over.lean` TODO.

## Job 2 — expand `lem:over_restrict_iso` (bridge C) proof to the concrete 4-step decomposition
The current proof sketch (~lines 2903–2912) is the abstract "equivalence of sites carries the structure
sheaf across" argument — too thin to guide the build (the iter-030 checker flagged this). Replace the proof
body with the concrete 4-step decomposition the prover established (keep the statement block as-is except
add `overEquivalence_sheafCongr` and the relevant continuity instances to its `\uses{}`):

1. **(done)** The over-site ↔ open-subspace sheaf-category equivalence
   `overEquivalence_sheafCongr U` (the 6 decls of Job 1) — the topos-theoretic layer.
2. **(next obstacle — step 2, geometric ring-sheaf identification)**: identify the sliced structure sheaf
   `(Spec R).ringCatSheaf.over U` with `U.toScheme.ringCatSheaf` transported across
   `overEquivalence_sheafCongr U RingCat` (an iso of `RingCat`-valued sheaves). Lead the prover with:
   `U.ι.opensFunctor = (Opens.overEquivalence U).inverse ⋙ Over.forget U`, so the structure-sheaf
   comparison reduces to open-immersion structure-sheaf lemmas; `Scheme.restrictFunctor` is `pushforward`
   along `U.ι.opensFunctor` (`Modules/Sheaf.lean`).
3. lift the step-2 ring-sheaf iso to sheaves of **modules** via
   `SheafOfModules.pushforwardPushforwardEquivalence` (`PushforwardContinuous.lean`; the two `IsContinuous`
   instances it needs are now in-file, Job 1).
4. compose with `Scheme.Modules.restrictFunctorIsoPullback` (`Modules/Sheaf.lean`) to land
   `M.over U ≅ M.restrict U.ι`. NOTE in the prose: the two sides live in different module categories, so
   the literal Lean statement of `overRestrictIso` must be phrased THROUGH the step-3 equivalence functor
   — keep the existing `% NOTE:` about the Lean form possibly needing to be sharpened, and add that the
   sharpening is the routing through the step-3 equivalence.

Keep the existing `% NOTE:` about `set_option backward.isDefEq.respectTransparency false` (it may be needed
for the step-3 module-level synthesis, NOT the topological layer — the prover confirmed the cocontinuity
proofs went through plainly without it).

## Mathlib anchors
If `pushforwardPushforwardEquivalence`, `restrictFunctorIsoPullback`, `Opens.overEquivalence`, or
`Equivalence.sheafCongr` lack a `\mathlibok` dependency anchor in this chapter and the proof relies on them,
add a one-line `\mathlibok` anchor block (statement in project notation + `\lean{}` naming the real Mathlib
decl). Do NOT mark `\mathlibok` on any project-own to-be-proved decl.

## Out of scope
The 4 protected stubs, SNAP, `def:sectionGradedRing`, the (D) `section_localization_descent` keystone block
(leave it as-is), `grassmannian_representable`. Do not add `\leanok`.

## Verification before you finish
- 6 new blocks exist, each pinning the exact `\lean{}` names above; `dag-query unmatched` debt for these 6
  is cleared (each now has a blueprint entry).
- `lem:over_restrict_iso` `\uses{}` includes `overEquivalence_sheafCongr` and its proof lists the 4 steps,
  with step 2 (ring-sheaf identification) marked as the current obstacle.
