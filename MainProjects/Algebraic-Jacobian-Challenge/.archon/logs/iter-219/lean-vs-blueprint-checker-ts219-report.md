# Lean ↔ Blueprint Check Report

## Slug
ts219

## Iteration
219

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration (sec:tensorobj_dual_infra — the 5 new blueprint pins)

### `\lean{PresheafOfModules.internalHom}` (def:presheaf_internal_hom)
- **Lean target exists**: no — the declaration `PresheafOfModules.internalHom` (the full presheaf object) is absent from the Lean file. The prover built the per-object VALUE module (`PresheafOfModules.InternalHom.homModule` and `PresheafOfModules.InternalHom.internalHomObjModule`) as a first sub-step, not the presheaf assembly.
- **Signature matches**: N/A (no target exists yet)
- **Proof follows sketch**: N/A
- **notes**: No `\leanok` on this blueprint block — the blueprint correctly acknowledges the declaration is not yet formalized. The `\lean{...}` pin is a forward-looking target. The 11 prover-built declarations are the first sub-step (value module) toward this target. This is expected, not a red flag.

### `\lean{PresheafOfModules.dual}` (def:presheaf_dual)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: No `\leanok`. Pre-existing gap, not introduced iter-219.

### `\lean{PresheafOfModules.internalHomEval}` (lem:internal_hom_eval)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: No `\leanok`. Pre-existing gap.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual}` (lem:internal_hom_isSheaf)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: No `\leanok`. Pre-existing gap.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (lem:dual_isLocallyTrivial)
- **Lean target exists**: no
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: No `\leanok`. Pre-existing gap.

---

## Per-declaration (other active blueprint pins — spot-check for completeness)

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (def:scheme_modules_tensorobj)
- **Lean target exists**: yes (line 1151, no sorry)
- **Signature matches**: yes — `M N : X.Modules → X.Modules`
- **Proof follows sketch**: yes — sheafifies `PresheafOfModules.Monoidal.tensorObj`
- **notes**: `\leanok` in blueprint. Clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (lem:scheme_modules_tensorobj_functoriality)
- **Lean target exists**: yes (line 1166, no sorry)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok`. Clean.

### `\lean{PresheafOfModules.restrictScalarsLaxMonoidal}` (lem:restrictscalars_laxmonoidal)
- **Lean target exists**: yes (line 336, instance, no sorry)
- **Signature matches**: yes — `CommRingCat`-level lift of sectionwise lax monoidal
- **Proof follows sketch**: yes
- **notes**: `\leanok`. Clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (lem:tensorobj_restrict_iso)
- **Lean target exists**: yes (line 1417, no sorry, closed iter-217)
- **Signature matches**: yes
- **Proof follows sketch**: yes — H1 ∘ H2 four-step composite
- **notes**: `\leanok`. Axiom-clean (iter-217). This is the substrate linchpin.

### `\lean{PresheafOfModules.pushforwardNatTrans, pushforwardCongr, pushforwardPushforwardAdj, isIso_of_isIso_app, restrictScalarsMonoidalOfBijective}` (lem:presheaf_pushforward_adj_substrate)
- **Lean target exists**: yes — all five present (lines 840, 871, 908, 940, 958)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: No `\leanok` on this blueprint block despite all being built. This is a pre-existing `\leanok`-sync issue, not an iter-219 concern.

### `\lean{restrictScalarsRingIsoTensorEquiv}` (lem:restrictscalars_ringiso_tensorequiv)
- **Lean target exists**: yes (line 115, no sorry)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok`. Clean.

### `\lean{restrictScalars_isIso_μ, restrictScalars_isIso_ε, restrictScalarsMonoidalOfRingEquiv, restrictScalars_isIso_μ_of_bijective, restrictScalars_isIso_ε_of_bijective}` (lem:restrictscalars_ringiso_strongmonoidal)
- **Lean target exists**: yes — all five present (lines 219, 237, 253, 266, 275)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok`. Clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (lem:tensorobj_preserves_locally_trivial)
- **Lean target exists**: yes (line 1507, no sorry)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok`. Clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (lem:tensorobj_inverse_invertible)
- **Lean target exists**: yes (line 1550, body `:= sorry`)
- **Signature matches**: yes
- **Proof follows sketch**: N/A — blueprint explicitly labels this "Infrastructure-blocked" with no proof body and no `\leanok` on the proof block
- **notes**: The `\leanok` on the STATEMENT block is correct (sorry present). The sorry is fully acknowledged by the blueprint. Not a red flag.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (lem:tensorobj_lift_onproduct)
- **Lean target exists**: yes (line 1567, no sorry)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok`. Clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (lem:tensorobj_assoc_iso)
- **Lean target exists**: yes (line 1310)
- **Signature matches**: yes — takes `IsLocallyTrivial` hypotheses as stated in blueprint
- **Proof follows sketch**: partial — uses ROUTE (d) whiskering composite which transitively depends on the `isLocallyInjective_whiskerLeft_of_W` sorry (line 632). Blueprint acknowledges "route mismatch, deferred".
- **notes**: `\leanok` on statement. Blueprint explicitly notes the proof is not yet the intended gluing route. Pre-existing known gap, not introduced iter-219.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor, tensorObj_right_unitor}` (lem:tensorobj_unit_iso)
- **Lean target exists**: yes (lines 1240, 1250, no sorry)
- **Signature matches**: yes
- **Proof follows sketch**: yes — cheap `mapIso` pattern
- **notes**: Blueprint lacks `\leanok` on this block. Pre-existing sync gap; both declarations are present and sorry-free.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (lem:tensorobj_comm_iso)
- **Lean target exists**: yes (line 1260, no sorry)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok`. Clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}` (def:scheme_modules_isinvertible)
- **Lean target exists**: yes (line 1179, `def`, no sorry)
- **Signature matches**: yes — existential `∃ N, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)`
- **Proof follows sketch**: yes (definition)
- **notes**: `\leanok`. Clean.

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (thm:rel_pic_addcommgroup_via_tensorobj)
- **Lean target exists**: yes (line 1600, body `:= sorry`)
- **Signature matches**: yes
- **Proof follows sketch**: N/A — blocked on `exists_tensorObj_inverse` which is itself infrastructure-blocked
- **notes**: `\leanok` on statement, no proof `\leanok`. Sorry acknowledged in both Lean and blueprint. Not a red flag.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid}` (lem:tensorobj_isoclass_commgroup)
- **Lean target exists**: no — absent from the file
- **Signature matches**: N/A
- **notes**: No `\leanok` in blueprint. Pre-existing gap, not introduced iter-219.

### `\lean{AlgebraicGeometry.LineBundle.OnProduct.pullback_tensorObj_iso}` (lem:pullback_compatible_with_tensorobj)
- **Lean target exists**: no — absent from the file
- **Signature matches**: N/A
- **notes**: No `\leanok` in blueprint. Pre-existing gap.

---

## Red flags

### Placeholder / suspect bodies
- `AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse` (line 1550): `:= sorry`, but the blueprint explicitly labels this "Infrastructure-blocked" and the proof block carries no `\leanok`. **Expected, not a red flag.**
- `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj` (line 1602): `:= sorry`. Blueprint lacks `\leanok` on proof block. **Expected.**
- `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W` (line 632): `:= sorry`. Blueprint `\leanok` on statement block but NOT proof block (explicitly described as route-(e) residual, superseded route). **Expected.**

None of the 11 new iter-219 declarations (`termRingMap` through `internalHomObjModule`) have placeholder bodies. All have genuine proofs.

### Excuse-comments
- The Lean file (lines 603–631, inside `isLocallyInjective_whiskerLeft_of_W`) contains a long comment block describing two residual gaps (d.1-bridge and d.2). These are documentation comments on an acknowledged open proof, not excuse-comments on a claimed-complete proof. **Not a red flag.**
- The `addCommGroup_via_tensorObj` docstring (lines 1575–1598) includes an `iter-218 INCOMPLETE gate` note. This is a workflow annotation on an acknowledged sorry, not a disguised bypass. **Not a red flag.**

### Axioms / Classical.choice on non-trivial claims
None found among the 11 new declarations.

---

## Unreferenced declarations (the 11 new iter-219 declarations)

All 11 live in `namespace PresheafOfModules.InternalHom` (lines 996–1129) and have no `\lean{...}` blueprint reference. Classification:

| Declaration | Nature | Blueprint coverage |
|---|---|---|
| `termRingMap` | Helper — ring map R(T) → R(Y) for globalSMul | Described implicitly in prose of `def:presheaf_internal_hom` |
| `termRingMap_naturality` | Helper lemma | Implied by presheaf-morphism requirement |
| `globalSMul` | Key building block — scalar endomorphism of N | Described in `def:presheaf_internal_hom` prose ("f • φ := postcompose with scalar-mult") |
| `globalSMul_hom_apply` | Simp helper | Pure helper |
| `globalSMul_one` | Module axiom ingredient | Pure helper |
| `globalSMul_zero` | Module axiom ingredient | Pure helper |
| `globalSMul_add` | Module axiom ingredient | Pure helper |
| `globalSMul_mul` | Module axiom ingredient | Pure helper |
| `homModule` | **Substantive** — R(T)-module on Hom(M,N) | Described in `def:presheaf_internal_hom` prose as the VALUE module; no `\lean{...}` pin |
| `restr` | Helper — over-category restriction M\|_U | Implied by the slice formula in `def:presheaf_internal_hom` |
| `internalHomObjModule` | **Substantive** — slice value Hom(M\|_U, N\|_U) as R(U)-module | The per-object VALUE module the blueprint's slice formula describes; no `\lean{...}` pin |

`homModule` and `internalHomObjModule` are the substantive intermediate deliverables of iter-219. They are described mathematically in the blueprint prose of `def:presheaf_internal_hom` but lack dedicated `\lean{...}` pins. The blueprint pins the final target (`PresheafOfModules.internalHom`) rather than these intermediate steps.

---

## Blueprint adequacy for this file

### What was built (iter-219 sub-step: value module)

- **Coverage**: 0/2 substantive iter-219 declarations (`homModule`, `internalHomObjModule`) have a `\lean{...}` pin. The blueprint prose describes what was built but routes the pin to the eventual full presheaf target.
- **Proof-sketch depth**: **adequate** for the value-module sub-step. The blueprint's `def:presheaf_internal_hom` prose specifies `ℋom(M,N)(U) = ModuleCat.of(R(U))(M|_U ⟶ N|_U)` with scalar action `f • φ := ` precompose or postcompose (both equal), and the Lean chooses postcompose (`φ ≫ globalSMul hT N f`). This is mathematically faithful. The `termRingMap` machinery and `Over`-category route for `restr` are Lean-specific implementation details not specified in the blueprint, but they are the correct realization.
- **Hint precision**: N/A (no `\lean{...}` hints for these intermediate declarations)
- **Generality**: matches need — the value module is built over an abstract `C` with terminal object `T`, which is the right level of generality for the subsequent presheaf assembly

### Remaining sub-steps (presheaf assembly through sheaf dual)

- **Restriction maps (V ⟶ U)**: The blueprint (`def:presheaf_internal_hom`) states "For V ⊆ U the restriction map sends M|_U → N|_U to its further restriction M|_V → N|_V; covariant in V ⊆ U." This is mathematically adequate but gives NO Lean-specific signature or intermediate declaration name for the restriction map. A prover must infer the Lean route: likely `PresheafOfModules.Hom.mk` applied to the functoriality of `pushforward₀ (Over.forget U)`. **Under-specified for Lean implementation.**
- **Presheaf assembly** (combining value modules + restriction maps into `PresheafOfModules`): **Under-specified**. The blueprint does not name any intermediate Lean declaration for the presheaf struct (the `PresheafOfModules.mk` or equivalent). A prover must work out the `Functor`-based assembly from `internalHomObjModule` values. This is the most under-specified step.
- **Dual** (`def:presheaf_dual → PresheafOfModules.dual`): adequately described — it is the internal hom into the unit, no new ideas needed.
- **Evaluation** (`lem:internal_hom_eval → PresheafOfModules.internalHomEval`): adequately described — the contraction `s ⊗ φ ↦ φ(s)`, sectionwise.
- **Sheaf condition** (`lem:internal_hom_isSheaf → AlgebraicGeometry.Scheme.Modules.dual`): adequately described — section-wise gluing in the sheaf N.

### Recommended chapter-side actions
1. **Add `\lean{...}` pins** for `PresheafOfModules.InternalHom.homModule` and `PresheafOfModules.InternalHom.internalHomObjModule` as explicitly named intermediate declarations within `def:presheaf_internal_hom` (or as a new sub-definition block). This makes the prover's iter-219 progress visible in the blueprint.
2. **Expand the presheaf-assembly step**: add a named sub-block (e.g. `lem:presheaf_internal_hom_restriction_map`) describing the restriction map `ρ : internalHomObjModule U M N → internalHomObjModule V M N` for `f : V ⟶ U`, with a Lean target name, so the next prover knows what to build before calling `PresheafOfModules.mk`.
3. **Add `\leanok` markers** (via sync_leanok) for `lem:presheaf_pushforward_adj_substrate` and `lem:tensorobj_unit_iso` — both are built axiom-clean but currently lack markers.

---

## Severity summary

- **must-fix-this-iter**: **None.** All blueprint `\lean{...}` pins that name non-existent declarations carry no `\leanok` marker; the blueprint correctly flags them as not yet formalized. The 11 new declarations have genuine (non-sorry) bodies. No signature mismatches, no excuse-comments on claimed-complete proofs, no unauthorized axioms.

- **major**:
  - `homModule` and `internalHomObjModule` are substantive intermediate deliverables with no blueprint `\lean{...}` pin. A blueprint-writing subagent should add named sub-steps.
  - Presheaf-assembly step (restriction maps for `V ⟶ U`) is under-specified in the blueprint — no Lean declaration name or signature is given for the restriction map component of the full presheaf.

- **minor**:
  - Blueprint `\leanok` missing on `lem:presheaf_pushforward_adj_substrate` and `lem:tensorobj_unit_iso` (declarations are present and sorry-free but markers not yet synced).
  - Pre-existing gaps (`tensorObjIsoclassCommMonoid`, `pullback_tensorObj_iso`) are consistent with no `\leanok` markers and are not iter-219 regressions.

**Overall verdict**: The 11 iter-219 declarations faithfully realize the blueprint's described per-object value sub-step with no placeholder bodies, no signature mismatches against the blueprint prose, and no unauthorized axioms; the `\lean{PresheafOfModules.internalHom}` pin correctly names the eventual full-presheaf target (not yet built); two major gaps (missing blueprint pins for the iter-219 intermediate deliverables, and under-specification of the presheaf-assembly restriction-map step) but no must-fix-this-iter findings.
