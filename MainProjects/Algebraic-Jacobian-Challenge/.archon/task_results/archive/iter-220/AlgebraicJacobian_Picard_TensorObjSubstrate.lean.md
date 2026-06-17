# AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Summary

**Declarations added: 12, all axiom-clean** (`#print axioms` = `{propext, Classical.choice, Quot.sound}`).
**Sub-step 2 COMPLETE + the ASSEMBLED `internalHom` BUILT** (iter-220's stated success target).
sorry count in file: **3 → 3 unchanged** (pre-existing L632 `isLocallyInjective_whiskerLeft_of_W`,
L1733 `exists_tensorObj_inverse`, L1777 `addCommGroup_via_tensorObj` — all untouched; the last two FORBIDDEN this iter).

New declarations (all in `namespace PresheafOfModules.InternalHom`):
1. `restrictionMap` (def) — `φ ↦ φ|_V` via `pushforward₀ (Over.map g)`. **PRIMARY target 1.**
2. `restrictionMap_add`, 3. `restrictionMap_zero` — additivity (`ext1 X; rfl`).
4. `hom_app_heq` (private helper) — `HEq` of a Hom's `.app` at equal objects, via `subst`. **The key that cracked functoriality.**
5. `restrictionMap_id`, 6. `restrictionMap_comp` — **functoriality (pseudofunctor coherence)**, via `eq_of_heq (hom_app_heq …)`.
7. `restrictionMap_comp_hom` — restriction respects `≫` (`Functor.map_comp`).
8. `restrictionMap_globalSMul` — **the semilinearity core**: `restrictionMap g (globalSMul_U r) = globalSMul_V (R(g) r)`.
9. `restrictionMapAddHom` — `restrictionMap` packaged as `→+`.
10. `internalHomPresheaf` — **the Ab-valued presheaf** `U ↦ (M|_U ⟶ N|_U)` (universe-polymorphic at `AddCommGrpCat.{max u uC vC}`). **PRIMARY target 2 (a)+(b)+(c).**
11. `restrictionMap_smul` — semilinearity in the exact `ofPresheaf` `map_smul` form.
12. `internalHom` — **THE ASSEMBLED presheaf internal hom** (`def:presheaf_internal_hom`), via `PresheafOfModules.ofPresheaf`. **PRIMARY target 2.**

## What was built and why

iter-219 left the per-object value module (`homModule`/`internalHomObjModule`). This iter built the
restriction maps, proved their functoriality + semilinearity, and **assembled the full presheaf
`internalHom`** — completing sub-step 2 of 5 and the funded build's iter-220 success bar.

The two genuinely hard pieces, both axiom-clean:
- **Functoriality of `restrictionMap` in `g`** (`restrictionMap_id`/`restrictionMap_comp`). `Over.map`
  is only pseudofunctorial (`Over.mapId_eq`/`Over.mapComp_eq` are propositional, NOT defeq), so `map_id`/
  `map_comp` are not `rfl`. Cracked by the helper `hom_app_heq φ (h : X = Y) : HEq (φ.app X) (φ.app Y)`
  (proved by `subst h; rfl`): since the slice restriction depends only on `.left` (identical for the
  reindexed objects), the source/target modules are defeq, so `eq_of_heq (hom_app_heq φ <objeq>)` closes
  it. This is the reusable trick for any `pushforward₀ (Over.map -)`-based functoriality.
- **`restrictionMap_globalSMul`** (semilinearity core): reduces to a scalar equality across the two
  slice bases (`(Over.forget U)`/`(Over.forget V)`), discharged by `R`-functoriality plus the underlying
  `Over` morphism identity `(mkIdTerminal.from A_Y).left = (mkIdTerminal.from Y).left ≫ g` (via `Over.w`).

## Universe note (important for downstream)

`PresheafOfModules.ofPresheaf` ties the underlying `Ab`-presheaf to the ground-ring presheaf's
`RingCat.{u}` universe, but for a **general** base category `C : Type uC` `[Category.{vC, uC} C]` the
morphism groups `M|_U ⟶ N|_U` live in `Type (max u uC vC)`. They coincide (→ `Type u`) iff the base is
single-universe (`Category.{u, u}`). **`internalHomPresheaf` is universe-polymorphic** (built for general
`C`). **`internalHom` is therefore stated in a fresh single-universe section** (`variable {D : Type u}
[Category.{u, u} D] {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}}`), which is exactly the topological site `Opens X`
underlying the structure sheaf of a scheme (`Opens X` is a `SmallCategory.{u}`). This is the correct and
only setting the dual ultimately needs; no generality is lost for the project.

Carrier-duality gotcha (per [[ts-assoc-flatness-gap]] memory): the `internalHomObjModule` instance is over
`CommRingCat` `R₀.obj`, while `ofPresheaf` wants `(R₀ ⋙ forget₂).obj` (`RingCat`). The anonymous instance
arg would NOT synthesize via `letI` (diamond); **must pass it explicitly via `@ofPresheaf D _ (R₀ ⋙
forget₂ _ _) (internalHomPresheaf M N) (fun X => internalHomObjModule X.unop M N) (fun {_ _} f r m =>
restrictionMap_smul f M N r m)`** — the `set_option backward.isDefEq.respectTransparency false` on
`ofPresheaf` then accepts the defeq carriers.

## Blueprint markers (for review agent)

- `lem:presheaf_internal_hom_restriction` `\lean{PresheafOfModules.InternalHom.restrictionMap}` — name
  MATCHES; statement (additive + semilinear) realised by `restrictionMap` + `restrictionMap_add` +
  `restrictionMap_zero` + `restrictionMap_smul`. Ready for `\leanok`.
- `def:presheaf_internal_hom` `\lean{PresheafOfModules.internalHom}` — **name MISMATCH.** The built decl is
  `PresheafOfModules.InternalHom.internalHom` (note the `InternalHom` namespace). The plan agent should
  repoint the `\lean{}` to `PresheafOfModules.InternalHom.internalHom`, or note the namespace. Once
  repointed, ready for `\leanok` (fully assembled, no sorry).
- `def:presheaf_internal_hom_value`/`_slice_value` (`homModule`/`internalHomObjModule`) — built iter-219,
  unchanged.

## Remaining work toward `exists_tensorObj_inverse` (sub-steps 3–5)

With `internalHom` assembled, the next chunks (all over the single-universe `Opens X` base):
1. `PresheafOfModules.dual M := internalHom M (𝟙_ …)` (`def:presheaf_dual`) — trivial alias once unit fixed.
2. `internalHomEval : M ⊗ dual M → R` (`lem:internal_hom_eval`) — the open-by-open contraction `s ⊗ φ ↦ φ(s)`.
3. `lem:internal_hom_isSheaf` — sheafify `internalHom` to `Scheme.Modules.dual`.
4. `lem:dual_isLocallyTrivial`, then `exists_tensorObj_inverse` (sub-step 5, still FORBIDDEN until infra lands).

## Ride-along cleanup (NOT done)

The stale-docstring cleanup (objectives, optional/comment-only) was SKIPPED to avoid touching lines near
the pre-existing sorries after my insertions shifted line numbers; no proof bodies were at risk but the
risk/reward was unfavourable mid-build. Line refs in the objective are now stale; a fresh pass should
re-locate by content (`tensorObjOnProduct`, `tensorObj_assoc_iso`, the L37–85 iter-202 header).

## Why I stopped

`Real progress`: 12 axiom-clean declarations added (file lines ~1130–1300), listed above, **including the
iteration's stated success target — the ASSEMBLED `PresheafOfModules.InternalHom.internalHom`**. Both hard
pieces (pseudofunctor functoriality coherence via the `hom_app_heq`/`subst` trick, and the global-scalar
restriction/semilinearity identity) are closed axiom-clean. Build is GREEN; sorry count unchanged 3→3.
Sub-step 2 of 5 is retired. Stopping here is the natural boundary: sub-steps 3–5 (dual alias, evaluation,
sheafification, inverse) are a fresh chunk and `exists_tensorObj_inverse` remains FORBIDDEN until the
sheaf-level dual lands.
