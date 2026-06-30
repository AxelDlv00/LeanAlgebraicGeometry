# Analogy: glue a global natural iso of 𝒪-module-valued functors from affine-local isos (FBC base-change locality on S′)

## Mode
cross-domain-inspiration

## Slug
fbc-locality-305

## Iteration
305

## Structural problem (abstracted)
Construct a global natural iso `e : g^*∘f_* ≅ f'_*∘g'^*` of `S'.Modules`-valued functors over an
arbitrary base `S'`, from concrete affine-local isos (the `cancelBaseChange`-tilde chain) defined
over each affine `Spec R' ⊆ S'` (with a chosen affine `Spec R ⊆ S` over its `g`-image). The gluing
needs an overlap-agreement (descent) condition so the affine pieces assemble to one natural iso of
sheaf-of-modules functors. Abstractly: **build a morphism (then iso) of sheaves of modules on a
space from compatible local-on-a-basis morphisms, naturally in the input sheaf.**

## Failed approaches (from directive)
- Canonical adjoint-mate (`pushforwardBaseChangeMap` = mate of the `(g'^*,g'_*)`-unit), prove iso
  affine-locally: walls on "mate ↔ tilde(cancelBaseChange)" coherence (~30 iters).
- Stalkwise: no stalk functor at the `Scheme.Modules` altitude (iter-244) — dead.
- `Modules.isIso_iff_isIso_app_affineOpens` proves an EXISTING map is iso; does not CONSTRUCT a
  fresh natural iso.

## Current code state (FlatBaseChange.lean)
- `affineBaseChange_pushforward_iso` (:709) = THE mate route: `rw [isIso_iff_isIso_app_affineOpens]`
  (:717) then `sorry` (:750). Two named walls in comments: (1) affine reduction / base-change
  compatibility of the mate with restriction to affine opens of `S'`; (2) mate ↔ cancelBaseChange.
- Sorry-free affine pieces in hand: `pushforward_spec_tilde_iso`, `pullback_spec_tilde_iso`,
  `TensorProduct.AlgebraTensorModule.cancelBaseChange`.
- Project ALREADY uses the morphism-descent machinery elsewhere: `Presheaf.IsSheaf.hom`,
  `presheafHomSectionsEquiv`, `sheafHomSectionsEquiv` (Picard/.../DualInverse.lean:919,1033),
  and `Scheme.OpenCover.glueMorphisms`/`Scheme.Cover.ι_glueMorphisms` (Picard/GrassmannianQuot.lean).

## Analogues found (ranked by porting cost, lowest first)

### Analogue: `CategoryTheory.Presheaf.IsSheaf.hom` (+ `presheafHom`, `sheafHomSectionsEquiv`)
- Path: `Mathlib.CategoryTheory.Sites.SheafHom`. CONFIRMED at pin (loogle); ALSO already used in
  project (DualInverse.lean).
- Domain: category-theoretic site theory.
- Same structural problem there: the hom-presheaf `presheafHom F G : Cᵒᵖ ⥤ Type`,
  `U ↦ (F|_{Over U} ⟶ G|_{Over U})`, is itself a SHEAF when `G` is a sheaf. So a global morphism
  `F ⟶ G` ↔ a global section of the hom-sheaf ↔ a PAIRWISE-compatible family of local morphisms on
  a cover. Descent = ordinary sheaf gluing (`existsUnique_gluing`), a 2-fold (pairwise) condition —
  NOT a 3-fold cocycle.
- Technique: forget `g^*f_*F`, `f'_*g'^*F` to the underlying `Ab`-sheaf via `SheafOfModules.toSheaf`;
  give the affine-local iso components `e.app(Spec R') = pushforward_spec_tilde ≫ pullback_spec_tilde
  ≫ tilde(cancelBaseChange)` as local sections of `presheafHom`; glue with
  `presheafHomSectionsEquiv`/`Presheaf.IsSheaf.hom`; re-impose 𝒪-linearity sectionwise via
  `PresheafOfModules.homMk` (R-linearity `f(r•m)=r•f(m)` is a sectionwise equation, holds globally
  once it holds on the basis by separatedness).
- Mapping: this is the EXACT recipe the project already executed for the line-bundle dual
  (DualInverse.lean). Re-run it with the FBC affine chain as the local data.
- Porting cost: LOW–MEDIUM. Machinery in hand; new work is the affine-restriction compatibility of
  the cancelBaseChange chain (see meta-judgment).
- Verdict: ANALOGUE_FOUND.

### Analogue: `TopCat.Sheaf.restrictHomEquivHom` (+ `TopCat.Sheaf.hom_ext`)
- Path: `Mathlib.Topology.Sheaves.SheafCondition.Sites`. CONFIRMED (leanfinder).
  `restrictHomEquivHom F F' (hB : IsBasis (range B)) : ((B^op)*F ⟶ (B^op)*F'.val) ≃ (F ⟶ F'.val)`.
- Domain: topological sheaf theory (basis form).
- Same structural problem: a morphism INTO a sheaf is determined by, and constructible from, its
  restriction to a BASIS of opens. The affine opens of `S'` form a basis (`X.isBasis_affineOpens`,
  already used at FlatBaseChange.lean:166). The only condition is naturality across basis
  INCLUSIONS — a poset of inclusions, i.e. commuting restriction squares, NOT a triple cocycle.
- Technique: define the iso on each affine `Spec R' ⊆ S'`, prove the square commutes for affine
  `Spec R'' ⊆ Spec R'` (= localization-naturality of cancelBaseChange), then `restrictHomEquivHom`
  promotes it to a global ab-sheaf morphism; `hom_ext` gives uniqueness/separatedness.
- Mapping: same as Analogue 1 but the descent is phrased as inclusion-naturality on a basis rather
  than pairwise gluing — strictly cheaper bookkeeping (no `IsCompatible` on pairwise meets).
- Porting cost: LOW for the ab-sheaf; +linearity upgrade via `homMk` (same as Analogue 1).
- Verdict: ANALOGUE_FOUND.

### Analogue: `CategoryTheory.Functor.IsCoverDense.restrictHomEquivHom` (+ `sheafHom`, `sheafHom_restrict_eq`)
- Path: `Mathlib.CategoryTheory.Sites.DenseSubsite.Basic`. CONFIRMED (leanfinder).
  `(G.op.comp ℱ ⟶ G.op.comp ℱ'.val) ≃ (ℱ ⟶ ℱ'.val)` for `G` cover-dense into site `(D,K)`.
- Domain: general site theory (dense-subsite descent — the abstract engine under Analogues 1–2).
- Same structural problem: the affine-opens subcategory is cover-dense in the Zariski site
  `Opens.grothendieckTopology S'`; a sheaf morphism over the full site ≃ a morphism of restrictions
  to the affine subsite. Matches the `Scheme.Modules` ab-sheaf altitude (sheaves on a site, general
  target `A`).
- Technique: identical shape; gives `sheafHom α` from `α` on the affine subsite, with
  `sheafHom_restrict_eq` the round-trip. Use when the `Opens X` basis form (Analogue 2) is awkward
  for the `SheafOfModules`-over-a-site presentation.
- Porting cost: MEDIUM (more general API; need `IsCoverDense`+`IsLocallyFull` instances for the
  affine subsite — heavier than the `TopCat` basis form).
- Verdict: ANALOGUE_FOUND (use only if Analogue 1/2 framing fights the `SheafOfModules` packaging).

### Analogue: `AlgebraicGeometry.Scheme.OpenCover.glueMorphisms` / `Scheme.Cover.ι_glueMorphisms`
- Path: `Mathlib.AlgebraicGeometry.Cover.Open` (project uses it in GrassmannianQuot.lean:4986+).
- Domain: algebraic geometry (SCHEME morphisms).
- Same structural problem (wrong altitude): compatible morphisms on cover pieces agreeing on
  pairwise pullbacks glue to a global morphism; `hom_ext`/`ι_glueMorphisms` give uniqueness. This is
  the morphism-gluing idiom the project is fluent in — but it glues maps of SCHEMES, not maps of
  sheaves-of-modules. Useful as the pattern/discipline (how to phrase pairwise agreement +
  uniqueness), not as the actual tool.
- Porting cost: pattern-only (does not act on `Scheme.Modules`).
- Verdict: PARTIAL_ANALOGUE.

### Analogue: `CategoryTheory.NatIso.ofComponents` + `Modules.isIso_iff_isIso_app_affineOpens`
- Path: project-local (`isIso_iff…` at FlatBaseChange.lean:161) + `NatIso.ofComponents` (used at
  FlatBaseChange.lean:667 for `gammaPushforwardNatIso`).
- Domain: project packaging step.
- Same structural problem: once you have, per quasi-coherent `F`, an object-level glued morphism
  `e_F : g^*f_*F ⟶ f'_*g'^*F` plus naturality in `F`, `NatIso.ofComponents` packages the family, and
  `isIso_iff_isIso_app_affineOpens` upgrades each `e_F` to an iso FOR FREE (it IS an iso affine-locally
  by the affine chain). Naturality-in-`F` is itself checked affine-locally / via `restrictHomEquivHom`
  naturality.
- Porting cost: LOW (idioms already in the file).
- Verdict: ANALOGUE_FOUND (the closing/packaging layer for whichever of 1/2/3 builds `e_F`).

## Cross-domain (wide) note
- `CategoryTheory.Functor.IsDenseSubsite.sheafEquiv` (Sites.DenseSubsite.*) — `Sheaf K A ≌ Sheaf J A`
  for a dense subsite; the abstract reason Analogues 1–3 work (the global iso is the Kan-extension /
  unique dense-extension of the affine-local iso). Heavier than needed but is the conceptual root.
- DISCARDED: analysis-style partition-of-unity gluing of local sections (manifolds / `ContinuousMap`).
  Same "local data + overlap ⇒ global object" silhouette, but the technique (bump functions /
  convex combination) does NOT port to a sheaf of modules with no smooth structure. NO_USEFUL_ANALOGUE.

## Meta-judgment: is "glue a fresh natIso" cheaper than the canonical-mate route?

**Conditionally YES — but only if `e` becomes the downstream deliverable, not a proof that the
existing mate is iso.**

- Building `e` via Analogue 1/2 **never forms the abstract mate**, so it sidesteps wall (2) (the
  mate ↔ cancelBaseChange coherence that stalled ~30 iters) ENTIRELY. The remaining obligation is
  wall (1) recast concretely: **naturality of the `cancelBaseChange`-tilde chain across affine
  restrictions of `S'`, plus coherence of the chosen upstairs affine `Spec R ⊆ S` as you shrink
  `Spec R' ⊆ S'`.** That is bounded commutative-algebra / localization-tensor naturality
  (`IsLocalizedModule`, `TensorProduct.AlgebraTensorModule` lemmas) — the kind the project already
  closed in `gammaTopEquivEqLocus`, `pushforward_spec_tilde_iso`, etc. — not a 2-categorical mate
  unwinding.
- The cocycle does NOT vanish, but it **shrinks**: with the BASIS form (Analogue 2) it is
  inclusion-naturality on a poset (commuting restriction squares), not a 3-fold descent datum.
- **The catch (decisive):** a fresh `e` does NOT discharge `IsIso (pushforwardBaseChangeMap …)`
  unless you also prove `e = pushforwardBaseChangeMap` — which IS wall (2) reborn. So the win is
  real ONLY if downstream (`flatBaseChange_pushforward_isIso`, `cechComplex_baseChange_iso`
  Stacks 02KG/02KH, Kleiman 4.8) is re-plumbed to consume `e` directly. `pushforwardBaseChangeMap`
  is NOT protected (only Genus/Jacobian/AbelJacobi are), so this is permitted. The Čech consumers
  need a base-change iso that commutes with restriction maps — which `e` supplies BY CONSTRUCTION
  (it is glued from restriction-compatible pieces), so the re-plumb is mathematically sound.
- If, instead, the project insists on the literal `IsIso (pushforwardBaseChangeMap)` statement,
  gluing buys NOTHING — the mate identification returns.

## Top suggestion
Pivot `affineBaseChange_pushforward_iso` from "prove the mate is iso" to "**construct a fresh
`e : g^*∘f_* ≅ f'_*∘g'^*` by gluing the affine `cancelBaseChange` chain, and re-target downstream to
`e`.**" Concretely: (1) per affine `Spec R' ⊆ S'`, take the sorry-free
`pushforward_spec_tilde_iso ≫ pullback_spec_tilde_iso ≫ tilde(cancelBaseChange)` as `e.app`; (2) glue
to a global ab-sheaf morphism with `Presheaf.IsSheaf.hom` + `presheafHomSectionsEquiv` (mirror
DualInverse.lean:919–1033, the project's own worked instance) — or, equivalently and with lighter
bookkeeping, `TopCat.Sheaf.restrictHomEquivHom` on the affine basis (`X.isBasis_affineOpens`); (3)
re-impose 𝒪-linearity via `PresheafOfModules.homMk`; (4) upgrade to iso with
`Modules.isIso_iff_isIso_app_affineOpens` and package in `F` via `NatIso.ofComponents`. The only
genuinely new lemma is the affine-restriction naturality of the cancelBaseChange chain (concrete
localization-tensor compatibility), which replaces the intractable mate coherence. First file to
touch: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (the `e` construction + restate
`affineBaseChange_pushforward_iso`'s consumers); reuse the descent recipe verbatim from
`Picard/TensorObjSubstrate/DualInverse.lean`.
