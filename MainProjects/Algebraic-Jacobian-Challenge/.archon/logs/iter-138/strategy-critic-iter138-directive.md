# Strategy Critic Directive

## Slug
iter138

## Project goal

Formalize the nine protected declarations of Christian Merten's Jacobian
challenge (`references/challenge.lean`):

| File | Declaration |
|---|---|
| `Genus.lean` | `AlgebraicGeometry.genus` |
| `Jacobian.lean` | `AlgebraicGeometry.Jacobian`, `Jacobian.instGrpObj`, `Jacobian.smoothOfRelativeDimension_genus`, `Jacobian.instIsProper`, `Jacobian.instGeometricallyIrreducible` |
| `AbelJacobi.lean` | `Jacobian.ofCurve`, `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp` |

All nine signatures are frozen. `nonempty_jacobianWitness` quantifies
over an arbitrary curve `C : Over (Spec (.of k))` with `[SmoothOfRelativeDimension 1 C.hom]`
— no genus parameter, no `k`-rational-point hypothesis.

End-state: **zero inline `sorry` in the project**, no named axioms.

## Strategy under review

(See file `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md`.)

The current STRATEGY.md spans 581 lines. Read it verbatim from disk.

## References index

```
| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — formal statement of the missing definitions/theorems for the Jacobian. Lean skeleton in `AlgebraicJacobian/` decomposes this file; signatures here are authoritative. |
```

## Blueprint summary

- `AbelJacobi.tex`: The Abel--Jacobi map
- `AlgebraicJacobian_Cotangent_GrpObj.tex`: Cotangent space at the identity (piece (i) — Lean file pointer chapter)
- `Cohomology_MayerVietoris.tex`: Mayer--Vietoris LES for sheaf cohomology with `k`-module coefficients
- `Cohomology_SheafCompose.tex`: Sheaf condition along the structure-sheaf forget composite
- `Cohomology_StructureSheafAb.tex`: Structure sheaf as a sheaf of abelian groups, sheafification + Ext
- `Cohomology_StructureSheafModuleK.tex`: Sheaves of `k`-modules: sheafification, Ext, structure sheaf as `k`-module sheaf
- `Differentials.tex`: The relative cotangent presheaf
- `Genus.tex`: Genus of a smooth proper curve
- `Jacobian.tex`: The Jacobian as an abelian variety
- `Rigidity.tex`: Rigidity for morphisms of schemes (scheme-level Mumford §4)
- `RigidityKbar.tex`: Rigidity over a base field `k`: morphisms from a genus-0 curve to a group scheme are constant. **This is the central blueprint chapter for the M2 critical path; it carries pieces (i)+(ii)+(iii) of the cotangent-vanishing pile.**

## Prior critique status

You have been dispatched in prior iters. The following items from prior verdicts are carried forward and you should re-verify (per the iter-138 mandatory re-verification directive):

- **Iter-137 Edit #1**: piece (i.c) sequencing-table row split into 3 sub-rows (i.c.1 chart-localisation ~100–200 LOC, i.c.2 `omega_free` ~50–150 LOC, i.c.3 `omega_rank_eq_dim` ~50–150 LOC). Absorbing your iter-137 CHALLENGE on piece (i.c) bundling.

- **Iter-137 Edit #2**: piece (i.b) sequencing-table row revised to show per-step LOC: Step 1 ~50 DONE iter-134 + Step 2 ~360–710 (revised by iter-137 mathlib-analogist) + Step 3 ~27 DONE iter-136 + Main Compose ~20–40 iter-138+. Total ~410–810 LOC across iter-134→iter-138 (3–5 iter envelope).

- **Iter-137 Edit #3**: gap-inventory entry for piece (i.b) Step 2 revised with iter-137 analogist's universal-property-at-presheaf-level route + ~360–710 LOC envelope + persistent-file pointer + renormalised LOC trigger arm.

- **Iter-137 Edit #4**: trigger (a')/(c) LOC arm renormalised from 600 LOC cumulative to 1000 LOC cumulative (the iter-134 cap was calibrated against iter-133's 150–300 LOC envelope which Mathlib's `PresheafOfModules.pullback` opacity rules out; renormalisation prevents sunk-cost-shaped over-revert on the envelope itself). Non-LOC components of trigger (a') retained unchanged.

- **3 minor alternatives REBUTTED-WITH-SCOPE-NOTE in iter-137**: (i) piece (i.c) sub-decomp (tied to CHALLENGE, ADOPTED), (ii) pre-commit path (b) of iter-139/140 consult, (iii) over-k re-frame to "operationally defaulted, bounded revert cost", (iv) genus-1 fast path within M3.

**Re-verify each of these is still sound. The iter-137 prover lane on Step 2 returned PARTIAL (no body change; documented inverse-direction-via-adjunction-transpose alternative route). Sorry count unchanged 5. Re-evaluate the over-k commitment defense (grounds (ii) blueprint cleanliness + (iv) piece (i.a) tractability), the piece (i.b) renormalised LOC trigger arm, the iter-139/140 `Differential.ContainConstants` alignment schedule, and any other strategic decision the iter-137 PARTIAL signal would call into question.**

NB: I am NOT giving you iter-138 prover-lane scope ideas. Your job is the STRATEGY level: routes, prerequisites, sunk costs, alternatives. The plan agent will dispatch progress-critic separately for the convergence question.
