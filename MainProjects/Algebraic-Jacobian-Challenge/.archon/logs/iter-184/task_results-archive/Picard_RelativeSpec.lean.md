# Picard/RelativeSpec.lean

## Lane D — `pullback_iso_construction` body close

### Outcome

**PARTIAL** with significant structural decomposition. Build green.

### State changes

The single bare `sorry` on `pullback_iso_construction` body (L484-530) was
replaced by a structured proof through 5 named helpers (using all of the
helper budget = 5):

1. **`pullback_iso_affine_piece`** (already existed, axiom-clean) — per-affine
   iso `(q⁻¹U.1).toScheme ≅ Spec((g^*𝒜)(U))` via `IsAffineOpen.isoSpec`.

2. **`pullback_cocone`** (NEW) — cocone on
   `(relativeGluingData _).functor` with point `pullback g (structureMorphism 𝒜)`.
   Component at U is `(U.2.preimage q).fromSpec`. **Naturality sorry**
   (Tier-3): the structural unfolding of `(relativeGluingData _).functor.map`
   to `Spec.map (P.presheaf.map _)` form requires deep transparency defeq
   beyond `set_option backward.isDefEq.respectTransparency false`. Once
   unfolded, `IsAffineOpen.map_fromSpec` closes. Strategy comment in place.

3. **`pullback_cocone_desc_comp_fst`** (NEW, **fully closed modulo helper 2**)
   — the colimit descent of `pullback_cocone` composed with the pullback
   projection `q` equals the relative-gluing-data structure morphism
   `d.toBase`. Proof: `colimit.hom_ext`, then `SpecMap_appLE_fromSpec` +
   `app_eq_appLE` + `isoSpec_inv_ι` chain (~6 lines). Axiom-clean modulo
   `pullback_cocone` naturality (Tier-2).

4. **`pullback_iso_desc_isIso`** (NEW) — the colimit descent is an isomorphism.
   Proof via `IsZariskiLocalAtTarget.iff_of_iSup_eq_top` with affine open
   family `{q⁻¹U.1 | U : T.AffineZariskiSite}`:
   - **iSup branch fully closed** (4 lines via `preimage_iSup` +
     `iSup_affineOpens_eq_top T` + `preimage_top`).
   - **Per-piece branch sorry** (Tier-3): the per-U `IsIso (desc ∣_ q⁻¹U.1)`
     check. Strategy: factor through three explicit isos (range equality via
     `hPre = desc⁻¹(q⁻¹U.1) = (colimit.ι d.functor U).opensRange`, then
     `isoOpensRange` to `d.functor.obj U`, then
     `(pullback_iso_affine_piece).symm` to `(q⁻¹U.1).toScheme`). Detailed
     compatibility check ~30-50 LOC; the structural scaffold (hPre named, all
     three isos identified) is in place.

5. **`pullback_iso_construction`** (RE-WRITTEN, fully closes modulo helpers
   2 + 4) — assembled via `asIso desc |>.symm` where `desc` is the colimit
   descent.

### Helper budget audit

5 of 5 used (on budget).

### Critical Mathlib idiom discovered

The `HasColimit (relativeGluingData _).functor` instance does NOT auto-synthesize
even though `T.RelativeSpec(𝒜) = (relativeGluingData _).glued = colimit ...`
works as an abbrev. The instance becomes available after explicitly invoking:

```lean
haveI : ((relativeGluingData _).functor ⋙ Scheme.forget).IsLocallyDirected :=
  Cover.RelativeGluingData.instIsLocallyDirectedI₀CompFunctorForgetOfIsThin _
```

(reusable Mathlib analogist note for any future code that uses
`colimit.desc d.functor _` etc. directly).

### Sorry tally

- **Entering**: 1 sorry (bare on `pullback_iso_construction` body).
- **Exiting**: 2 sorries (both well-decomposed in named helpers with
  Tier-3 strategy comments).
  - L494: `pullback_cocone` naturality.
  - L583: `pullback_iso_desc_isIso` per-piece factorisation.

Raw sorry count went up by 1, but the proof structure is now hierarchically
decomposed with 3 axiom-clean helpers (`pullback_iso_affine_piece`,
`pullback_cocone_desc_comp_fst`'s body, `pullback_iso_desc_isIso`'s iSup
branch + `hPre` identity) and 2 narrowly-scoped sorries with explicit
strategy comments.

### Axiom audit (file-level)

- `pullback_iso_affine_piece` — axiom-clean (kernel-only).
- `pullback_cocone` — sorryAx (naturality sorry).
- `pullback_cocone_desc_comp_fst` — sorryAx (transitively, via
  `pullback_cocone`). Body itself is fully proven.
- `pullback_iso_desc_isIso` — sorryAx (per-piece sorry).
- `pullback_iso_construction` — sorryAx (transitively).

No new project-level axioms introduced (only `sorryAx`).

### iter-184+ pickup plan

The two remaining sorries are both close to landing:

1. **`pullback_cocone` naturality**: routine unfolding of
   `(relativeGluingData _).functor.map` to expose `Spec.map (P.presheaf.map _)`
   form, then `IsAffineOpen.map_fromSpec` closes. The challenge is the deep
   transparency required for the defeq; possibly a `dsimp [relativeGluingData,
   AffineZariskiSite.toOpensFunctor, Functor.rightOp, NatTrans.whiskerLeft]`
   or similar unfolding directive plus `set_option maxHeartbeats 800000` will
   succeed (we tried `set_option backward.isDefEq.respectTransparency false`
   which wasn't enough).

2. **`pullback_iso_desc_isIso` per-piece**: build the iso explicitly via
   `IsOpenImmersion.isoOfRangeEq` on `pullback.fst desc (q⁻¹U.1).ι` and
   `colimit.ι d.functor U`, then identify `desc ∣_ q⁻¹U.1` with the
   composition `e.inv ≫ pullback.snd desc (q⁻¹U.1).ι` (where `e` is the
   constructed iso) and verify via cancellation. The `hPre` identity is the
   key bridge — already in place. See
   `SmallAffineZariski.isColimitCocone` (`Sites/SmallAffineZariski.lean:343`)
   for the exact template.

### Build

`lake build AlgebraicJacobian.Picard.RelativeSpec` GREEN (4.3s).

### Lemmas/idioms discovered (for task_pending.md)

- `Cover.RelativeGluingData.instIsLocallyDirectedI₀CompFunctorForgetOfIsThin`
  is the named instance for the locally-directed property; manually
  invoking via `haveI` unblocks `HasColimit` synthesis through abbrevs.
- `IsAffineOpen.SpecMap_appLE_fromSpec` (`AffineScheme.lean:464`) — `q.appLE`
  composed with `fromSpec` factors as the affine-restriction `fromSpec ≫ q`.
- `IsAffineOpen.map_fromSpec` (`AffineScheme.lean:451`) — `Spec.map` of
  restriction composed with `fromSpec` of bigger affine open = `fromSpec` of
  smaller affine open.
- `Cover.RelativeGluingData.toBase_preimage_eq_opensRange_ι`
  (`RelativeGluing.lean:166`) — preimage of cover piece under `toBase` is the
  `colimit.ι`'s opens-range. Used by `pullback_iso_desc_isIso` via the
  identity `desc ≫ q = d.toBase`.
