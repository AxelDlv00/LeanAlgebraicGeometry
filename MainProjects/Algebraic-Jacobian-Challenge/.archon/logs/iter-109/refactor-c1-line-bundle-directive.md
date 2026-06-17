# Refactor Directive

## Slug
c1-line-bundle

## Problem

`AlgebraicGeometry.Scheme.LineBundle` is currently defined in `AlgebraicJacobian/Picard/LineBundle.lean:85-86` as

```lean
def LineBundle (X : Scheme.{u}) : Type u :=
  CommRing.Pic (X.presheaf.obj (op (⊤ : X.Opens)))
```

i.e. the Picard group of the *global-sections* ring. This is a strict subgroup of the true Picard group of `X` whenever `X` is non-affine (the docstring at L17-60 acknowledges this). The refactor target is the geometric definition: the units of the symmetric-monoidal-skeleton on `X.Modules`. The canonical Mathlib idiom is `(Skeleton X.Modules)ˣ`, mirroring `CommRing.Pic R := Shrink (Skeleton (SemimoduleCat R))ˣ` at `Mathlib.RingTheory.PicardGroup:407-408`.

This is **Phase C1** of `STRATEGY.md` and fires this iter (Archon iter-109) with the mathlib-analogist `c1-route` recipe pre-loaded. Persistent rationale: `analogies/c1-route.md`.

## Mathematical Justification

A line bundle on a scheme `X` is an invertible quasi-coherent `O_X`-module. Equivalently: an object of `X.Modules` (the symmetric-monoidal category of sheaves of `O_X`-modules) that is invertible under tensor product `- ⊗_{O_X} -`. The Picard group `Pic(X)` is the set of isomorphism classes of such objects, with group operation tensor product and inverse the `O_X`-dual.

Mathlib provides:

- `AlgebraicGeometry.Scheme.Modules : Scheme.{u} → Type (u+1)` — the abelian category of `O_X`-modules (`Mathlib.AlgebraicGeometry.Modules.Sheaf`).
- `Scheme.Modules.instMonoidalCategory : MonoidalCategory X.Modules` — already provided by the project (`AlgebraicJacobian/Modules/Monoidal.lean:190-193`) via `LocalizedMonoidal` of the sheafification functor at the class `W X`. This is conditional on `(W X).IsMonoidal` (project sorry `instIsMonoidal_W` at `Modules/Monoidal.lean:173`).
- `CategoryTheory.Skeleton C : Type` (`Mathlib.CategoryTheory.Skeleton`) — the type of objects of `C` up to isomorphism.
- `CategoryTheory.Skeleton.instMonoid : MonoidalCategory C → Monoid (Skeleton C)` — `Mathlib.CategoryTheory.Monoidal.Skeleton:60`.
- `CategoryTheory.Skeleton.instCommMonoid : BraidedCategory C → CommMonoid (Skeleton C)` — `Mathlib.CategoryTheory.Monoidal.Skeleton:80`.
- `CategoryTheory.Skeleton.monoidHom : (F : C ⥤ D) → [F.Monoidal] → Skeleton C →* Skeleton D` — `Mathlib.CategoryTheory.Monoidal.Skeleton:111`.
- `instance : BraidedCategory (LocalizedMonoidal L W ε)` — `Mathlib.CategoryTheory.Localization.Monoidal.Braided:118`, derives `BraidedCategory (X.Modules)` from `BraidedCategory (presheaf side)` + `[W.IsMonoidal]`.
- The presheaf side `PresheafOfModules` carries `SymmetricCategory` (hence `BraidedCategory`) at `Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal:145`.

Therefore the chain `BraidedCategory (PresheafOfModules ...) ⟹ BraidedCategory (LocalizedMonoidal ... = X.Modules)` is in scope, transitively through `instIsMonoidal_W`. After C1, every Lean term referencing `LineBundle X` or its consumers will transitively depend on `instIsMonoidal_W`, formalising the "load-bearing post-C1" disclosure already in `STRATEGY.md`.

For `Pic.pullback`: the categorical pullback `Scheme.Hom.pullback f : Y.Modules ⥤ X.Modules` (`Mathlib.AlgebraicGeometry.Modules.Sheaf:167`) is **not equipped with a `Functor.Monoidal` instance in Mathlib b80f227** (verified absent by strategy-critic-iter109). The C1 refactor adopts default option (c) per analogist: introduce a top-level sorry-bodied lemma `SheafOfModules.pullback_tensorObj` giving the iso `(pullback f).obj (M ⊗ N) ≅ (pullback f).obj M ⊗ (pullback f).obj N`, and route `Pic.pullback` through it.

## Changes Requested

### File: `AlgebraicJacobian/Picard/LineBundle.lean`

#### Change 1 — Refactor the body of `LineBundle`

- **Old** (L85-86):
  ```lean
  def LineBundle (X : Scheme.{u}) : Type u :=
    CommRing.Pic (X.presheaf.obj (op (⊤ : X.Opens)))
  ```
- **New** (prefer the bare form; see "Universe-size escape hatch" below for the fallback):
  ```lean
  /-- A line bundle on a scheme `X`: an isomorphism class of invertible
  quasi-coherent `O_X`-modules, packaged as the units of the skeleton of the
  symmetric monoidal category `X.Modules`. This mirrors `CommRing.Pic R` which
  is `Shrink (Skeleton (SemimoduleCat R))ˣ`. -/
  def LineBundle (X : Scheme.{u}) : Type _ :=
    (Skeleton X.Modules)ˣ
  ```
  Note the type ascription `Type _`: `X.Modules` lives in universe `Type (u+1)`, so its skeleton (and the units thereof) lives in `Type (u+1)`. Leaving it `Type _` lets the elaborator pick the right universe.

#### Change 2 — `instCommGroupLineBundle`

- **Old** (L96-98):
  ```lean
  noncomputable instance instCommGroupLineBundle (X : Scheme.{u}) :
      CommGroup (LineBundle X) :=
    inferInstanceAs (CommGroup (CommRing.Pic _))
  ```
- **New**:
  ```lean
  noncomputable instance instCommGroupLineBundle (X : Scheme.{u}) :
      CommGroup (LineBundle X) :=
    inferInstanceAs (CommGroup (Skeleton X.Modules)ˣ)
  ```
  This relies on Lean's typeclass resolution to find `CommGroup (Skeleton X.Modules)ˣ` via:
  - `instCommGroupUnits : CommMonoid M → CommGroup Mˣ` (Mathlib core).
  - `Skeleton.instCommMonoid : BraidedCategory C → CommMonoid (Skeleton C)` (`Mathlib.CategoryTheory.Monoidal.Skeleton:80`).
  - `BraidedCategory (X.Modules)` via the localized-monoidal chain (transitively through `instIsMonoidal_W`).

  **If typeclass resolution fails** to find `BraidedCategory (X.Modules)` directly (it might not be registered as an instance even though the chain exists), insert a *project-side* `noncomputable instance : BraidedCategory (X.Modules)` in `Modules/Monoidal.lean` mirroring how `instMonoidalCategory` is registered (use `inferInstanceAs (BraidedCategory (LocalizedMonoidal ...))`). This is a permitted addition since it just exposes a transitively-existing instance.

#### Change 3 — Introduce `SheafOfModules.pullback_tensorObj` named-deferred sorry

Add a new top-level theorem (still inside `namespace AlgebraicGeometry.Scheme`, near the existing `Pic.pullback`):

```lean
/-- **Mathlib gap (post-C1, named-deferred per Phase C1 default option (c))**.
The categorical pull-back functor `Scheme.Hom.pullback f : Y.Modules ⥤ X.Modules`
should be monoidal: `(pullback f).obj (M ⊗ N) ≅ (pullback f).obj M ⊗ (pullback f).obj N`
for every `M N : Y.Modules`. Mathlib b80f227 does not provide a
`Functor.Monoidal (Scheme.Hom.pullback f)` instance, so this iso must be
hand-built or named-deferred. The project takes the named-deferral route per
analogist `c1-route` (`analogies/c1-route.md`).

A future Mathlib refresh that lands `(SheafOfModules.pullback _).Monoidal`
collapses this sorry to `MonoidalCategoryStruct.tensorObj_iso` (or the
canonical successor lemma). -/
theorem SheafOfModules.pullback_tensorObj {X Y : Scheme.{u}} (f : X ⟶ Y)
    (M N : Y.Modules) :
    (Scheme.Hom.pullback f).obj (M ⊗ N) ≅
      (Scheme.Hom.pullback f).obj M ⊗ (Scheme.Hom.pullback f).obj N := by
  sorry
```

**Hard requirement**: the statement must be `mathematically correct` and the type `Y.Modules`'s `⊗` must be the project's existing `instMonoidalCategory` tensor. The body is a single `sorry`. Do not attempt to fill it.

#### Change 4 — Refactor the body of `Pic.pullback`

- **Old** (L120-122):
  ```lean
  noncomputable def Pic.pullback {X Y : Scheme.{u}} (f : X ⟶ Y) :
      Pic Y →* Pic X :=
    CommRing.Pic.mapRingHom (globalSectionsHom f).hom
  ```
- **New**:
  ```lean
  /-- Pull-back of line bundles along a scheme morphism, as a group
  homomorphism. Defined via `Units.map` applied to the monoid hom
  `Skeleton (Y.Modules) →* Skeleton (X.Modules)` induced by the categorical
  pull-back functor `Scheme.Hom.pullback f`. The monoid hom requires the
  pull-back functor to be monoidal; per `SheafOfModules.pullback_tensorObj`
  (the C1 named-deferred sorry), this is a current Mathlib gap. -/
  noncomputable def Pic.pullback {X Y : Scheme.{u}} (f : X ⟶ Y) :
      Pic Y →* Pic X := by
    sorry
  ```
  Insert a `sorry`-bodied body. The eventual implementation (which the prover will fill once `pullback_tensorObj` is closed or hand-rolled) is `Units.map (Skeleton.monoidHom (Scheme.Hom.pullback f))` — but `Skeleton.monoidHom` requires `[(Scheme.Hom.pullback f).Monoidal]`, and that instance is the missing Mathlib piece. The prover round can construct an ad-hoc monoid hom from `SheafOfModules.pullback_tensorObj` + a soundness lemma; for this refactor round, the body is `sorry` and the lemma surfaces the dependency.

#### Change 5 — Decommission obsolete helpers

The helpers `globalSectionsHom`, `globalSectionsHom_id`, `globalSectionsHom_comp`, `Pic.pullback_id`, `Pic.pullback_comp` at L108-151 are tied to the global-sections-approximation. After Change 4 they become obsolete:

- `globalSectionsHom`, `globalSectionsHom_id`, `globalSectionsHom_comp`: **DELETE** entirely. They are project-local and only used by `Pic.pullback`'s old body.
- `Pic.pullback_id`, `Pic.pullback_comp`: replace bodies with `sorry`:
  ```lean
  @[simp]
  lemma Pic.pullback_id (X : Scheme.{u}) : Pic.pullback (𝟙 X) = MonoidHom.id (Pic X) := by
    sorry

  @[simp]
  lemma Pic.pullback_comp {X Y Z : Scheme.{u}} (f : X ⟶ Y) (g : Y ⟶ Z) :
      Pic.pullback (f ≫ g) = (Pic.pullback f).comp (Pic.pullback g) := by
    sorry
  ```
  These are public lemmas consumed by `Picard/Functor.lean` (see `fiberMap_well_defined`, `fiberMap_comp` at L121-142), so their **signatures and `@[simp]` attributes must stay**. Only the bodies become `sorry`. They will be re-closed by the prover once `Pic.pullback`'s body is filled.

#### Change 6 — Update the file-header docstring

Replace the L17-60 status block (which currently describes the global-sections approximation as a "first-approximation stand-in") with a brief Phase C1 status block describing the *current* (post-C1) state:

- Mathematical content: `LineBundle X := (Skeleton X.Modules)ˣ`, mirroring `CommRing.Pic R`.
- Load-bearing transition: post-C1, `instIsMonoidal_W` (`Modules/Monoidal.lean:173`) becomes load-bearing for the entire Pic-and-down arc via the `BraidedCategory (X.Modules)` chain.
- Pullback gap: `Pic.pullback` body is `sorry` pending closure of `SheafOfModules.pullback_tensorObj` (or a hand-built equivalent).
- Cross-reference `STRATEGY.md` Phase C1 and `analogies/c1-route.md`.

Keep it ≤ 25 lines. Do NOT include extended excuse-prose; cite the strategy/analogy files.

### File: `AlgebraicJacobian/Modules/Monoidal.lean`

**Possibly-required addition only**: if the typeclass resolution in Change 2 fails to find `BraidedCategory (X.Modules)` transitively, add a registered instance near the existing `instMonoidalCategory` (around L190-193):

```lean
noncomputable instance instBraidedCategory : BraidedCategory (X.Modules) :=
  inferInstanceAs (BraidedCategory
    (LocalizedMonoidal (sheafificationFunctor X) (W X) (Iso.refl _)))
```

This is a no-content registration — just exposes an instance that already exists transitively. If the typeclass chain works without this, **do NOT add** the registration (over-aggressive instance registration can confuse the resolver later). Verify first by running `#check` mentally; if uncertain, prefer adding it. The body at L166-173 (`instIsMonoidal_W`) stays **byte-for-byte unchanged**.

**No other edits to this file**. The docstring updates that the blueprint-reviewer flagged for `Modules_Monoidal.tex` are blueprint-writer territory.

### File: `AlgebraicJacobian/Picard/Functor.lean`

Downstream consumer of `Pic` and `Pic.pullback`. Lines 110-142 use `Pic.pullback_comp`, `Pic.pullback_id`, and reduce by `simp`. After Change 5 those simp lemmas have `sorry` bodies, so:

- Any proof that **relies on `Pic.pullback` reducing computationally** (i.e. via `rfl` after `simp`) will break because the body is `sorry`. Insert `sorry` at the broken proof sites.
- Specifically: examine `fiberMap_well_defined` (L116-127), `fiberMap_apply` (L128-131), `fiberMap_id` (L135-138), `fiberMap_comp` (L140-142). These will likely keep compiling because they're proven against the *statements* (signatures) of `Pic.pullback_id` / `Pic.pullback_comp`, not the bodies. **If they keep compiling, leave them alone**. If any breaks, replace its proof body with `sorry` and document.

The forward-compatibility note at L29-36 of the docstring (which describes `LineBundle` as the "global-sections approximation") is **stale post-C1**. **DELETE the L29-36 block** in this refactor — the blueprint-writer will update the chapter prose, but the Lean docstring should not contradict the post-C1 reality.

### File: `AlgebraicJacobian/Picard/FunctorAb.lean`

Consumer of `Pic` via `Additive`. Lines 23-24 and 57-64 reference `Pic` and `Pic.pullback`. Same review pattern as `Picard/Functor.lean`: keep compiling, replace broken proof bodies with `sorry` if any. Most likely no changes needed since the `Additive` wrapping is purely syntactic.

## Universe-size escape hatch

The bare form `(Skeleton X.Modules)ˣ` lives in `Type (u+1)`, but `LineBundle X` is currently typed `Type u` (the file declares `universe u` at L65 and the existing body returns `Type u`). After Change 1's bare form, **either**:

- (Option A — preferred) **Re-declare `LineBundle X` with `Type _`** (let elaboration pick the universe). Most clients should not care because they consume `Pic X` (= `LineBundle X`) only via its `CommGroup` instance, not via universe-pinned manipulation.
- (Option B — fallback) **Wrap with `Shrink`**: `def LineBundle (X : Scheme.{u}) : Type u := Shrink (Skeleton X.Modules)ˣ`. This requires `Small.{u} (Skeleton X.Modules)ˣ` which may need a separate instance. Use this only if Option A causes universe-checker failures across `Picard/Functor.lean` or `Picard/FunctorAb.lean`.

Try Option A first. Verify the project compiles end-to-end before considering Option B. Document which option you took in your report.

## Affected Files

- `AlgebraicJacobian/Picard/LineBundle.lean` — primary refactor target (Changes 1-6).
- `AlgebraicJacobian/Modules/Monoidal.lean` — possible `BraidedCategory` instance registration (only if typeclass resolution requires it).
- `AlgebraicJacobian/Picard/Functor.lean` — downstream consumer; expect 0-2 new sorries at proof sites that previously relied on `Pic.pullback` reducing; expect to delete the stale L29-36 forward-compatibility note.
- `AlgebraicJacobian/Picard/FunctorAb.lean` — downstream consumer; expect 0-1 new sorries.

**Files NOT to touch this iter**:

- `AlgebraicJacobian/Cohomology/**` — completely unrelated; do not edit.
- `AlgebraicJacobian/Differentials.lean` — completely unrelated; do not edit.
- `AlgebraicJacobian/Jacobian.lean`, `AlgebraicJacobian/AbelJacobi.lean` — these do NOT consume `LineBundle` / `Pic` directly (grepped: no `LineBundle`, `Pic.pullback` references; `Pic` referenced only in comments). Verify and do not touch.
- `AlgebraicJacobian/Genus.lean`, `AlgebraicJacobian/Rigidity.lean` — done; no `LineBundle` references.
- `archon-protected.yaml` — no protected declaration moves are required by this refactor; do not edit.
- All blueprint chapters — concurrent blueprint-writer dispatches will handle them.

## Bounded sorry-budget for this refactor

This refactor introduces sorries by design — that's its function. The bound is:

- **`Picard/LineBundle.lean`**: 4 new sorries — `Pic.pullback` body, `Pic.pullback_id` body, `Pic.pullback_comp` body, `SheafOfModules.pullback_tensorObj` body. **No others.**
- **`Picard/Functor.lean` + `Picard/FunctorAb.lean` combined**: ≤4 new sorries (progress-critic-iter109 bound). If your refactor would exceed this combined count, STOP and write `INCOMPLETE` to your report explaining which downstream call-sites need attention.

Project-level sorry count is currently 14. Expected post-refactor count: 14 → 18-22 (4 from LineBundle + ≤4 downstream = ≤22 max). If you exceed 22, that is a sign the refactor scope was wrong; report INCOMPLETE.

## Expected Outcome

- `Picard/LineBundle.lean` body is `(Skeleton X.Modules)ˣ` (or `Shrink (...)`).
- `instCommGroupLineBundle` derives via Lean's typeclass resolution from `BraidedCategory (X.Modules)` (transitively `instIsMonoidal_W`).
- `Pic.pullback`, `Pic.pullback_id`, `Pic.pullback_comp` have `sorry`-bodies; signatures unchanged.
- `SheafOfModules.pullback_tensorObj` exists as a top-level `sorry`-bodied theorem.
- `Modules/Monoidal.lean` has `instBraidedCategory` registered if needed (otherwise unchanged).
- `Picard/Functor.lean` compiles, possibly with new sorries; stale L29-36 forward-compatibility note deleted.
- `Picard/FunctorAb.lean` compiles, possibly with 0-1 new sorries.
- Project compiles end-to-end: `lean_diagnostic_messages` severity=error returns `[]` on every touched file.
- No new `axiom` declarations.
- `archon-protected.yaml` unchanged.

## Strict prohibitions

- **No proof bodies.** Every body in the refactor scope above must be either compiling code or `sorry`. Filling proofs is the prover's job.
- **No new helpers.** Do not invent ancillary lemmas beyond what's named here. The refactor's job is structural; helper-filling is the next prover round's.
- **No new axioms.**
- **No edits outside the named files.** If you discover an unrelated file also needs editing, write that observation into "Notes for Plan Agent" — do not edit.
- **No edits to the `instIsMonoidal_W` body at `Modules/Monoidal.lean:173`.** That sorry is the project's named load-bearing Mathlib gap; it stays exactly as it is.
- **No edits to `Cohomology/BasicOpenCech.lean`.** That file is OFF-LIMITS this iter (L1846 budget-deferral landed iter-108; rest is PAUSED / deferred).
