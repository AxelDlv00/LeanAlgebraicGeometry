# mathlib-analogist directive — Pic⁰ via ker(deg) pivot consult

## Slug
`pic0-ker-deg-pivot`

## Mode
`api-alignment`

## Strategic question

The project's positive-genus arm (Route A) defines
`Pic⁰_{C/k}` canonically as the **identity component** of the Picard
scheme `Pic_{C/k}` (Stacks 04KU/04KV). This requires:

1. The identity component construction for a smooth group scheme
   (`IdentityComponent` def at
   `AlgebraicJacobian/Picard/IdentityComponent.lean`).
2. A theorem `geometricallyConnected_of_connected_of_section` that
   shows the identity component (or any component carrying a
   `k`-rational section) is geometrically connected.

Phase A.3.i (IdentityComponent + geom-connectedness) has been
PARKED for ~4 iters at ~0/iter velocity. Stacks 04KU / 04KV are NOT
shipped in Mathlib `b80f227`; project-side they would be ~350 LOC of
Mathlib-upstream-grade work. Iter-195 progress-critic flagged this
as a strategic risk.

**The alternative under analysis**: define
`Pic⁰_{C/k} := ker(deg : Pic_{C/k} → ℤ_{C/k})`
where `deg` is the degree map (Phase A.3.vii in STRATEGY). This
bypasses Stacks 04KU/04KV entirely. The equivalence
"ker(deg) = identity component" can be proved post-hoc when
04KU/04KV land — and crucially, the project's downstream use of
Pic⁰ does not need to wait for that equivalence.

## What I need from you

A **DECISION-GRADE** recommendation: should the project pivot from
identity-component Pic⁰ to ker(deg) Pic⁰?

### Specific questions

1. **Mathlib alignment**: Is there a canonical Mathlib idiom for
   "the kernel of a morphism of group schemes" / "the kernel of a
   morphism of sheaves of abelian groups in the Picard setting"?
   - Search for: `Mor.ker`, `Subgroup`, `MorphismProperty.kernel`,
     `AlgebraicGeometry.Scheme.Hom.kernel`, group-scheme kernel
     definitions in Mathlib's algebraic-geometry hierarchy.
   - If Mathlib has it: name + signature + how to invoke.
   - If Mathlib doesn't have it: how is it ALMOST achieved? Is
     there a `GroupObject` kernel pattern that ports?

2. **Equivalence of definitions in the literature**: Confirm or
   refute the claim "`ker(deg) = identity component` for proper
   smooth group schemes over a field". Cite sources:
   - Mumford, *Abelian Varieties* §7 / §12 (degree map on a Jacobian)
   - Kleiman, *The Picard scheme* §5.2 / §5.4
   - Milne, *Abelian Varieties* §I.7 / §III.6
   Read the local PDFs at `references/` (e.g. `kleiman-picard.pdf`,
   `mumford-abelian-varieties.pdf`, `abelian-varieties.pdf` for
   Milne); cite the page or section number that says this.

3. **Project-side cost**: Estimate the LOC and iter budget for
   building `Pic⁰_{C/k} := ker(deg)` directly under Cartier route
   assumption:
   - Pre-requisites: A.3.vii degree map (currently ~80-200 LOC,
     gated); the kernel construction for a group-object morphism in
     a category with finite limits (Mathlib has this for
     `MonoidHom.ker` but not for scheme morphisms directly).
   - Downstream impact: the `Pic⁰ AbelianVariety` chapter
     (`Pic0AbelianVariety`) currently uses A.3.i; how disruptive is
     the swap?

4. **Verdict**: One of
   - `ALIGN_WITH_MATHLIB` — Mathlib idiom exists, port to it.
   - `STRUCTURAL OK` — Mathlib does not have the exact idiom but the
     project-side construction is small (≤ ~150 LOC), well-aligned
     with existing Mathlib patterns, and clearly cheaper than Stacks
     04KU/04KV.
   - `STRUCTURAL CONCERN` — buildable but more expensive than
     identity-component approach OR introduces a cycle / cross-
     coupling.
   - `REJECT` — the alternative is mathematically wrong (e.g. the
     equivalence fails outside the field-of-constants case).

If your verdict is `ALIGN_WITH_MATHLIB` or `STRUCTURAL OK`, recommend
a concrete iter-198+ work-plan: which file gets the ker(deg) def,
what the signature looks like, and how the existing
`Pic0AbelianVariety.lean` consumers update.

If `REJECT` or `STRUCTURAL CONCERN`, name the showstopper precisely
(missing Mathlib lemma, mathematical subtlety, downstream cycle).

## Read-only constraint

You are read-only. Write only your task_results report and the
persistent analogy file `analogies/pic0-ker-deg-pivot.md`. Do NOT
modify Lean files or blueprint chapters.

## References to consult

- `references/kleiman-picard.pdf` (Kleiman, "The Picard scheme") — §5
  on Pic⁰.
- `references/mumford-abelian-varieties.pdf` (Mumford, "Abelian
  Varieties") — §7 / §12 on the Jacobian's degree map.
- `references/abelian-varieties.pdf` (Milne, "Abelian Varieties") —
  §I.7 / §III.6.
- Local Stacks excerpts (none in `references/` for 04KU/04KV;
  WebFetch the canonical Stacks page if needed for the equivalence
  claim).
- Project files:
  - `AlgebraicJacobian/Picard/IdentityComponent.lean` (current
    A.3.i implementation, parked).
  - `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean` (current
    downstream consumer of A.3.i).
  - `AlgebraicJacobian/Picard/FGAPicRepresentability.lean` (the
    Pic functor / scheme representability infrastructure).

## Output

- Persistent file: `analogies/pic0-ker-deg-pivot.md` — your
  full structural analysis (visible to all future iters).
- Task result: `task_results/mathlib-analogist-pic0-ker-deg-pivot.md`
  — the executive summary + verdict.

## Out of scope

- Closing any sorry.
- Editing STRATEGY.md (the plan agent does that based on your verdict).
- Investigating any other Mathlib idiom (Pic^d, Cartier divisors,
  base-change of Proj, etc.) — those are separate consults.
