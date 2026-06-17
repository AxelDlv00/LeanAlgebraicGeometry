# Strategy-critic directive — iter-016 (Quot-Foundations)

Fresh-context review of the project strategy. Read STRATEGY.md as a mathematician seeing it
for the first time; challenge sunk-cost and structural soundness.

## Project goal (one paragraph)
Close the seven `sorry`-bearing nodes of the Čech-independent leg of the parent's
`thm:fga_pic_representability` cone (Kleiman, "The Picard scheme", FGA §4), then merge back:
flat base change of `f_*` at i=0 (`thm:flat_base_change_pushforward`), generic flatness
(`thm:generic_flatness` + algebraic core), and the Quot foundations
(`def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`,
`thm:grassmannian_representable`). End-state: zero project `sorry` in the closure, zero
project axioms, kernel-only axioms; names/labels match the parent so finished work merges back.

## Read these (and nothing else as "what we tried")
1. `STRATEGY.md` (verbatim — the object under review).
2. `references/summary.md` (the source index).
3. Blueprint chapter titles + one-line topics:
   - `Cohomology_FlatBaseChange.tex` — flat base change of the pushforward of a QCoh sheaf (i=0).
   - `Cohomology_RegroupHelper.tex` — the regroup iso `(A⊗_R R')⊗_A M ≅ R'⊗_R M`.
   - `Picard_FlatteningStratification.tex` — generic flatness / flattening stratification.
   - `Picard_GrassmannianCells.tex` — Grassmannian big cells + cocycle (DONE).
   - `Picard_QuotScheme.tex` — Quot functor, Hilbert polynomial, graded Hilbert–Serre rationality.
   - `Picard_RelativeSpec.tex` — relative Spec (RepresentableBy route).

## Focus this iter (the changed strategy)
The QUOT graded-rationality route was PIVOTED this iter (see STRATEGY.md "QUOT route" +
SNAP-S2 row + Mathlib gaps). The iter-014 plan (build `K=ker x`, `C=M/xM` as graded modules
over the quotient ring `R/(x)`, blocks G2/G3/G4) hit a hard Mathlib `isDefEq`/`whnf`
non-termination (2M heartbeats) on any `DirectSum.Decomposition` over a quotient/subtype
carrier. The pivot ("Route 2") runs the Stacks-00K1 induction over pairs of ambient
homogeneous submodules `N'≤N` of a fixed graded κ-module with `r` commuting degree-+1 endos,
with an ambient Hilbert-difference function, so no derived-carrier graded object is built.

## Questions
- Is Route 2 a SOUND realization of graded Hilbert–Serre rationality (Stacks 00K1)? In
  particular: is the subquotient class genuinely closed under ker/coker of a degree-1 endo,
  and does the `(⊤,⊥)` instantiation recover `dim_κ Mₙ`? Any hidden hypothesis missing
  (e.g. the degree-1 generator count `r`, finite-dimensionality of components)?
- Are the other routes (FBC seams, GF dévissage, QUOT-defs, QUOT-repr) still sound, or does
  any carry a structural error / mis-scoped Mathlib dependency / unnecessary case split?
- Estimation realism: FBC-A revised to 1–3, GF-alg 1–3, SNAP-S2 2–3. Are these honest?
