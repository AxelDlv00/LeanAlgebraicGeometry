<!-- Archived from REFACTOR_DIRECTIVE.md at 2026-05-06T06:09:42Z -->
<!-- This is the directive the plan agent wrote for the refactor agent in this iteration. -->

# Refactor Directive — iter-004

## Problem statement and motivation

Iter-003 cleanly closed the two helper-scaffold targets created by iter-002:
- `AlgebraicJacobian/Rigidity.lean` — `eq_of_eqOnOpen` honestly closed (Phase E rigidity helper available).
- `AlgebraicJacobian/Picard/LineBundle.lean` — `LineBundle`, `instCommGroupLineBundle`, `Pic.pullback` closed under documented first-approximation `LineBundle X := CommRing.Pic Γ(X, ⊤)` (correct on affine schemes, strict subgroup elsewhere).

Sorry count: 13 → 9 (the 9 remaining are exactly the protected sorries). The project now has two helper modules but no remaining helper sorries to attack — every sorry left is either a protected declaration or a multi-iteration-blocked downstream consumer.

To keep momentum without attacking protected sorries directly, iter-004 opens **two parallel low-coupling helper tracks** that have been pre-vetted by the iter-001 discovery report and the iter-003 review:

1. **Phase A step 1** — assemble the `HasSheafCompose` instance for the `CommRingCat ⥤ AddCommGrpCat` forget composite. This is the smallest unblocking unit toward computing `H¹(C, O_C)` (the genus). Provable from current Mathlib (`b80f227`) with limit-preservation lemmas about algebraic forgetful functors.

2. **Phase C step 2** — scaffold the relative Picard functor `S ↦ Pic(C ×_k S) / p_S^* Pic(S)` on top of the iter-003 `LineBundle` API, plus an FGA-level deferred `representable` sorry. The functor *definition* is fillable from current Mathlib + the iter-003 `Pic.pullback`; the representability theorem is intentionally left as a sorry (it is the bundled blocker for the four `Jacobian.lean` sorries and is not honestly closeable until upstream Mathlib gains étale sheafification, Hilbert / Quot schemes, and Riemann–Roch).

Both tracks are independent of each other: Track 1 (Phase A) touches `Sheaf` / `AddCommGrpCat` machinery; Track 2 (Phase C) touches `LineBundle` / `Pic` / fiber products of schemes. Provers can attack them in parallel in iter-005.

## Mathematical justification

### Track 1 — `HasSheafCompose` for the structure-sheaf forget composite

The structure sheaf of a scheme `C` is delivered by Mathlib in shape `TopCat.Sheaf CommRingCat C`. Mathlib's abstract sheaf-cohomology API `CategoryTheory.Sheaf.H` accepts `Sheaf J AddCommGrpCat`, so to use it we must transport the sheaf condition along the forget composite `forget₂ CommRingCat RingCat ⋙ forget₂ RingCat AddCommGrpCat`. The transport is a small, well-understood limit-preservation argument:

- The composite of two structure-forgetful functors preserves all small limits.
- The sheaf condition on a Grothendieck topology is preservation of certain `multiequalizer` limits (Mathlib `Presheaf.IsSheaf.isSheaf_iff_isSheaf_comp` or analogous).
- Hence the post-composition with the forget composite preserves the sheaf condition, which is exactly what `HasSheafCompose` packages.

This unblocks Phase A step 2 (`HasSheafify` on `Sheaf (Opens.gT X) AddCommGrpCat`), which is the next checkpoint in the 5-step chain that ends in `genus`.

### Track 2 — Relative Picard functor scaffold

The relative Picard functor `S ↦ Pic(C ×_k S) / p_S^* Pic(S)` is the standard input to FGA-style representability of `Pic_{C/k}` for a smooth proper geometrically irreducible curve. The four `Jacobian.lean` sorries (`Jacobian` itself plus the three instances `instGrpObj`, `instIsProper`, `instGeometricallyIrreducible`, and additionally `smoothOfRelativeDimension_genus` after Phase A) all reduce to **one** representability theorem on this functor.

The *type* of `PicardFunctor C` is constructible in `b80f227` from:
- `LineBundle X` (iter-003) for the per-scheme Picard groups,
- `Pic.pullback (p_S : C ×_k S → S)` (iter-003) for the subgroup quotient,
- `Limits.HasPullback` for the fiber product of schemes,
- `QuotientGroup.mk` for the quotient.

The *representability* theorem is FGA-level and honestly closeable only on the true sheaf-theoretic Picard group, which requires `MonoidalCategory X.Modules` (multi-iteration; absent in `b80f227`) plus étale sheafification (also absent). Iter-004 declares the theorem as a sorry; iter-005 prover attacks the *definition* only and leaves the theorem intentionally unfilled.

**Forward-compatibility warning** (relayed to the iter-005 prover and recorded in chapter `Picard_Functor.tex`): closing `representable` on top of the iter-003 first-approximation `LineBundle` would assert representability of the *wrong* functor and is therefore a forbidden shortcut. The iter-005 prover must keep it as `sorry`.

## Concrete refactor actions

The refactor agent must perform exactly the following structural changes. Do **not** fill any proof body except where the directive explicitly asks for a `sorry`.

### Action 1 — Create `AlgebraicJacobian/Cohomology/SheafCompose.lean`

Create the directory `AlgebraicJacobian/Cohomology/` if it does not exist, then create `AlgebraicJacobian/Cohomology/SheafCompose.lean` with the following content (sketch — the file header should follow the style of `AlgebraicJacobian/Picard/LineBundle.lean`):

```lean
/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# Sheaf condition along the structure-sheaf forget composite

Phase A step 1 (per `STRATEGY.md`): the `HasSheafCompose` instance for the
forget composite `CommRingCat ⥤ RingCat ⥤ AddCommGrpCat` on the Grothendieck
topology of opens of an arbitrary topological space. This is the gateway to
computing `H¹(C, O_C)` as an abelian group (and ultimately as a `k`-vector
space for the genus).

See `blueprint/src/chapters/Cohomology_SheafCompose.tex`.

## Status (iteration 004 — refactor scaffold)

This file is a scaffold. The single instance below is `sorry`. The iter-005
prover is responsible for filling it (Phase A step 1 of `STRATEGY.md`).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry.Cohomology

/-- The forget composite `CommRingCat ⥤ RingCat ⥤ AddCommGrpCat` preserves the
sheaf condition on the Grothendieck topology of opens of any topological space.
Equivalently: a sheaf of commutative rings on a topological space is in
particular a sheaf of abelian groups (post-composing with the forgetful is
sound). -/
instance instHasSheafCompose_forget_CommRing_AddCommGrp (X : TopCat) :
    (TopologicalSpace.Opens.grothendieckTopology X).HasSheafCompose
      (CategoryTheory.forget₂ CommRingCat RingCat ⋙
       CategoryTheory.forget₂ RingCat AddCommGrpCat) := sorry

end AlgebraicGeometry.Cohomology
```

The instance name `instHasSheafCompose_forget_CommRing_AddCommGrp` matches the `\lean{...}` macro in `Cohomology_SheafCompose.tex`, theorem `thm:HasSheafCompose_forget`. Keep the name verbatim.

### Action 2 — Create `AlgebraicJacobian/Picard/Functor.lean`

Create `AlgebraicJacobian/Picard/Functor.lean` with the following content (sketch — file header should follow the style of `AlgebraicJacobian/Picard/LineBundle.lean`):

```lean
/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Picard.LineBundle

/-!
# The relative Picard functor

Phase C step 2 (per `STRATEGY.md`): the relative Picard functor of a curve
`C` over `Spec k`, packaged as a contravariant functor on schemes, plus the
(deferred) representability theorem whose closure jointly unblocks the four
`Jacobian.lean` sorries.

See `blueprint/src/chapters/Picard_Functor.tex`.

## Status (iteration 004 — refactor scaffold)

This file is a scaffold. The two declarations below are `sorry`. The iter-005
prover is responsible for filling **only the definition** of `PicardFunctor`
(the `representable` theorem is FGA-level and intentionally deferred — see the
forward-compatibility note in `Picard_Functor.tex`).

## Forward-compatibility note (`LineBundle` approximation)

`LineBundle` (per `Picard/LineBundle.lean`) is currently realised as the
global-sections approximation `CommRing.Pic Γ(X, ⊤)`. The relative Picard
functor built on top of this approximation gives smaller subgroups than the
true relative Picard functor on non-affine `S`. Closing `representable` on
top of this approximation would silently assert representability of the wrong
functor and is therefore a forbidden shortcut: keep it as `sorry`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry.Scheme

/-- The relative Picard functor of `C` over `Spec k`:
    `S ↦ Pic(C ×_k S) / p_S^* Pic(S)`,
where `p_S : C ×_k S → S` is the projection. Functoriality in `S` is via base
change of the fiber product and the pull-back homomorphism on Picard groups
(`Pic.pullback`).

**Iteration 004 implementation.** This is the scaffolded signature; the iter-005
prover fills the body using `Limits.pullback` (fiber product of schemes),
`LineBundle`, `Pic.pullback`, and `QuotientGroup.mk` for the quotient. -/
noncomputable def PicardFunctor
    {k : Type u} [Field k] (C : Scheme.{u}) [C.Over (Spec (.of k))] :
    Scheme.{u}ᵒᵖ ⥤ Type u := sorry

/-- Representability of the relative Picard functor for a smooth, proper,
geometrically irreducible curve `C` over a field `k` (Grothendieck FGA, Mumford
*Abelian Varieties* §III.13). The connected component of the identity of the
representing group scheme is the Jacobian `Jac(C)`.

**Intentionally deferred.** This is FGA-level and not honestly closeable on
the global-sections-approximate `LineBundle`. The four `Jacobian.lean` sorries
all reduce to this theorem. Do not attempt to fill it in iter-005 — see the
file docstring and `Picard_Functor.tex` forward-compatibility note. -/
theorem PicardFunctor.representable
    {k : Type u} [Field k] (C : Scheme.{u}) [C.Over (Spec (.of k))]
    [SmoothOfRelativeDimension 1 (C ↘ Spec (.of k))]
    [IsProper (C ↘ Spec (.of k))]
    [GeometricallyIrreducible (C ↘ Spec (.of k))] :
    (PicardFunctor C).IsRepresentable := sorry

end AlgebraicGeometry.Scheme
```

The names `PicardFunctor` and `PicardFunctor.representable` (qualified `AlgebraicGeometry.Scheme.PicardFunctor` and `AlgebraicGeometry.Scheme.PicardFunctor.representable`) match the `\lean{...}` macros in `Picard_Functor.tex`. Keep the names verbatim.

**Verification that the signature compiles**: if Mathlib does not expose `Scheme.IsRepresentable` under that exact name, search for the appropriate idiom — likely `(PicardFunctor C).Representable`, or `Functor.IsRepresentable`, or `RepresentableBy`. The blueprint's `\lean{...}` macro is name-only; pick the most natural Mathlib formulation and adjust the chapter `\lean{...}` macro to match if needed (see Action 6 below). If the most natural formulation requires re-shaping the conditions (e.g. unbundling `[Over]`), preserve the *intent* of the statement (representability of the relative Picard functor for smooth proper geometrically irreducible curves) and document the chosen shape in `task_results/refactor.md`.

### Action 3 — Update `AlgebraicJacobian.lean`

Update the umbrella import file `AlgebraicJacobian.lean` to import the two new files. The dependency-correct order is:

```lean
import AlgebraicJacobian.Cohomology.SheafCompose
import AlgebraicJacobian.Genus
import AlgebraicJacobian.Picard.LineBundle
import AlgebraicJacobian.Picard.Functor
import AlgebraicJacobian.Jacobian
import AlgebraicJacobian.Rigidity
import AlgebraicJacobian.AbelJacobi
```

Rationale:
- `Cohomology.SheafCompose` has only Mathlib upstream and is independent of `Genus` (no cross-imports).
- `Picard.Functor` depends on `Picard.LineBundle`.
- `Jacobian` already depends on `Genus`; `Rigidity` and `AbelJacobi` already depend on `Jacobian`.

### Action 4 — `archon-protected.yaml` is unchanged

No protected declaration is moved or renamed by this refactor. The file does not need to be edited.

### Action 5 — Verify the project still compiles cleanly

After Actions 1–3, run `lean_diagnostic_messages` on:
- `AlgebraicJacobian.lean` (umbrella),
- `AlgebraicJacobian/Cohomology/SheafCompose.lean` (new),
- `AlgebraicJacobian/Picard/Functor.lean` (new),
- `AlgebraicJacobian/Picard/LineBundle.lean` (unchanged but newly imported by `Picard.Functor`),
- `AlgebraicJacobian/Jacobian.lean` (unchanged but downstream),
- `AlgebraicJacobian/Rigidity.lean` (unchanged),
- `AlgebraicJacobian/AbelJacobi.lean` (unchanged),
- `AlgebraicJacobian/Genus.lean` (unchanged).

Each file should report only sorry warnings (no errors). The expected post-refactor sorry counts are:
- `Cohomology/SheafCompose.lean`: 1 (new).
- `Picard/Functor.lean`: 2 (new).
- `Genus.lean`: 1 (unchanged).
- `Jacobian.lean`: 5 (unchanged).
- `AbelJacobi.lean`: 3 (unchanged).
- `Rigidity.lean`: 0 (unchanged).
- `Picard/LineBundle.lean`: 0 (unchanged).
- **Total**: 12 (was 9 before refactor — `+3` from the two new scaffolds).

### Action 6 — Reconcile blueprint `\lean{...}` macros if signatures differ

If the chosen Mathlib formulation in Action 2 (e.g.\ `IsRepresentable` vs `Representable` vs `RepresentableBy`) results in declaration names different from those in the blueprint, update the corresponding `\lean{...}` macro in `blueprint/src/chapters/Picard_Functor.tex` (lines: theorem `thm:Pic_representable` → declaration name) and in `blueprint/src/chapters/Cohomology_SheafCompose.tex` (theorem `thm:HasSheafCompose_forget` → declaration name) to match. **Document the chosen names in `task_results/refactor.md`.**

For Track 2, do *not* edit the prose of either chapter. Only update `\lean{...}` macros if the Lean name diverges from what the chapter currently asserts.

### Action 7 — Constraints to respect

- Do **not** fill any proof body except as `sorry`.
- Do **not** add new axiom declarations.
- Do **not** modify any protected declaration's signature (`archon-protected.yaml`).
- Do **not** touch `Rigidity.lean` or `Picard/LineBundle.lean`'s closed proofs.
- Do **not** touch the `Genus.lean` discovery comments or the `Jacobian.lean` / `AbelJacobi.lean` sorry-bodies.
- The two new `def`/`theorem` bodies must be *exactly* `sorry` (or in the form `:= by sorry`); no extra unfilled fields, no `axiom` workarounds.
- The two new files must compile with **only sorry warnings** (no errors).

### Reporting requirements

The refactor agent's `task_results/refactor.md` must include:

- Final paths of the two new files.
- Final, fully-qualified Lean names of the four new declarations (1 instance + 1 def + 1 theorem; if Action 6 required adjustments, the new names).
- Per-file sorry counts after the refactor (verified via `lean_diagnostic_messages`).
- Any deviation from the directive (e.g.\ if `Functor.IsRepresentable` is not the right Mathlib idiom and a different shape was chosen) plus the mathematical justification of the deviation.
- Confirmation that no axiom was added (`grep -n '^axiom' AlgebraicJacobian/`) and no protected signature was changed.

The plan agent (post-refactor) will independently verify each of these before scoping iter-005.
