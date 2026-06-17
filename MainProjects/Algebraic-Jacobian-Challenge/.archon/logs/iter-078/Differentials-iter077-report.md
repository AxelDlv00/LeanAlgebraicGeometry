# AlgebraicJacobian/Differentials.lean — iter-077 prover lane

## Status: PARTIAL PROGRESS (sorry count 7 → 6)

File compiles cleanly. 0 errors, 0 lint warnings. 6 `declaration uses sorry`
warnings.

## Sorry inventory (final)

| Line | Decl | Status |
|------|------|--------|
| 122  | `relativeDifferentialsPresheaf_isSheaf` | unchanged (pre-iter-076) |
| 260  | `cotangentExactSeqAlpha` (d_app field) | **partial close** — 4 of 5 fields proven; d_app retains a single internal sorry due to the non-definitional adjunction-coherence identity in current mathlib |
| 387  | `cotangentExactSeq_structure` | unchanged (still 1 absorbed sorry from iter-076) |
| 671  | `smooth_iff_locally_free_omega` | unchanged |
| 688  | `cotangent_at_section` | unchanged |
| 830  | `serre_duality_genus` | unchanged |

## cotangentExactSeqAlpha (line 200) — PARTIALLY CLOSED

### Approach
Restored the iter-072 strategy: refine via `(adj_f.homEquiv).symm`, build a
`Derivation' φ_g'` on the pushed-forward target with
`d_target.d b = D_X.d ((f.c.app U).hom b)`, then descend via
`isUniversal'.desc`.

### Per-field outcomes

- **`d` (additivity)** — CLOSED. Used
  `rw [show (f.c.app U).hom (a + b) = (f.c.app U).hom a + (f.c.app U).hom b
       from map_add _ _ _]; exact map_add D_X.d _ _`. The iter-076 recipe
  `rw [(f.c.app U).hom.map_add, D_X.d_add]` failed at pattern matching;
  the `show ... from map_add _ _ _` workaround bypasses the
  `CommRingCat.Hom.hom` syntactic-vs-pretty-print mismatch.
- **`d_mul`** — CLOSED. Same `show ... from map_mul _ _ _` workaround,
  then `exact D_X.d_mul _ _` (the `a • _` smul on the pushforward module
  is definitionally `(f.c.app U).hom a • _`).
- **`d_map`** — CLOSED. Used `erw [hnat']` for the elaboration-lenient
  rewrite, then `exact D_X.d_map _ _` (NOT `.symm` — the iter-072
  `.symm` was incorrect against the current pushforward goal form). The
  `congr_arg` binder type-annotation `(fun h : _ ⟶ _ => ...)` from the
  recipe was applied.
- **`d_app`** — SORRY (1 internal). The adjunction-coherence identity
  `φ_g' ≫ f.c = adj_f.unit ≫ (pushforward).map φ_fg'` is no longer `rfl`
  in current mathlib. Type-checking this composition requires the pullback
  composition functor equality
  `pullback f . obj (pullback g . obj S.presheaf) = pullback (f≫g) . obj S.presheaf`,
  which is true up to iso (uniqueness of left adjoints) but not definitional
  since `pullback := (Opens.map _).op.lan` is constructed via the left Kan
  extension's universal property. Closing this requires an explicit
  pullback-composition iso. See **Recommendation for iter-078** below.

### Heartbeat budget
The `cotangentExactSeqAlpha` body's elaboration (the d_target struct with
its four non-trivial fields) overflows the default 200k-heartbeat budget.
`set_option maxHeartbeats 16000000 in` is required before the def.

## cotangentExactSeqBeta (line 271) — FULLY CLOSED ✓

### Approach
Restored the iter-072 strategy verbatim: build a bridge map
`η := adj_fg.homEquiv.symm (g.c ≫ pushforward(g).map (adj_f.unit.app Y.presheaf))`
and prove `hη : η ≫ φ2' = φ1'` via the h1–h7 chain using
`Adjunction.homEquiv_naturality_right`, `Equiv.apply_symm_apply`, and
`(f≫g).c = g.c ≫ pushforward(g).map f.c` (`LocallyRingedSpace.comp_c`).

### Fixes from iter-072 baseline
- `(LocallyRingedSpace.comp_c f g).symm` failed because `f, g` are Scheme
  morphisms not LRS morphisms. Replaced with `rfl` (the identity is still
  rfl at the Scheme level because Scheme composition is defined via
  `f.toLRSHom ≫ g.toLRSHom` and `(f≫g).c` projects through `toLRSHom`).
- `congr 1` and removal of the trailing `exact h4` (the iter-076 recipe
  recommended this; verified that the `congr 1` alone closes the goal).

### Heartbeat budget
Same as alpha: `set_option maxHeartbeats 16000000 in` required.

## cotangentExactSeq_structure (line 377) — DEFERRED

Kept as a single sorry. The disabled iter-076 chain depends on
`unfold cotangentExactSeqAlpha` to expose the inline `d_target`, and on
the alpha definition fully closing (which it doesn't in this iter due to
the d_app sorry above). The disabled chain block is removed from the
file body (was a `/- ITER-076 disabled chain -/` comment) to reduce file
weight; the strategy is preserved in this task report and in iter-076's
preserved chain log.

When alpha's d_app is closed (iter-078+), re-enable the h_zero proof via
the chain:
1. `apply ((Scheme.Modules.pullbackPushforwardAdjunction f).homEquiv _ _).injective`
2. `rw [Adjunction.homAddEquiv_zero, Adjunction.homEquiv_naturality_right]`
3. `unfold cotangentExactSeqAlpha; simp only [Equiv.apply_symm_apply]`
4. `apply SheafOfModules.hom_ext; simp only [SheafOfModules.comp_val,
   SheafOfModules.pushforward_map_val]`
5. Re-bind `set φ_g'/φ_fg'/φ_2'/adj_f` and apply
   `isUniversal'.postcomp_injective`
6. `ext U b`, then build `hcoh + hcoh_app + hd_app` for the φ_2' derivation
7. Chain `hα_fac` then `unfold cotangentExactSeqBeta` then `hβ_fac` to
   collapse via the universal property of both alpha and beta to
   `(derivation' φ_2').d ((f.c.app U).hom b) = 0`, closed by `hd_app`.

`h_exact` and `h_epi` remain absorbed in the single structure sorry.

## Mathlib leverage names (verified iter-077)

- `Adjunction.homEquiv_naturality_right` ✓
- `Adjunction.homAddEquiv_zero` ✓
- `Equiv.apply_symm_apply` ✓
- `SheafOfModules.hom_ext` ✓
- `PresheafOfModules.DifferentialsConstruction.isUniversal'.postcomp_injective` ✓
- `PresheafOfModules.DifferentialsConstruction.derivation'.d_app` ✓
- `PresheafOfModules.Derivation.congr_d` ✓
- `KaehlerDifferential.exact_mapBaseChange_map` (still needed for structure
  h_exact)
- `KaehlerDifferential.map_surjective` (still needed for structure h_epi)

## NEW name added by this iter
- `LocallyRingedSpace.comp_c` is now restricted to LRS morphisms; for
  Scheme morphisms, `rfl` works directly (Scheme's category instance defers
  composition to `toLRSHom`).

## Recommendation for iter-078

### Priority 1: close `cotangentExactSeqAlpha.d_app` (1 internal sorry)

The goal is `D_X.d ((f.c.app U).hom (φ_g'.app U a)) = 0` where
`D_X = derivation' φ_fg'`. The mathematics: `(f.c.app U).hom (φ_g'.app U a)`
factors through `(φ_fg'.app (f⁻¹U)).hom` of some lift, then `D_X.d_app`
gives 0.

The lift requires the pullback composition iso
`pullback f ∘ pullback g ≅ pullback (f≫g)` as a natural iso of functors
on TopCat.Presheaf. By uniqueness of left adjoints (both functors are
left adjoint to `pushforward g ∘ pushforward f = pushforward (f≫g)`),
this iso exists. Search Mathlib for `lan_comp`, `lanCompIso`,
`Functor.compLeftAdjoint`, or build via
`Adjunction.leftAdjointUniq pullbackPushforwardAdjunction _`.

Alternatively, use the η bridge from cotangentExactSeqBeta: η lifts a
morphism `pullback (f≫g) S.presheaf ⟶ pullback f Y.presheaf`. The dual
direction `ζ : pullback g S.presheaf ⟶ pushforward f . obj (pullback (f≫g) S.presheaf)`
can be built similarly via `adj_fg.homEquiv.symm` of a specific morphism.
Then pointwise `(f.c.app U).hom (φ_g'.app U a) = (φ_fg'.app (f⁻¹U)) ((ζ.app U) a)`
gives the desired form.

### Priority 2: close `cotangentExactSeq_structure` (3-in-1 sorry)

After alpha is fully closed, execute the preserved chain above for h_zero.
For h_exact, need a sheaf-level stalkwise exactness bridge. For h_epi,
need a sheaf-level epi-from-presheaf bridge.

## Blueprint marker

No blueprint edits performed (prover-stage rule). `\leanok` markers in
`blueprint/src/chapters/Differentials.tex` will be re-synced by
`sync_leanok` next phase based on the actual sorry state above:
- `relativeDifferentialsPresheaf` — \leanok (fully closed, no sorry)
- `relativeDifferentialsPresheaf_isSheaf` — \leanok (sorry inside, but
  declared)
- `relativeDifferentials` — \leanok
- `universalDerivation` — \leanok
- `cotangentExactSeqAlpha` — \leanok (sorry inside d_app)
- `cotangentExactSeqBeta` — \leanok (FULLY CLOSED — sync_leanok should
  add \leanok to the proof block too)
- `cotangentExactSeq_structure` — \leanok (sorry inside)
- `cotangent_exact_sequence` — \leanok (zero sorries, derived)
- `smooth_iff_locally_free_omega` — \leanok (sorry)
- `cotangent_at_section` — \leanok (sorry)
- `serre_duality_genus` — \leanok (sorry)
