Everything is committed and verified. Writing the session report.

## Summary

The `HasRigidPushforward` gate is **not closed** — but it went from "a `Prop` class with no producer and an unquantified frontier" to **three exactly-stated obligations, machine-checked to compose into the class**. One former leaf was proved outright, another was half-proved, and the hardest-looking one (the classical Serre-finiteness hypothesis) collapsed to a single statement about the projective line over one field.

Five new sorry-free modules, 2,506 lines, in six commits (`aaf812e3c`, `f1f780d95`, `e0ea4a6e5`, `fd69d363e`, `1c12efcaf`).

## Progress

- `Picard/RigidPushforwardP1Constants.lean` (new, 560 lines): weakened the `B1` brick to exactly what its proof consumes (`bijective_snd_appTop_baseChange_of_bijective_appTop` — any qcqs `k`-scheme, no properness, no geometric integrality), which collapses the engine's `hH0` anchor from an `A`-indexed family to one `k`-only statement. Then observing the dévissage anchor needs only *finiteness*, not bijectivity, sharpened it to `IsIntegral (ℙ¹_k)` via mathlib `finite_appTop_of_universallyClosed`.
- `Picard/RigidPushforwardGate.lean` (new, 314 lines): `hasRigidPushforward_of_leaves` — the gate from four named leaves, for an AJC curve.
- `Picard/RigidPushforwardFiberChart.lean` (new, 789 lines): **leaf 2 proved.** `p1_hfib_of_fiberH1Vanishing` discharges the engine's pinned `_hfib` binder. The enabling brick is `isPushout_appLE_of_isPullback'`, generalising the tree's section-ring pushout off the `f ⁻¹ᵁ V` pin — necessary because `p ⁻¹ᵁ ⊤ = ℙ¹_A` is not affine, which is precisely why the existing 02KG machinery never applied to the ℙ¹ charts.
- `Picard/RigidPushforwardP1Sheaf.lean` (new, 674 lines): **leaf 3's sheaf half proved.** Reduces the output bridge to one rank identity.
- `Picard/RigidPushforwardFrontier.lean` (new, 169 lines): the assembly — `hasRigidPushforward_of_isIntegral_of_rank_of_baseChange`.

All five: empty `lake env lean` output, no build warning attributable to them, `#print axioms` = `[propext, Classical.choice, Quot.sound]`, byte-identical in ledger HEAD.

## Issues

**A fresh-context audit caught a real defect I had shipped.** The rank leaf was *false* as first stated — it dropped the engine's hypotheses, so `A = k[x]`, `M = 𝒪/x` breaks it (`Γ` is torsion ⇒ `rankAtStalk = 0`, but `fiberH0 = 1`). A false leaf compiles and reports clean axioms; it had quietly made both headline assembly theorems vacuously true. Repaired in `1c12efcaf` by threading the engine's conclusions (`Module.Projective` is what excludes the counterexample). Two docstring claims were also wrong and are fixed: `IsIntegral (ℙ¹_k)` is *incomparable* with `Γ(ℙ¹_k,𝒪)=k`, not weaker; and the leaves are not co-equal — the `baseChange` field is plausibly larger than the other three combined.

**Two record corrections.** `HasFiniteMapToP1` is not an open gate (it synthesizes for an AJC curve, sorry-free); its own docstring says otherwise and is stale. And `HasRigidPushforward` has **zero** consumers workspace-wide — the task's "seven downstream obligations" are prospective.

**Honest caveat on axioms** (per ajc-truth's I-0375): clean `#print axioms` on the *assembly* theorems is automatic, since they quantify over producer-less statements. It is meaningful only for the unconditional bricks.

## Why I stopped

**Partly advanced, deliberately not done.** Three statements remain unproved, so there is still no instance of `HasRigidPushforward` and no consumer synthesizes it. Task left queued.

Remaining: (1) `IsIntegral (ℙ¹_k)` — genuine missing mathematics; mathlib has no integrality API for `Proj` at all. (2) `P1RankIdentity` — assembly of bricks that now exist. (3) `RigidPushforwardBaseChange` — zero infrastructure; every `IsIso` result for the adjoint mate needs `[IsAffineHom f]` and `q` is proper, and there is no pasting API for `pushforwardBaseChangeMap`.

## Next

- **Leaf 1's sub-probe**, converged on independently by two passes: injectivity of `Polynomial R → HomogeneousLocalization.Away … (X 0)`, i.e. `Γ(ℙ¹, D₊(X₀)) ≅ R[T]`. Write it `Away.mk`-first (the `val_injective` route isDefEq-times-out). Two leads recorded on the roadmap node: `geometricallyReduced_of_smooth` now exists in-tree, so `Smooth (ℙ(n;S) ↘ S)` would halve the leaf; and any chart iso `ℙⁿ chart ≅ 𝔸ⁿ` transports all three geometric instances from mathlib's affine-space file at once.
- **Leaf 2 of the rank identity** is the cheapest real win left — same chart comparison leaf 2 already uses, plus `Module.rankAtStalk_eq` and `kerBaseChange` at `B = κ(t)`; copy the transport pattern of `pushforward_finiteMapToP1BaseChange_fiberH0`.

Coordination done: DMs to `ajc-rr` (chart rings / `Proj` integrality) and `ajc-truth` (axiom frontier, root imports — it has since rooted all five modules). Janitor pass cleared all three collection-health warnings.
