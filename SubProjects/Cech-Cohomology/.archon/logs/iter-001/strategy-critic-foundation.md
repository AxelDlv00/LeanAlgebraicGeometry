# Strategy Critic Directive

## Slug
foundation

## Project goal

Formalize, in Lean 4 / Mathlib, the **Čech computation of higher direct images** of a
quasi-coherent sheaf. The single protected, frozen-signature target is
`AlgebraicGeometry.cech_computes_higherDirectImage`
(blueprint `lem:cech_computes_cohomology`): for `f : X ⟶ S` separated and
quasi-compact, `F : X.Modules` quasi-coherent, and `𝒰` a finite affine open cover of
`X`, there is an isomorphism (stated in the weak `Nonempty (… ≅ …)` existence form,
under `[HasInjectiveResolutions X.Modules]`) between the `i`-th homology of the
relative Čech complex `(CechComplex f 𝒰 F).homology i` and the derived-functor higher
direct image `higherDirectImage f i F = ((pushforward f).rightDerived i).obj F`.
End-state: zero inline `sorry` in the dependency cone of that theorem, zero project
axioms, kernel-only axioms. This is an extraction from a larger challenge; the
downstream Picard/Quot machinery is OUT of scope. Only the Čech engine and its cone
remain.

## Strategy under review

```
# Strategy

## Goal

Formalize the **Čech computation of higher direct images** of a quasi-coherent sheaf:
`AlgebraicGeometry.cech_computes_higherDirectImage` (`lem:cech_computes_cohomology`).
For `f : X ⟶ S` separated and quasi-compact, `F` quasi-coherent, and `𝒰` a finite affine
open cover of `X`, the cohomology sheaves of the relative Čech complex `Č•(𝒰, F)` are
canonically isomorphic to `Rⁱ f_* F` wherever the derived functor is defined; over an
affine base this recovers `Hⁱ(X,F) = H⁰(S, Rⁱ f_* F)`.

End-state: zero inline `sorry` in the 12-node dependency cone of the seed, 0 project
axioms, kernel-only axioms. This is an extraction from the Algebraic-Jacobian challenge,
where this Čech engine is the **unconditional** cohomological substrate (no enough-injectives
hypothesis) underneath FGA representability of the relative Picard scheme. That downstream
Picard/Quot/RR/Albanese machinery is out of scope here and was carved away.

## The construction (Stacks Project, Cohomology of Schemes)

Three pieces, all in `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`:

1. **Čech nerve + complex** (`def:cech_nerve`, `def:cech_complex`,
   `def:relative_cech_complex_of_nerve`) — the cosimplicial direct-image object of an affine
   cover and the cochain complex obtained by global sections; degree `p` is the product of
   pushforwards of `F` over the `(p+1)`-fold intersections.
2. **`pushPull` transport** (`def:push_pull_obj`, `def:push_pull_map`, `lem:push_pull_functor`,
   `lem:push_pull_unit_mate`, `lem:push_pull_transport_cancel`, `def:cover_arrow`,
   `def:cover_cech_nerve`) — functoriality of the pushforward-along-cover assignment.
3. **Affine acyclicity** (`lem:cech_acyclic_affine`) — Serre vanishing of the Čech complex of
   a standard cover of an affine (Stacks 02KG), the input that makes the Leray spectral
   sequence degenerate and yields the comparison.

## Phases & risks

| Phase | Status | Key Mathlib needs | Risks |
|---|---|---|---|
| `pushPull` functor laws | `pushPullMap_id` landed; `pushPullMap_comp` open | generalized `eqToHom`-cancellation that is kernel-cheap | **DEFINITIONAL, not mathematical**: a kernel `whnf` blow-up on the `eqToHom` over-triangle transports in `pushPullMap`. Option (a) transport-light def refactor if the cheap cancellation lemma does not suffice. |
| affine acyclicity | `sorry` | Serre vanishing / Čech vanishing for QCoh on affines (Stacks 02KG); `Algebra.lemma-cover-module` analog | may need explicit Koszul/standard-cover bookkeeping |
| comparison theorem | `sorry` | two spectral sequences for `Scheme.Modules` (Leray + affine vanishing), absent from Mathlib | DOMINANT pole — gated on the spectral-sequence inputs; the existence-only `Nonempty (… ≅ …)` form keeps coherence obligations minimal |

## Posture

The composition law `pushPullMap_comp` is the rate-limiter; weight effort there. The
comparison theorem is stated in the weak **existence** form (`Nonempty (… ≅ …)`), not a
chosen natural iso — all the original downstream consumers needed only object-level
agreement, so no canonical-naturality coherence is pursued.
```

## References index

```
# References

This subproject was extracted from the Algebraic-Jacobian challenge; only the source
cited by the kept Čech-cohomology chapter is retained.

| File | Description |
| ---- | ----------- |
| stacks-coherent.md → stacks-coherent.tex | Stacks ch.30 "Cohomology of Schemes". The source for the entire chapter. Tags: 02KE (lemma-cech-cohomology-quasi-coherent — Čech computes cohomology when all intersections are affine), lemma-cech-cohomology-quasi-coherent-trivial (standard-cover Čech vanishing), 02KG (lemma-quasi-coherent-affine-cohomology-zero — Serre vanishing for quasi-coherent sheaves on affines), and lemma-quasi-coherence-higher-direct-images-application (H^q(X,F) = H^0(S, R^q f_* F) for affine S). Backs def:cech_nerve, def:cech_complex, lem:cech_acyclic_affine, and the comparison theorem lem:cech_computes_cohomology. Large file: jump to line. |
```

## Blueprint summary

- `blueprint/src/chapters/Cohomology_HigherDirectImage.tex` — the derived-functor
  definition `higherDirectImage f i F = ((pushforward f).rightDerived i).obj F` (the
  RHS the comparison theorem compares the Čech complex against). One definition.
- `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` — the whole Čech engine:
  Čech nerve/complex of an affine cover, the push-pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules`,
  `p ↦ p_* p^* F` (object/morphism bricks + functor laws `pushPullMap_id`/`pushPullMap_comp`
  + mate lemmas), affine acyclicity `CechAcyclic.affine` (Stacks 02KG), and the comparison
  theorem `cech_computes_higherDirectImage` (Stacks 02KE).

## Prior critique status

no prior critique

## Specific concerns I want pressure-tested (in addition to your standard checklist)

1. **Is the spectral-sequence route the only way to the EXISTENCE statement?** The
   comparison theorem's blueprint proof invokes TWO spectral sequences (a Čech-to-cohomology
   SS and the Leray SS) for `Scheme.Modules`, both declared absent from Mathlib. Building
   spectral-sequence machinery for sheaves of modules on schemes is potentially enormous.
   Since the GOAL is only the weak `Nonempty (homology i ≅ rightDerived i)` existence form,
   is there a lighter mathematical route — e.g. exhibiting the augmented Čech complex as an
   `f_*`-acyclic resolution and invoking "an acyclic resolution computes the right-derived
   functor" (does Mathlib's `CategoryTheory.Abelian`/`Functor.rightDerived` API provide this?),
   or a universal δ-functor / effaceability comparison — that avoids constructing spectral
   sequences at all? If so this is a route the strategy omits.

2. **Three independent absent-infrastructure blockers — feasibility.** All three phases
   (pushPull pentagon coherence; standard-cover localisation complex + prime-local contracting
   homotopy; the two spectral sequences) require infrastructure not in Mathlib. Is the project
   as scoped feasible, and is the decomposition the right one, or is there a re-decomposition
   that shares more infrastructure / removes a blocker entirely?

3. **`pushPullMap_comp` as "rate-limiter".** The strategy weights effort on the pushPull
   pentagon (a definitional/coherence problem that stalled ~5 iters in the parent project).
   But even closing it only unblocks `CechNerve`/`CechComplex`; the comparison theorem and
   affine acyclicity remain blocked on separate infrastructure. Is "rate-limiter" the right
   framing, or is the comparison theorem's spectral-sequence dependency the true dominant pole
   that should be de-risked FIRST (since it may invalidate the whole approach)?
