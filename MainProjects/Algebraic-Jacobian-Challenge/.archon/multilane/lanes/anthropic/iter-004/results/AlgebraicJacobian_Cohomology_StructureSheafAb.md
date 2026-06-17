# AlgebraicJacobian/Cohomology/StructureSheafAb.lean

**Status: RESOLVED — all 3 sorries closed.**

Iteration 004 prover round, Objective 1 (Phase A steps 2–4 wiring).
File compiles cleanly via `lean_diagnostic_messages` (no errors, no warnings)
and `lake env lean AlgebraicJacobian/Cohomology/StructureSheafAb.lean` (exit 0).
Axiom hygiene: `lean_verify` on each of the three new declarations returns only
`propext`, `Classical.choice`, `Quot.sound` (the standard Mathlib triple).
**No new `axiom` declarations were introduced or considered.**

## Summary

The plan-agent live-Mathlib probe in `PROGRESS.md` was correct on the nose:
each of the three closures lands in one or two lines, exactly the shape the
probe predicted. No `b80f227` name adjustments were required, no
universe-pinning fights beyond the explicit `.{u}` annotations the scaffold
already carried, and no helper lemmas needed introducing.

## instHasSheafify_Opens_AddCommGrp (L34)

### Attempt 1
- **Approach:** Plan-agent probe verbatim — `inferInstance` after universe
  pinning. Pre-validated by `lean_run_code` on the imports of the file
  before editing.
- **Result:** RESOLVED.
- **Closure body:**

  ```lean
  instance instHasSheafify_Opens_AddCommGrp (X : TopCat.{u}) :
      CategoryTheory.HasSheafify (Opens.grothendieckTopology X)
        AddCommGrpCat.{u} :=
    inferInstance
  ```

- **Key insight:** Mathlib `b80f227` has the full chain
  `HasWeakSheafify` + small-site / concrete-category sheafification API for
  `AddCommGrpCat`-valued sheaves on `Opens.grothendieckTopology X` already
  wired as instances; with the explicit `.{u}` on each category in the
  signature, `inferInstance` discharges the goal.

## instHasExt_Sheaf_Opens_AddCommGrp (L42)

### Attempt 1
- **Approach:** Plan-agent probe verbatim — `CategoryTheory.HasExt.standard _`.
  Pre-validated by `lean_run_code`.
- **Result:** RESOLVED.
- **Closure body:**

  ```lean
  noncomputable instance instHasExt_Sheaf_Opens_AddCommGrp (X : TopCat.{u}) :
      CategoryTheory.HasExt.{u+1}
        (CategoryTheory.Sheaf (Opens.grothendieckTopology X)
          AddCommGrpCat.{u}) :=
    CategoryTheory.HasExt.standard _
  ```

- **Key insight:** `HasExt.standard` produces a `HasExt` instance from any
  abelian category. The abelian instance on
  `Sheaf (Opens.gT X) AddCommGrpCat.{u}` is provided automatically by
  Mathlib via `Sheaf.instAbelian`, fed by the
  `instHasSheafify_Opens_AddCommGrp` of the previous step plus the iter-003
  `HasSheafCompose` ingredient. The `HasExt.{u+1}` annotation in the scaffold
  is correct — `HasExt.standard _` unifies its universe with `u+1` because
  the morphism universe of the sheaf category is `u+1` (one higher than the
  underlying-set / `AddCommGrpCat.{u}` universe).

## Scheme.toAbSheaf (L54)

### Attempt 1
- **Approach:** Plan-agent probe verbatim — `(sheafCompose J F).obj C.sheaf`
  with `F` the forget composite. Pre-validated by `lean_run_code` against
  the imports of the file (`AlgebraicJacobian.Cohomology.SheafCompose`,
  which carries `instHasSheafCompose_forget_CommRing_AddCommGrp`).
- **Result:** RESOLVED.
- **Closure body:**

  ```lean
  noncomputable def toAbSheaf (C : Scheme.{u}) :
      CategoryTheory.Sheaf (Opens.grothendieckTopology C.toTopCat)
        AddCommGrpCat.{u} :=
    (CategoryTheory.sheafCompose (Opens.grothendieckTopology C.toTopCat)
        (CategoryTheory.forget₂ CommRingCat.{u} RingCat.{u} ⋙
          CategoryTheory.forget₂ RingCat.{u} AddCommGrpCat.{u})).obj C.sheaf
  ```

- **Key insight:** `CategoryTheory.sheafCompose J F` is Mathlib's bundled
  "post-compose with `F`" functor on the sheaf category. Its `obj` map,
  applied to `C.sheaf : Sheaf (Opens.gT X) CommRingCat`, produces the
  desired `Sheaf (Opens.gT X) AddCommGrpCat`. The required
  `(Opens.gT X).HasSheafCompose F` instance is supplied by
  `AlgebraicGeometry.Cohomology.instHasSheafCompose_forget_CommRing_AddCommGrp`
  from `Cohomology/SheafCompose.lean` — typeclass resolution picks it up
  automatically once the universe annotations on the two `forget₂` factors
  match the iter-003 instance verbatim (`CommRingCat.{u} → RingCat.{u} →
  AddCommGrpCat.{u}`).

## Forbidden shortcuts

- No `:= sorry` left.
- No `:= ()` / `:= PUnit` / vacuous-sheaf placeholder.
- No `decide` or `trivial`.
- No new `axiom` declarations.
- No `Discrete PUnit` or constant-`0` shortcuts.

## Mathlib `b80f227` name adjustments

None required. Every Mathlib symbol invoked
(`HasSheafify`, `Opens.grothendieckTopology`, `AddCommGrpCat`, `HasExt`,
`HasExt.standard`, `Sheaf`, `sheafCompose`, `forget₂`, `Scheme.sheaf`,
`CommRingCat`, `RingCat`) lines up with the scaffold's import set
(`AlgebraicJacobian.Cohomology.SheafCompose`, which itself imports `Mathlib`).

## Sorry count

- Before this round (in this file): 3 (`L34`, `L42`, `L54`).
- After this round (in this file): 0.
- Project-wide impact: 14 → 11 (still pending Objective 2 in
  `Picard/FunctorAb.lean`, the deferred `representable` in `Picard/Functor.lean`,
  and the 9 protected sorries).

## Proposed `\leanok` markers (for the review agent)

In `blueprint/src/chapters/Cohomology_StructureSheafAb.tex`:

- `thm:HasSheafify_Opens_AddCommGrp` — `\leanok` on **both** the statement
  block and the proof block (the proof is `inferInstance`, fully closed,
  no `sorry`).
- `thm:HasExt_Sheaf_Opens_AddCommGrp` — `\leanok` on **both** the statement
  block and the proof block (the proof is `HasExt.standard _`, fully closed).
- `def:Scheme_toAbSheaf` — `\leanok` on the statement block. (It is a
  definition; the body is the term itself, no separate proof block.)

## Next steps

For this file: none. The three Phase A wiring obligations are discharged.
The downstream consumer

```
H^n(C, struct C) := (Scheme.toAbSheaf C).H n
```

is now well-typed (Mathlib's `Sheaf.H` consumes the `HasExt` instance plus
the sheaf, both of which this file now provides). Phase A still has steps 5
(`Module k` structure on `H¹`) and 6 (Serre finiteness) outstanding, but
those are out of scope for iter-004.

## Dead-end warnings (none)

No exploration of failed paths was needed: the plan-agent probe predicted
the closures correctly. Future iterations should reuse this file's
universe-pinning style verbatim when adding further `Sheaf … AddCommGrpCat`
instances on Grothendieck topologies (e.g.\ for the étale topology, if and
when Mathlib closes the `HasWeakSheafify Scheme.etaleTopology AddCommGrpCat`
gap).
