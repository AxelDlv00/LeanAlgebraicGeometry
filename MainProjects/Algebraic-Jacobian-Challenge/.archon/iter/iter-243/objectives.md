# Iter-243 — prover objectives (detail)

Two lanes, both `[prover-mode: mathlib-build]` (no sorry pins — each step is either fully proved or absent
with a precise handoff). Build bottom-up.

---

## Lane 1 — `Picard/TensorObjSubstrate.lean` (CRITICAL PATH, A.1.c substrate `IsInvertible.pullback`)

**Route PIVOT this iter: local trivialization (the iter-242 concrete-`P` route is DESCOPED — empirically
Mathlib-scale).** The general `pullbackTensorIso` for arbitrary `M,N` needs the Mathlib-absent
`PresheafOfModules.extendScalars` + a topological inverse-image left Kan extension; it is NOT being built
and is NOT needed (only the invertible case is). Blueprint: `chapters/Picard_TensorObjSubstrate.tex`,
§ `sec:tensorobj_pullback_monoidality`. The two presheaf instances `presheafPushforwardLaxMonoidal` /
`presheafPullbackOplaxMonoidal` (the comparison MAP `δ`) already landed iter-242 and are now pinned.

Build these, in order (each new decl axiom-clean; go as far as you can):

1. **`pullbackTensorMap` (`δ_sheaf`) — PRIMARY, self-contained** (`lem:pullback_tensor_map`). The
   sheaf-level comparison MORPHISM (not yet iso) for GENERAL `M,N`:
   `(pullback f).obj (M ⊗_X N) ⟶ (pullback f).obj M ⊗_Y (pullback f).obj N`. Build it by transporting the
   presheaf-level oplax `δ` (`presheafPullbackOplaxMonoidal`) through sheafification — reuse the
   `sheafificationCompPullback` device and `sheafifyTensorUnitIso` (the BUILDING BLOCKS used in
   `tensorObj_restrict_iso` Steps 1–2, NOT its conclusion — you do NOT need to close the H1 residual). This
   is the iter's primary deliverable and is the most concrete/self-contained brick.

2. **`IsInvertible.isLocallyTrivial` (forward bridge)** (`lem:isinvertible_implies_locallytrivial`). On a
   scheme, `IsInvertible M ⟹ LineBundle.IsLocallyTrivial M`. This is the route's GENUINE NEW COST (flagged
   in-blueprint). Recipe (Stacks `lemma-invertible-is-locally-free-rank-1` + `lemma-invertible`): from the
   tensor-inverse witness `M ⊗ N ≅ 𝒪`, at each `x` the stalk `M_x ⊗_{𝒪_{X,x}} N_x ≅ 𝒪_{X,x}` (via the
   already-proven d.2 `stalkTensorIso` = `lem:stalk_tensor_commutation`), so `M_x` is invertible over the
   LOCAL ring `𝒪_{X,x}`, hence free of rank 1; `M` is finitely presented (lemma-invertible: locally a
   direct summand of finite free), so a free stalk spreads to a free affine neighborhood. If this proves
   Mathlib-scale (finite-presentation-spread-out over `SheafOfModules` absent), STOP and hand off precisely
   which Mathlib ingredient is missing — do NOT pin a sorry.

3. **`IsInvertible.pullback` — assemble if 1+2 land** (`lem:isinvertible_pullback`). Witness `f^*N`; the iso
   `f^*M ⊗ f^*N ≅ 𝒪_Y` is `(asIso δ_sheaf).symm ≫ (pullback f).mapIso e ≫ pullbackUnitIso`, where `δ_sheaf`
   is shown ISO **on the invertible pair**: trivialise `M,N` (step 2), take the common affine cover `{U_i}`
   of `X` and the preimage cover `{f⁻¹U_i}` of `Y`; on each `f⁻¹U_i` all of `f^*M, f^*N, f^*(M⊗N)` restrict
   to `𝒪` (via `IsLocallyTrivial.pullback`, already proven), and `δ_sheaf` restricts to the canonical
   `𝒪⊗𝒪≅𝒪` comparison (iso); globalise by `isIso_of_isIso_restrict`. The CRUX step (flagged in-blueprint)
   is the "`δ_sheaf` restricts to the canonical `𝒪⊗𝒪≅𝒪`" compatibility — spend budget there.

**Guardrail (strategy-critic ts243): do NOT prove `δ_sheaf` iso STALKWISE** — that revives the abandoned
d.2 stalk-tensor sink for the pullback-stalk formula. Use the COVER route via `isIso_of_isIso_restrict`.
Do NOT touch the group-law section or the deferred dual-bridge sorries (`exists_tensorObj_inverse` L693,
`addCommGroup` L1202). Secondary cleanup (lean-auditor ts242 minor): the two new presheaf instances sit in
`AlgebraicGeometry.Scheme.Modules` but operate at the general `PresheafOfModules` level — leave as-is unless
trivially relocatable.

---

## Lane 2 — `Cohomology/FlatBaseChange.lean` (engine, parallel; affine close of base change)

**progress-critic ts243 = CONVERGING.** TARGET 1 (`pullback_spec_tilde_iso`) closed iter-242; the affine
push+pull dictionary is complete. This iter: build the TWO now-named sub-obligations of
`affineBaseChange_pushforward_iso`. Blueprint: `chapters/Cohomology_FlatBaseChange.tex`,
§ "The affine base-change lemma and its remaining obligations". mathlib-build, no sorry pins.

1. **`base_change_map_affine_local` (affine reduction)** (`lem:base_change_map_affine_local`). The
   base-change map `pushforwardBaseChangeMap` is compatible with restriction to affine opens of `S'`, so
   `IsIso` over arbitrary `(S,S',X,X')` reduces (via `modules_isIso_iff_affineOpens`) to the affine-affine
   case. This is the more tractable naturality-plumbing obligation; attempt it first.

2. **`pushforward_base_change_mate_cancelBaseChange` (the affine-affine crux)**
   (`lem:pushforward_base_change_mate_cancelBaseChange`). In the affine-affine case, `Γ(α)` transported
   through the two affine dictionaries (`pushforward_spec_tilde_iso`, `pullback_spec_tilde_iso`) equals
   `TensorProduct.AlgebraTensorModule.cancelBaseChange` (`(r'⊗a)⊗m ↦ r'⊗(a·m)`). This is the genuine crux —
   an adjoint-mate coherence computation. It is exactly what the `#37189` bump
   (`isIso_fromTildeΓ_pushforward`) would supply in-tree.

3. **Assemble `affineBaseChange_pushforward_iso`** if both land (the existing body already has the locality
   reduction + dictionaries wired).

**Watch-signal (progress-critic ts243):** if BOTH sub-obligations come back PARTIAL with no reduction in the
obligation list, the plan switches to the `#37189` Mathlib bump next iter rather than another in-tree round.
Do NOT attempt `flatBaseChange_pushforward_isIso` (deep Čech + flatness, out of scope).
