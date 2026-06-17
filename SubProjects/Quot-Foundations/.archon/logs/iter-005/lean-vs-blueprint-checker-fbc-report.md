# Lean ↔ Blueprint Check Report

## Slug
fbc

## Iteration
005

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (1166 lines)
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (1924 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (def:pushforward_base_change_map)
- **Lean target exists**: yes (line 78)
- **Signature matches**: yes — canonical map `g^*(f_* F) ⟶ f'_*((g')^* F)` built as the adjoint mate of the unit; matches prose exactly
- **Proof follows sketch**: yes — the three-step composite (unit application, pseudofunctoriality `pushforwardComp`, commutativity reindexing) matches the blueprint description
- **notes**: Definition block; no proof body to compare beyond the `homEquiv` formula

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (lem:modules_isIso_iff_stalk)
- **Lean target exists**: yes (line 101)
- **Signature matches**: yes — `IsIso φ ↔ ∀ x, IsIso (stalkFunctor.map (toPresheaf.map φ))`
- **Proof follows sketch**: yes — forward direction uses `Functor.map_isIso`, backward packages into `TopCat.Sheaf` and applies `isIso_of_stalkFunctor_map_iso`, then reflects through `toPresheaf`; matches blueprint's two-step argument
- **notes**: Proof complete, no sorry

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (lem:modules_isIso_of_isBasis)
- **Lean target exists**: yes (line 127)
- **Signature matches**: yes — `IsBasis (range B) → (∀ i, IsIso (φ.app (B i))) → IsIso φ`
- **Proof follows sketch**: yes — reduces to stalk criterion, then injectivity via `stalkFunctor_map_injective_of_isBasis`, surjectivity via `germ_exist_of_isBasis`
- **notes**: Proof complete, no sorry

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (lem:modules_isIso_iff_affineOpens)
- **Lean target exists**: yes (line 163)
- **Signature matches**: yes — `IsIso φ ↔ ∀ U : X.affineOpens, IsIso (φ.app U)`
- **Proof follows sketch**: yes — forward by `inferInstance`, backward by `isIso_of_isIso_app_of_isBasis` with `isBasis_affineOpens`
- **notes**: Proof complete, no sorry

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (lem:globalSectionsIso_hom_comp_specMap_appTop)
- **Lean target exists**: yes (line 267)
- **Signature matches**: yes — `(gsR).hom ≫ (Spec.map φ).appTop = φ ≫ (gsR').hom` as a ring equation
- **Proof follows sketch**: yes — reduces to `ΓSpecIso_inv_naturality`; matches "naturality of unit/counit"
- **notes**: Proof complete, no sorry

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (lem:gammaPushforwardIso)
- **Lean target exists**: yes (line 287)
- **Signature matches**: yes — `moduleSpecΓFunctor.obj ((pushforward (Spec.map φ)).obj N) ≅ (restrictScalars φ.hom).obj (moduleSpecΓFunctor.obj N)`
- **Proof follows sketch**: yes — `restrictScalarsComp'App` (×2) + `restrictScalarsCongr hcomp` using `globalSectionsIso_hom_comp_specMap_appTop`; matches "nested restriction-of-scalars towers reconciled"
- **notes**: Proof complete, no sorry; element-free route (b) fully executed

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (lem:gammaPushforwardTildeIso)
- **Lean target exists**: yes (line 312)
- **Signature matches**: yes — specializes `gammaPushforwardIso` to `N = tilde M`, composes with `toTildeΓNatIso`
- **Proof follows sketch**: yes
- **notes**: Proof complete, no sorry

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (lem:gammaPushforwardIsoAt)
- **Lean target exists**: yes (line 330)
- **Signature matches**: yes — indexed by arbitrary open `U`; target sections over preimage `(Spec.map φ)⁻¹ U`
- **Proof follows sketch**: yes — same `restrictScalarsComp'App` construction as `gammaPushforwardIso` with `U`/`V` in place of `⊤`/`⊤`
- **notes**: Proof complete, no sorry; blueprint naturality remark is reflected in Lean via pointwise `rfl`

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (lem:tildeRestriction_isLocalizedModule)
- **Lean target exists**: yes (line 482)
- **Signature matches**: yes — structure-sheaf restriction `Γ(M~, ⊤) → Γ(M~, D(b))` is a localization at `powers b`
- **Proof follows sketch**: yes — uses `tilde.toOpen` localization, bijectivity at `⊤` via `powers 1`, and triangle identity `toOpen_res`
- **notes**: Proof complete, no sorry

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (lem:powers_restrictScalars)
- **Lean target exists**: yes (line 454)
- **Signature matches**: yes — `IsLocalizedModule (algMapSubmonoid A S) f → IsLocalizedModule S (f.restrictScalars R)`; three conditions (`map_units`, `surj`, `exists_of_eq`) checked directly
- **Proof follows sketch**: yes — matches "check three defining conditions"
- **notes**: Proof complete, no sorry

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (lem:fromTildeGamma_app_isIso_of_localized)
- **Lean target exists**: yes (line 366)
- **Signature matches**: yes — `IsLocalizedModule (powers a) ρ → IsIso (fromTildeΓ N).app (D(a))`
- **Proof follows sketch**: yes — uses triangle identity `toOpen_fromTildeΓ_app`, uniqueness of localization via `IsLocalizedModule.iso`, forces `L = e.toLinearMap`
- **notes**: Proof complete, no sorry

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (lem:pushforward_spec_tilde_iso_conditional)
- **Lean target exists**: yes (line 430)
- **Signature matches**: yes — conditional iso `(Spec φ)_* (tilde M) ≅ tilde (restrictScalars φ M)` given `hloc`
- **Proof follows sketch**: yes — applies `isIso_of_isIso_app_of_isBasis` over basic opens, with `fromTildeΓ_app_isIso_of_isLocalizedModule`, then `asIso ≪≫ tilde.functor.mapIso gammaPushforwardTildeIso`
- **notes**: Proof complete, no sorry

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (lem:pushforward_spec_tilde_iso)
- **Lean target exists**: yes (line 537)
- **Signature matches**: yes — unconditional `(Spec φ)_* (tilde M) ≅ tilde (restrictScalars φ M)`
- **Proof follows sketch**: yes — applies conditional form with `hloc(a)` discharged via the three movements: `gammaPushforwardIsoAt`, `tildeRestriction_isLocalizedModule`, `powers_restrictScalars`; naturality square closed by `rfl` (iter-241 `algebraize` pivot matches blueprint's description)
- **notes**: Proof complete, no sorry; axiom-clean

### `\lean{AlgebraicGeometry.gammaPushforwardNatIso}` (lem:gammaPushforwardNatIso)
- **Lean target exists**: yes (line 666)
- **Signature matches**: yes — natural isomorphism `pushforward (Spec.map φ) ⋙ moduleSpecΓFunctor ≅ moduleSpecΓFunctor ⋙ restrictScalars φ.hom`
- **Proof follows sketch**: yes — `NatIso.ofComponents` with pointwise `rfl` for naturality
- **notes**: Proof complete, no sorry

### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (lem:pullback_spec_tilde_iso)
- **Lean target exists**: yes (line 688)
- **Signature matches**: yes — `(Spec φ)^* (tilde M) ≅ tilde (extendScalars φ M)`; construction is uniqueness-of-left-adjoints via `conjugateIsoEquiv` applied to `gammaPushforwardNatIso`
- **Proof follows sketch**: yes — matches "uniqueness of left adjoints" route in blueprint
- **notes**: Proof complete, no sorry

### `\lean{AlgebraicGeometry.pullback_fst_snd_specMap_tensor}` (lem:pullback_fst_snd_specMap_tensor)
- **Lean target exists**: yes (line 708)
- **Signature matches**: yes — bundled conjunction: `pullbackSpecIso.inv ≫ pullback.fst = Spec.map includeLeftRingHom` and `pullbackSpecIso.inv ≫ pullback.snd = Spec.map includeRight.toRingHom`
- **Proof follows sketch**: yes — direct application of `pullbackSpecIso_inv_fst`/`_inv_snd`
- **notes**: Proof complete, no sorry

### `\lean{AlgebraicGeometry.base_change_mate_domain_read}` (lem:base_change_mate_domain_read)
- **Lean target exists**: yes (line 736)
- **Signature matches**: yes — `moduleSpecΓFunctor.obj (pullback g^* (pushforward f^* (tilde M))) ≅ extendScalars ψ (restrictScalars φ M)`
- **Proof follows sketch**: yes — `pullback.mapIso (pushforward_spec_tilde_iso) ≪≫ pullback_spec_tilde_iso ≪≫ toTildeΓNatIso.symm`
- **notes**: Proof complete, no sorry

### `\lean{AlgebraicGeometry.pullbackIsoEquivalenceOfIso}` (lem:pullbackIsoEquivalenceOfIso)
- **Lean target exists**: yes (line 752)
- **Signature matches**: yes — `Y.Modules ≌ X.Modules` via `pullback f` / `pullback (inv f)` with pseudofunctor coherences
- **Proof follows sketch**: yes
- **notes**: Proof complete, no sorry

### `\lean{AlgebraicGeometry.pullback_isEquivalence_of_iso}` (lem:pullback_isEquivalence_of_iso)
- **Lean target exists**: yes (instance, line 761)
- **Signature matches**: yes — `(pullback f).IsEquivalence` derived from `pullbackIsoEquivalenceOfIso`
- **Proof follows sketch**: yes
- **notes**: Proof complete, no sorry

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read}` (lem:base_change_mate_codomain_read)
- **Lean target exists**: yes (line 772)
- **Signature matches**: yes — `moduleSpecΓFunctor.obj (pushforward (pullback.snd) (pullback (pullback.fst) (tilde M))) ≅ restrictScalars includeRight (extendScalars includeLeft M)`
- **Proof follows sketch**: yes — identifies legs via `pullback_fst_snd_specMap_tensor`, routes through `pullbackSpecIso`, applies affine dictionaries
- **notes**: Proof complete, no sorry; correctly uses `pullbackIsoEquivalenceOfIso` to handle the `unit_iso` step

### `\lean{AlgebraicGeometry.base_change_mate_regroupEquiv}` (lem:base_change_mate_regroupEquiv)
- **Lean target exists**: yes (line 918)
- **Signature matches**: yes — `(restrictScalars includeRight).obj ((extendScalars includeLeft).obj M) ≅ (extendScalars ψ).obj ((restrictScalars φ).obj M)` as an `R'`-linear iso; tensor orientation `A ⊗[R] R'` consistent with the documented NOTE in the blueprint
- **Proof follows sketch**: partial — the `base_change_regroup_linearEquiv` auxiliary builds the `comm ≫ cancelBaseChange ≫ comm` composite correctly; the `map_smul'` sorry in `base_change_mate_regroupEquiv` itself (line 978) is the single residual obligation
- **notes**: **KNOWN sorry** in `map_smul'`; blueprint has `\leanok` on statement only (correct — sorry present); proof block lacks `\leanok` (correct — proof not closed). The obstacle (carrier-instance wall after `TensorProduct.induction_on`) is extensively documented in the Lean docstring. The alternative one-line proof via `base_change_regroup_linearEquiv` (see line 916 comment) is a viable path if the auxiliary is compiled separately.

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace_eq}` (lem:base_change_mate_generator_trace_eq)
- **Lean target exists**: yes (line 996)
- **Signature matches**: yes — `(domain_read).inv ≫ Γ(pushforwardBaseChangeMap) ≫ (codomain_read).hom = (regroupEquiv).inv`; matches blueprint's `Θ_tgt ∘ Γ(α) ∘ Θ_src⁻¹ = regroup⁻¹` exactly (categorical `≫` vs function-composition notation)
- **Proof follows sketch**: N/A — proof body is `sorry` (known, the genuine mate-unwinding crux)
- **notes**: **KNOWN sorry**; blueprint has `\leanok` on statement only (correct). Blueprint proof sketch describes the 3-step adjoint-mate trace; the sorry is the mate-unwinding coherence.

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` (lem:base_change_mate_generator_trace)
- **Lean target exists**: yes (line 1022)
- **Signature matches**: yes — `IsIso ((domain_read).inv ≫ Γ(pushforwardBaseChangeMap) ≫ (codomain_read).hom)`
- **Proof follows sketch**: yes — `rw [base_change_mate_generator_trace_eq]; infer_instance`; the proof body is sorry-free, but transitively inherits sorry via `base_change_mate_generator_trace_eq`
- **notes**: Proof closed in body. Blueprint NOTE at lines 1371–1376 correctly describes this. Lack of proof-block `\leanok` is consistent (transitive sorry via `generator_trace_eq`).

### `\lean{AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange}` (lem:pushforward_base_change_mate_cancelBaseChange)
- **Lean target exists**: yes (line 1059)
- **Signature matches**: yes — `IsIso (moduleSpecΓFunctor.map (pushforwardBaseChangeMap ...))` in the affine-affine model
- **Proof follows sketch**: yes — assembles `domain_read`, `codomain_read`, `generator_trace` via the conjugation `D.hom ≫ conj ≫ C.inv`; the proof body itself has no sorry (closes by `infer_instance` after the conjugation)
- **notes**: Proof body sorry-free; transitively inherits sorry via `base_change_mate_generator_trace`. Blueprint NOTE at lines 1405–1414 correctly explains this. Lack of proof-block `\leanok` is consistent.

### `\lean{AlgebraicGeometry.base_change_map_affine_local}` (lem:base_change_map_affine_local)
- **Lean target exists**: yes (line 1098)
- **Signature matches**: yes — `IsPullback → IsAffineHom f → F.IsQuasicoherent → (∀ U, IsIso (map.app U)) → IsIso map`; one-line proof via `isIso_iff_isIso_app_affineOpens`
- **Proof follows sketch**: yes — locality reduction spelled out in blueprint
- **notes**: Proof complete, no sorry; blueprint describes the remaining affine-reduction obligation (Step 2 of the proof) correctly as still outstanding in the Lean

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (lem:affine_base_change_pushforward)
- **Lean target exists**: yes (line 1110)
- **Signature matches**: yes — `IsPullback → IsAffineHom f → F.IsQuasicoherent → IsIso (pushforwardBaseChangeMap …)`
- **Proof follows sketch**: partial — the first reduction (locality via `base_change_map_affine_local`) is in place; the per-open sorry (line 1141) is the deferred affine-reduction step (restriction-compatibility of `pushforwardBaseChangeMap`)
- **notes**: **KNOWN deferred sorry** (later lanes). Blueprint `\leanok` on statement only (correct — declaration present). Lean proof comment at lines 1122–1141 accurately describes what remains.

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (thm:flat_base_change_pushforward)
- **Lean target exists**: yes (line 1150)
- **Signature matches**: yes — `Flat g → QuasiCompact f → QuasiSeparated f → F.IsQuasicoherent → IsIso (pushforwardBaseChangeMap …)`
- **Proof follows sketch**: N/A — proof body is `sorry` (deferred, Čech infrastructure missing)
- **notes**: **KNOWN deferred sorry** (later lanes). Blueprint `\leanok` on statement only (correct). Lean comment at lines 1153–1163 matches blueprint's §4.3 proof outline.

---

## Red flags

### Placeholder / suspect bodies
- `base_change_mate_regroupEquiv` (line 978): `:= sorry` for `map_smul'`. **Known** per directive; blueprint claims statement formalized (statement `\leanok` present), not proof closed (no proof-block `\leanok`). The statement is mathematically correct and well-specified. **Not a must-fix-this-iter** given the directive's known-issues designation.
- `base_change_mate_generator_trace_eq` (line 1010): `:= sorry` for the mate-unwinding coherence. **Known** per directive; same marker status. Not must-fix-this-iter.
- `affineBaseChange_pushforward_iso` (line 1141): `:= sorry` for the per-affine-open restriction step. **Known** deferred. Not must-fix-this-iter.
- `flatBaseChange_pushforward_isIso` (line 1163): `:= sorry` for the Čech/Mayer-Vietoris argument. **Known** deferred. Not must-fix-this-iter.

### Excuse-comments
None found. The extensive STATUS commentary in lines 183–246 (iter-234 through iter-241 notes) and the docstring comments on `base_change_mate_regroupEquiv` (lines 906–917) are implementation-strategy documentation, not excuses for incorrect code. They accurately describe resolved and outstanding obstacles.

### Axioms / Classical.choice on non-trivial claims
None found. No `axiom` declarations. The Lean file header comment notes the construction is "axiom-clean (`propext`, `Quot.sound`)" for `base_change_regroup_linearEquiv`, which is appropriate (tensor products use `Quot.sound`).

---

## Unreferenced declarations (informational)

### `base_change_regroup_linearEquiv` (lines 848–887)
- **Known coverage debt** per directive — do not treat as Lean error.
- A `LinearEquiv[R']` whose body is the `comm ≫ cancelBaseChange ≫ comm` composite with proved `map_smul'`, used as the mathematical heart of `base_change_mate_regroupEquiv`. Its name and docstring clearly indicate it is intended to be promoted to a blueprint block once `base_change_mate_regroupEquiv` is resolved.
- **Recommended blueprint action**: add a `\begin{lemma} ... \lean{AlgebraicGeometry.base_change_regroup_linearEquiv} ... \end{lemma}` block as a pure-tensor-algebra helper for `lem:base_change_mate_regroupEquiv`. The docstring already contains the full statement.

---

## Blueprint adequacy for this file

- **Coverage**: 27/28 Lean declarations have a `\lean{...}` block in the chapter. The 1 unreferenced declaration (`base_change_regroup_linearEquiv`) is a known prover-introduced helper. No substantive declaration is invisible to the blueprint.

- **Proof-sketch depth**: adequate for completed proofs. The sketches for `pushforward_spec_tilde_iso` (movements 1–3), `base_change_mate_generator_trace_eq` (three-step adjoint-mate trace), and `base_change_mate_regroupEquiv` (`comm ≫ cancelBaseChange ≫ comm` composite) are detailed enough to have guided formalization correctly. The outstanding sorries (`map_smul'` and mate-unwinding) represent genuine mathematical/formalization difficulties not fully bridged by the prose — but the prose itself is correct and the obstacles are documented in the Lean file's extensive comments. **Under-specified** for the pending `affineBaseChange_pushforward_iso` per-open step: the blueprint prose (Steps 1–3 at lines 910–961) correctly identifies the naturality-of-restriction-compatibility obligation but does not break it into lemmas, leaving it as a multi-hundred-LOC deferred obligation.

- **Hint precision**: precise throughout. Every `\lean{...}` tag names the exact Lean declaration at the correct namespace. The tensor-orientation NOTE at blueprint line 1233 correctly documents the `A ⊗[R] R'` vs `R' ⊗_R A` convention difference.

- **Generality**: matches need. No parallel API was required.

- **Proof-block `\leanok` markers**: **systematic gap** — none of the ~19 fully-proved lemmas in this file have `\leanok` on their proof blocks (i.e., every `\begin{proof}` in the chapter lacks `\leanok`). The statement blocks are correctly marked. This indicates that `sync_leanok` is either not running or not adding proof-block markers. Affected proof blocks include: `lem:modules_isIso_iff_stalk`, `lem:modules_isIso_of_isBasis`, `lem:modules_isIso_iff_affineOpens`, `lem:globalSectionsIso_hom_comp_specMap_appTop`, `lem:gammaPushforwardIso`, `lem:gammaPushforwardTildeIso`, `lem:gammaPushforwardIsoAt`, `lem:tildeRestriction_isLocalizedModule`, `lem:powers_restrictScalars`, `lem:fromTildeGamma_app_isIso_of_localized`, `lem:pushforward_spec_tilde_iso_conditional`, `lem:pushforward_spec_tilde_iso`, `lem:gammaPushforwardNatIso`, `lem:pullback_spec_tilde_iso`, `lem:pullback_fst_snd_specMap_tensor`, `lem:base_change_mate_domain_read`, `lem:base_change_mate_codomain_read`, `lem:pullbackIsoEquivalenceOfIso`, `lem:pullback_isEquivalence_of_iso`, `lem:base_change_map_affine_local`. This makes the blueprint appear more incomplete than it is to external readers.

- **Recommended chapter-side actions**:
  1. Add a `\begin{lemma}...\lean{AlgebraicGeometry.base_change_regroup_linearEquiv}...\end{lemma}` block as a dependency of `lem:base_change_mate_regroupEquiv`.
  2. Investigate why `sync_leanok` is not adding `\leanok` to proof blocks for the ~19 fully-proved lemmas. If the tool is working, run it to add missing proof-block markers. If not configured to add proof-block markers, update the configuration.
  3. For `lem:base_change_map_affine_local`: expand the proof sketch to isolate the "restriction-compatibility of `pushforwardBaseChangeMap`" obligation as a sub-lemma with its own `\lean{...}` hint, so the affine-reduction step becomes trackable.

---

## Severity summary

- **must-fix-this-iter**: none. All sorry-carrying declarations are known per the directive, blueprint markers are consistent with sorry status, no signature mismatches, no axioms, no excuse-comments.

- **major**:
  - Proof blocks for ~19 fully-proved lemmas lack `\leanok`, making `sync_leanok` appear not to be adding proof-block markers. This is a blueprint adequacy / tooling gap. The plan agent should verify `sync_leanok` behavior and trigger a re-run or config fix if proof-block markers are supposed to be added.

- **minor**:
  - `base_change_regroup_linearEquiv` has no blueprint block (known coverage debt; add a helper lemma block).
  - Blueprint proof sketch for `affineBaseChange_pushforward_iso` (the per-open affine-reduction step) is correct in identifying the obstacle but does not isolate it as a named lemma — this makes the remaining obligation hard to track.

**Overall verdict**: The Lean file is faithful to the blueprint in all essential respects — declarations exist with correct signatures, the four known sorries are consistent with the blueprint's marker state, the mathematical content matches the prose, and there are no red flags beyond the documented known issues. The only actionable gaps are the systematic absence of proof-block `\leanok` for ~19 closed proofs (likely a `sync_leanok` tooling gap) and the missing blueprint block for the `base_change_regroup_linearEquiv` helper.

---

*28 declarations checked (27 blueprint-referenced + 1 unreferenced helper); 4 known sorries (all pre-registered in directive); 0 must-fix-this-iter findings; 1 major (sync_leanok proof-block gap); 2 minor (helper coverage + proof sketch granularity).*
