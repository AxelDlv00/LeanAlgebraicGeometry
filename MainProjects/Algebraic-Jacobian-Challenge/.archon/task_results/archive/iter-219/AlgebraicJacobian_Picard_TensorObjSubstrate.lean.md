# AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Summary

- **Declarations added: 11**, all axiom-clean (`#print axioms` = `{propext, Classical.choice, Quot.sound}`),
  in new `namespace PresheafOfModules.InternalHom` (file lines ~969–1140).
  1. `termRingMap` — canonical ring map `R(T) → R(Y)` from a terminal object `T`.
  2. `termRingMap_naturality` — `R(g) ∘ termRingMap X = termRingMap Y`.
  3. `globalSMul` — "multiply by global scalar `f ∈ R(T)`" endomorphism `N ⟶ N`.
  4. `globalSMul_hom_apply` — its section-wise action (`rfl`).
  5. `globalSMul_one` / 6. `globalSMul_zero` / 7. `globalSMul_add` / 8. `globalSMul_mul`
     — `globalSMul` is a ring hom `R(T) → End N` (mul ↦ composition).
  9. `homModule` — **the `R(T)`-module structure on `Hom(M, N)`** for a base category `C`
     with terminal object `T`, action `f • φ := φ ≫ globalSMul f`.
  10. `restr` — restriction `M|_U` to `Over U` via `PresheafOfModules.pushforward₀`.
  11. `internalHomObjModule` — **the slice value `Hom(M|_U, N|_U)` as an `R(U)`-module**,
      i.e. the per-object value of blueprint `def:presheaf_internal_hom`.
- **Declarations blocked: 0** this iter (the full `internalHom` presheaf is the next chunk; see below).
- **sorry count in file: unchanged (3 → 3).** The 3 pre-existing sorries
  (`isLocallyInjective_whiskerLeft_of_W` L600, `exists_tensorObj_inverse` L1390,
  `addCommGroup_via_tensorObj` L1440) are untouched (the latter two are FORBIDDEN this iter).
  My 11 additions contain **no sorry**.

## What was built and why

PRIMARY objective was `PresheafOfModules.internalHom` (`def:presheaf_internal_hom`), the slice
internal hom `ℋom(M, N)(U) := ModuleCat.of (R(U)) (M|_U ⟶ N|_U)` — the missing primitive of the
`⊗`-inverse / dual block (`sec:tensorobj_dual_infra`). The genuinely hard, reusable core of that
construction is the **`R(U)`-module structure on the morphism group `M|_U ⟶ N|_U`** (Mathlib has the
fixed-ring internal hom `ihom M N = (M ⟶ N)` but nothing for the varying structure sheaf at the
`PresheafOfModules` level — confirmed absent, `analogies/ts219dual.md`).

I built this in full generality and axiom-clean:

- **`homModule`** gives `Module (R(T)) (M ⟶ N)` for ANY base category `C` with a terminal object `T`.
  The scalar `f ∈ R(T)` acts by post-composition with `globalSMul f : N ⟶ N` (multiply each section by
  the restriction of `f`). The module axioms reduce to the four `globalSMul_{one,zero,add,mul}`
  ring-homomorphism facts plus `Preadditive` bilinearity of composition.
- **`restr` + `internalHomObjModule`** specialise this to the slice formula: `M|_U` is
  `pushforward₀` along `Over.forget U : Over U ⥤ C`; the over-category's terminal is `Over.mk (𝟙 U)`
  (`Over.mkIdTerminal`), at which the restricted ring is `R(U)` by `rfl`. So
  `internalHomObjModule U M N : Module (R(U)) (M|_U ⟶ N|_U)` is exactly the value module of
  `def:presheaf_internal_hom`.

The slice formula (NOT the naive contravariant `U ↦ Hom_{R(U)}(M(U),N(U))`) is the blueprint-mandated
covariant remedy; the over-category restriction realises it concretely.

## Key technical notes (for the next prover — read before continuing)

- **Carrier duality `R.obj Y` (CommRingCat) vs `(R ⋙ forget₂).obj Y` (RingCat).** This is the #1 source
  of friction. They are the same type/ops up to defeq, but `rw`/`simp` of `map_add`/`add_smul`/`lsmul`
  fail across them. **Resolution that works:** keep `termRingMap` valued in `R.obj` (CommRingCat) so the
  scalar `f`, all `+`/`*`/`1`, and `LinearMap.lsmul` (needs `CommSemiring`) share ONE carrier; bridge to
  the `(Fr R)` semilinearity (`PresheafOfModules.map_smul`) with `erw` (defeq) in the `globalSMul`
  naturality only. `globalSMul_hom_apply` is then `rfl` with the `•` over `R.obj Y`.
- **`map_add` is AMBIGUOUS in this file** (`_root_.map_add` vs `Functor.map_add`, due to the file's
  `open CategoryTheory`). Use `_root_.map_add` (already done in `globalSMul_add`). `map_mul/map_one/map_zero`
  were not ambiguous here.
- `homModule` is `@[implicit_reducible]` (it is a `def` of class type `Module`; without the attribute the
  linter errors).
- **`ModuleCat.of` packaging of a hom-type module is fragile.** `letI := homModule …; ModuleCat.of _ (M ⟶ N)`
  fails `Quiver` synthesis (tried; the `Module` instance whose type mentions `M ⟶ N` confuses inference).
  `internalHomObjModule` therefore returns the bare `Module`, not a `ModuleCat`. When you need the
  `ModuleCat` value for the presheaf, construct it with all instances explicit (`@ModuleCat.of … AddCommGroup
  Module`) rather than `letI` + `ModuleCat.of _`.

## Remaining work toward the full `internalHom : PresheafOfModules R` (precise handoff)

The per-object VALUE is done (`internalHomObjModule`). To assemble the full presheaf:

1. **Restriction maps.** For `g : V ⟶ U` in `C`, build the `R(U)`-semilinear (over `R(g)`) map
   `(M|_U ⟶ N|_U) → (M|_V ⟶ N|_V)`. Route: `Over.map g : Over V ⥤ Over U` (precompose `_ ≫ g`); its
   action by precomposition restricts a morphism over `Over U` to one over `Over V`. Concretely a morphism
   `φ : M|_U ⟶ N|_U` is whiskered/precomposed; check `pushforward₀`/`Over.map` interplay. Verify
   `(Over.forget V).op ⋙ R = (Over.map g).op ⋙ (Over.forget U).op ⋙ R` (should be `rfl`, mirroring the
   associativity `rfl` already used).
2. **Presheaf assembly.** Package `U ↦ ModuleCat.of (R(U)) (M|_U ⟶ N|_U)` + the step-1 maps into
   `PresheafOfModules R` via `PresheafOfModules.ofPresheaf` (needs: underlying `Cᵒᵖ ⥤ Ab`, per-object
   `Module (R(U))`, and the `map_smul` compatibility `restr-map (r • φ) = R(g) r • restr-map φ`). The
   `Module` per object is `internalHomObjModule`; the `Ab`-presheaf is `U ↦ (M|_U ⟶ N|_U)` with the step-1
   maps; functoriality (id/comp) from `Over.map` functoriality.
3. **Then** `def:presheaf_dual` = `internalHom M (unit R)`; `lem:internal_hom_eval` (evaluation
   `M ⊗ M^∨ → R`, the open-by-open contraction `s ⊗ φ ↦ φ(s)`); `lem:internal_hom_isSheaf` (sheafify to
   `Scheme.Modules.dual`); `lem:dual_isLocallyTrivial`; finally `exists_tensorObj_inverse` via
   `rem:dual_discharges_inverse`. NONE of these are touched this iter (the last is FORBIDDEN this iter).

Estimated remaining: still multi-iter (the presheaf assembly in step 2 is the bulk), but the value-level
module — the piece the analogist flagged as Mathlib-absent at every level — is now built and reusable.

## Blueprint markers (for review agent)

Ready for `\leanok` on `def:presheaf_internal_hom`'s **value-level realisation**: the slice value module
is `PresheafOfModules.InternalHom.internalHomObjModule` (and `restr` for `M|_U`). The `\lean{...}` pin
on `def:presheaf_internal_hom` currently names `PresheafOfModules.internalHom` (the FULL presheaf, not yet
built) — suggest the plan agent either (a) repoint the pin to `internalHomObjModule`/`homModule` for the
value-level lemma, or (b) keep the pin and add a new blueprint sub-lemma for `homModule`/`internalHomObjModule`
(the `R(T)`/`R(U)`-module on `Hom`). The 11 new decls are all unprotected and upstream-PR candidates
(general `PresheafOfModules` internal-hom-value infrastructure).

## Why I stopped

`Real progress`: 11 axiom-clean declarations added (lines ~969–1140), listed above. The central deliverable
— `homModule`, the `R(T)`-module structure on `Hom(M,N)` of presheaves of modules over a terminal-object
base, and its slice specialisation `internalHomObjModule : Module (R(U)) (M|_U ⟶ N|_U)` — fully realises the
**per-object value** of the slice internal hom `def:presheaf_internal_hom`, which the mathlib-analogist
(`ts219dual`) flagged as absent from Mathlib at the presheaf, sheaf, AND categorical level. The next chunk
(restriction maps `V ⟶ U` + full `PresheafOfModules` assembly) is well-defined, partially de-risked (the
key associativity / ring-at-terminal defeqs verified by `rfl`), and handed off precisely above; it is a
genuinely large new sub-build, so a clean stop here with no sorry in any addition is the correct boundary
per the `mathlib-build` contract. Build is GREEN (no errors in the file; the 3 pre-existing sorries are
untouched).
