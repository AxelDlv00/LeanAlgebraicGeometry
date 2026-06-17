# Iter-234 objectives (dispatch detail)

2 prover lanes (cap 10; dispatch-sanity OK per progress-critic ts234). HigherDirectImage deferred.

## Lane 1 — `Picard/TensorObjSubstrate/StalkTensor.lean` [mathlib-build] — d.2 critical path
- Continue from stage (iii) of `lem:stalk_tensor_commutation` (forward map stages i–ii DONE iter-233).
- (iii) `stalkTensorDescU_smul` → `stalkTensorLinearMap : (A⊗ᵖB).stalk x →ₗ[R.stalk x] A_x⊗_{R_x}B_x`.
  Wall = CommRingCat/RingCat carrier-duality: bridge `R(U)` (CommRingCat) ↔ `(R⋙forget₂)(U)` (RingCat)
  via `RingEquiv`/`eqToHom`, then `TensorProduct.smul_tmul'`/`germ_smul` fire (erw). Mirror d.1
  `stalkLinearMap` (Vestigial.lean ~391–426).
- (iv) reverse map `A_x⊗_{R_x}B_x → (A⊗ᵖB).stalk x` (tensor universal property, nested colimit descent).
- (v) bundle `stalkTensorIso` (mutual inversion on germ generators).
- Keep import-minimal (no `Vestigial` import). mathlib-build: no sorry pins.
- CONVERGENCE PROBE: `stalkTensorLinearMap` lands?
- Recipe: chapter §`sec:tensorobj_stalk_tensor` (5 stages) + iter-233 task result (archive/iter-233).

## Lane 2 — `Cohomology/FlatBaseChange.lean` [mathlib-build] — engine
- Build the tilde pushforward/pullback dictionary: (1) pushforward of tilde ≅ `restrictScalars φ`;
  (2) pullback of tilde ≅ base change `-⊗[R]R'` (`extendScalars`); (3) fibre product `Spec(R'⊗_R A)` +
  section base-change map. Close `affineBaseChange_pushforward_iso` per-affine-open via
  `TensorProduct.AlgebraTensorModule.cancelBaseChange`. Leave `flatBaseChange_pushforward_isIso` sorry.
- CONVERGENCE PROBE: tilde dictionary lands / affine iso closes?
- Recipe: `informal/affineBaseChange_pushforward_iso.md` + iter-233 task result (1)(2)(3) decomposition.

## Deferred — `Cohomology/HigherDirectImage.lean`
- Gap-blocked (Gaps 1–3, no frontier step). Re-engagement: dedicated mathlib-build sub-lane for one gap,
  OR a Mayer–Vietoris/Čech blueprint chapter.
