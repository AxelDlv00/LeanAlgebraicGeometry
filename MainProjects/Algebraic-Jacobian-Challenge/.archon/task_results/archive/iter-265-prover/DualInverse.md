# DualInverse.lean — fine-grained pass (iter-265)

Objective 1: `sliceDualTransport` — close `invFun` (linchpin) + `left_inv`/`right_inv`, stretch `naturality`.

## Sentence breakdown (blueprint `lem:slice_dual_transport`, L5780–5946)

### Leg-B inverse-codomain swap infrastructure → NEW NAMED LEMMAS — **RESOLVED (axiom-clean)**
The blueprint inverse paragraph (L5859–5868) says `invFun` "uses `(f.appIso W'').hom` in place of its
inverse" and "the ε-codomain swap … itself (not `inv ε`)". Translating this to Lean requires the
`.hom`-direction leg-B swap, which did **not** exist (only the `.inv`-direction `dualUnitRingSwap` did).
Built and verified axiom-clean (only `propext`/`Classical.choice`/`Quot.sound`):

- `dualUnitRingSwapInv f W'` : `𝟙_Y(W') ⟶ restrictScalars (appIso f W').inv (𝟙_X(fW'))` — `ε` itself
  (reverse of `dualUnitRingSwap`). **RESOLVED.**
- `dualUnitRingSwapInv_comp_dualUnitRingSwap` / `dualUnitRingSwap_comp_dualUnitRingSwapInv` —
  `ε ≫ inv ε = 𝟙` and `inv ε ≫ ε = 𝟙` (`@[simp]`). The round-trip cancellation lemmas
  `left_inv`/`right_inv` will consume these. **RESOLVED.**
- `isIso_ε_restrictScalars_appIso_hom f W'` : `IsIso (ε (restrictScalars (appIso f W').hom.hom))` —
  mirror of `isIso_ε_restrictScalars_appIso` for the `.hom` direction. **RESOLVED.**
- `dualUnitRingSwapHom f W'` : `restrictScalars (appIso f W').hom (𝟙_Y(W')) ⟶ 𝟙_X(fW')` =
  `inv (ε (restrictScalars (appIso f W').hom.hom))`. This is the actual codomain swap `invFun` needs.
  **RESOLVED.**

**Correctness finding (recipe sharpening, recorded in-file at the `invFun` sorry):** the blueprint gloss
"ε itself (not inv ε)" is imprecise once the reindex is spelled in Lean. Because the reverse reindex must
turn a `𝒪_Y(P)`-section map into a `𝒪_X(fP)`-map, it uses `restrictScalars (appIso f P).hom.hom` (the
`.hom` direction); its codomain swap is therefore `inv ε` of *that* `.hom`-direction functor, i.e.
`dualUnitRingSwapHom`. (`dualUnitRingSwapInv` = `ε` itself is the `.inv`-direction object, useful for the
toFun-leg round-trips, not for the invFun reindex.)

### Sentence: `invFun` (reverse `PresheafOfModules.Hom` over `Over fV`) → **PARTIAL (sorry, real recipe)**
- The `{ app, naturality }` structure IS accepted as an element of the LHS carrier
  `((pushforward β).obj M.val.dual).obj V` (verified via `lean_multi_attempt`).
- The crux is the `app` field: for `W'' ≤ fV`, set `P := f⁻¹ᵁ W''.left`; the component is the X-slice
  mirror of `toFun` with an `eqToHom` conjugation (à la `homLocalSection`, since `f.opensFunctor.obj P =
  W''.left` only *propositionally* via `image_preimage_of_le`/`image_preimage_eq_opensRange_inf`):
  `eqToHom(M.val) ≫ (restrictScalars (appIso f P).hom.hom).map (ψ.app (Over.mk hPV)) ≫
  dualUnitRingSwapHom f P`.
- **Blocker:** the deferred `app` metavar lives under a `fun W'' =>` binder, so its precise goal type
  does not surface through `refine { app := fun W'' => ?_, .. }`; building it requires a standalone named
  helper `sliceDualTransportInv` with the full (instance-delicate) codomain type spelled out, plus the
  `eqToHom`-transport assembly + internal naturality. This is a ~50–100 LOC build, not completable this
  pass without risking file compilation (RACE-MITIGATION mandate: keep `DualInverse.lean` compiling).
- The sharpened recipe + helper names are recorded in-file at L462+ for the next pass.

### Sentence: `left_inv` / `right_inv` → sorry (blocked on `invFun`)
Will collapse via the new `@[simp]` cancellation lemmas + `image_preimage_of_le` once `invFun` exists.

### Sentence: `naturality` (refine_1, toFun) → sorry (blocked on missing helper)
Needs the ε-naturality square `PresheafOfModules.restrictScalarsLaxε` (planner-named, marked `[expected]`)
— it does NOT exist in the codebase (`lean_local_search` empty). Building it locally is itself a sizable
addition; deferred in favor of the leg-B infrastructure that unblocks the linchpin `invFun`.

## Summary
- **N/M sentences:** leg-B inverse-codomain swap infrastructure (4 declarations + 2 cancellation lemmas)
  CLOSED axiom-clean. The 4 `sliceDualTransport` proof fields (`naturality`, `invFun`, `left_inv`,
  `right_inv`) remain sorry.
- **Internal holes:** sliceDualTransport still 4 open (decl-sorry flat at 1 for `sliceDualTransport`,
  1 for `dual_restrict_iso`). File-level: NO new sorries introduced; 4 NEW compiling axiom-clean
  declarations added.
- **sorry count file-wide:** unchanged (2 decls carry sorry, as before) — but the linchpin's missing
  infrastructure (the `.hom`-direction leg-B swap) is now built.

## Why I stopped
- **Real progress:** 4 axiom-clean reusable declarations (`dualUnitRingSwapInv`,
  `dualUnitRingSwapInv_comp_dualUnitRingSwap`, `dualUnitRingSwap_comp_dualUnitRingSwapInv`,
  `isIso_ε_restrictScalars_appIso_hom`, `dualUnitRingSwapHom`) — the leg-B swaps for BOTH ring-iso
  directions, which `invFun` (`.hom` direction) and the round-trips (cancellation) require. Plus a
  correctness finding correcting the blueprint's "ε itself" gloss to "`inv ε` of the `.hom`-direction".
- **Partial progress:** `invFun` has a sharpened, concrete recipe in-file (exact reindex functor +
  codomain swap helper + eqToHom transport pattern) but the full `app`-field assembly is a standalone
  ~50–100 LOC helper build that could not be safely landed this pass.
- **Blocker for `naturality`:** the planner-named helper `PresheafOfModules.restrictScalarsLaxε` does not
  exist; it must be built (in this file or an upstream file the prover does not own) before `naturality`
  can close.
- **Reversing signal (per objective bar):** `invFun` did not close. The exact failing step is *not* the
  recipe (the recipe is now concrete and the leg-B helpers exist) but the mechanical `app`-field assembly:
  the deferred metavar under the `fun W'' =>` binder does not surface its goal type, so the build must be
  extracted as a standalone named helper `sliceDualTransportInv` with the full codomain type written out.
  Recommend next `prove` pass: write `sliceDualTransportInv` as a top-level `noncomputable def` (mirror
  `homLocalSection`'s `eqToHom` conjugation), then `exact … ψ` at refine_4.

## Ready-for-marker
- New helpers are statement+proof complete (axiom-clean) — eligible for `\leanok` if added to the
  blueprint (currently the blueprint references `dualUnitRingSwap`/`isIso_ε_restrictScalars_appIso`; the
  `.hom`-direction analogs `dualUnitRingSwapHom`/`isIso_ε_restrictScalars_appIso_hom` and
  `dualUnitRingSwapInv` are new and could be cited in the `lem:slice_dual_transport` inverse paragraph).
