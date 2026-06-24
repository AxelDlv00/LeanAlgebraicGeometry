# Obstacle: `chartBaseChangeGeometricComparison_dictionary_glue_app` (b2 master glue at `M`)

## Where we are (iter-032)

The re-scoped ring-square realization
`pullback_spec_tilde_iso_ring_square_natural_extendScalarsCocycle` (the b2 crux conclusion) is now
**genuine iso-algebra**, PROVED modulo a single isolated identity:

```
chartBaseChangeGeometricComparison_dictionary_glue_app  (the `.app M` of blueprint
  lem:chartBaseChangeGeometricComparison_dictionary_glue):

  geomComp(M) ≪≫ (pb ι_{R'}).mapIso(pst ρ M) ≪≫ pst ι_{R'}(ext ρ M)
    = (pb ρ_B).mapIso(pst ι_R M) ≪≫ pst ρ_B(ext ι_R M) ≪≫ tilde.mapIso(reassoc M)
```

The realization is exactly this with the trailing dictionary `pst ι_{R'}(ext ρ M)` cancelled by the
proven helper `iso_trans_cancel_trailing`. So **the only open content of the b2 crux is this master
glue at `M`.**

Proven helpers landed this iter (all cold-green, sorry-free):
- `iso_trans_cancel_trailing` — trailing-iso cancellation (pure category theory).
- `pullbackSpecTildeComp` — the two-leg dictionary fold (blueprint `lem:pullbackSpecTildeComp`).
- `pullbackSpecTildeComp_hom_app` — its `.hom.app M` is the leg composite, by `rfl`.

## The tractable target: `mgNat` (functor level)

The master glue at `M` is the `.app M` of the **functor-level** master glue:

```
mgNat :
  (tilde ◁ chartBaseChangeGeometricComparisonNat) ≪≫ pullbackSpecTildeComp ρ ι_{R'}
    = pullbackSpecTildeComp ι_R ρ_B ≪≫ (chartBaseChangeModuleReassocNat ▷ tilde)
```

**Phrasing note (important):** declare `pullbackSpecTildeComp`'s codomain LEFT-associated,
`(extendScalars φ ⋙ extendScalars φ') ⋙ tilde`, so that both sides of `mgNat` are *syntactically*
typed (otherwise the right side's `≪≫` has a defeq-but-not-syntactic middle and `NatIso.trans_app`
will not fire). With the left-assoc codomain `mgNat` needs **no associators**.

`mgNat` is the blueprint master glue and is the **right place to do the hard work**: every functor is
abstract, no `tilde M` is ever evaluated, so `pullbackComp` is never forced to whnf. Its proof is the
dictionary multiplicativity `pullbackSpecTildeComp_eq_composite` applied to both routings, after which
the two `pullbackComp` conjugators cancel against `chartBaseChangeGeometricComparisonNat`'s, leaving
exactly `chartBaseChangeModuleReassocNat` (the algebraic cocycle). The per-piece mate ingredients are
ALL already proven in `FlatBaseChange.lean`:
- `conjugateEquiv_pullbackComp_inv` (conjugate of `pushforwardComp.inv` = `pullbackComp.hom`),
- `conjugateEquiv_extendScalarsComp` (conjugate of `extendScalarsComp` = `restrictScalarsComp.inv`),
- `conjugateIsoEquiv_comp` / `conjugateIsoEquiv_symm_comp` (carrier-free conjugate composition),
- `gammaPushforwardNatIso_comp` (multiplicativity of the base Γ-comparison).

So `pullbackSpecTildeComp_eq_composite` should follow by transporting `gammaPushforwardNatIso_comp`
through the conjugation (`pullbackSpecTildeNatIso φ = conjugate of gammaPushforwardNatIso φ`), exactly
as the geometric/algebraic legs `chartBaseChangeGeometricComparison_mate` /
`chartBaseChangeModuleReassoc_extendScalarsComp` were closed (iter-018). This is the next-iter target.

## The wall (why `mgNat ⟹ master_glue_app` does NOT close this iter)

The descent `congrArg (·.app M) mgNat` followed by the cheap rfl-folds
(`NatIso.trans_app`, `whiskerLeft_app`/`whiskerRight_app` = `rfl`, `pullbackSpecTildeComp_app` = `rfl`,
`tilde.functor_obj`, the **iso-level** geometric bridge
`chartBaseChangeGeometricComparison M = chartBaseChangeGeometricComparisonNat.app (tilde M)` which is
`rfl` at the iso level — only the `.hom` extraction is the L1737 wall — and the reassoc bridge
`chartBaseChangeModuleReassoc_eq_natApp`) folds BOTH sides to **identical visible normal forms**.

But the closing `exact h` / `convert h` STILL `(kernel) deterministic timeout`s at `isDefEq`
(> 200000 hb, surfaced only by cold `lake env lean`, not the LSP). Root cause: the iso EQUATION's
TYPE carries the heavy `pullback (Spec _).obj (tilde M)` objects; matching `h`'s carrier against the
goal's carrier forces a whnf of the sheafification / `Localization.fac` proof terms buried in
`tilde M` — the documented `X.Modules`/value-`ModuleCat` diamond. Every structural fold is cheap; only
the final whole-equation defeq is expensive, and it cannot be avoided by further normalization (tried:
`exact`, `convert using 1/2`, `tilde.functor_obj` carrier unification, iso-level vs hom-level bridges).

So the descent reduces `master_glue_app` to `mgNat` **modulo a whnf-free final defeq the diamond
denies.** Two ways forward for the planner:

1. **Prove `mgNat` and find a whnf-free descent.** Candidates: a custom congruence that never forms
   the whole-equation defeq (e.g. building the `M`-component iso by `Iso.ext` over a per-component
   equation proved at the abstract level then `.app M`-instantiated by substitution, per the L1737
   "generic-N then instantiate" hint — but the algebraic reassoc is `tilde M`-specific, so a generic
   carrier `N` substitution must be set up carefully); or a `Subsingleton`/uniqueness argument for the
   adjoint transpose that closes the iso without a carrier defeq.
2. **Adjoint-uniqueness route for `master_glue_app` directly**, keeping the geometric comparison
   abstract (never extracting its value), so no `tilde M` carrier defeq is ever demanded.

The diamond is the same wall that killed the element / `_concrete` / mate-fold routes; the re-scope
genuinely moves the hard *mathematical* content to the tractable `mgNat`, but the *kernel* descent to
`M` remains the residual engineering obstacle.
