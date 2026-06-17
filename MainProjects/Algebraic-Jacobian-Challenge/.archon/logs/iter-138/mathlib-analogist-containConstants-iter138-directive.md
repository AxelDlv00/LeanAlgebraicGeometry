# Mathlib Analogist Directive

## Slug
containConstants-iter138

## Design question

For the scheme-level argument "`df = 0` for `d : Γ(C, V) → Ω_{Γ(C, V) / Γ(Spec k, U)}`
implies `f` factors through `Spec k`" (piece (ii) of the M2.body-pile,
to be Lean-named `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero`),
which Mathlib idiom should the project align to?

Two paths under evaluation (per STRATEGY.md line 446):

- **(a) `Differential.ContainConstants` typeclass install**: Mathlib's
  `Differential.ContainConstants A B` (`Mathlib.RingTheory.Derivation.DifferentialRing`)
  is keyed on `Differential B` — a derivation `B → B` valued IN `B`
  (NOT in differentials) — with `mem_range_of_deriv_eq_zero` consuming
  `x' = 0`. To use it literally the project would need a `Differential`
  typeclass instance on chart algebras, obtained by selecting a derivation
  `B → B` from the universal `B → Ω_{B/A}` via a splitting.

- **(b) Direct `KaehlerDifferential` exactness route**: pivot piece (ii)
  to route through `KaehlerDifferential` exactness lemmas directly
  (`KaehlerDifferential.exact_mapBaseChange_map` family + a kernel-of-
  derivation argument).

Pin which alignment path is materially cheaper / cleaner / more
Mathlib-idiomatic. The strategy MUST decide this **before** iter-141+
piece (ii) scaffolding (current schedule).

## Project artifact(s) under question

- `AlgebraicJacobian/Rigidity.lean` — `Scheme.Over.ext_of_eqOnOpen`
  (iter-125 refactor); the iter-141+ piece (ii) lemma `ext_of_diff_zero`
  will be its differential-vanishing companion. Currently a PHANTOM in
  the project tree (no scaffold; piece (ii) is not yet scheduled to
  scaffold until iter-141+).

- `blueprint/src/chapters/RigidityKbar.tex` §sec:RigidityKbar_shared_pile
  — names piece (ii) `ext_of_diff_zero` as a NEEDS_MATHLIB_GAP_FILL
  helper. Currently the prose says "ring-level half aligns with Mathlib
  `Differential.ContainConstants`" but this framing is acknowledged as
  loose (STRATEGY.md line 446).

- Mathlib's `Differential B` is `Mathlib.RingTheory.Derivation.DifferentialRing`
  keyed on `Differential B` (the typeclass), not on `KaehlerDifferential B A`.

## Specific questions to answer

1. **(a) `Differential` typeclass install feasibility**: for the project's
   chart algebras `B = Γ(C, V)` over `A = Γ(Spec k, U)` (with
   `[SmoothOfRelativeDimension 1 C.hom]`, `C` smooth proper geom-irr
   curve over `k`), is the `Differential B` typeclass installable?
   What is the LOC cost of the install (derivation-splitting +
   `mem_range_of_deriv_eq_zero` consumer)?

2. **(b) Direct `KaehlerDifferential` exactness route feasibility**:
   does `KaehlerDifferential.exact_mapBaseChange_map` (or the broader
   `KaehlerDifferential` exactness family in
   `Mathlib.RingTheory.Kaehler.*`) provide a direct "df=0 ⇒ factors"
   argument over the same chart algebras, without going through a
   `Differential` typeclass? What is the LOC cost?

3. **LOC comparison**: rank (a) vs (b) by LOC envelope, alignment-with-
   Mathlib quality, and downstream-API-shape implications.

4. **Verdict**: pin path (a) OR (b); state the LOC envelope for the
   chosen path; name the exact Mathlib lemmas it consumes.

5. **Scaffold-shape recommendation**: when piece (ii) `ext_of_diff_zero`
   scaffolds iter-141+, what should its Lean signature look like? Pin
   the type signature, the instance binders, and the body-closure
   pattern (e.g. "build a `Differential B` instance THEN apply
   `mem_range_of_deriv_eq_zero`" vs. "obtain a derivation kernel via
   `KaehlerDifferential.exact_mapBaseChange_map`'s exactness and
   conclude via splitting").

## Persistent file (write target)

`analogies/differential-containConstants-alignment.md` — canonical
persistent file for this design question (no prior file; iter-138
inaugural consult, advanced from iter-139/140 per
`strategy-critic-iter138` Alternative #4 front-load recommendation).

## References

- `references/challenge.lean` — Christian Merten's original challenge.
- STRATEGY.md line 446 — the iter-136 scheduling rationale.
- Mathlib `Mathlib.RingTheory.Derivation.DifferentialRing` — `Differential`
  typeclass + `mem_range_of_deriv_eq_zero` + `ContainConstants`.
- Mathlib `Mathlib.RingTheory.Kaehler.*` — `KaehlerDifferential`
  exactness family.
- `Mathlib.AlgebraicGeometry.Scheme` / `Mathlib.AlgebraicGeometry.AffineScheme`
  for the chart-algebra setup over `[Field k]`.

## Out of scope

- Do NOT propose changes to the protected `Scheme.Over.ext_of_eqOnOpen`
  signature (already in-tree post-iter-125 refactor).
- Do NOT re-litigate piece (i) or piece (iii) Mathlib alignment (those
  are separate analogist consults).
- Do NOT propose scaffolding piece (ii) this iter — the verdict only
  pins the alignment; scaffolding waits for iter-141+.
- M3 / positive-genus witness path is off-scope.
- The over-k vs over-`k̄` decision is off-scope.

## Sequencing rationale

This consult was scheduled iter-139/140 (per STRATEGY.md line 479) but
front-loaded to iter-138 per `strategy-critic-iter138` Alternative #4:
dispatching two analogist consults in parallel costs nothing extra (no
prover bandwidth competition) and ensures the verdict feeds the
iter-141+ piece (ii) scaffold without slip risk. Co-dispatched with
`mathlib-analogist-p1-hedge-iter138`.
