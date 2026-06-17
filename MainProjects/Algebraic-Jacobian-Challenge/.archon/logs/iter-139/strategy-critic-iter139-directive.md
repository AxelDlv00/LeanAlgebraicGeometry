# Strategy Critic Directive — iter-139

## Project goal (verbatim from STRATEGY.md § "Project goal")

Formalize the nine protected declarations of Christian Merten's Jacobian
challenge (`references/challenge.lean`):

| File | Declaration |
|---|---|
| `Genus.lean` | `AlgebraicGeometry.genus` |
| `Jacobian.lean` | `AlgebraicGeometry.Jacobian`, `Jacobian.instGrpObj`, `Jacobian.smoothOfRelativeDimension_genus`, `Jacobian.instIsProper`, `Jacobian.instGeometricallyIrreducible` |
| `AbelJacobi.lean` | `Jacobian.ofCurve`, `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp` |

All nine signatures are frozen. `nonempty_jacobianWitness` quantifies
over an arbitrary curve `C : Over (Spec (.of k))` with
`[SmoothOfRelativeDimension 1 C.hom]`; no $k$-rational-point hypothesis.
Substrategies depending on `C(k) ≠ ∅` are mathematically false on the
protected signature.

End-state target: **zero inline `sorry` in the project**, no named axioms.

## Reference index (verbatim from `references/summary.md`)

| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |

## Blueprint chapters (titles + one-line topic, derived from chapter `\chapter{...}` headers)

- `AbelJacobi.tex` — The Abel--Jacobi map (Layer II of the Albanese-framework formalisation).
- `AlgebraicJacobian_Cotangent_GrpObj.tex` — Cotangent space at the identity (piece (i) — Lean file `Cotangent/GrpObj.lean`).
- `Cohomology_MayerVietoris.tex` — Mayer--Vietoris long exact sequence for sheaf cohomology with $k$-module coefficients.
- `Cohomology_SheafCompose.tex` — Sheaf condition along the structure-sheaf forget composite.
- `Cohomology_StructureSheafAb.tex` — `O_X` viewed as a sheaf of abelian groups (precursor to ModuleCat-coefficients).
- `Cohomology_StructureSheafModuleK.tex` — `O_X` viewed as a sheaf of `k`-modules (final-form coefficients).
- `Differentials.tex` — Relative differentials on schemes (presheaf-of-modules form), bridge to algebra-side Kähler differentials.
- `Genus.tex` — Definition of the arithmetic genus of a curve over `k`.
- `Jacobian.tex` — Jacobian via Albanese witness (Layer I + the genus-stratified body of `nonempty_jacobianWitness`).
- `Rigidity.tex` — Rigidity-over-`k̄` formulation (the auxiliary tool over algebraic closure).
- `RigidityKbar.tex` — Rigidity-over-`k` formulation (the chosen target per the iter-127 over-k commitment, supplies the piece-(i.b) main lemma + ancillaries).

## Current `STRATEGY.md`

The full STRATEGY.md is in the project at `.archon/STRATEGY.md` (~583
lines). Read it directly via the Read tool. It is the primary subject
of this review.

## Your task

Re-verify the strategy as a fresh mathematician would. Specific
verification asks for iter-139:

1. **Re-verify last iter's STRATEGY.md edits (iter-138 absorbed 4
   strategy-critic challenges).** Are the resulting clauses internally
   consistent? Specifically:
   - Edit 1 (LOC trigger arm renormalisation discipline): does the
     codified rule actually constrain the planner, or is it
     ceremonially-shaped without enforcement?
   - Edit 2 (fibre-free pivot 750 → 1000 LOC + iter-138-close 4-axis MUST
     re-eval): now that iter-138 prover lane has returned with measured
     LOC (~92 LOC body + ~50 LOC docstring; ~408 LOC cumulative on
     (i.b)-side iter-134→iter-138), does the trigger arithmetic still
     reconcile? The 4-axis re-eval is one of the iter-139 watch criteria.
   - Edit 3 (over-k reframing as "operationally defaulted, bounded
     revert cost preserved"): iter-138 returned PARTIAL — Edit 3's
     conditional ground extension is paused; does the "if PARTIAL,
     iter-139 plan phase auto-flags for explicit re-discussion" gate
     fire this iter, and if so, what should the re-discussion produce?
   - Edit 4 (piece (iii) upstream-PR-extraction lane named, decision
     deferred pending iter-138 ℙ¹-hedge analogist): the analogist
     returned **NOT-VIABLE** for the hedge. STRATEGY.md says "PR lane
     opens iter-144+ alongside in-tree build (no further deferral)" —
     is this conclusion sound given the analogist's verdict, or is the
     PR lane itself now in question?
2. **Audit the piece (i.b) Step 2 status.** Iter-138 closed PARTIAL
   with structural body cut: the iter-137 Route (b) skeleton landed
   with d_add + d_mul of the pointwise derivation; three sub-sorries
   remain (d_app, d_map, IsIso). Is the iter-139 plan ("close the two
   derivation sub-sorries d_app + d_map in one prover lane,
   ~60–160 LOC; dispatch a mathlib-analogist on Route (a) vs Route
   (b'2) for the IsIso closure in iter-140") mathematically sound and
   strategically right? Or should the planner instead bundle d_app +
   d_map + IsIso in one go (or split them differently)?
3. **Goal-alignment check.** Even if every milestone in the roadmap
   closes substantively, does the resulting Lean state actually
   discharge the 9 protected declarations cleanly? Look for any subtle
   gap between the strategy's planned end-state and the goal as
   stated.
4. **Sunk-cost smell on Route (b).** The strategy now favours Route
   (b) (inverse-direction-via-adjunction-transpose) for Step 2.
   Iter-138 explicitly chose Route (b) over Route (a) (the iter-137
   analogist's PRIMARY) for tactical reasons (chart-unfolding helper
   in Route (a) hits the same opacity blocker). Is this drift a
   sound pivot, or a sunk-cost defense of a choice made under
   tactical pressure?
5. **Alternative routes the strategy doesn't mention.** What other
   approaches to closing piece (i.b) Step 2 (or piece (i.b) as a
   whole, or M2.a as a whole) does the strategy not even consider,
   and why might they be cheaper / sounder / more upstream-PR-aligned?

## Format

Use the standard strategy-critic output: per-route verdict
(SOUND / CHALLENGE / REJECT), then sunk-cost-flag list, then minor
alternatives. Be specific about what the planner should change.
