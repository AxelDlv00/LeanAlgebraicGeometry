# Effort Breaker Report

## Slug
piece-a

## Target
`lem:qcoh_pullback_fromSpec` (`AlgebraicGeometry.Scheme.Modules.isQuasicoherent_pullback_fromSpec`)

## Status
COMPLETE — target re-expressed as a `\uses`-linked chain (route 1). Graph validated: target effort
dropped, all 6 new project sub-lemmas + 2 Mathlib anchors present, every `\uses` resolves
(`gaps`/`unmatched` clean, all 12 dependency links OK via `ancestors`).

## Effort before → after
- target `effort_local`: **2177 → 517** (now a thin `g := fromSpec` specialization)
- sub-lemmas added: **8** (6 project + 2 Mathlib anchors)

## Chain added (target ← L6 ← {L4 ← L2,L3 ; L5} , L1 feeds L2)
Bottom-up, all under namespace `AlgebraicGeometry.Scheme.Modules` (anchors under `SheafOfModules`):

- **L1** `def:over_restrict_unit_iso_inv` `\lean{…overRestrictUnitIsoInv}` — the INVERSE unit-iso dual
  to `def:over_restrict_unit_iso`: `(overRestrictEquiv V).inverse.obj (𝟙 V.toScheme.ringCatSheaf) ≅
  𝟙 (X.ringCatSheaf.over V)`. `\uses{def:over_restrict_equiv, lem:isIso_unitToPushforwardObjUnit_of_isIso}`.
  (effort ≈ 707). **Carries the iter-043 friction `% NOTE`** verbatim in its proof prose: `Functor.IsContinuous`
  non-synthesis (supply via `haveI`) + the `↥V`/`↥↑V` coercion mismatch (state `R`/`K` via
  `V.toScheme.ringCatSheaf`'s ACTUAL space, mirroring `overRestrictPullbackIso`).
- **L2** `def:over_restrict_presentation_inv` `\lean{…overRestrictPresentationInv}` — geometric→slice
  back-transport, dual to `def:over_restrict_presentation`: `((V.ι^*) M).Presentation →
  (M.over V).Presentation`. Route: `Presentation.ofIsIso` across `(overRestrictPullbackIso V M).symm` →
  `Presentation.map` along `(overRestrictEquiv V).inverse` (unit-match by L1) → `ofIsIso` the equivalence
  counit. `\uses{def:over_restrict_unit_iso_inv, lem:over_restrict_pullback_iso, lem:presentation_map_mathlib}`
  (effort ≈ 526).
- **L3** `def:presentation_pullback_iota_preimage` `\lean{…presentationPullbackιPreimage}` — for an open
  immersion `g`, a presentation of the GEOMETRIC pullback `(W_i.ι^*) N` on `W_i := g⁻¹ᵁ(q.X i)`,
  `N := (pullback g).obj M`. Built from the induced open immersion `k : W_i.toScheme → (q.X i).toScheme`
  (`k ≫ (q.X i).ι = W_i.ι ≫ g`): via `pullbackComp` (named in prose) `(W_i.ι^*) N ≅ k^*((q.X i).ι^* M)`,
  then `Presentation.map` along `k^*` of `presentationPullbackιOfQuasicoherentData q i`, then `ofIsIso`.
  `\uses{def:presentation_pullback_iota_of_quasicoherentData, lem:presentation_map_mathlib, lem:modules_pullback_mathlib}`
  (effort ≈ 498).
- **L4** `lem:isQuasicoherent_over_preimage` `\lean{…isQuasicoherent_over_preimage}` — `IsQuasicoherent
  (N.over W_i)`: feed L3's geometric presentation into L2 at `V = W_i`, then `Presentation.isQuasicoherent`.
  `\uses{def:over_restrict_presentation_inv, def:presentation_pullback_iota_preimage, lem:presentation_isQuasicoherent_mathlib}`
  (effort ≈ 507).
- **L5** `lem:coversTop_preimage` `\lean{…coversTop_preimage}` — the preimage family `{g⁻¹ᵁ(q.X i)}` is a
  `CoversTop` family on `Y` (`g⁻¹⊤ = ⊤`, `g⁻¹` preserves suprema). `\uses{lem:isQuasicoherent_quasicoherentData_mathlib}`
  (effort ≈ 467).
- **L6** `lem:isQuasicoherent_pullback_of_isOpenImmersion` `\lean{…isQuasicoherent_pullback_of_isOpenImmersion}`
  — the GENERAL statement: pullback of a QC sheaf along an open immersion `g` is QC. Assembles via
  `IsQuasicoherent.of_coversTop` on the preimage cover, using L4 (per-member) + L5 (cover).
  `\uses{lem:isQuasicoherent_quasicoherentData_mathlib, lem:isQuasicoherent_over_preimage, lem:coversTop_preimage, lem:isQuasicoherent_of_coversTop_mathlib}`
  (effort ≈ 710).
- **Target** `lem:qcoh_pullback_fromSpec` — proof rewritten to the `g := hU.fromSpec` instance of L6
  (`IsAffineOpen.fromSpec` is `IsOpenImmersion`, named in prose). Proof now `\uses{lem:isQuasicoherent_pullback_of_isOpenImmersion}` only.

### Mathlib anchors added (verified to exist in the form written, `\mathlibok`)
- `lem:presentation_isQuasicoherent_mathlib` `\lean{SheafOfModules.Presentation.isQuasicoherent}` —
  verified `Quasicoherent.lean:317`.
- `lem:isQuasicoherent_of_coversTop_mathlib` `\lean{SheafOfModules.IsQuasicoherent.of_coversTop}` —
  verified `Quasicoherent.lean:377` (`(M) (X : I → C) (hX : J.CoversTop X) [∀ i, IsQuasicoherent (M.over (X i))]`).

## Still hard (re-break candidates)
- `def:over_restrict_unit_iso_inv` (L1, ≈707) and `lem:isQuasicoherent_pullback_of_isOpenImmersion`
  (L6, ≈710) are the two heaviest. L1's weight is the known slice-coercion/`IsContinuous` friction
  (now pinned in its proof `% NOTE`); it is a single defeq/instance fight, not further mathematically
  decomposable — re-break would only be sentence-level if the prover stalls. L6 is a single
  `of_coversTop` application but pulls in cover-index bookkeeping; leave as-is for a first attempt and
  re-dispatch finer only if it resists.

## Could not decompose (strategy items)
- None. Every gap the original (illusory iso/`U⊓V_i`) proof crossed is now covered by an `L_i`; the
  route-1 structure is mathematically complete.

## References consulted
- `.lake/.../Mathlib/Algebra/Category/ModuleCat/Sheaf/Quasicoherent.lean` — read `Presentation.isQuasicoherent`
  (L317), `IsQuasicoherent.of_coversTop` (L377), `QuasicoherentData.bind` (L360) to confirm the two
  anchor names/signatures before marking `\mathlibok`. (Bespoke infra otherwise — no external math source.)
- `.archon/task_results/AlgebraicJacobian/Picard/QuotScheme.md` (iter-043 "Piece A … route 1") — the
  5-step decomposition and pinned friction this chain implements.

## Notes for dispatcher
- `\lean{}` names assigned by convention (confirm/scaffold — none exist in Lean yet): `overRestrictUnitIsoInv`,
  `overRestrictPresentationInv`, `presentationPullbackιPreimage`, `isQuasicoherent_over_preimage`,
  `coversTop_preimage`, `isQuasicoherent_pullback_of_isOpenImmersion` (all `AlgebraicGeometry.Scheme.Modules`).
- **Build order for the prover** (bottom-up, mathlib-gradient): L1 → L2 ; L3 ; L4(needs L2,L3) ; L5 ;
  L6(needs L4,L5) ; target. L1 is the gateway — land it first; its `% NOTE` records the exact two blockers.
- The directive's "scheme-iso transport `presentationPullbackOfSchemeIso`" for step 3 does NOT reuse the
  existing `def:presentation_pullback_of_scheme_iso` (that is for an iso `φ`; here `k` is an open
  immersion, not an iso). L3 instead transports via `pullbackComp` + `Presentation.ofIsIso`, named in
  prose like the existing `def:opens_map_equiv_of_iso` handles pseudofunctoriality isos. No new anchor needed.
- Mathlib pseudofunctoriality (`pullbackComp`) and `IsAffineOpen.fromSpec`'s open-immersion instance are
  named in prose (no blueprint anchor), consistent with the file's existing convention.
