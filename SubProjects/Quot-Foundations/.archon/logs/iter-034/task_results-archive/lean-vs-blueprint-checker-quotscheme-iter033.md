# Lean ↔ Blueprint Check Report

## Slug
quotscheme-iter033

## Iteration
033

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex`

---

## Directive-specific checks

### (a) The 4 new decls are faithful P1 infrastructure, not placeholders

All 4 new decls added in iter-033 have genuine proof/definition bodies — none contain `:= sorry`.

**`AlgebraicGeometry.isIso_unitToPushforwardObjUnit_of_isIso'`** (private theorem, lines 1037–1056):
- Proves: if `ψ : S ⟶ (F.sheafPushforwardContinuous …).obj R` is an iso, then `SheafOfModules.unitToPushforwardObjUnit ψ` is an iso.
- Proof strategy: unfolds via `NatTrans.isIso_iff_isIso_app`, reflects through `SheafOfModules.toSheaf` and `sheafToPresheaf`, then uses that each component of `ψ` is iso to conclude.
- **Verdict: faithful**. This is the exact helper `overRestrictUnitIso` requires (with `ψ = 𝟙`).

**`AlgebraicGeometry.Scheme.Modules.overRestrictUnitIso`** (noncomputable def, lines 1069–1079):
- Constructs: `(overRestrictEquiv U).functor.obj (SheafOfModules.unit (X.ringCatSheaf.over U)) ≅ SheafOfModules.unit U.toScheme.ringCatSheaf`
- Implementation: unfolds `overRestrictEquiv` (which is `(pushforwardPushforwardEquivalence …).symm`), then applies `asIso` on `unitToPushforwardObjUnit (ObjectProperty.homMk (𝟙 _))`, whose iso condition is discharged by `isIso_unitToPushforwardObjUnit_of_isIso'` applied to `inferInstanceAs (IsIso (𝟙 U.toScheme.ringCatSheaf))`.
- **Verdict: faithful**. Provides the `F.obj (unit R) ≅ unit S` datum required by `SheafOfModules.Presentation.map` in `overRestrictPresentation`.

**`AlgebraicGeometry.Scheme.Modules.overRestrictPresentation`** (noncomputable def, lines 1095–1098):
- Constructs: given `P : (M.over U).Presentation`, a `Presentation` of `(pullback U.ι).obj M`.
- Implementation: `Presentation.ofIsIso (overRestrictPullbackIso U M).hom (Presentation.map P (overRestrictEquiv U).functor (overRestrictUnitIso U))`.
- This is exactly the two-step composition the blueprint's proof of `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` describes: `Presentation.map` along the equivalence functor (using the unit-iso), then `ofIsIso` across the `overRestrictPullbackIso` bridge.
- **Verdict: faithful**. The heart of the P1 slice-to-geometric presentation transport.

**`AlgebraicGeometry.Scheme.Modules.presentationPullbackιOfQuasicoherentData`** (noncomputable def, lines 1100–1121):
- Constructs: given `M : X.Modules`, `q : M.QuasicoherentData`, `i : q.I`, a `Presentation` of `(pullback (Scheme.Opens.ι (q.X i))).obj M`.
- Implementation: `overRestrictPresentation (q.X i) M (q.presentation i)`.
- Carries heartbeat options (`maxHeartbeats 2000000`, `synthInstance.maxHeartbeats 800000`, `backward.isDefEq.respectTransparency false`) to handle the `Presentation.map` typeclass synthesis blow-up across the slice-site equivalence functor — same incantation Mathlib's `QuasicoherentData.bind` uses, as the docstring notes.
- **Verdict: faithful**. The per-cover-member output feeding the affine descent of the P1 transport; connects `q.presentation i` to a geometric presentation of `(q.X i).ι^* M`.

---

### (b) The `% NOTE` on the unbuilt target is still accurate

Blueprint line 3233–3236 states:
```
% NOTE: the pinned Lean decl isIso_fromTildeΓ_restrict_basicOpen does NOT yet exist; it is the
% per-element transport step of gap1.
```

Confirmed: `isIso_fromTildeΓ_restrict_basicOpen` does **not** appear anywhere in the Lean file. The 4 new decls build up to it — `presentationPullbackιOfQuasicoherentData` produces a `Presentation` of `(q.X i).ι^* M`, but the further restriction to a basic affine `D(r) ≅ Spec R_r` followed by `isIso_fromTildeΓ_of_presentation` is the remaining unformalized step. The NOTE is accurate and its description of the remaining work is still correct.

---

### (c) Which new decls need blueprint coverage entries

None of the 4 new decls have a `\lean{...}` pin in the blueprint chapter. All need entries.

The project convention is clear: even `private` helpers that serve the DAG get `\lean{}` pins (with a `% NOTE: the pinned Lean decl is private` annotation). Evidence: `AlgebraicGeometry.isIso_sheaf_of_isIso_app_basicOpen` and `AlgebraicGeometry.bijective_comp_of_localizations` are both private but have blueprint entries at `lem:isIso_sheaf_of_isIso_app_basicOpen` (lines 3473–3478) and `lem:bijective_comp_of_localizations` (lines 3451–3456) respectively.

| Declaration | Public/Private | Blueprint entry | Status |
|---|---|---|---|
| `AlgebraicGeometry.isIso_unitToPushforwardObjUnit_of_isIso'` | private | none | **missing** |
| `AlgebraicGeometry.Scheme.Modules.overRestrictUnitIso` | public | none | **missing** |
| `AlgebraicGeometry.Scheme.Modules.overRestrictPresentation` | public | none | **missing** |
| `AlgebraicGeometry.Scheme.Modules.presentationPullbackιOfQuasicoherentData` | public | none | **missing** |

Recommended blueprint additions (in the P1 section, before or after `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`):
- A `\begin{lemma}` block for `isIso_unitToPushforwardObjUnit_of_isIso'` with the `% NOTE: the pinned Lean decl is private` convention, describing that `unitToPushforwardObjUnit ψ` is iso when `ψ` is iso (with `IsIso ψ` hypothesis instead of `PullbackFree`).
- A `\begin{lemma}` or `\begin{definition}` block for `overRestrictUnitIso`, describing that the slice-to-geometric equivalence functor sends the sliced unit module to the geometric unit module.
- A `\begin{lemma}` or `\begin{definition}` block for `overRestrictPresentation`, describing the slice-presentation → geometric-restriction-presentation transport.
- A `\begin{lemma}` block for `presentationPullbackιOfQuasicoherentData`, describing that the geometric restriction to a cover member `q.X i` admits a presentation (the per-element output of P1).

---

### (d) The 4 file-level `sorry` at lines 126/165/201/228 are unchanged protected stubs

| Line | Declaration | Status |
|---|---|---|
| 126 | `AlgebraicGeometry.Scheme.hilbertPolynomial` | Protected stub, unchanged. Body `sorry` is documented "iter-177+". |
| 165 | `AlgebraicGeometry.Scheme.QuotFunctor` | Protected stub, unchanged. Body `sorry` is documented "iter-177+". |
| 201 | `AlgebraicGeometry.Scheme.Grassmannian` | Protected stub, unchanged. Body `sorry` is documented "iter-177+". |
| 228 | `AlgebraicGeometry.Scheme.Grassmannian.representable` | Protected stub, unchanged. Body `sorry` is documented "iter-177+". |

All 4 are listed in `archon-protected.yaml`. These are **not regressions**.

---

## Per-declaration (selected `\lean{}` blocks in the chapter for QuotScheme.lean)

This section covers only the declarations whose `\lean{...}` pins resolve into QuotScheme.lean. Declarations resolving into GradedHilbertSerre.lean are out of scope for this checker.

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` (def:hilbert_polynomial)
- **Lean target exists**: yes (line 123)
- **Signature matches**: partial — blueprint prose describes `s ↦ Φ_{F,s}` at a fiber `s ∈ S`, using Snapper's Lemma. The Lean signature uses `(_s : S)` as an extra parameter (making it a function over `S` via currying) and uses plain `X.Modules` rather than coherent sheaves with proper support. The body is `sorry` as documented.
- **Proof follows sketch**: N/A (body is a `sorry`-stub; the blueprint's `\leanok` marks that a stub exists, not that the proof is closed)
- **Notes**: Protected stub. The type uses `X.Modules` broadly; the blueprint prose and blueprint `\uses{thm:hilbertPoly_of_sectionModule}` indicate the real implementation will route through `hilbertPolynomialOfSectionModule`. No mismatch that is actionable until the body is filled (iter-177+).

### `\lean{AlgebraicGeometry.Scheme.QuotFunctor}` (def:quot_functor)
- **Lean target exists**: yes (line 161)
- **Signature matches**: yes — contravariant functor `(Over S)ᵒᵖ ⥤ Type u`, matching the blueprint's `(Sch/S)^op ⥤ Set` description
- **Proof follows sketch**: N/A (sorry stub)
- **Notes**: Protected stub, unchanged.

### `\lean{AlgebraicGeometry.Scheme.Grassmannian}` (def:grassmannian_scheme)
- **Lean target exists**: yes (line 198)
- **Signature matches**: yes — `(Over S)ᵒᵖ ⥤ Type u`, matching the blueprint
- **Proof follows sketch**: N/A (sorry stub)
- **Notes**: Protected stub, unchanged.

### `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` (thm:grassmannian_representable)
- **Lean target exists**: yes (line 225)
- **Signature matches**: partial — the Lean statement uses `∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)`, which is weaker than the blueprint's full description (smoothness, properness, relative dimension `d(r-d)`, tautological quotient, Plücker embedding). The blueprint already has a `% NOTE` at line 3832 flagging this weakening. Not newly introduced in iter-033.
- **Proof follows sketch**: N/A (sorry stub)
- **Notes**: Pre-existing weakened skeleton; the `% NOTE` in the blueprint documents the gap.

### `\lean{AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank}` (def:is_locally_free_of_rank)
- **Lean target exists**: yes (line 253)
- **Signature matches**: yes — uses open cover + isomorphism to `free (ULift (Fin d))`, matching the blueprint's definition
- **Proof follows sketch**: N/A (definition)
- **Notes**: Real implementation, no sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictEquiv}` (def:over_restrict_equiv)
- **Lean target exists**: yes (line 930)
- **Signature matches**: yes — `SheafOfModules (X.ringCatSheaf.over U) ≌ U.toScheme.Modules`
- **Proof follows sketch**: yes — uses `pushforwardPushforwardEquivalence` with the whiskered unit and identity as documented; the `rfl` for the structure-sheaf identification was confirmed in an earlier iter NOTE (lines 3112–3120)
- **Notes**: Axiom-clean; `\leanok` in blueprint. No issues.

### `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictIso}` (lem:over_restrict_iso)
- **Lean target exists**: yes (line 980)
- **Signature matches**: yes — `(overRestrictEquiv U).functor.obj (M.over U) ≅ (restrictFunctor U.ι).obj M`
- **Proof follows sketch**: yes — `(overRestrictFunctorIso U).app M`
- **Notes**: Axiom-clean; confirmed clean in iter-031 NOTE.

### `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictPullbackIso}` (lem:over_restrict_pullback_iso)
- **Lean target exists**: yes (line 990)
- **Signature matches**: yes — composes `overRestrictIso` with `restrictFunctorIsoPullback`
- **Proof follows sketch**: yes
- **Notes**: No issues.

### `\lean{AlgebraicGeometry.exists_finite_basicOpen_cover_le_quasicoherentData}` (lem:exists_finite_basicOpen_cover_le_quasicoherentData)
- **Lean target exists**: yes (line 730)
- **Signature matches**: yes — produces `∃ t : Finset R, Ideal.span t = ⊤ ∧ ∀ r ∈ t, ∃ i, basicOpen r ≤ q.X i`
- **Proof follows sketch**: yes — uses `iSup_basicOpen_eq_top_iff'`, `Sieve.mem_ofObjects_iff`, basic-open basis, `Ideal.span_eq_top_iff_finite`
- **Notes**: Real proof, no sorry.

### `\lean{AlgebraicGeometry.isLocalizedModule_restrict_of_isIso_fromTildeΓ}` (lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ)
- **Lean target exists**: yes (line 510)
- **Signature matches**: yes
- **Proof follows sketch**: yes — transports `isLocalizedModule_tilde_restrict` across `M.fromTildeΓ` isomorphism via `IsLocalizedModule.of_linearEquiv` and `of_linearEquiv_right`
- **Notes**: Real proof, no sorry.

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_isLocalizedModule_restrict}` (lem:isIso_fromTildeΓ_of_isLocalizedModule_restrict)
- **Lean target exists**: yes (line 614)
- **Signature matches**: yes
- **Proof follows sketch**: yes — uses `isIso_sheaf_of_isIso_app_basicOpen`, `bijective_comp_of_localizations`, `SpecModulesToSheafFullyFaithful`
- **Notes**: Real proof, no sorry.

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_iff_isLocalizedModule_restrict}` (lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict)
- **Lean target exists**: yes (line 653)
- **Signature matches**: yes
- **Proof follows sketch**: yes (trivial iff combining the two directions)
- **Notes**: Real proof, no sorry.

---

## Red flags

### Placeholder / suspect bodies
- `Scheme.hilbertPolynomial` at line 126: body is `:= sorry` — **expected**, blueprint-authorized stub; body noted "iter-177+". Not a regression.
- `Scheme.QuotFunctor` at line 165: body is `:= sorry` — **expected**, blueprint-authorized stub.
- `Scheme.Grassmannian` at line 201: body is `:= sorry` — **expected**, blueprint-authorized stub.
- `Scheme.Grassmannian.representable` at line 228: body is `:= sorry` — **expected**, blueprint-authorized stub.

None of the 4 new decls have sorry bodies.

### Excuse-comments
None. The `iter-177+` comment pattern in the docstrings explains WHY the sorry is deferred (missing infrastructure), not that the code is wrong-but-accepted. This is informational, not an excuse for wrong code.

### Axioms / Classical.choice on non-trivial claims
None introduced in this iter. The file already used `classical` (line 369) inside `annihilator_isLocalizedModule_eq_map`, consistent with Mathlib patterns.

---

## Unreferenced declarations (informational)

The following declarations in QuotScheme.lean have no `\lean{...}` blueprint pin. Among these, 4 are the new decls from this iter (already identified above); the others are pre-existing.

**New (iter-033), no pin — flag for blueprint action:**
- `AlgebraicGeometry.isIso_unitToPushforwardObjUnit_of_isIso'` (private) — needs pin with `% NOTE: private`
- `AlgebraicGeometry.Scheme.Modules.overRestrictUnitIso` — needs pin
- `AlgebraicGeometry.Scheme.Modules.overRestrictPresentation` — needs pin
- `AlgebraicGeometry.Scheme.Modules.presentationPullbackιOfQuasicoherentData` — needs pin

**Pre-existing, no pin — informational only (not introduced in iter-033):**
- `AlgebraicGeometry.Scheme.Modules.overRestrictFunctorIso` — has blueprint entry `lem:over_restrict_functor_iso` at line 3065; the `\lean{}` pin at line 3070 resolves correctly. *(Rechecked: this one does have a pin.)*
- The `overEquivalence_*` instances — all have pins in the blueprint. *(Rechecked: confirmed.)*

After re-checking, all pre-existing non-helper declarations are covered. The 4 new decls are the only uncovered substantive declarations.

---

## Blueprint adequacy for this file

- **Coverage**: Approximately 28/32 QuotScheme.lean declarations have a corresponding `\lean{...}` block. The 4 new decls from iter-033 are uncovered. Pre-existing coverage is good.
- **Proof-sketch depth**: **under-specified** for the P1 section. The proof of `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` (lines 3249–3268) describes the high-level steps ("Presentation.map along the equivalence functor", "pushing through the slice-to-geometric bridge", "Presentation.ofIsIso") but these correspond to three distinct noncomputable definitions (`overRestrictUnitIso`, `overRestrictPresentation`, `presentationPullbackιOfQuasicoherentData`) and a private helper (`isIso_unitToPushforwardObjUnit_of_isIso'`) with no individual blueprint entries. The proof sketch is at the right level of mathematical detail but the blueprint-to-Lean traceability is broken for this step.
- **Hint precision**: **loose** for the P1 step. `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` has `\lean{AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_restrict_basicOpen}` which does not yet exist — the blueprint's `% NOTE` documents this. However, the intermediate steps (the 4 new decls) are not pinned at all.
- **Generality**: **matches need**. The 4 new decls are at the right level of generality for the project's needs.
- **Recommended chapter-side actions**:
  1. Add a blueprint block for `isIso_unitToPushforwardObjUnit_of_isIso'` (private, with `% NOTE: private`) in the P1 sub-section, labelled e.g. `lem:isIso_unitToPushforwardObjUnit_of_isIso`. State: when `ψ : S ⟶ (F.sheafPushforwardContinuous …).obj R` is an iso, the map `unitToPushforwardObjUnit ψ` is an iso. Uses: that `ψ` is iso (rather than the `PullbackFree` hypothesis Mathlib uses).
  2. Add a blueprint block for `overRestrictUnitIso`, labelled e.g. `lem:overRestrictUnitIso`. State: the slice-to-geometric equivalence functor sends `unit (O_X.over U)` to `unit (U.toScheme.ringCatSheaf)`. Uses: `lem:isIso_unitToPushforwardObjUnit_of_isIso`.
  3. Add a blueprint block for `overRestrictPresentation`, labelled e.g. `lem:overRestrictPresentation`. State: a presentation of `M.over U` transports to a presentation of `(pullback U.ι).obj M`. Uses: `lem:overRestrictUnitIso`, `lem:presentation_map_mathlib`, `lem:over_restrict_pullback_iso`.
  4. Add a blueprint block for `presentationPullbackιOfQuasicoherentData`, labelled e.g. `lem:presentationPullbackιOfQuasicoherentData`. State: the pullback `(q.X i).ι^* M` has a global presentation. Uses: `lem:overRestrictPresentation`.

---

## Severity summary

- **must-fix-this-iter**: None. The 4 new decls are genuine, no-sorry infrastructure. The 4 sorry stubs are authorized protected declarations. No excuse-comments on substantive code. No wrongly-typed definitions.
- **major**: Blueprint adequacy gap — 4 new public/private declarations (`overRestrictUnitIso`, `overRestrictPresentation`, `presentationPullbackιOfQuasicoherentData`, `isIso_unitToPushforwardObjUnit_of_isIso'`) have no `\lean{...}` blueprint pins; the P1 proof sketch is not traceable to individual Lean declarations. A blueprint-writing pass is needed to restore bidirectional traceability.
- **minor**: The `Grassmannian.representable` statement is known-weaker than the blueprint prose (no smoothness/properness/tautological quotient/Plücker embedding); pre-existing, documented in the blueprint `% NOTE` at line 3832; not introduced in iter-033.

**Overall verdict**: iter-033 landed 4 axiom-clean, sorry-free P1 infrastructure declarations; the protected stubs are unchanged; the `% NOTE` on the unbuilt target remains accurate. The single open concern is a **major** blueprint traceability gap: the 4 new decls need `\lean{...}` entries added to the chapter before the next review cycle.
