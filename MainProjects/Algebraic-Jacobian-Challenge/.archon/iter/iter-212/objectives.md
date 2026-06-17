# Iter-212 objectives detail

## Lane TS — `Picard/TensorObjSubstrate.lean` (sole active lane; `prove`)

**Goal:** finish the ⊗-invertibility group-law engine on top of the iter-211 gate.

### Step 1 (go/no-go) — `isIso_sheafification_map_of_W`
`J.W ((toPresheaf _).map f) → IsIso ((PresheafOfModules.sheafification …).map f)`, where `J` is
the small-site topology of `X.ringCatSheaf` (NOT `Scheme.zariskiTopology` — that probe failed,
wrong type). Recipe (prior task result):
- (a) `PresheafOfModules.toPresheaf` reflects isomorphisms (PoM map iso ⇔ underlying additive-
  presheaf map sectionwise iso).
- (b) underlying `AddCommGrpCat`-sheafification = localization at `J.W`
  (`GrothendieckTopology.W_iff_isIso_map_of_adjunction` / `W_iff` /
  `instIsLocalizationFunctorOppositeSheafPresheafToSheafW`) [expected — verify via LSP].
- (c) compatibility iso `toPresheaf ∘ sheafification ≅ AddCommGrp-sheafify ∘ toPresheaf`.
Plus the cheap conjugate `W_whiskerRight_of_flat` (braiding-conjugate of `W_whiskerLeft_of_flat`)
and `IsInvertible ⇒ sectionwise Module.Flat` (`Module.Flat.of_projective` [expected]).

### Step 2 (if Step 1 closes) — `tensorObj_assoc_iso` (`lem:tensorobj_assoc_iso`)
Blueprint 3-step composite (chapter lines ~632–728): absorb inner sheafification on the left
(`a` of `η_{M⊗N} ▷ P` ∈ `J.W`) → `a.mapIso α` (presheaf associator) → restore inner sheafification
on the right (`a` of `M ◁ η_{N⊗P}` ∈ `J.W`). **Must close this iter (throughput guard).**

### Step 3 (if Step 2 closes) — `tensorObjIsoclassCommMonoid` (`lem:tensorobj_isoclass_commgroup`)
Carrier PINNED in blueprint: mirror `CommRing.Pic = Units (Skeleton (ModuleCat R))` — commutative
monoid of `⊗`-iso-classes of `IsInvertible` objects under `tensorObj`; unit `[𝒪_X]`; multiplication
well-defined by `tensorObj`-bifunctoriality (`lem:scheme_modules_tensorobj_functoriality`); closure
"tensor of invertibles is invertible"; group axioms = `Nonempty`-propositions discharged by the
coherence isos. Bonus (not required): `addCommGroup_via_tensorObj` may then close.

### Reversal (pre-committed for iter-213)
Bridge (Step 1) bottoms out in genuinely-absent Mathlib → STOP, report residual → **escalate to
USER**, no third construction pivot.

### Off-path (leave as-is)
`tensorObj_restrict_iso`, `exists_tensorObj_inverse`. Stale module docstring may be refreshed.

### Carried non-blocking debt (not this iter's objective)
Deprecated `Sheaf.val` → `ObjectProperty.obj` sweep (10 sites); blueprint prose cite swap
`lTensor_preserves_injective_linearMap` → `lTensor_exact`.
