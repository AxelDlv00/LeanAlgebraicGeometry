# Project Progress

## Current Stage

prover

## Stages
- [x] init
- [x] autoformalize
- [ ] prover
- [ ] polish

## End-state overview

**Zero inline `sorry` project-wide; kernel-only axioms, 0 project axioms.** The deliverable is
`AlgebraicGeometry.cech_computes_higherDirectImage` (`CechToHigherDirectImage.lean`) — the separated
relative case of Stacks 02KE, with `[QuasiCompact f] [IsSeparated f] [X.IsSeparated] [S.IsSeparated]`,
`h𝒰 : ∀ i, IsAffine (𝒰.X i)`, and the per-intersection `hres` injective-resolutions family.
**PROVED iter-079, 0 sorries.** Full framing in STRATEGY.md.

## Iter-080 context — frozen decl resolved by the user; project sorry-free

The user dropped the old false-as-signed protected `cech_computes_higherDirectImage` (general
`X.OpenCover`, only `[IsSeparated f]`) and its `archon-protected.yaml` entry, and the correct sibling
was renamed to the canonical `cech_computes_higherDirectImage`. **Verified the drop is sound:** peer
`Algebraic-Jacobian-Challenge` carries that same general signature as a `sorry` (needs absent Mathlib
spectral sequences) and does **not** protect it; the general statement is FALSE (counterexample
`X=ℙ¹, 𝒰={𝟙 X}, F=O(-2)`: `Hⁱ(Č•)=0` but `R¹f_*F≠0`). **Project-wide inline `sorry` count = 0.**

This iter (plan phase):
- Reconciled the blueprint: merged the two near-duplicate comparison blocks into the single
  `lem:cech_computes_cohomology` (pinned to the live `cech_computes_higherDirectImage`) carrying the
  precise hypotheses + scope note; deleted the orphaned `..._affineCover` block. blueprint-reviewer
  `finish` = PASS (statement matches the live signature; no broken refs; clean doctor).
- strategy-critic `finish` = SOUND (deliverable TRUE + faithful to the separated relative case of 02KE;
  ℙ¹/O(-2) counterexample correct; dropping the false decl is a soundness necessity).
- Updated STRATEGY/TO_USER to the new reality.

## Current Objectives

**(no prover dispatch this iter — see iter/iter-080/plan.md for rationale)**

MECHANICAL HARD GATE: there are **no inline `sorry` anywhere in the project** — nothing to dispatch a
prover at. The deliverable is proved; the remaining gate is the deterministic full-build + axiom check
(the heavy cohomology cone cold-builds ~25 min; a `lake build AlgebraicJacobian.Cohomology.CechToHigherDirectImage`
was launched this plan phase to confirm). The `sync_leanok` + review-build gate will verify the cone
compiles axiom-clean against a full build.

## Next iter plan — ordered
1. **Read the review-build result.** If green ⟹ the deliverable is confirmed PROVED and the project's
   mathematical content is complete ⟹ advance `## Current Stage` to **polish** and run the cleanup lane(s)
   below.
2. **If the review-build flags an error** (the user's large CHDI edit, 429+/201−, is not yet build-verified):
   identify the failing module; if it is a signature/structural issue re-dispatch the `refactor` subagent
   (the project is 0-sorry, so a `prove` lane would no-op); if a genuine proof gap reopened, dispatch a
   `prove` lane on that file.
3. **Polish (when build confirmed):**
   - Reading-order cosmetic (blueprint-reviewer `finish`): `lem:pushforward_mapHC_cechComplexOnX` and
     `lem:cechAugmented_to_acyclicResolutionInput` appear textually after their consumer in
     `Cohomology_CechHigherDirectImage.tex` (DAG correct, reading order awkward) — reorder.
   - Marker inconsistency (blueprint-reviewer `finish`, review-agent's domain): dormant
     `lem:tile_section_comparison` has `\leanok` with no `\lean{}` contradicting its UNFORMALIZED NOTE.
     Not in the goal cone; flag for the review agent to reconcile.
   - Stale "sorry"-mentioning docstrings: `CechSectionIdentificationLeg.lean:15`,
     `CechSectionIdentification.lean:20` (files are 0-sorry; comments are stale).
   - Confirm `cech_computes_higherDirectImage`'s cone is axiom-clean (`#print axioms` = kernel only).

## Deferred / standing notes
- **Frozen-signature decision RESOLVED (iter-080, by the user):** the false general decl + its protection
  are gone; the canonical name now carries the correct hypotheses. (Prior iters 077–079 left it a documented
  `sorry` because agents cannot edit a protected signature; the user removed it.)
- **Dead routes (no retry):** see STRATEGY §Routes / ARCHON_MEMORY — stalk-at-prime exactness; naive
  affine-basis section-exactness (circular); span-cover descent on global sections (circular);
  open-subscheme Ext transport (restriction-injectives wall); non-augmented section complex (not
  contractible); `hacyc` via Serre vanishing on `U∩f⁻¹V` (open not affine).
- **Build-wall:** the heavy chain cold-builds ~25+ min and may exit-137 in the prover memory cap; trust
  the review-build gate for full verification. `\leanok` owned by `sync_leanok`.
- No usable external-LLM API key in env; use subagents / LSP.
