# Iter-002 objectives (detail)

## Prover lane (1 file, 1 prover)

### `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` — build & prove `pushPullMap_comp`
- **Mode**: `prove` (default). One deep target with a concrete de-risked recipe + all bricks proved.
- **Nature**: BUILD-AND-PROVE. `AlgebraicGeometry.pushPullMap_comp` is NOT in the file (only the
  planning comment at L269–300). The prover must ADD the declaration, then prove it. There is no
  sorry to "fill".
- **Signature** (contravariant composition law; match the in-file comment form):
  `pushPullMap F (g ≫ h) = pushPullMap F h ≫ pushPullMap F g`.
- **Recipe** (avoids the documented kernel-`whnf` explosion of the pushforward-side `erw` grind):
  mate calculus — `Scheme.Modules.conjugateEquiv_comp` + injectivity of `conjugateEquiv` reduces
  the goal to the pullback-side pentagon
  `Scheme.Modules.pseudofunctor_associativity (f := g.left) (g := h.left) (h := Y₁.hom)`
  (verified to typecheck), assisted by `Adjunction.comp_unit_app`, `Adjunction.unit_naturality`,
  and the `pushPullMap_eq_raw` (`rfl`) reduction through `rawPushPullMap`.
- **Bricks already proved in-file** (reuse, do not re-prove): `pushPullMap_id` (template),
  `pushPull_unit_mate`, `pushPull_transport_cancel`, `pushPull_unit_comp`,
  `pushforwardComp_hom_app_id`, `rawPushPullMap`, `pushPullMap_eq_raw`.
- **Informal content**: `.archon/analogies/pushpull-functoriality.md` (full recipe + verified
  Mathlib infra); in-file comment L269–471; blueprint `lem:push_pull_comp` in
  `chapters/Cohomology_CechHigherDirectImage.tex`.
- **Stretch** (only if `pushPullMap_comp` closes cleanly with budget left): attempt the
  `CechNerve` sorry (L91, `def:cech_nerve`, P2) — buildable once `G` is a functor.
- **Out of scope**: `CechAcyclic.affine` (L544, P3), `cech_computes_higherDirectImage` (L581, P5)
  — both blocked on absent infra; do not touch.

## Not dispatched (blocked — see plan.md D3/D4)
- P4 `AcyclicResolution.lean`: file unscaffolded; chapter `correct: partial` (anchor must-fix).
- P3 `CechAcyclic.affine`: needs localisation infra + effort-breaker decomposition first.
- P5 `cech_computes_higherDirectImage`: needs P2–P4.
