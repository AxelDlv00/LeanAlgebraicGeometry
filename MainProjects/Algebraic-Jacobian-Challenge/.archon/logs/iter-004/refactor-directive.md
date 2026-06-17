<!-- Archived from REFACTOR_DIRECTIVE.md at 2026-05-06T07:25:46Z -->
<!-- This is the directive the plan agent wrote for the refactor agent in this iteration. -->

# Refactor Directive — iter 004

## Problem statement and motivation

The just-completed prover round closed both helper-scaffold targets created by
the iter-004 refactor (canonical numbering: this is the same Archon iteration
in which the SheafCompose / Functor scaffolds were first introduced):

- `AlgebraicJacobian/Cohomology/SheafCompose.lean` — `instHasSheafCompose_forget_CommRing_AddCommGrp` honestly closed (Phase A step 1).
- `AlgebraicJacobian/Picard/Functor.lean` — `PicardFunctor` definition honestly closed (Phase C step 2). `PicardFunctor.representable` deferred per directive.

Sorry count: 12 → 10 (9 protected + 1 deferred `representable`). All remaining
sorries are either protected declarations or the bundled FGA-level
`PicardFunctor.representable`. There is no further helper sorry to attack
directly; iter-004 must scaffold a new layer to keep momentum.

A live Mathlib probe (`lean_run_code`, recorded in the Mathlib-gap section
below) shows that **Phase A steps 2–3 are essentially already in Mathlib**:

- `HasSheafify (Opens.grothendieckTopology X) AddCommGrpCat.{u}` — `infer_instance` succeeds directly with appropriate universe annotations.
- `HasExt.{u+1} (Sheaf (Opens.grothendieckTopology X) AddCommGrpCat.{u})` — derivable from `HasExt.standard` together with the abelian instance on the sheaf category, with universe pinning.

Together with the iter-004 `HasSheafCompose` instance, this means the
`AddCommGrpCat`-valued cohomology pipeline `HasSheafCompose → HasSheafify →
HasExt → Sheaf.H` is **fully assembled** in Mathlib; the remaining work to
reach `genus` is only the scheme-side wiring (`Scheme.toAbSheaf`) plus the
`Module k` structure on `H¹` and Serre finiteness.

To keep momentum without attacking protected sorries directly, iter-004 opens
**two parallel low-coupling helper tracks** in the iter-002 / iter-004
pattern:

1. **Phase A steps 2–4 wiring** — assemble the `HasSheafify` and `HasExt`
   instances and define `Scheme.toAbSheaf : Scheme.{u} → Sheaf (Opens.gT
   C.toTopCat) AddCommGrpCat.{u}`. This packages every Phase A piece below the
   `Module k`-on-`H¹` step into a single small file. After the prover round,
   one further iteration (Phase A step 5, deferred to a later directive) plus
   a Phase A step 6 (Serre finiteness) are the only barriers between the
   project and an honest `genus`.

2. **Phase C step 3 setup (codomain change)** — define an `AddCommGrpCat`-
   valued variant `PicardFunctorAb` of the iter-004 `PicardFunctor`. The
   underlying-set functor of `PicardFunctorAb` agrees on the nose with
   `PicardFunctor` (Chapter `Picard_Functor.tex`); the change is purely the
   codomain. This sets up the input shape required by
   `CategoryTheory.presheafToSheaf` once the étale-sheafification gap is
   closed in a future iteration.

Both tracks are independent of each other: Track 1 (Phase A) touches `Sheaf` /
`AddCommGrpCat` machinery; Track 2 (Phase C) touches the existing iter-004
`PicardFunctor` API plus `AddCommGrpCat.of` / `AddCommGrpCat.ofHom`. Provers
can attack them in parallel in the next prover round.

## Mathematical justification

### Track 1 — `HasSheafify`, `HasExt`, `Scheme.toAbSheaf`

The abstract Mathlib sheaf-cohomology API `CategoryTheory.Sheaf.H` evaluates
on `F : Sheaf J AddCommGrpCat` once `HasSheafify J AddCommGrpCat` and `HasExt
(Sheaf J AddCommGrpCat)` are present (`Sheaf.instAddCommGroupH` produces the
abelian-group structure on each `F.H n`). For our use case `J =
Opens.grothendieckTopology X` and `F = Scheme.toAbSheaf C`, both class
hypotheses are **already inferable** in Mathlib `b80f227`:

- `HasSheafify (Opens.grothendieckTopology X) AddCommGrpCat.{u}` follows from
  Mathlib's small-site / concrete-category sheafification API. The instance
  search succeeds with `infer_instance` once universes are pinned to the
  `TopCat.{u}` universe of `X` (the same universe-pinning idiom that closed
  the iter-004 `HasSheafCompose` instance).
- `HasExt.{u+1} (Sheaf (Opens.grothendieckTopology X) AddCommGrpCat.{u})`
  follows from `CategoryTheory.HasExt.standard` together with the abelian
  instance `Sheaf.instAbelian` on `Sheaf (Opens.gT X) AddCommGrpCat.{u}`.
  The unique correct universe annotation is `HasExt.{u+1}` (the morphism
  universe of `Sheaf (Opens.gT X) AddCommGrpCat.{u}`); other annotations
  produce a `Type mismatch HasExt.{max ?u_1 ?u_2, ?u_2, ?u_1}` error.

`Scheme.toAbSheaf C` is then the post-composition of the `CommRingCat`-valued
structure sheaf with the iter-004 forget composite, packaged via
`CategoryTheory.sheafCompose`:
```
Scheme.toAbSheaf C :=
  ((CategoryTheory.sheafCompose (Opens.grothendieckTopology C.toTopCat)
      (forget₂ CommRingCat RingCat ⋙ forget₂ RingCat AddCommGrpCat)).obj
    C.sheaf)
```
This relies on the iter-004 `HasSheafCompose` instance and on the fact that
Mathlib's `Scheme` carries a `sheaf` field that lives in `Sheaf
(Opens.grothendieckTopology X.toTopCat) CommRingCat`.

After this chapter lands, `(Scheme.toAbSheaf C).H 1 : Type _` is well-defined
and carries an `AddCommGroup` instance via `Sheaf.instAddCommGroupH`. The
remaining gap to `genus` is the `Module k` structure on this group plus Serre
finiteness; these are deferred to a later iteration.

### Track 2 — `PicardFunctorAb`

The iter-004 `PicardFunctor C` returns `Type u`; the values
`Pic(C ×_k S) / p_S^* Pic(S)` carry a `CommGroup` structure that the type-
valued shape forgets. To enable Phase C step 3 (étale sheafification of the
Picard presheaf, deferred — `HasWeakSheafify Scheme.etaleTopology
AddCommGrpCat` is a real Mathlib gap, see "Mathlib gap" below) and any
future cohomology-of-Picard-presheaf work, we need an `AddCommGrpCat`-valued
variant whose values agree on the nose with the type-valued ones.

The construction wraps `PicardFunctor.quotMap` (closed in iter-004) as an
`AddCommGrpCat` morphism via `AddCommGrpCat.ofHom`. The functor laws
`map_id` / `map_comp` follow from `PicardFunctor.quotMap_id` /
`PicardFunctor.quotMap_comp` (also closed in iter-004) plus the
`AddCommGrpCat.ofHom` boilerplate. No new mathematical content.

## Changes requested

### Track 1 (single new file)

**Create `AlgebraicJacobian/Cohomology/StructureSheafAb.lean`** with three new
`sorry`-declarations:

```lean
import AlgebraicJacobian.Cohomology.SheafCompose

set_option autoImplicit false

universe u

open CategoryTheory Limits TopologicalSpace

namespace AlgebraicGeometry.Cohomology

/-- Phase A step 2: sheafification on the topology of opens of any
topological space, valued in `AddCommGrpCat`. -/
instance instHasSheafify_Opens_AddCommGrp (X : TopCat.{u}) :
    CategoryTheory.HasSheafify (Opens.grothendieckTopology X)
      AddCommGrpCat.{u} := sorry

/-- Phase A step 3: `Ext` on the sheaf category. The universe annotation
`HasExt.{u+1}` is forced by the morphism universe of
`Sheaf (Opens.gT X) AddCommGrpCat.{u}`; other annotations produce a
`HasExt.{max ?u_1 ?u_2, ?u_2, ?u_1}` mismatch. -/
noncomputable instance instHasExt_Sheaf_Opens_AddCommGrp (X : TopCat.{u}) :
    CategoryTheory.HasExt.{u+1}
      (CategoryTheory.Sheaf (Opens.grothendieckTopology X)
        AddCommGrpCat.{u}) := sorry

end AlgebraicGeometry.Cohomology

namespace AlgebraicGeometry.Scheme

/-- Phase A step 4 first half: the structure sheaf of a scheme, viewed as a
sheaf of abelian groups via the iter-004 `HasSheafCompose` instance for the
forget composite `CommRingCat → RingCat → AddCommGrpCat`. -/
noncomputable def toAbSheaf (C : Scheme.{u}) :
    CategoryTheory.Sheaf (Opens.grothendieckTopology C.toTopCat)
      AddCommGrpCat.{u} := sorry

end AlgebraicGeometry.Scheme
```

The blueprint chapter for this file is
`blueprint/src/chapters/Cohomology_StructureSheafAb.tex` (already written by
the plan agent; theorems `thm:HasSheafify_Opens_AddCommGrp`,
`thm:HasExt_Sheaf_Opens_AddCommGrp`, definition `def:Scheme_toAbSheaf`).

The `\lean{...}` macros in that chapter must match the declaration names
above:
- `thm:HasSheafify_Opens_AddCommGrp` → `\lean{AlgebraicGeometry.Cohomology.instHasSheafify_Opens_AddCommGrp}`
- `thm:HasExt_Sheaf_Opens_AddCommGrp` → `\lean{AlgebraicGeometry.Cohomology.instHasExt_Sheaf_Opens_AddCommGrp}`
- `def:Scheme_toAbSheaf` → `\lean{AlgebraicGeometry.Scheme.toAbSheaf}`

### Track 2 (single new file)

**Create `AlgebraicJacobian/Picard/FunctorAb.lean`** with one new
`sorry`-declaration:

```lean
import AlgebraicJacobian.Picard.Functor

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry.Scheme

variable {k : Type u} [Field k]

/-- Phase C step 3 codomain change: the `AddCommGrpCat`-valued variant of
the relative Picard functor. The underlying-set functor agrees on the nose
with `PicardFunctor` (Chapter `Picard_Functor.tex`); only the codomain
changes. Wraps `PicardFunctor.quotMap` via `AddCommGrpCat.ofHom`. -/
noncomputable def PicardFunctorAb
    (C : Over (Spec (CommRingCat.of k))) :
    (Over (Spec (CommRingCat.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u} := sorry

end AlgebraicGeometry.Scheme
```

The blueprint chapter for this file is
`blueprint/src/chapters/Picard_FunctorAb.tex` (already written by the plan
agent; definition `def:Pic_functorAb`). The `\lean{...}` macro:
- `def:Pic_functorAb` → `\lean{AlgebraicGeometry.Scheme.PicardFunctorAb}`

### Updates to umbrella import file

**Update `AlgebraicJacobian.lean`** to import the two new files:

```lean
import AlgebraicJacobian.Cohomology.SheafCompose
import AlgebraicJacobian.Cohomology.StructureSheafAb   -- NEW
import AlgebraicJacobian.Picard.LineBundle
import AlgebraicJacobian.Picard.Functor
import AlgebraicJacobian.Picard.FunctorAb              -- NEW
import AlgebraicJacobian.Rigidity
import AlgebraicJacobian.Genus
import AlgebraicJacobian.Jacobian
import AlgebraicJacobian.AbelJacobi
```

The dependency order is: `Cohomology/SheafCompose.lean` (closed iter-004) →
`Cohomology/StructureSheafAb.lean` (new); `Picard/LineBundle.lean` (closed) →
`Picard/Functor.lean` (closed iter-004) → `Picard/FunctorAb.lean` (new). No
existing import chains are disturbed.

### What MUST NOT be changed

- `archon-protected.yaml` — unchanged. No protected declaration is moved or
  renamed by this directive.
- The 9 protected sorries — left alone.
- `PicardFunctor.representable` — left as `sorry`.
- `Cohomology/SheafCompose.lean` — body of `instHasSheafCompose_…` left as
  closed iter-004 (do not unroll).
- `Picard/Functor.lean` — body of `PicardFunctor` left as closed iter-004.
  The `PicardFunctorAb` of the new file must wrap, not replicate, the
  iter-004 construction.
- The signature of `PicardFunctor` itself — kept as
  `(Over (Spec (CommRingCat.of k)))ᵒᵖ ⥤ Type u`, unchanged from iter-004.
  `PicardFunctorAb` is a separate definition.

## Mathlib gap

A live probe via `lean_run_code` (recorded by the plan agent):

| Probe | Result |
|---|---|
| `infer_instance : HasSheafify (Opens.grothendieckTopology X) AddCommGrpCat.{u}` | ✓ succeeds (with universe pinning) |
| `infer_instance : Abelian (Sheaf (Opens.grothendieckTopology X) AddCommGrpCat.{u})` (with `noncomputable`) | ✓ succeeds |
| `HasExt.standard _ : HasExt.{u+1} (Sheaf (Opens.grothendieckTopology X) AddCommGrpCat.{u})` | ✓ succeeds (universe annotation `.{u+1}` is forced) |
| `infer_instance : HasWeakSheafify Scheme.etaleTopology AddCommGrpCat.{u+1}` | ✗ fails — Mathlib gap, real |
| `Scheme.etaleTopology.over _ : GrothendieckTopology (Over (Spec (CommRingCat.of k)))` | ✓ succeeds (étale topology on `Sch_k` is constructible from `GrothendieckTopology.over`) |

The étale-sheafification gap (`HasWeakSheafify Scheme.etaleTopology
AddCommGrpCat`) is a genuine multi-iteration project; this directive does
**not** attack it. The codomain change in Track 2 prepares the input shape
without trying to sheafify.

## Expected outcome

After the refactor:

- Sorry count: 10 → 14 (4 new scaffold sites: 3 in Track 1, 1 in Track 2).
- Compilation: green; the only diagnostic warnings are the 14 expected
  sorry warnings.
- No new axioms.
- Two new blueprint chapters (already written by the plan agent) gain a
  `\lean{...}` correspondence to declarations that exist with `sorry`
  bodies.

The next prover round (the second prover round of iter-004 / first prover
round of iter-005, depending on dispatcher) is expected to close all four
new sorries in one pass. Track 1 closures rely on `infer_instance` /
`HasExt.standard` plus universe pinning (closely analogous to the iter-004
closure of `instHasSheafCompose_…`). Track 2 closures rely on the iter-004
`PicardFunctor.quotMap` API plus `AddCommGrpCat.ofHom` boilerplate.

If the prover hits a surprise (e.g.\ Mathlib's small-site sheafification API
in fact requires a stronger hypothesis than the plan agent's probe
suggested, or `AddCommGrpCat.ofHom` of a `MonoidHom` is not the canonical
Mathlib idiom), the prover should document the surprise in
`task_results/<file>.lean.md` with the missing-API name and intended type;
the plan agent will then re-route in the next iteration.
