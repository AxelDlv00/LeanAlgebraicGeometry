# Mathlib Analogist Directive — iter-150 (cross-domain-inspiration)

## Mode

cross-domain-inspiration

## Slug

h1cotangent-vanishing-iter150

## Structural problem

The project needs to prove (or sidestep) the following Mathlib-gap-heavy statement:

> For a smooth proper geometrically irreducible scheme `X` over a field `k`, the structure sheaf cohomology in degree 0 is the base field:
>
>     `Γ(X, O_X) ≅ k` as `k`-algebras.

The current closure path (path (b)) decomposes this into four sub-claims (S3.sep.1) (S3.sep.2) (S3.pi.1) (S3.pi.2), with (S3.pi.1) being the load-bearing flat-base-change content.

**The downstream consumer** of `Γ ≅ k` is `rigidity_over_kbar` in `AlgebraicJacobian/RigidityKbar.lean`. The chain goes:

1. `df_zero_factors_through_constant_on_chart` (consumer of the chart-algebra envelope) needs to conclude that any chart-algebra-map `b : B` with `KaehlerDifferential.D b = 0` lies in the image of `algebraMap k B`.
2. The constant-extraction packaging then propagates this to scheme-level `Scheme.Over.ext_of_diff_zero`.
3. This is consumed by `rigidity_over_kbar`'s body to derive that two `X → A` morphisms equal on an open subset are globally equal (an Albanese rigidity step).

**Mathlib already has** the typeclass `Algebra.H1Cotangent A B` and an instance-producer `Algebra.FormallySmooth.subsingleton_h1Cotangent : Algebra.FormallySmooth A B → Subsingleton (Algebra.H1Cotangent A B)`. This raises the question: can the chart-algebra closure chain consume `Subsingleton (Algebra.H1Cotangent k B)` directly, **without** routing through the `Γ ≅ k` global statement?

The mathematical content is the same (both express the cotangent-vanishing condition that smooth + proper imposes), but the API surface is wildly different: `Γ ≅ k` is a scheme-level cohomology computation requiring proper-base-change infrastructure; `H1Cotangent` vanishing is a ring-theoretic / module-theoretic typeclass condition expressed locally on the chart algebras.

## Failed approaches

- **Path (a) BUILD proper-Γ-flat-base-change in-tree**: ~250–300 LOC; requires substantial Čech-equaliser + flat-tensor-exactness chase. Stacks Tag 02KH H^0 row content. Mathlib snapshot b80f227 ships neither `AlgebraicGeometry.IsBaseChange` namespace nor `R^iπ_*` for proper π. Underlying obstacle: no Mathlib infrastructure for the proper-base-change theorem.

- **Path (b) SMART PROOF via four (S3.*) sub-claims**: ~310–550 LOC; (S3.pi.1) is the SAME Mathlib gap as path (a) step (e). The genuine advantage is sub-claim independence ((S3.sep.*) and (S3.pi.*) can close in parallel) and tighter Mathlib citation surface, but (S3.pi.1) remains an ~150–250 LOC structured-sorry blocker even when (S3.sep.*) + (S3.pi.2) close. Iter-149 status: 0/4 bodies closed; all 4 are PARTIAL scaffolds.

- **KDM (p2) char-0 bridge inside `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`**: project-built bridge from the universal Kähler derivation `D : B → Ω_{B/k}` to family of coefficient derivations `∂_i : B → B` via `Algebra.IsStandardSmooth.free_kaehlerDifferential` basis projection. (BR.2)–(BR.4) scaffolded iter-149; (BR.5) joint-kernel collapse remains structured sorry. Underlying obstacle: Mathlib's `Differential.ContainConstants` typeclass is positioned for a SINGLE derivation `b' : B → B`, not for the INTERSECTION of multiple coordinate-derivation kernels. The kernel of one `∂_i` alone is strictly larger than `range (algebraMap k B)` (e.g. `B = k[x_1, x_2]`, `∂_1 = ∂/∂x_1`, `ker ∂_1 = k[x_2] ⊋ k`); the joint-kernel collapse requires a coordinate induction.

## Search radius

`wide` — any Mathlib domain. Specifically, we want to know:

1. Does Mathlib have an alternative API for "Γ(X, O_X) ≅ k for smooth proper geometrically irreducible X/k" that bypasses the proper-base-change machinery (e.g. via `Algebra.FormallySmooth` + `Algebra.IsLocalRing.isField_of_universallyClosed`)?

2. Does Mathlib have a "rigidity-of-morphisms-on-smooth-schemes" pattern that the project's `rigidity_over_kbar` could instantiate, where the rigidity criterion is phrased in terms of `H1Cotangent`-vanishing rather than `Γ ≅ k`?

3. Are there structural analogues in other Mathlib areas — e.g. "for a connected compact Hausdorff space X, `C(X, R) ≅ R` when X is a point" (functional analysis), "for a connected finite-type Hopf algebra over a field, the augmentation ideal vanishes" (Hopf algebras), "for a connected formal scheme, the structure sheaf reduces to the base" (formal geometry) — whose proof technique might suggest a more abstract approach?

4. The KDM (BR.5) joint-kernel-collapse problem also wants a cross-domain perspective: how does Mathlib handle "join of derivation kernels = base" in any related setting (Differential Galois? Locally free modules of differentials? `Module.End` of free modules?)?

## What the dispatcher will use this for

The iter-149 plan agent committed to dispatching this consult IF iter-149's prover lane closed ≤1 of the four (S3.*) sub-claims AND the KDM (BR.5) body remained structured sorry. Both conditions are met. The escalation hook fires. The planner needs the analogist's ranked list of structural analogues to decide whether to:

- **Continue path (b)** with the now-decomposed (S3.*) targets, iter-150 prover working on (S3.sep.1)+(S3.sep.2)+(S3.pi.2) and accepting (S3.pi.1) as the long-tail blocker;
- **Pivot to H1Cotangent** by introducing a `rigidity_over_kbar_via_h1cotangent` body that consumes `Subsingleton (Algebra.H1Cotangent A B)` instead of `Γ ≅ k`, requiring a new scheme-level statement of `ext_of_diff_zero` that uses formally-smooth + universally-closed instead of cohomological vanishing;
- **Hybrid** — keep the (S3.sep.*) closures (which are independent of the proper-base-change blocker and useful for downstream Mathlib PRs) but rewrite the chart-algebra consumer to consume `H1Cotangent` directly, dropping (S3.pi.1) + (S3.pi.2) entirely.

## Output format

Per `dispatcher_notes`, your output is a ranked list of structural analogues with:
- The Mathlib citation (file + declaration name + verified-or-not).
- The technique used there.
- A concrete suggestion for porting it to this project's setting.
- An honest assessment of porting cost.

Plus a recommendation among continue / pivot / hybrid.

Persistent output: `analogies/h1cotangent-vanishing-iter150.md` (please name it).

Report: `.archon/task_results/mathlib-analogist-h1cotangent-vanishing-iter150.md`.
