# mathlib-analogist directive — tile section-localization descent: instance-install wall

## Mode: api-alignment

## Context (self-contained)

We are formalizing (Lean 4 / Mathlib, algebraic geometry) the per-tile section-localization
leaf of a Čech-cohomology project. The MATHEMATICS is complete and axiom-clean. The blocker is
purely a Lean *engineering / design-shape* wall around installing module-/scalar-tower instances
on a `Spec`-dependent (hence noncomputable) carrier. We need your judgement on whether the project's
chosen instance-install shape is the Mathlib-idiomatic one, or whether a different shape avoids the
wall entirely.

### The setup (read these source spans first)

- `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`:
  - lines **643–703** — `isLocalizedModule_powers_restrictScalars_of_algebraMap` (the DONE base-ring
    descent: an `A`-linear localization at `powers (algebraMap R A f)` restricts `R`-linearly to a
    localization at `powers f`; requires `[Module R M] [Module R N] [Module A M] [Module A N]
    [IsScalarTower R A M] [IsScalarTower R A N]`).
  - lines **705–739** — the tile section setup: `modulesSpecToSheaf.obj F` is the global-ring
    `SheafOfModules` whose section over `W` carries an `R`-action; `modulesRestrictBasicOpen g F` is
    the tile, whose sections carry an `R_g = Localization.Away g`-action. `modulesSpecToSheaf_smul_eq`
    + `modulesRestrictBasicOpen_smul_eq(')` are the rfl bridges identifying both actions with `F.val`'s
    structure-sheaf `Γ(W,𝒪)`-action.
  - lines **1003–1110** — the **W1–W3 wall** comment block + the mathematically-complete inline-term
    sketch of `tile_section_localization`. READ THIS CAREFULLY — it is the precise error state.
- `analogies/keystone-descent.md` — the non-circularity / route rationale (background only).

### The target lemma (math complete)

`tile_section_localization`: for qcoh `F` on `Spec R`, elements `f g : R`, tile `F_{(g)}` globally
presented over `R_g`, the section restriction `σ_tile : Γ(D(f̄), tile) ←from Γ(⊤, tile)` is a
localization at `powers (algebraMap R R_g f)` over `R_g` (DONE: `section_isLocalizedModule_of_presentation`).
To finish we feed `σ_tile` to `isLocalizedModule_powers_restrictScalars_of_algebraMap` to get
`IsLocalizedModule (powers f) (σ_tile.restrictScalars R)`, then identify `σ_tile.restrictScalars R`
with `ρ : Γ_R(D(g),F) → Γ_R(D(gf),F)`. The map identity is `rfl` on the underlying type (kernel-verified).

### The wall (verbatim from the prover, two concrete attempts made)

- **W1 (pervasive):** introducing the native `R`-module structure on the (defeq) tile carrier
  `(modulesSpecToSheaf.obj F).presheaf.obj (op (ι ''ᵁ V))` by ANY of `letI` / `haveI` /
  `have inst := inferInstanceAs (Module R …)` HOISTS into a noncomputable auxiliary def and fails
  codegen: *"failed to compile definition, consider marking it as 'noncomputable' because it depends
  on 'Spec'"*. `noncomputable lemma` is rejected (`'theorem' subsumes 'noncomputable'`). Same wall hits
  the `IsScalarTower` `have`s, the `e0/e1` `(…mapIso…).toLinearEquiv`, and `hdesc2`.
- **W2:** the TYPE `IsScalarTower R R_g (tile-carrier)` will not elaborate: *"failed to synthesize
  SMul ↑R (tile-carrier)"* — the carrier carries only `Module R_g`; no `Module R` / `SMul R` is found
  by TC. Building it via `@IsScalarTower.of_algebraMap_smul … (explicit SMul) (fun r x =>
  (tile_scalar_compat …).symm)` still requires the explicit SMul to BE the genuine `mod F` action to
  match `tile_scalar_compat`, which only stays transparent if introduced inline (not via a `have`).
- **W3:** `whnf`/`isDefEq` timeout even at `maxHeartbeats 4000000` — the carrier-`rfl`
  (`σ.restrictScalars R = F`-restriction over image opens) + the two scalar-compat defeqs through
  `modulesSpecToSheaf` + the restrict functor are very heavy.

## What we need from you (two concrete questions)

1. **Idiom for instances on a `Spec`-noncomputable carrier.** Is there a Mathlib-idiomatic way to
   supply `Module R` / `SMul R` / `IsScalarTower R R_g` on a carrier whose *type* mentions `Spec`
   (so any `letI`/`haveI`/`have` for it hoists to a noncomputable aux def and fails codegen in a
   `theorem`) — WITHOUT the giant single-inline-`exact @…` term the prover sketched? Look for how
   Mathlib handles "install a `Module`/scalar-tower on a sheaf-of-modules section type" or
   "restrictScalars on a `SheafOfModules`/`ModuleCat`-valued presheaf section". Cite the exact
   Mathlib decls (e.g. anything around `SheafOfModules`, `ModuleCat.restrictScalars`,
   `PresheafOfModules`, `IsScalarTower.of_algebraMap_smul`, `LinearMap.restrictScalars`) and say
   whether the project should route the descent through a *bundled* `ModuleCat`/`restrictScalars`
   functor (so the instances are structural, not dynamically installed) instead of installing raw
   `Module R` on the underlying type.

2. **Design-shape question (the deeper one).** The project installs `Module R` + `IsScalarTower R R_g`
   on the `modulesSpecToSheaf.obj` (global-ring `SheafOfModules`) carrier. Is this the wrong carrier?
   Would phrasing the *entire descent on the `F`-side carrier* `F.val.obj (op W)` from the start —
   where the `R`-structure is the native structure-sheaf `Γ(W,𝒪)`-action via the bridges
   `modulesSpecToSheaf_smul_eq` / `modulesRestrictBasicOpen_smul_eq'`, so NO dynamic `Module R` install
   is needed and `IsScalarTower` is structural — avoid W1/W2 entirely? Concretely: should
   `isLocalizedModule_powers_restrictScalars_of_algebraMap` be re-stated / instantiated with `M N`
   being the `F.val` section types (carrying native `R` and `R_g` actions) rather than the
   `modulesSpecToSheaf.obj` section types? Is there a Mathlib precedent for proving an
   `IsLocalizedModule` statement on a presheaf-section carrier by transporting along a `rfl`/`eqToHom`
   carrier identification while keeping all instances structural?

## Deliverables

- A ranked recommendation: (a) the bundled-functor / structural-instance reshape, (b) the F-side-carrier
  reshape, or (c) the inline-`exact`-term threading — which is most Mathlib-idiomatic and most likely to
  compile, with the cost of each. Be explicit if the project is building a parallel API where Mathlib
  already has the idiom.
- The exact Mathlib decls (names + signatures, verified via your search tools) the prover should use.
- A concrete starting shape (signature-level, NOT a full proof) for the recommended reshape.
- Write the persistent rationale to `analogies/tile-descent-instance-shape.md`.

Do NOT attempt to write the Lean proof or edit any `.lean` file. Read-only advisor.
