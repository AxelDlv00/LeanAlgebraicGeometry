# Analogy: Beck–Chevalley for an open immersion in sheaves of modules

## Mode
cross-domain-inspiration

## Slug
fbc326

## Iteration
326

## Structural problem (abstracted)
A cartesian square of "spaces" with one parallel edge `p` a restriction-along-an-open
(an open immersion). Two functors of a coefficient object `F` on the base: pull back the
direct image `p_*p^*F` along the other base edge `g'`, vs. take the direct image
`p'_*p'^*((g')^*F)` along the pulled-back open. Want: a canonical iso. The right adjoint
`p_*` is *direct image* (NOT extension-by-zero), so there is no "vanish off the open"
support trick; the genuine content is that the abstract left adjoint `(g')^*` (a left Kan
extension / sheafified tensor) commutes with the concrete restriction-direct-image along
the open. Concretely `(pullback g').obj (pushforward p (pullback p F)) ≅ pushforward p'
(pullback p' (pullback g' F))` in `X'.Modules`.

## Failed approaches (from directive)
- General flat adjoint-mate route (`pushforwardBaseChangeMap`/`pushPullMap_comp`): walls on
  the opaque `Lan` left adjoint; mate cocycle deleted iter-312; >80-min builds.
- Literal stalkwise iso: NO stalk functor for (pre)sheaves of modules in Mathlib
  (iter-244/304 left-exactness wall).

## Key Mathlib facts located (all in `Mathlib.AlgebraicGeometry.Modules.Sheaf`)
- `Scheme.Modules.Hom.isIso_iff_isIso_app` : `IsIso φ ↔ ∀ U, IsIso (Hom.app φ U)` — **iso
  criterion over OPENS, not stalks.** This is the stalk-free substitute the directive asks
  for. (+ `instIsIsoAbApp` the easy direction.)
- `pushforward_obj_obj` : `Γ((pushforward f).obj M, U) = Γ(M, (Opens.map f.base).obj U)` —
  closed-form sectionwise formula for pushforward along ANY `f`. `pushforward_map_app`,
  `restrict_obj` likewise. (Pushforward sections are CONCRETE.)
- `restrictFunctorIsoPullback f` `[IsOpenImmersion f]` : `restrictFunctor f ≅ pullback f`.
  → for an open immersion the abstract `Lan` pullback IS the `Opens.map` restriction.
- `restrictAdjunction f` `[IsOpenImmersion f]` : `restrictFunctor f ⊣ pushforward f`
  (CONCRETE adjunction; left adjoint is `Opens.map`-restriction, not the opaque Lan).
- `instFullPushforward`, `instFaithfulPushforward` `[IsOpenImmersion f]` — `pushforward f`
  FULLY FAITHFUL; `restrictFunctorAdjCounitIso`/`instIsIsoFunctorCounitRestrictAdjunction`
  — counit `restrictFunctor f ∘ pushforward f ≅ id` is iso.
- `pullbackComp`, `pullbackId`, `pullbackCongr` — full pseudofunctor structure on `pullback`.
- `AlgebraicGeometry.pullbackRestrictIsoRestrict f U` : `pullback f U.ι ≅ (Opens.map f.base).obj U`
  — scheme-level open-immersion base change (already used in-file by `coverOpen_baseChange_eq`).
- Project (`QuotScheme.lean`): `canonicalBaseChangeMap sq` IS the mate
  `pushforward f ⋙ pullback g ⟶ pullback g' ⋙ pushforward f'`; its iso-ness rests on the
  typed-sorry affine section formula `pullback_app_isoTensor` / `pullback_tildeIso`
  (Stacks 01HQ). Same gap catalogued in `analogies/quotscheme-pullback-affine-section.md`.

## Analogues found (ranked by porting cost)

### Analogue 1 — pseudofunctor telescope (reduces the leaf). `restrictFunctorIsoPullback` + `pullbackComp` (×2) + `sq.w`
- **Domain**: algebraic geometry / 2-categorical (pseudofunctor of pullback).
- **Same shape**: collapse `restrict ∘ pullback` across the commuting square to a single
  pullback. `restrict p' (pullback g' M) = pullback p' (pullback g' M) ≅ pullback (p'≫g') M
  = pullback (gV≫p) M ≅ pullback gV (pullback p M) = pullback gV (restrict p M)` using
  `restrictFunctorIsoPullback p'/p`, `pullbackComp`, and `sq.w : gV ≫ p = p' ≫ g'`.
- **Technique**: same telescope idiom the project already lands in the CechSectionIdentification
  legs (associator + `pullbackComp` + `pullbackCongr w`). Sorry-free, build-cheap.
- **Mapping**: this rewrites the TARGET RHS `pushforward p' (pullback p' (pullback g' F))`
  into `pushforward p' (pullback gV (pullback p F))`, and the LHS is
  `pullback g' (pushforward p (pullback p F))`. So `openImmersion_beckChevalley` reduces, with
  `G := pullback p F`, to the bare BC `pullback g' (pushforward p G) ≅ pushforward p' (pullback gV G)`
  — i.e. exactly `(canonicalBaseChangeMap _hsq).app G` being an iso (one `Hom`, one `IsIso`).
- **Porting cost**: LOW. ~30–50 LOC, no new Mathlib. Independent of how the bare BC is proven.
- **Verdict**: ANALOGUE_FOUND.

### Analogue 2 — sectionwise iso criterion (stalk-free). `Scheme.Modules.Hom.isIso_iff_isIso_app`
- **Domain**: algebraic geometry (sheaf of modules), but the SHAPE is the generic
  "iso ⟺ iso on a generating family" (cf. `Sheaf.isLocallyBijective_iff_isIso`,
  `GrothendieckTopology.W_sheafToPresheaf_map_iff_isIso`).
- **Same shape**: replace the missing stalk-conservativity by conservativity of the family
  of section functors `{Γ(-,U)}_U`.
- **Technique**: build the bare-BC comparison map, prove `IsIso` by checking each
  `Hom.app _ U`. Pushforward sections are computable (`pushforward_obj_obj`); restriction
  sections computable (`restrict_obj`).
- **Mapping**: answers the directive crux — YES, the open-immersion case sidesteps the
  missing STALK functor (use opens, not stalks). BUT one side is `pullback g' (pushforward p G)`
  with the pullback OUTSIDE, and `Scheme.Modules.pullback` has NO sectionwise formula → see
  the frontier ingredient. So this criterion is necessary but not yet sufficient.
- **Porting cost**: LOW to state, BLOCKED until the pullback-section formula exists.
- **Verdict**: ANALOGUE_FOUND (criterion) / blocked on Frontier.

### Analogue 3 — open-immersion full-faithfulness / essential-image. `instFullPushforward` + `restrictFunctorAdjCounitIso`
- **Domain**: category theory (reflective-style: ff right adjoint, essential image via unit-iso).
- **Same shape**: an object `A` is `≅ pushforward p' (restrict p' A)` iff the unit
  `A → pushforward p' (restrict p' A)` is iso; `restrict p' A` is computable by the
  telescope + counit (`restrict p (pushforward p G) ≅ G`), giving `restrict p' A ≅ pullback gV G`.
- **Technique**: reduce the bare BC to "the LHS `pullback g' (pushforward p G)` is a direct
  image from `V'`", i.e. its restriction maps `Γ(A,U) → Γ(A,U∩V')` are isos.
- **Mapping**: elegant reformulation, but `restrict p'` (a left adjoint) is NOT conservative,
  so `restrict p' θ` iso does not give `θ` iso — the off-`V'` sections are exactly the
  pullback-section content. So this too funnels into the Frontier ingredient.
- **Porting cost**: MEDIUM; still blocked on pullback sections.
- **Verdict**: PARTIAL_ANALOGUE.

### Analogue 4 — scheme-level open-immersion base change. `AlgebraicGeometry.pullbackRestrictIsoRestrict`
- **Domain**: algebraic geometry (schemes, not modules).
- **Same shape**: `pullback f U.ι ≅ (Opens.map f.base).obj U` — pulling an open immersion
  back is restriction to the preimage open. Range identity already used in-file
  (`coverOpen_baseChange_eq`, `pullbackRestrictIsoRestrict_inv_fst`).
- **Technique**: range-equality + restriction functoriality, NO mate/stalks.
- **Mapping**: supplies the geometric backbone (the cartesian square IS the preimage open),
  i.e. `V' = (g')⁻¹V`, feeding `isoOfRangeEq` in `twisted_cech_nerve_per_sigma` step (3).
  Module-level it only confirms the square; the coefficient iso is Analogue 1+frontier.
- **Porting cost**: LOW (already partly in use).
- **Verdict**: ANALOGUE_FOUND (geometric scaffolding only).

### Analogue 5 — topological pushforward base change (lower-tech). `TopCat.Presheaf.pushforward` + `pushforwardPullbackAdjunction`
- **Domain**: topology (presheaves on spaces).
- **Same shape**: identical square; `pushforward` is precompose-with-`Opens.map`
  (`pushforward_obj_map`, concrete), `pullback` is the colimit/Lan left adjoint.
- **Technique**: the pushforward side is definitional via `Opens.map` functoriality; the
  pullback side is the SAME Lan wall.
- **Mapping**: confirms structurally that ONLY the pullback factor is hard, and that there is
  no free topological short-circuit — Mathlib's `TopCat.Presheaf.pullback` has no affine/open
  section formula either. Negative evidence: don't expect a topological port to dodge the gap.
- **Porting cost**: N/A (no win).
- **Verdict**: NO_USEFUL_ANALOGUE (same obstruction one shelf down).

## Frontier ingredient (precise)
The open-immersion case does NOT avoid the project-wide pullback wall. Every route above
funnels into a **sectionwise / affine-open description of `Scheme.Modules.pullback g'`**:
the Stacks **01HQ / 0BJ8** formula
`Γ((pullback g).obj N, U) ≃ Γ(S',U) ⊗_{Γ(S,V)} Γ(N,V)` for compatible affine `V⊆S, U⊆S'`,
project-named `pullback_app_isoTensor` / `pullback_tildeIso` (typed sorries,
`QuotScheme.lean:409–600`). Mathlib has NO `pullback_obj_obj` (only `pullbackObjFreeIso` at
free sheaves; see `analogies/quotscheme-pullback-affine-section.md` survey table). With that
formula, `isIso_iff_isIso_app` (Analogue 2) closes the open-immersion BC AND the general
flat BC uniformly.

**Open-immersion-specific bypass (cheaper, signature change):** the actual consumer
(`twisted_cech_nerve_per_sigma`) has `[IsSeparated f]` and `U_σ` AFFINE
(`coverInterOpen_isAffine`/`isAffineOpen_coverInterOpen`). If `openImmersion_beckChevalley`
is allowed `[IsAffine V]` (or `[QuasiCompact p]`) — it is NOT protected, so the signature can
be widened — then `p_*p^*F` is affine-locally a localization and the project's existing
sorry-free affine bridge `pushPullObj_pushforward_iso_tilde_affine [IsAffine S]`
(`CechHigherDirectImageUnconditional.lean:448`) + localization⊗base-change may discharge the
bare BC without the full 01HQ formula. This is the lower-cost frontier.

## Top suggestion
Dispatch a `mathlib-build` lane in two stages. STAGE 1 (low-risk, do regardless): land the
**Analogue-1 telescope** so `openImmersion_beckChevalley := (telescope) ≪≫ asIso (bareBC.app
(pullback p F))`, collapsing the leaf to the single obligation `IsIso (bareBC.app G)` where
`bareBC : pushforward p ⋙ pullback g' ⟶ pullback gV ⋙ pushforward p'` (re-state the 6-line
`canonicalBaseChangeMap` mate locally — do NOT import sorry-tainted QuotScheme). This is
sorry-free and shrinks every dependent FBC leaf. STAGE 2 (the genuine node): prove `IsIso
bareBC` for open-immersion `p` via `isIso_iff_isIso_app` + `pushforward_obj_obj`; this needs
the 01HQ pullback-section formula. Recommend FIRST trying the `[IsAffine V]` bypass through
`pushPullObj_pushforward_iso_tilde_affine` (cheap, matches the actual affine `U_σ`), and only
if that fails, escalate the full 01HQ `pullback_app_isoTensor` (the shared frontier with
`canonicalBaseChangeMap_isIso`). First files to touch:
`CechHigherDirectImageUnconditional.lean` (telescope + bareBC) and the 01HQ atom.

## Discarded
- Forming a fresh `pushforwardBaseChangeMap` mate on the abstract `Lan` adjunction — directive
  Failed-approach; also the project's `canonicalBaseChangeMap` already IS that mate and its
  iso-apparatus is the wrong orientation (`[Flat g]`, not flat-`p`).
- Stalkwise iso — no stalk functor for modules (Failed-approach); replaced by `isIso_iff_isIso_app`.
- "Vanish off `V'`" (the docstring's own sketch) — FALSE for the right-adjoint direct image
  `p_*` (it has sections off `V`); conflates `p_*` with `p_!`. The square's off-`V'` data is
  real and is exactly the pullback-section content.
