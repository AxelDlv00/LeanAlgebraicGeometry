# AlgebraicJacobian/Picard/QuotScheme.lean — iter-194 prover

## Lane F: LinearEquiv extraction in `pullback_app_isoTensor_baseMap_sectionLinearEquiv`

### Result: PARTIAL (structural progress; sorry count unchanged at 12)

- **LinearEquiv portion**: axiom-clean.
- **Beck-Chevalley intertwining**: typed sorry (architecturally blocked
  on `step1` + `step2` bodies).

### Attempt 1 (line 815: `pullback_app_isoTensor_baseMap_sectionLinearEquiv`)
- **Approach**: Build `f : T ≃ₗ[Γ(Y,U)] Γ((pullback g).obj N, U)` from
  the existing `composedIso` chain by:
  1. Introducing local alias `TR := ModuleCat.of Γ(Y,U) (T)` to silence
     `Γ(·,·)` notation ambiguity inside the tilde type ascription.
  2. Restating the `Module.compHom`-via-`ΓSpecIso.inv.hom` instance for
     the source of `topAdd` so that `topAdd.toLinearEquiv` typechecks
     (the source-side instance from `step3`'s signature did not carry
     through `obtain ⟨step3⟩` to the calling scope).
  3. `topLin = topAdd.toLinearEquiv ...` with the smul-compat proof
     reducing to `Scheme.Modules.Hom.app_smul composedIso.hom`.
  4. `toTensor := topLin.trans (tilde.isoTop TR).symm.toLinearEquiv`
     (the underlying types `Γ(tilde TR, ⊤)` and `(modulesSpecToSheaf.obj
     (tilde TR)).presheaf.obj (.op ⊤)` are defeq; the Γ(Y,U)-module
     structures match via `Module.compHom` vs. `restrictScalars
     globalSectionsIso.hom`).
  5. `f := toTensor.symm.trans step3`.
- **Result**: RESOLVED for steps 1-5 (LinearEquiv construction axiom-clean).
- **Key insight**: `(tilde.isoTop M).toLinearEquiv` directly produces the
  needed `M ≃ₗ[R] Γ(tilde M, ⊤)` (the two Γ(Y,U)-module instances are
  defeq enough to make this typecheck without a manual `Module.compHom`
  bridge on the tilde side).

### Attempt 2 (line 957: Beck-Chevalley intertwining at `1 ⊗ₜ x`)
- **Approach**: Tried `rfl`, `simp [f, toTensor, topLin, topAdd,
  composedIso, pullback_app_isoTensor_baseMap, ...]`, `unfold ...`.
- **Result**: FAILED (`rfl` unfolds the goal to a chain involving
  `Scheme.Modules.Hom.app step1.inv`, `Scheme.Modules.Hom.app step2.inv`,
  and `(tilde.isoTop TR).symm.toLinearEquiv.symm` applied to `1 ⊗ₜ x`,
  which cannot be closed by `rfl`/`simp` alone).
- **Architectural finding**: The intertwining provably DEPENDS on the
  bodies of `step1` (`tildeIso_of_isQuasicoherent_isAffineOpen`,
  Stacks 01I8) and `step2` (`pullback_tildeIso`, Stacks 01HQ). Both are
  currently `Nonempty (... ≅ ...)` typed-sorry pins; their isos are
  opaque (Classical.choice-extracted), so the LHS chain cannot be
  reduced to a closed form. **The intertwining is unprovable until
  either**:
  - (a) `step1`'s and `step2`'s bodies land (Mathlib gaps Stacks 01I8 +
    01HQ), OR
  - (b) `step1` and `step2` signatures are refactored to Σ-pair form
    carrying the canonical iso-characterizing identity (e.g.,
    `step1.hom = (asIso fromTildeΓ).inv` for QC-on-affine, or
    `step2.hom = canonical tilde-pullback-iso` for Spec base change).

### Mathlib precedent searches done
- `IsQuasicoherent.pushforward`: no direct API at pinned commit (Stacks
  01XJ unowned at `Scheme.Modules` layer per analogist verdict in
  `analogies/lane-f-isbasechange.md`).
- `Module.compHom` + `restrictScalars`: defeq verified via
  `lean_run_code` test (the Γ(Y,U)-module on `Γ(tilde M, ⊤)` via
  `Module.compHom _ ΓSpecIso.inv.hom` matches the natural one via
  `(modulesSpecToSheaf.obj (tilde M)).presheaf.obj (.op ⊤)`).
- `tilde.isoTop`: confirmed at `Mathlib/AlgebraicGeometry/Modules/Tilde.lean:177`,
  produces the canonical `M ≅ (modulesSpecToSheaf.obj (tilde M)).presheaf.obj (.op ⊤)`.
- `Scheme.Modules.Hom.app_smul`: confirmed at
  `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean:110`, gives
  Γ(X,U)-linearity of `Hom.app φ U`.

### Status post-iter-194

- **Sorry count**: 12 (unchanged from iter-193).
- **Structural**: `_sectionLinearEquiv` body is now ~30 LOC of pure
  compositional glue (axiom-clean LinearEquiv construction) followed by
  ONE typed sorry on the intertwining. Pre-iter-194, the entire
  `Nonempty {f // ...}` was a single typed sorry. Post-iter-194, the
  LinearEquiv `f` is concretely built and the residual sorry is a
  focused identity `f (1 ⊗ₜ x) = baseMap g N e x`.

### Suggested iter-195+ next steps for the Plan agent

1. **Refactor step1/step2 to Σ-pair signatures** with canonical-iso
   identities. This is the unblocking refactor for `_sectionLinearEquiv`
   body closure. Cost: ~10-15 LOC per pin (the signature gains a
   `// step1.hom = canonical_map`-style clause; the bodies still typed
   sorry but the consumer can use the identity).
2. **OR**: Close `step1`'s body via Stacks 01I8 path (extract a
   Presentation of `(N|_V).overSpec` from `[N.IsQuasicoherent] + hV`
   transport, then apply `isIso_fromTildeΓ_of_presentation`). Estimated
   ~50-80 LOC; Mathlib gap is the per-affine-open presentation
   extraction (`QuasicoherentData.presentation` only ships per-cover
   element).
3. Either path unblocks the Beck-Chevalley intertwining and closes
   `_sectionLinearEquiv` axiom-clean, which then propagates to
   `pullback_app_isoTensor_isBaseChange` and `Scheme.Modules.pullback_app_isoTensor`.

### HARD BAR status

iter-194 HARD BAR was "≥1 axiom-clean closure". This was NOT met
(no full closure of any typed sorry); however, **substantial structural
progress** landed:
- The LinearEquiv extraction (Steps a-c of the iter-189 5-step plan)
  is now axiom-clean.
- The body of `_sectionLinearEquiv` no longer hides three Mathlib gaps
  + bookkeeping under one bare sorry; the sorry is now narrowed to the
  Beck-Chevalley intertwining at `1 ⊗ₜ x` (a single specific identity).
- An architectural finding was surfaced: the intertwining is provably
  blocked on step1/step2 body landings OR signature strengthening —
  this is concrete guidance for iter-195+ plan-phase routing.

PUSH-BEYOND (full `_sectionLinearEquiv` close) was NOT achievable this
iter without prior step1/step2 work.
