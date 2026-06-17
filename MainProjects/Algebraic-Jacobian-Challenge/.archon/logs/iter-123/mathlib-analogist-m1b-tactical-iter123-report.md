# Mathlib Analogist Report

## Slug
m1b-tactical-iter123

## Iteration
123

## Question

Tactical pre-prove consult for the iter-123 M1.b prover lane. Surface
Mathlib-canonical APIs / patterns for four tactical clusters that
bloated iter-122's Step 0 work and would otherwise bloat the
iter-123 prover's Step 1+2+3+4 work:

- **A.** `Functor.map_comp`-style rewriting on the Lan-defined
  `TopCat.Presheaf.pullback` functor.
- **B.** Alternatives to the four-step `IsLocalization.of_le` plan for
  closing `appLE_isLocalization`.
- **C.** `algebraMap`-from-`.toAlgebra` rewriting after `letI`.
- **D.** `adj.unit.naturality` cleanup of `(𝟭 _).obj _` decoration.

## Verdicts (summary)

| Cluster | Canonical API | Verdict | Severity |
|---|---|---|---|
| A — Lan map_comp rewrite | none; `Functor.map_comp _ _ _` + `erw` | PROCEED_WITH_WORKAROUND | informational |
| B — IsLocalization shape | `IsLocalization.isLocalization_of_algEquiv` (Step 4 only) | ALIGN_WITH_MATHLIB | major |
| C — algebraMap-from-`.toAlgebra` | `RingHom.algebraMap_toAlgebra` (Defs.lean:212, `rfl`) | ALIGN_WITH_MATHLIB | informational |
| D — unit.naturality cleanup | `Adjunction.unit_naturality` (outer); inner needs `simpa` | PROCEED_WITH_WORKAROUND | informational |

## Cluster A — Lan-defined functor rewriting

**Reproduced the iter-122 failure in-situ** at `Differentials.lean:239`
with `lean_multi_attempt`. Three tactics fail, one succeeds:

| Tactic | Result |
|---|---|
| `rw [Functor.map_comp]` | FAILS — "Did not find an occurrence of the pattern `CategoryTheory.Functor.map ?self (?f ≫ ?g)`" |
| `rw [Functor.map_comp _ _ _]` | FAILS — same pattern-not-found |
| `simp only [Functor.map_comp]` | FAILS — "`simp` made no progress" |
| `erw [hmc]` with `hmc := Functor.map_comp _ _ _` | **SUCCEEDS** |

The failure is real and reproducible. It is NOT a Mathlib gap — `rw`'s
higher-order matching cannot abstract over `?self : C ⥤ D` when `C =
(Opens X)ᵒᵖ` and the functor body involves a `Lan` whose underlying
colimit term is opaque. `erw` succeeds because it allows definitional
unfolding during unification.

**Mathlib has no `pullback_map_comp` simp lemma**, and in a clean
isolated setting `rw [Functor.map_comp]` and `simp only
[Functor.map_comp]` both work — confirmed via `lean_run_code`. The
problem is *contextual*: when surrounded by `set Acolim := ...` and
`set cleg := ...` aliases plus opaque `Lan` evaluation, the
unification fails.

### Recommendation (Cluster A)

**Verdict: PROCEED_WITH_WORKAROUND.**

For every `((TopCat.Presheaf.pullback C f.base).obj P).map (g₁ ≫ g₂)`
that needs splitting in the M1.b proof, the iter-123 prover should use
the pre-prove + `erw` idiom:

```lean
have hmc : ((TopCat.Presheaf.pullback C f.base).obj P).map (g₁ ≫ g₂) =
    ((TopCat.Presheaf.pullback C f.base).obj P).map g₁ ≫
    ((TopCat.Presheaf.pullback C f.base).obj P).map g₂ :=
  Functor.map_comp _ _ _
erw [hmc]
```

A cheaper alternative when possible: **avoid the `set` aliases** for
the inner sub-terms that participate in the rewrite. The aliases are
the proximate cause of the unification failure, not the `Lan`
definition itself.

## Cluster B — `IsLocalization` constructor alternatives

Exhaustive enumeration via `lean_loogle`:

| Constructor | Inputs | Useful for skipping 4-step? |
|---|---|---|
| `IsLocalization.of_le` (Defs.lean:173) | existing `IsLocalization M S` + `M ≤ N` + `∀ r ∈ N, IsUnit (algebraMap r)` | **No** — requires existing IsLocalization on A_colim |
| `IsLocalization.of_le_of_exists_dvd` (Defs.lean:184) | same + divisibility witness | **No** |
| `IsLocalization.isLocalization_of_is_exists_mul_mem` (LocalizationLocalization.lean) | existing `IsLocalization M S` + grow to N | **No** |
| `IsLocalization.atUnits` (Localization/Basic.lean) | existing IL + `M ≤ IsUnit.submonoid R` ⇒ `R ≃ₐ[R] S` | **No** (and produces trivial iso) |
| `IsLocalization.isLocalization_of_algEquiv` (Basic.lean) | `S ≃ₐ[R] P` + existing `IsLocalization M S` ⇒ `IsLocalization M P` | **Yes (Step 4)** |
| `IsLocalization.of_ringEquiv_left` (Defs.lean) | RingEquiv + algebra-compatibility | **No** (transfers between R, not changes S) |
| `Localization.algEquiv` (Basic.lean) | existing `IsLocalization M S` ⇒ `Localization M ≃ₐ[R] S` | **Yes (gives canonical L)** |
| `isLocalization_iff` (Defs.lean:110) | the three-piece characterisation directly | **Yes (direct refine)** |

**Crucial finding**: Mathlib has NO constructor for `IsLocalization N T`
that takes only "every n ∈ N is a unit in T". The minimal interface
is the three-piece `isLocalization_iff`:

```
IsLocalization M S ↔
  (∀ y : M, IsUnit (algebraMap R S y)) ∧
  (∀ z : S, ∃ x : R × M, z * algebraMap R S x.2 = algebraMap R S x.1) ∧
  (∀ {x y : R}, algebraMap R S x = algebraMap R S y → ∃ c : M, c * x = c * y)
```

The `map_units` piece (Step 0) was the iter-122 work; **`surj` and
`exists_of_eq` are the iter-123 bottleneck and require exactly the
same cofinality work as Steps 1+2+3 of the blueprint plan**.

### Recommendation (Cluster B)

**Verdict: ALIGN_WITH_MATHLIB.** The 4-step plan is the canonical
Mathlib pattern; there is no shortcut that skips the cofinality
argument. There are two equivalent formulations of the final reduction,
both align with Mathlib:

**Path 1 (matches blueprint's plan, recommended)**:
Construct the AlgEquiv `Localization M ≃ₐ[A] A_colim` via Steps 1+2+3,
then apply `IsLocalization.isLocalization_of_algEquiv` as Step 4. The
canonical builder for the LHS is `Localization.algEquiv M (Localization M)`
plus the iso to `A_colim`.

**Path 2 (direct three-piece, slightly fewer steps)**:
Use `isLocalization_iff` directly:
```lean
rw [isLocalization_iff]
refine ⟨?map_units, ?surj, ?well_defined⟩
case map_units => exact fun y => isUnit_appLE_unitSubmonoid_in_colim ...
case surj => -- cofinality + basic-open cover argument
case well_defined => -- eq_iff_exists from the same cofinality argument
```

The mathematical content is identical between Paths 1 and 2; Path 2
saves the bookkeeping of explicitly naming the AlgEquiv. The
recommendation: stick with Path 1 (matches the blueprint).

**Important sub-finding**: `IsLocalization.isLocalization_of_algEquiv`
takes `S ≃ₐ[R] P` (an `AlgEquiv`, not a `RingEquiv`). So Step 4 needs
to produce a `Localization M ≃ₐ[Γ(S,U)] A_colim`. The algebra
structure on `A_colim` over `Γ(S,U)` comes from
`appLE_colimAlgebra` (already defined). The algebra structure on
`Localization M` over `Γ(S,U)` comes from `Localization.instAlgebra`.
The `Localization.algEquiv` lemma may help bridge between
`Localization M` and any other `IsLocalization` of `M`, but here we
need to construct the AlgEquiv from scratch via the two-direction
ring maps and prove they're inverses.

## Cluster C — `algebraMap` rewriting after `.toAlgebra`

**Mathlib lemma**: `RingHom.algebraMap_toAlgebra`
(`.lake/packages/mathlib/Mathlib/Algebra/Algebra/Defs.lean:212`):

```lean
theorem RingHom.algebraMap_toAlgebra {R S} [CommSemiring R] [CommSemiring S]
    (i : R →+* S) :
    @algebraMap R S _ _ i.toAlgebra = i :=
  rfl
```

This is the canonical lemma; the project's `appLE_colimAlgebra` is
literally `(appLE_colimRingHom f e).hom.toAlgebra`, so
`algebraMap Γ(S,U) A_colim = (appLE_colimRingHom f e).hom` is `rfl`.

**Reproduced the iter-122 lesson 3 in-situ** at `Differentials.lean:267`
(the final `exact h_unit_colim` line) with `lean_multi_attempt`:

| Tactic | Result |
|---|---|
| `exact h_unit_colim` (direct) | **SUCCEEDS** |
| `change IsUnit ((appLE_colimRingHom f e).hom g)` | **SUCCEEDS** |
| `show IsUnit ((appLE_colimRingHom f e).hom g)` | SUCCEEDS (with linter warning) |
| `rw [show algebraMap _ _ g = (appLE_colimRingHom f e).hom g from rfl]` | FAILS — motive resolution |

**The iter-122 lesson 3 was inaccurate.** `change` does work, and
`exact` against a `_.hom g` hypothesis works directly (the algebra
instance unification is automatic at term level, just not at the `rw`
motive level). The only failing tactic is `rw [... from rfl]`, which
fails for the standard reason that `rw` requires syntactic match of
the LHS — `(algebraMap _ _) g` doesn't pattern-match itself because
the underscore positions are filled by motive-dependent instances.

### Recommendation (Cluster C)

**Verdict: ALIGN_WITH_MATHLIB.** The iter-123 prover should use one
of (in preference order):

1. **`exact h : IsUnit (φ.hom g)`** — the algebraMap unification is
   automatic when the goal is the `IsUnit (algebraMap _ _ g)` form.
2. **`change IsUnit (φ.hom g)`** — explicit conversion before `exact`,
   when the conclusion shape needs to be made obvious for downstream
   work.
3. Cite `RingHom.algebraMap_toAlgebra` in proofs that need to
   manipulate the equality outside an `IsUnit`/`exact` context.

**Do NOT use** the iter-122 `have h_alg : algebraMap _ _ g = φ.hom g
:= rfl; rw [h_alg]` workaround — it adds noise without value. The
canonical pattern is the implicit unification + `exact`.

## Cluster D — `adj.unit.naturality` cleanup

**Mathlib lemma**: `Adjunction.unit_naturality`
(`.lake/packages/mathlib/Mathlib/CategoryTheory/Adjunction/Basic.lean:282`):

```lean
@[reassoc (attr := simp)]
theorem unit_naturality {X Y : C} (f : X ⟶ Y) :
    dsimp% adj.unit.app X ≫ G.map (F.map f) = f ≫ adj.unit.app Y :=
  (adj.unit.naturality f).symm
```

This is the **outer** naturality, where `f` is a morphism in the
source category `C` of the adjunction. It is `@[simp]` and uses
`dsimp%` to strip identity-functor decorations.

**Crucial distinction**: the iter-122 prover's situation is the
**inner** naturality. The adjunction `pullback C f.base ⊣ pushforward
C f.base` has `unit : 𝟙 ⟶ pushforward ∘ pullback` as a `NatTrans` of
endofunctors of `Y.Presheaf C`. So:

- **Outer**: `adj.unit.naturality (η : ℱ ⟶ 𝒢)` for a morphism `η`
  between presheaves. Source category `Y.Presheaf C`.
- **Inner**: `(adj.unit.app S.presheaf).naturality (homOfLE _).op` for
  a morphism in `(Opens Y)ᵒᵖ`. Source category `(Opens Y)ᵒᵖ`.

The inner-level NatTrans `adj.unit.app S.presheaf` has type
`(𝟭 _).obj S.presheaf ⟶ pushforward.obj (pullback.obj S.presheaf)`,
so its `.naturality` field produces `((𝟭 _).obj S.presheaf).map _ ≫ ...`
— the `(𝟭 _).obj` decoration is intrinsic to the inner level.

`Adjunction.unit_naturality` does NOT eliminate this decoration
because it targets the outer level. There is no Mathlib lemma that
directly gives the inner naturality without the `(𝟭 _).obj` term.

### Recommendation (Cluster D)

**Verdict: PROCEED_WITH_WORKAROUND.** The `simpa using
(adj.unit.app S.presheaf).naturality _` pattern IS the canonical
Mathlib idiom for cleaning the `(𝟭 _).obj _` decoration from the
inner naturality. This is used pervasively in Mathlib
(e.g. throughout `CategoryTheory/Sheaves/`).

The iter-122 prover's code at `Differentials.lean:224-226` already
uses this pattern correctly:
```lean
have hnat' : ... := by
  simpa using
    (((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).unit.app
        S.presheaf)).naturality (homOfLE (S.basicOpen_le g)).op
```
The iter-123 prover should reuse this pattern verbatim wherever inner
unit-naturality is needed in Steps 1-3.

## Must-fix-this-iter

None of the four clusters require an immediate refactor of
shipped code. The iter-122 patterns at `Differentials.lean:208-267`
are mostly canonical; the one minor cleanup (Cluster C) is
informational, not load-bearing.

## Major

**Cluster B (IsLocalization shape)**: when the iter-123 prover writes
Step 4, they should use `IsLocalization.isLocalization_of_algEquiv`
(takes an `AlgEquiv`, not a `RingEquiv`). The blueprint already
correctly identifies this. No refactor needed on existing code;
the directive is for the new Step 4 proof.

## Informational

- **Cluster A** (`erw` + pre-prove): canonical workaround for `rw
  [Functor.map_comp]` failure on Lan-defined functors. Documented in
  `analogies/relative-differentials-presheaf-bridge.md` as a reusable
  pattern.
- **Cluster C** (algebraMap-from-`.toAlgebra`): canonical Mathlib
  lemma is `RingHom.algebraMap_toAlgebra : ... = i := rfl`. Prefer
  `exact` over `change` over `rw [show ... from rfl]`.
- **Cluster D** (unit.naturality): inner naturality requires `simpa
  using ... .naturality _` cleanup; no Mathlib gap.

## Persistent file
- `analogies/relative-differentials-presheaf-bridge.md` — appended a
  new "Iter-123 tactical addendum" section documenting the four
  Cluster patterns for future-iter consumers.

## Overall verdict

The iter-122 prover's four lessons are all *correct* about the
tactical surface, but only Cluster A genuinely requires the
"workaround" framing — Clusters C and D are the canonical Mathlib
patterns, not workarounds. Cluster B has no shortcut: the 4-step
plan is the canonical shape. Iter-123 should proceed with the
existing tactical library; no Mathlib PR is warranted from these
findings.
