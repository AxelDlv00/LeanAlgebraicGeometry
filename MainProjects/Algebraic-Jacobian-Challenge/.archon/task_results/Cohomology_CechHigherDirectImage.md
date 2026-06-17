# AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean

## Summary
- **Declarations added (4, all axiom-clean `{propext, Classical.choice, Quot.sound}`):**
  - `pushforwardComp_hom_app_id` — pushforward of sheaves of modules is **strict**:
    `(pushforwardComp a p).hom.app M = 𝟙 _` by `rfl` (`pushforward (a≫p) = pushforward a ⋙ pushforward p`
    definitionally). Collapses all `pushforwardComp` legs of the push–pull pentagon.
  - `pushPull_unit_comp` — composite-unit decomposition `η^{f≫p} = η^p ≫ p_*(η^f) ≫ pushforwardComp ≫
    (f≫p)_*(pullbackComp.hom)`; the `pushPull_unit_mate` identity solved for `η^{f≫p}`
    (proof: `erw [reassoc_of% mate, ← map_comp, Iso.inv_hom_id_app, Functor.map_id, comp_id]`).
  - `rawPushPullMap` (def) — the body of `pushPullMap` with underlying map `a`, structure maps `p₁ p₂`,
    and over-triangle `w : a ≫ p₁ = p₂` **generalised to a free hypothesis** (this is what lets
    `subst` kill the transports).
  - `pushPullMap_eq_raw` — `pushPullMap F g = rawPushPullMap g.left Y₁.hom Y₂.hom (Over.w g) F` by `rfl`
    (NOTE: needs `set_option maxHeartbeats 1000000` — the kernel `rfl` check on the two big bodies is
    slow but valid; default 200000 kernel-times-out).
- **Declarations blocked (NOT added — would require `sorry`): `rawPushPullMap_comp`, `pushPullMap_comp`.**
  Reduced to an explicit, **transport-free** pullback pentagon (full reduction + roadmap + dead-ends are
  documented in a `/- ... -/` block in the file where the lemma would go). The 5-iteration kernel `whnf`
  wall (iters 264/265/271) is **completely removed** by the `subst` route.
- **sorry count: 4 → 4** (the 4 pre-existing infra-gated sorries: `CechNerve` L89, `CechAcyclic.affine`
  L540, `cech_computes_higherDirectImage` L577, `cech_flatBaseChange` L637). My additions add zero sorries.
- `lake env lean` on the file: **EXIT 0**.

## The dominant pole `pushPullMap_comp` — what was achieved
The blocker for iters 264/265/271 was a kernel `whnf` blow-up when cancelling `pushPullMap`'s two
over-triangle `eqToHom` transports *in situ*. This iter **kills that wall**:

1. `pushPullMap F g = rawPushPullMap g.left Y₁.hom Y₂.hom (Over.w g) F` (`rfl`), so `pushPullMap_comp`
   reduces to `rawPushPullMap_comp`, which has the over-triangles `wg : a≫p₁=p₂`, `wh : b≫p₂=p₃` as
   **free hypotheses**.
2. `subst wg; subst wh` → every over-triangle `eqToHom` becomes `eqToHom rfl = 𝟙` and vanishes
   (kernel-cheap, no `whnf` of comparison objects). `p₂ := a≫p₁`, `p₃ := b≫a≫p₁`.
3. `simp only [rawPushPullMap, eqToHom_refl]`, `rw [pushPull_unit_comp b a _]` (decompose `η^{b≫a}`),
   `simp only [pushforwardComp_hom_app_id]` (strictness collapses all `pushforwardComp`), then
   `repeat erw [Category.id_comp]` absorbs the resulting defeq-`𝟙`s.
4. Peel the common leading `(pushforward p₁).map(η^a)` via `erw [Category.assoc]; congr 1`, then align the
   `η^b` units via `(pullbackPushforwardAdjunction b).unit.naturality ((pullbackComp a p₁).hom.app F)`.

**Remaining goal (the genuine pullback pseudofunctor pentagon, explicit, no transports):**
```
(pushforward p₁).map (a_*(η^b) ≫ (b≫a)_*((pullbackComp b a).hom.app (p₁^*F))) ≫
  (pushforward (b≫a≫p₁)).map ((pullbackComp (b≫a) p₁).hom.app F) ≫ eqToHom
=
(pushforward (a≫p₁)).map (η^b ≫ (pullback b ⋙ pushforward b).map ((pullbackComp a p₁).hom.app F)) ≫
  (pushforward (b≫a≫p₁)).map ((pullbackComp b (a≫p₁)).hom.app F)
```
The residual content is exactly `Scheme.Modules.pseudofunctor_associativity (f := b) (g := a) (h := p₁)`
(its four `pullbackComp` 2-cells — `pullbackComp b a`, `pullbackComp (b≫a) p₁`, `pullbackComp a p₁`,
`pullbackComp b (a≫p₁)` — match) plus the single associativity cell `eqToHom ((b≫a)≫p₁ = b≫(a≫p₁))`
and the pushforward-strictness reindexing.

## Why I stopped — Partial progress (real, axiom-clean)
4 axiom-clean declarations added (named above); the dominant pole reduced from "kernel-wall-blocked
5-LOC composite" to "explicit transport-free pentagon". The remaining pentagon is **not closed** because
the regime is pervasively **defeq-not-syntactic**, and every closing tactic fails in a *named* way:

- `rw`/`reassoc_of%`/`simp` of `Category.assoc`, `Functor.map_comp`, and even a hand-written `rfl`-bridge
  `have hlead : … := rfl` **fail to match visually-identical terms** (the `SheafOfModules`/pushforward `≫`
  and `.map` carry non-syntactic instances). `reassoc_of%` of `pushPull_transport_cancel` also re-triggers
  the kernel `whnf` blow-up.
- `erw` matches by defeq but **whnf-unfolds `pullbackComp` into its raw `TwoSquare.equivNatTrans` /
  `mateEquiv` mate definition**, exploding the goal into hundreds of lines.
- `congr 1` on the defeq-but-not-syntactic leading factors recurses into the functor structure and likewise
  unfolds `pullbackComp` into HEq (`≍`) goals.
- Pinning the functor (`Functor.map_comp (F := …)`) lets `rw` target one side without exploding, but the
  *next* `erw` step still probes `pullbackComp`.

The informal agent was not consulted (this is a Lean-tactic/defeq-engineering obstacle, not a math gap;
`env | grep` for keys was not run — the obstacle is mechanical, not mathematical).

## Recommended next route (for the planner / next prover)
The bricks `rawPushPullMap`, `pushPullMap_eq_raw`, `pushPull_unit_comp`, `pushforwardComp_hom_app_id` are
the axiom-clean scaffolding; only the final pentagon remains. Two candidate routes:
1. **Adjunction-transpose reformulation**: transpose the pentagon across `(pullbackPushforwardAdjunction _).homEquiv`
   so it becomes a pure `pullback`-side identity provable by `pseudofunctor_associativity` *without* touching
   the strict-pushforward defeq wall (which is what makes `erw`/`congr` explode).
2. **A strictness-aware `@[simp]` normal form** for `pushforward (a≫b)` (= `pushforward a ⋙ pushforward b`),
   so the lead-peel and the strictness merges become *syntactic* and `rw`/`congr 1` stop failing/exploding.
   The single `eqToHom ((b≫a)≫p₁ = b≫(a≫p₁))` then closes against `pseudofunctor_associativity`.

## Blueprint markers (for review agent)
- `lem:push_pull_functor` (`AlgebraicGeometry.pushPullMap_id`, `AlgebraicGeometry.pushPullMap_comp`):
  `pushPullMap_id` is closed (unchanged); **`pushPullMap_comp` is NOT yet a declaration** — do not mark its
  half `\leanok`. (This matches the existing `% NOTE (iter-264)` in the chapter flagging that the block
  over-states until `pushPullMap_comp` lands.)
- `lem:push_pull_unit_mate`, `lem:push_pull_transport_cancel`: unchanged, still closed.
- New helper lemmas `pushPull_unit_comp`, `pushforwardComp_hom_app_id`, `rawPushPullMap`,
  `pushPullMap_eq_raw` have no blueprint block yet (project-local supplement bricks); the plan agent may add
  blueprint nodes if desired, but they are pure Lean scaffolding toward `lem:push_pull_functor`.
