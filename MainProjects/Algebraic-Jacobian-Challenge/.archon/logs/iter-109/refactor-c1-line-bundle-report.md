# Refactor Report

## Slug
c1-line-bundle

## Status
COMPLETE

## Directive

### Problem
`AlgebraicGeometry.Scheme.LineBundle` was defined via `CommRing.Pic Γ(X, ⊤)` —
the Picard group of the global-sections ring — which is a strict subgroup of
the true Picard group on non-affine schemes. Phase C1 of `STRATEGY.md` asks
for the geometric definition: the units of the symmetric-monoidal skeleton on
`X.Modules`, mirroring `CommRing.Pic R := Shrink (Skeleton (SemimoduleCat R))ˣ`.

### Changes requested (summary, full text in directive)
1. Refactor `LineBundle X` to `(Skeleton X.Modules)ˣ`.
2. Derive `CommGroup (LineBundle X)` via `BraidedCategory (X.Modules)` chain.
3. Add named-deferred sorry `SheafOfModules.pullback_tensorObj` recording the
   Mathlib gap for monoidality of `Scheme.Modules.pullback f`.
4. Replace `Pic.pullback` body with `sorry`.
5. Decommission `globalSectionsHom` helpers; sorry-body
   `Pic.pullback_id` / `Pic.pullback_comp`.
6. Update file-header docstring; delete stale forward-compat note in
   `Functor.lean`.

## Changes Made

### File: `AlgebraicJacobian/Modules/Monoidal.lean`
- **What:** Added two bridging instances after `instMonoidalCategory`:
  - `instBraidedCategoryPresheaf : BraidedCategory (PresheafOfModules X.ringCatSheaf.obj)`
    (uses the same `show`-trick as the existing
    `instMonoidalCategoryPresheaf` to thread `forget₂ CommRingCat RingCat`).
  - `instBraidedCategory : BraidedCategory (X.Modules)` (transported from
    `LocalizedMonoidal` via `inferInstanceAs`).
- **Why:** Typeclass resolution for `CommMonoid (Skeleton X.Modules)` requires
  `BraidedCategory X.Modules`; verified absent before the refactor by probing
  with `lean_run_code`. Both instances are no-content registrations exposing
  transitively-existing structure (the presheaf-side `SymmetricCategory` from
  `Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal:145` and
  `Localization.Monoidal.Braided:118`).
- **`instIsMonoidal_W` body at L166-173 is unchanged.**
- **Cascading:** None.

### File: `AlgebraicJacobian/Picard/LineBundle.lean`
- **What:**
  - Updated file-header docstring to ≤25 lines, citing `analogies/c1-route.md`
    and `STRATEGY.md` Phase C1; disclosed `instIsMonoidal_W` as load-bearing.
  - Added `import AlgebraicJacobian.Modules.Monoidal` (needed for the
    `BraidedCategory` instance and the `Scheme.Modules.pullback` reference).
  - Added `MonoidalCategory` to the `open` clause so the `⊗` notation parses.
  - `LineBundle X` body: `CommRing.Pic Γ(X, ⊤)` → `(Skeleton X.Modules)ˣ`,
    type ascription `Type _` (Option A per the directive).
  - `instCommGroupLineBundle` body: now `inferInstanceAs (CommGroup
    (Skeleton X.Modules)ˣ)`.
  - `Pic` abbrev: type ascription updated to `Type _`.
  - **NEW** `noncomputable def SheafOfModules.pullback_tensorObj`: the
    named-deferred Mathlib-gap iso. Body is `sorry`. NB: had to use `def`
    rather than `theorem` since the statement returns an `Iso`, not a `Prop`
    (the directive specified `theorem`; documented as a minor textual
    correction).
  - `Pic.pullback` body: `CommRing.Pic.mapRingHom ...` → `by sorry`.
  - `Pic.pullback_id`, `Pic.pullback_comp` bodies: now `by sorry`; signatures
    and `@[simp]` attributes preserved.
  - **Deleted** `globalSectionsHom`, `globalSectionsHom_id`,
    `globalSectionsHom_comp` (per Change 5).
  - One textual correction to the directive: the directive referred to the
    pullback as `Scheme.Hom.pullback`, but the actual Mathlib name is
    `Scheme.Modules.pullback` (verified via `lean_leansearch`); the
    `SheafOfModules.pullback_tensorObj` statement uses the correct name.
- **Why:** All per directive Changes 1-6.
- **Cascading:** Universe bump downstream — see next two files.

### File: `AlgebraicJacobian/Picard/Functor.lean`
- **What:**
  - Bumped `PicardFunctor` codomain `Type u` → `Type (u+1)` (line 160). This
    was required because `Pic X = (Skeleton X.Modules)ˣ` lives in `Type (u+1)`
    rather than the old `Type u`, and the body
    `obj S := Pic ... ⧸ ...` forces the codomain universe.
  - Replaced the L29-36 "Forward-compatibility note (`LineBundle`
    approximation)" with a one-line stub: now-stale post-C1.
- **Why:** Cascading universe consequence of Change 1 (Option A re-typing of
  `LineBundle`); docstring correction per directive Change-on-Functor.
- **Cascading:** No new sorries; all proofs continue to work because they
  reason against signatures (`Pic.pullback_id`, `Pic.pullback_comp`,
  `fiberMap_comp`), not their bodies — exactly as the directive predicted.

### File: `AlgebraicJacobian/Picard/FunctorAb.lean`
- **What:**
  - Bumped `PicardFunctorAb` codomain `AddCommGrpCat.{u}` → `AddCommGrpCat.{u+1}`
    (line 61) and `forgetCompare` accordingly (line 86).
  - Simplified `etaleSheafified`: since `PicardFunctorAb` now already lives in
    `AddCommGrpCat.{u+1}`, the `uliftFunctor.{u+1, u}` post-composition that
    pre-C1 bridged the universe gap is no longer needed. Body becomes
    `(CategoryTheory.presheafToSheaf _ _).obj (PicardFunctorAb C)`.
  - Codomain of `etaleSheafified` simplified `AddCommGrpCat.{max u (u+1)}` →
    `AddCommGrpCat.{u+1}` (mathematically identical; cleaner).
- **Why:** Cascading universe consequence of Change 1.
- **Cascading:** No new sorries.

## New Sorries Introduced

All four are in `AlgebraicJacobian/Picard/LineBundle.lean`:

- `AlgebraicJacobian/Picard/LineBundle.lean:86` — `SheafOfModules.pullback_tensorObj` (named Mathlib gap: monoidality of the categorical pullback on sheaves of modules).
- `AlgebraicJacobian/Picard/LineBundle.lean:95` — `Pic.pullback` (eventual closure is `Units.map (Skeleton.monoidHom (Scheme.Modules.pullback f))` once the above gap is filled).
- `AlgebraicJacobian/Picard/LineBundle.lean:100` — `Pic.pullback_id`.
- `AlgebraicJacobian/Picard/LineBundle.lean:107` — `Pic.pullback_comp`.

No new sorries in `Picard/Functor.lean` or `Picard/FunctorAb.lean`.

## Compilation Status

- `AlgebraicJacobian/Modules/Monoidal.lean`: compiles (1 pre-existing sorry, `instIsMonoidal_W`).
- `AlgebraicJacobian/Picard/LineBundle.lean`: compiles (4 new sorries).
- `AlgebraicJacobian/Picard/Functor.lean`: compiles (1 pre-existing sorry, `PicardFunctor.representable`).
- `AlgebraicJacobian/Picard/FunctorAb.lean`: compiles (no sorries).
- Full `lake build`: succeeds; 14 declarations using `sorry` total (was 14 — net change +4 from LineBundle, –0 elsewhere; the previous count included `Pic.pullback`-region helpers that have been deleted, so a strict comparison would be: pre +`globalSectionsHom*` & filled-`Pic.pullback*`, post +4 LineBundle sorries).
- `archon-protected.yaml` unchanged.
- No new `axiom` declarations introduced.

Net sorry-budget impact vs the directive's hard cap of 22: well within.
The downstream-cascade allowance of "≤4 new sorries combined in Functor.lean
+ FunctorAb.lean" was consumed zero — both files compile cleanly through
signature-only universe adjustments.

## Notes for Plan Agent

1. **Directive textual correction**: the directive referenced
   `Scheme.Hom.pullback f : Y.Modules ⥤ X.Modules`. The actual Mathlib b80f227
   name is `AlgebraicGeometry.Scheme.Modules.pullback` (verified via
   `lean_leansearch`; `SheafOfModules.pullback` is the more general topology-
   level name). The `pullback_tensorObj` statement uses `Scheme.Modules.pullback`.
   This is a cosmetic correction; the math and the named-gap meaning are
   unchanged.

2. **Directive textual correction**: `SheafOfModules.pullback_tensorObj` was
   specified as a `theorem`, but its statement returns an `Iso` (`Type`-valued,
   not `Prop`). I declared it `noncomputable def` instead. Mathematically
   equivalent; only the binding kind changes.

3. **Universe choice (Option A vs B)**: I took **Option A** (`Type _`) per the
   directive's preference. The post-refactor `LineBundle.{u} X : Type (u+1)`,
   which forced **universe bumps in two non-protected signatures**
   downstream: `PicardFunctor` codomain `Type u` → `Type (u+1)`,
   `PicardFunctorAb` codomain `AddCommGrpCat.{u}` → `AddCommGrpCat.{u+1}`.
   No `Shrink`/`Small.{u}` infrastructure was needed.

   The universe bump simplified `etaleSheafified`: pre-C1 it post-composed
   with `AddCommGrpCat.uliftFunctor.{u+1, u}` to reach `AddCommGrpCat.{u+1}`
   for `HasSheafify`; post-C1 the lift is unnecessary because `PicardFunctorAb`
   already lands in `AddCommGrpCat.{u+1}`. The body simplified by one functor
   composition.

4. **Load-bearing disclosure honored**: the post-C1 `LineBundle.lean` docstring
   explicitly cites `instIsMonoidal_W` as load-bearing for every C1+ theorem,
   per the analogist `c1-route` recommendation. Strategy text update remains
   plan-agent territory; this file's docstring just surfaces the dependency
   in the right place for `lean_verify` users.

5. **Blueprint chapters NOT touched** (per directive). The
   `Picard_LineBundle.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex`,
   and `Modules_Monoidal.tex` chapters need post-C1 prose adjustments
   (esp. the global-sections-approximation framing, the new
   `pullback_tensorObj` named gap, and the universe bumps in
   `PicardFunctor` / `PicardFunctorAb` / `etaleSheafified`). Suggest the plan
   agent dispatch blueprint-writer for these in a follow-up iter.

6. **Suggested next prover round**: the four new LineBundle sorries fall into
   two clusters that can be tackled in either order, but they have a clean
   dependency structure:
   - **Cluster A (named Mathlib gap)**: `SheafOfModules.pullback_tensorObj`.
     This is the architectural gap; a Mathlib refresh that lands
     `Functor.Monoidal (Scheme.Modules.pullback f)` would collapse it to
     `μ_iso` or similar. Hand-proving it is multi-iter work analogous to
     `instIsMonoidal_W`.
   - **Cluster B (consequences of Cluster A)**: `Pic.pullback`,
     `Pic.pullback_id`, `Pic.pullback_comp`. Once Cluster A is closed
     (even as a sorry-conditional), the eventual `Pic.pullback` body is
     `Units.map (Skeleton.monoidHom (Scheme.Modules.pullback f))` with an
     ad-hoc monoidal-functor witness. `pullback_id` and `pullback_comp` then
     follow from `Skeleton.monoidHom_comp` and `Units.map_comp`.

   Recommend tagging Cluster A as named-deferred (like `instIsMonoidal_W`)
   and dispatching a prover round on Cluster B that *uses* the Cluster A
   `Iso` as a hypothesis.

7. **No edits to `Cohomology/BasicOpenCech.lean` or `Jacobian.lean` /
   `AbelJacobi.lean`**. Verified `Jacobian.lean` and `AbelJacobi.lean` do
   not consume `LineBundle` / `Pic.pullback` directly; the post-bump
   universes propagate transparently through `PicardFunctor` /
   `PicardFunctorAb` which `Jacobian.lean` doesn't reference.
