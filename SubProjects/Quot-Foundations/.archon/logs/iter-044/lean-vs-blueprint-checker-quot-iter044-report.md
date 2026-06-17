# Lean ↔ Blueprint Check Report

## Slug
quot-iter044

## Iteration
044

## Files audited
- Lean: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex`

## Focus
gap2 closure: Piece A chain L1–L6 + `isQuasicoherent_pullback_fromSpec` + `isLocalizedModule_basicOpen`,
plus two new undocumented helpers (`pullbackOpenImmersionUnitIso`, `pullbackPreimageιIso`).

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictUnitIsoInv}` (chapter: `def:over_restrict_unit_iso_inv`)
- **Lean target exists**: yes (line 2560)
- **Signature matches**: yes — `(overRestrictEquiv V).inverse.obj (SheafOfModules.unit V.toScheme.ringCatSheaf) ≅ SheafOfModules.unit (X.ringCatSheaf.over V)` matches blueprint exactly
- **Proof follows sketch**: partial — blueprint sketch mentions going through `unitToPushforwardObjUnit`/`lem:isIso_unitToPushforwardObjUnit_of_isIso`; Lean proof takes a shorter categorical route: `(overRestrictEquiv V).inverse.mapIso (overRestrictUnitIso V).symm ≪≫ (overRestrictEquiv V).unitIso.symm.app _`. Mathematical content is equivalent (produces the same iso object), but the intermediate step referenced in `\uses` is not used. Correct but the `\uses` tag is stale.
- **notes**: `\leanok` present; no sorry; axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictPresentationInv}` (chapter: `def:over_restrict_presentation_inv`)
- **Lean target exists**: yes (line 2572)
- **Signature matches**: yes — `(P : ((Scheme.Modules.pullback V.ι).obj M).Presentation) : (M.over V).Presentation` matches blueprint's "geometric pullback presentation → slice presentation" map
- **Proof follows sketch**: yes — the three steps match: (1) `ofIsIso (overRestrictPullbackIso V M).inv P`, (2) `Presentation.map … (overRestrictEquiv V).inverse (overRestrictUnitIsoInv V)`, (3) outer `ofIsIso (overRestrictEquiv V).unitIso.symm.app (M.over V)` collapses the round trip
- **notes**: `\leanok` present; no sorry; axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.presentationPullbackιPreimage}` (chapter: `def:presentation_pullback_iota_preimage`)
- **Lean target exists**: yes (line 2625)
- **Signature matches**: yes — for open immersion `g : Y ⟶ X`, quasi-coherence datum `q`, index `i`, produces `((pullback (ι (g ⁻¹ᵁ (q.X i)))).obj ((pullback g).obj M)).Presentation`, matching the blueprint's `(W_i.ι^*) N` with `W_i = g^{-1}(q.X i)`, `N = (pullback g).obj M`
- **Proof follows sketch**: yes — applies `Presentation.map` along `pullback k` (where `k = g.resLE (q.X i) W_i`), using `pullbackOpenImmersionUnitIso` as the unit datum, then transports across `pullbackPreimageιIso` via `Presentation.ofIsIso`. Matches the blueprint's pseudofunctoriality-square description.
- **notes**: `\leanok` present; no sorry; axiom-clean. The `\uses` block for this definition in the blueprint is missing `pullbackOpenImmersionUnitIso` and `pullbackPreimageιIso` (see Unreferenced declarations below).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.isQuasicoherent_over_preimage}` (chapter: `lem:isQuasicoherent_over_preimage`)
- **Lean target exists**: yes (line 2649)
- **Signature matches**: yes — `[IsOpenImmersion g] (M : X.Modules) (q : M.QuasicoherentData) (i : q.I) : (((pullback g).obj M).over (g ⁻¹ᵁ (q.X i))).IsQuasicoherent`
- **Proof follows sketch**: yes — one-liner: feeds `presentationPullbackιPreimage` into `overRestrictPresentationInv` and calls `.isQuasicoherent`. Matches blueprint "feed geometric presentation into back-transport, apply Presentation.isQuasicoherent".
- **notes**: `\leanok` present; no sorry; axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.coversTop_preimage}` (chapter: `lem:coversTop_preimage`)
- **Lean target exists**: yes (line 2660)
- **Signature matches**: yes — for any morphism `g : Y ⟶ X` (not restricted to open immersion), `(q : M.QuasicoherentData)`, `(Opens.grothendieckTopology ↥Y).CoversTop (fun i => g ⁻¹ᵁ (q.X i))`. Blueprint says "Let `g : Y → X` be a morphism of schemes", consistent.
- **Proof follows sketch**: yes — for any `y ∈ W'`, finds `i` s.t. `g y ∈ q.X i`, then uses `W' ⊓ (g ⁻¹ᵁ (q.X i))` as the refining open. Blueprint describes the same argument.
- **notes**: `\leanok` present; no sorry; axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.isQuasicoherent_pullback_of_isOpenImmersion}` (chapter: `lem:isQuasicoherent_pullback_of_isOpenImmersion`)
- **Lean target exists**: yes (line 2682)
- **Signature matches**: yes — `[IsOpenImmersion g] (M : X.Modules) [M.IsQuasicoherent] : ((pullback g).obj M).IsQuasicoherent`
- **Proof follows sketch**: yes — obtains `q`, shrinks with `q.shrink` (important: blueprint says "choose quasi-coherence data"; `shrink` brings it to the right universe), applies `isQuasicoherent_over_preimage` and `coversTop_preimage`, invokes `IsQuasicoherent.of_coversTop`.
- **notes**: `\leanok` present; no sorry; axiom-clean. The `q.shrink` universe-management step is a Lean-specific detail not mentioned in the blueprint prose but is a standard universe-shrink move (see prior memory notes on this pattern).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.isQuasicoherent_pullback_fromSpec}` (chapter: `lem:qcoh_pullback_fromSpec`)
- **Lean target exists**: yes (line 2698)
- **Signature matches**: yes — `(M : X.Modules) [M.IsQuasicoherent] {U : X.Opens} (hU : IsAffineOpen U) : ((pullback hU.fromSpec).obj M).IsQuasicoherent`
- **Proof follows sketch**: yes — one-liner specializing `isQuasicoherent_pullback_of_isOpenImmersion` at `g := hU.fromSpec`. Blueprint says "the `g := fromSpec` instance of the general statement".
- **notes**: `\leanok` present; no sorry; axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen}` (chapter: `lem:qcoh_section_localization_basicOpen`)
- **Lean target exists**: yes (line 2709)
- **Signature matches**: yes — `(M : X.Modules) [M.IsQuasicoherent] {U : X.Opens} (hU : IsAffineOpen U) (f : Γ(X, U)) [Module Γ(X, U) Γ(M, X.basicOpen f)] [IsScalarTower Γ(X, U) Γ(X, X.basicOpen f) Γ(M, X.basicOpen f)] : IsLocalizedModule (Submonoid.powers f) (restrictBasicOpenₗ M f)`. This matches the blueprint's "quasi-coherent M, affine U, f ∈ Γ(X,U), restriction M(U) → M(D(f)) is IsLocalizedModule (powers f)".
- **Proof follows sketch**: yes — three-liner: (1) `isQuasicoherent_pullback_fromSpec` to get the QC-pullback P1 datum; (2) `isIso_fromTildeΓ_of_isQuasicoherent` to produce the IsIso; (3) `isLocalizedModule_basicOpen_of_hP1` for the final bridge. Matches blueprint: "QC-pullback (Piece A) → gap1 → eqToHom bridge (Piece B)".
- **notes**: `\leanok` present; no sorry; axiom-clean. The `[Module …]` and `[IsScalarTower …]` instance arguments in the Lean signature are Lean-specific elaboration hints; the mathematical statement is equivalent to the blueprint's prose.

---

## Red flags

None. All 8 declaration bodies are non-sorry, non-placeholder, and contain no excuse-comments.

---

## Unreferenced declarations (informational)

Two declarations in the Lean file have no `\lean{...}` reference in the blueprint:

### `pullbackOpenImmersionUnitIso` (line 2586)
- **What it is**: For an open immersion `k : A ⟶ B`, the pullback functor `pullback k` carries the structure-sheaf (unit) module of `B` to that of `A`. Generalizes `pullbackSchemeIsoUnitIso` (which handles scheme isos) to arbitrary open immersions, using `IsOpenMap.adjunction` to supply the `Final` instance.
- **Role**: Consumed by `presentationPullbackιPreimage` as the unit-iso datum for `Presentation.map`.
- **Recommended blueprint slot**: Add a `\begin{lemma}` (or `\begin{definition}`) block between the existing `lem:pullback_scheme_iso_unit_iso` and `def:presentation_pullback_iota_preimage`, with `\lean{AlgebraicGeometry.Scheme.Modules.pullbackOpenImmersionUnitIso}`. Add it to the `\uses` block of `def:presentation_pullback_iota_preimage`.

### `pullbackPreimageιIso` (line 2603)
- **What it is**: For an open immersion `g : Y ⟶ X`, `M` on `X`, `U ⊆ X`, the pseudofunctoriality natural iso `(pullback (g.resLE U (g ⁻¹ᵁ U))).obj ((pullback U.ι).obj M) ≅ (pullback (Scheme.Opens.ι (g ⁻¹ᵁ U))).obj ((pullback g).obj M)`. Built from `pullbackComp` and `pullbackCongr`.
- **Role**: Consumed by `presentationPullbackιPreimage` to transport the presentation across the pseudofunctoriality square.
- **Recommended blueprint slot**: Add a `\begin{definition}` block next to `pullbackOpenImmersionUnitIso` above, with `\lean{AlgebraicGeometry.Scheme.Modules.pullbackPreimageιIso}`. Add it to the `\uses` block of `def:presentation_pullback_iota_preimage`. The blueprint's existing proof prose already mentions "pseudofunctoriality of pullback (`pullbackComp`, named in prose) gives a natural isomorphism" — this is exactly `pullbackPreimageιIso`.

---

## Blueprint adequacy for this file

- **Coverage**: 8/8 gap2 Lean declarations (the focus of this check) have a corresponding `\lean{...}` block in the chapter. The two new helpers have no `\lean{...}` block and should be added (see above).
- **Proof-sketch depth**: **adequate** for 7 of 8. The `def:over_restrict_unit_iso_inv` proof sketch mentions `unitToPushforwardObjUnit` but the Lean proof takes a simpler route; sketch is not wrong, just not the path taken. This is a stale intermediate-step reference.
- **Hint precision**: **precise** — all `\lean{...}` pins use the exact fully-qualified Lean name and these names match the actual Lean declarations.
- **Generality**: **matches need** — no parallel APIs were built; the declarations are at exactly the right level of generality.
- **Recommended chapter-side actions**:
  1. Add a `\begin{definition}\leanok` block for `pullbackOpenImmersionUnitIso` (between `lem:pullback_scheme_iso_unit_iso` and `def:presentation_pullback_iota_preimage`).
  2. Add a `\begin{definition}\leanok` block for `pullbackPreimageιIso` (adjacent to the above).
  3. Add both to the `\uses` block of `def:presentation_pullback_iota_preimage`.
  4. Update the `\uses` block of `def:over_restrict_unit_iso_inv` to remove/adjust the reference to `lem:isIso_unitToPushforwardObjUnit_of_isIso`, since the Lean proof does not go through that lemma (or leave it as an alternative route reference — it is not wrong, just unused).

---

## Severity summary

### must-fix-this-iter
None.

### major
None.

### minor
1. **`pullbackOpenImmersionUnitIso` (line 2586)** — substantive helper with no `\lean{...}` blueprint reference. The `\uses` block of `def:presentation_pullback_iota_preimage` is incomplete without it.
2. **`pullbackPreimageιIso` (line 2603)** — substantive helper with no `\lean{...}` blueprint reference. The `\uses` block of `def:presentation_pullback_iota_preimage` is incomplete without it.
3. **`def:over_restrict_unit_iso_inv` proof sketch** — `\uses` references `lem:isIso_unitToPushforwardObjUnit_of_isIso` but the Lean proof takes a different (simpler) route. The reference is stale but not actively misleading.

---

**Overall verdict**: gap2 closes cleanly — all 8 blueprint-pinned declarations exist in Lean with correct names, matching signatures, no sorries, and proofs that follow the blueprint sketches; two new undocumented helpers (`pullbackOpenImmersionUnitIso`, `pullbackPreimageIso`) should be promoted to named blueprint blocks.
