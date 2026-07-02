# Analogy: cover-localization iso criterion for `Scheme.Modules` morphisms

## Mode
api-alignment

## Slug
keystone328

## Iteration
328

## Question
Should `Scheme.Modules.Hom.isIso_iff_isIso_restrict` (a morphism of `X.Modules` is iso ⟺ its
restriction to each member of an open cover `𝒰` is iso) be built, and via what idiom? Does
Mathlib already package a cover-locality / conservativity result for `SheafOfModules` /
`Scheme.Modules` morphisms? Is the planned stalk route (`restrictStalkNatIso` +
`isIso_iff_stalkFunctor_map_iso`) the Mathlib-aligned construction or a parallel API?

## Project artifact(s)
- `Cohomology/CechHigherDirectImageUnconditional.lean:830/898` — `openImmersion_bareBC` /
  `openImmersion_beckChevalley`; STAGE-2 residual `IsIso (bareBC.app G)` — the consumer this gates.
- `analogies/fbc327.md` — "base-free affine-open route" already prescribes restricting `IsIso bareBC`
  to an affine cover of X' (the affine pieces feed the tilde / `cancelBaseChange` algebra). That route
  needs precisely this cover→iso lift.

## Decisions identified

### Decision: Q1 — does Mathlib already have the cover criterion / a conservativity instance?
- **Mathlib idiom search result**: NO packaged cover criterion for `SheafOfModules` /
  `Scheme.Modules` morphisms. What exists in `Mathlib.AlgebraicGeometry.Modules.Sheaf`:
  - `Scheme.Modules.Hom.isIso_iff_isIso_app` — iso ⟺ iso on **ALL opens** (stalk-free; via
    `toPresheaf` ReflectsIsos + componentwise nat-iso). NOT a cover statement.
  - `Scheme.Modules.restrictStalkNatIso (f) (x)` `[IsOpenImmersion f]` — `restrictFunctor f ⋙
    toPresheaf X ⋙ stalkFunctor Ab x ≅ toPresheaf Y ⋙ stalkFunctor Ab (f x)`. **Purpose-built
    bridge** "restrict to an open immersion ↔ stalk", + `germ_restrictStalkNatIso_{hom,inv}_app`.
  - `instReflectsIsomorphismsPresheafAbCarrierCommRingCatToPresheaf` — `toPresheaf X` reflects isos.
  - `Scheme.Modules.isSheaf : (M : X.Modules) → M.presheaf.IsSheaf` — the IsSheaf handle.
  Generic side: `TopCat.Presheaf.isIso_iff_stalkFunctor_map_iso` (`Mathlib.Topology.Sheaves.Stalks`,
  stated at **`TopCat.Sheaf C X`** level, C = Ab supplies all instances) — iso ⟺ iso on all stalks.
  Grothendieck-topology side: `CategoryTheory.Sheaf.isLocallyBijective_iff_isIso`
  (`Mathlib.CategoryTheory.Sites.LocallyBijective`) — iso ⟺ locally injective+surjective — but for
  `CategoryTheory.Sheaf J A`, and `X.Modules` (= `SheafOfModules`) is NOT definitionally that, so it
  needs its own bridge and is no cleaner. `IsLocalAtTarget (isomorphisms Scheme)` exists but is about
  **scheme** morphisms, not module-sheaf morphisms.
- **Project's path**: assemble the cover lemma from the pieces above.
- **Gap**: divergent-with-cost (the lemma is genuinely absent — must build), but all atoms exist.
- **Verdict**: NEEDS_MATHLIB_GAP_FILL (assemblable; no shorter packaged result; naming nothing ends the build).

### Decision: Q2 — is the planned stalk route the Mathlib-aligned idiom?
- **Mathlib idiom**: YES. `restrictStalkNatIso` + `germ_restrictStalkNatIso_*` were added to
  `Mathlib.AlgebraicGeometry.Modules.Sheaf` for **exactly** the "restrict-to-open-immersion vs. stalk"
  comparison; `isIso_iff_stalkFunctor_map_iso` is the matching stalk-conservativity. The earlier
  "no stalk functor for modules" wall (iter-244/304) is about a stalk functor on `X.Modules` directly;
  the aligned route instead pushes through `toPresheaf` to **`Ab`** and stalks there — which is what
  `restrictStalkNatIso` is phrased in. So the plan is on-rails.
- **Project's path**: identical to the idiom.
- **Gap**: identical.
- **Verdict**: ALIGN_WITH_MATHLIB (route choice — use these exact decls; do NOT re-derive a module
  stalk functor, do NOT mint a fresh mate, do NOT route through `isLocallyBijective`).

### Decision: Q3 — shape (plain lemma vs. `ReflectsIsomorphisms`/`Conservative` instance)?
- **Mathlib idiom**: a single restriction functor reflecting isos would be a `ReflectsIsomorphisms`
  instance, but the statement is **joint** conservativity of the *family* `{restrictFunctor (𝒰.map j)}_j`
  — Mathlib has no typeclass for joint conservativity of an indexed family. So a plain `theorem`
  (iff) is the idiom; cf. `isIso_iff_isIso_app` itself is a plain theorem, not an instance.
- **Project's path**: plain lemma (as proposed).
- **Gap**: identical. No parallel-API risk: it is a strict corollary-shaped addition that *composes
  with* `isIso_iff_isIso_app` and `isIso_iff_stalkFunctor_map_iso`, not a competitor to them.
- **Verdict**: PROCEED (plain `theorem`, iff; reverse direction is the content).

## Recommended signature (prover target)
```lean
theorem AlgebraicGeometry.Scheme.Modules.Hom.isIso_iff_isIso_restrict
    {X : Scheme} {M N : X.Modules} (φ : M ⟶ N) (𝒰 : X.OpenCover) :
    IsIso φ ↔ ∀ j, IsIso ((Scheme.Modules.restrictFunctor (𝒰.map j)).map φ)
```
`𝒰.map j` is an open immersion for an `OpenCover`, so `restrictFunctor (𝒰.map j)` is well-typed.

## Assembly (all atoms exist — ~60-90 LOC)
1. **→ (easy)**: functors preserve isos: `(restrictFunctor (𝒰.map j)).map φ` is iso when `φ` is.
2. **← (content)**: assume `∀ j, IsIso (restrict_j φ)`.
   - `IsIso φ ⟺ IsIso (toPresheaf.map φ)` via `toPresheaf` ReflectsIsos (+ functor preserves).
   - Present `M,N` as `TopCat.Sheaf Ab X.carrier` via `⟨M.presheaf, M.isSheaf⟩`; pass to the sheaf
     morphism through `sheafToPresheaf` (fully faithful, reflects+preserves isos).
   - `isIso_iff_stalkFunctor_map_iso`: reduce to `∀ x, IsIso ((stalkFunctor Ab x).map (toPresheaf.map φ))`.
   - For each `x`: set `j := 𝒰.f x`; `x ∈ range (𝒰.map j).base` (`𝒰.covers`), lift to `y` with
     `(𝒰.map j).base y = x`. Naturality of `restrictStalkNatIso (𝒰.map j) y` at `φ` gives
     `stalk_y (restrict_j φ) ≅`-conjugate-of `stalk_x φ`; since `restrict_j φ` is iso, its stalk is
     iso, hence `stalk_x φ` is iso.
   `germ_restrictStalkNatIso_{hom,inv}_app` are the section-level handles if the naturality square
   needs to be discharged germ-wise.

## Known plumbing hurdles (de-risk for build-blind env)
- The Sheaf-level lift (presheaf-iso ↔ `TopCat.Sheaf Ab` iso) — discharged by `Scheme.Modules.isSheaf`
  + `sheafToPresheaf` full-faithfulness. This is the one non-mechanical bridge; it is NOT a gap.
- The point lift `x ↔ y` and the `restrictStalkNatIso` naturality conjugation — fiddly but pure
  rewriting against the two `germ_restrictStalkNatIso_*` equations.

## Recommendation
Build the plain `theorem` with the signature above via the stalk route (Q2 idiom). It is a genuine
gap-fill (Q1) but every atom — `restrictStalkNatIso`, `germ_restrictStalkNatIso_{hom,inv}_app`,
`isIso_iff_stalkFunctor_map_iso`, `Scheme.Modules.isSheaf`,
`instReflectsIsomorphismsPresheafAbCarrierCommRingCatToPresheaf` — exists and is named here, so no
exploratory search is needed at build time. Do NOT attempt a module-level stalk functor (dead, iter-244/304)
nor a `Sheaf J A` / `isLocallyBijective` reroute (needs its own bridge, no cleaner). Place the lemma next
to `isIso_iff_isIso_app` conceptually (a project file importing `Mathlib.AlgebraicGeometry.Modules.Sheaf`).
Related: [[openimm-beckchevalley-326]], [[fbc327]], [[fbc-isiso-barebc-327]].
</content>
</invoke>
