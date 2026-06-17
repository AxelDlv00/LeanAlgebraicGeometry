# Lean ↔ Blueprint Check Report

## Slug
fbc

## Iteration
003

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (976 lines, 25 public declarations)
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (1789 lines, 26 `\lean{...}` references; 3 are `\mathlibok`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (def:pushforward_base_change_map)
- **Lean target exists**: yes (L76)
- **Signature matches**: yes — adjunction transpose of the unit-pushed composite; the commutativity hypothesis is `g' ≫ f = f' ≫ g` in Lean (same condition as the blueprint's `g ∘ f' = f ∘ g'`, just category-theoretically ordered)
- **Proof follows sketch**: yes — `pullbackPushforwardAdjunction.homEquiv.symm` applied to `pushforward.map (unit.app F) ≫ pushforwardComp ≫ pushforwardCongr ≫ pushforwardComp.inv`, matching the blueprint's description
- **notes**: clean, no sorry

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (lem:modules_isIso_iff_stalk)
- **Lean target exists**: yes (L99)
- **Signature matches**: yes — `IsIso φ ↔ ∀ x, IsIso (stalkFunctor Ab x).map (toPresheaf X).map φ)`
- **Proof follows sketch**: yes — forward by functoriality; backward by packaging as `TopCat.Sheaf`, applying stalk-local isomorphism criterion, reflecting back through `toPresheaf`
- **notes**: no sorry; `leanok` on both statement and proof blocks

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (lem:modules_isIso_of_isBasis)
- **Lean target exists**: yes (L125)
- **Signature matches**: yes — takes `IsBasis (Set.range B)`, `φ : M ⟶ N`, `h : ∀ i, IsIso (φ.app (B i))`, concludes `IsIso φ`
- **Proof follows sketch**: yes — reduces to stalkwise via `isIso_iff_isIso_stalkFunctor_map`, uses `stalkFunctor_map_injective_of_isBasis` for injectivity and `germ_exist_of_isBasis` for surjectivity
- **notes**: no sorry

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (lem:modules_isIso_iff_affineOpens)
- **Lean target exists**: yes (L161)
- **Signature matches**: yes — `IsIso φ ↔ ∀ U : X.affineOpens, IsIso (φ.app U)`
- **Proof follows sketch**: yes — specialises `isIso_of_isIso_app_of_isBasis` to `X.isBasis_affineOpens`
- **notes**: no sorry

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (lem:globalSectionsIso_hom_comp_specMap_appTop)
- **Lean target exists**: yes (L265)
- **Signature matches**: yes — `(globalSectionsIso R).hom ≫ (Spec.map φ).appTop = φ ≫ (globalSectionsIso R').hom`
- **Proof follows sketch**: yes — rewrites both sides to `ΓSpecIso.inv` and applies `ΓSpecIso_inv_naturality`
- **notes**: no sorry

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (lem:gammaPushforwardIso)
- **Lean target exists**: yes (L285)
- **Signature matches**: yes — `(moduleSpecΓFunctor R).obj ((pushforward (Spec.map φ)).obj N) ≅ (restrictScalars φ.hom).obj ((moduleSpecΓFunctor R').obj N)`
- **Proof follows sketch**: yes — element-free route (b): `restrictScalarsComp'App` × 2 + `restrictScalarsCongr` from `globalSectionsIso_hom_comp_specMap_appTop`
- **notes**: no sorry

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (lem:gammaPushforwardTildeIso)
- **Lean target exists**: yes (L310)
- **Signature matches**: yes — `(moduleSpecΓFunctor R).obj ((pushforward (Spec.map φ)).obj (tilde M)) ≅ (restrictScalars φ.hom).obj M`
- **Proof follows sketch**: yes — specialises `gammaPushforwardIso` to `N = tilde M` then composes with `tilde.toTildeΓNatIso`
- **notes**: no sorry

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (lem:gammaPushforwardIsoAt)
- **Lean target exists**: yes (L328)
- **Signature matches**: yes — open-indexed generalization matching blueprint statement
- **Proof follows sketch**: yes — same construction as `gammaPushforwardIso` with evaluation open changed from `⊤` to `U`
- **notes**: no sorry; blueprint remark on naturality in the open matches the Lean proof structure

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (lem:tildeRestriction_isLocalizedModule)
- **Lean target exists**: yes (L480)
- **Signature matches**: yes — `IsLocalizedModule (Submonoid.powers b) (restriction map hom)`
- **Proof follows sketch**: yes — triangle identity `toOpen ⊤ ≫ res = toOpen D(b)` combined with bijectivity of `toOpen ⊤` (localization at `powers 1`)
- **notes**: no sorry

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (lem:powers_restrictScalars)
- **Lean target exists**: yes (L452)
- **Signature matches**: yes — takes `[IsLocalizedModule (Algebra.algebraMapSubmonoid A S) f]`, concludes `IsLocalizedModule S (f.restrictScalars R)`
- **Proof follows sketch**: yes — checks three conditions: `map_units`, `surj`, `exists_of_eq`, each transporting along `s ↦ algebraMap R A s`
- **notes**: no sorry

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (lem:fromTildeGamma_app_isIso_of_localized)
- **Lean target exists**: yes (L364)
- **Signature matches**: yes — `IsIso (Hom.app N.fromTildeΓ (basicOpen a))` under localization hypothesis
- **Proof follows sketch**: yes — triangle identity `L ∘ j = ρ`, uniqueness of localized modules gives `L = e : ej.symm.trans eρ`, which is bijective
- **notes**: no sorry

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (lem:pushforward_spec_tilde_iso_conditional)
- **Lean target exists**: yes (L428)
- **Signature matches**: yes — conditional form with `hloc` hypothesis; concludes `(pushforward (Spec.map φ)).obj (tilde M) ≅ tilde ((restrictScalars φ.hom).obj M)`
- **Proof follows sketch**: yes — `isIso_of_isIso_app_of_isBasis` over basic opens via `fromTildeΓ_app_isIso_of_isLocalizedModule`; then `(asIso fromTildeΓ).symm ≪≫ tilde.mapIso gammaPushforwardTildeIso`
- **notes**: no sorry

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (lem:pushforward_spec_tilde_iso)
- **Lean target exists**: yes (L535)
- **Signature matches**: yes — unconditional `(pushforward (Spec.map φ)).obj (tilde M) ≅ tilde ((restrictScalars φ.hom).obj M)`
- **Proof follows sketch**: yes — discharges `hloc` via `algebraize [φ.hom]` + `tildeRestriction_isLocalizedModule` (R'-side) + `powers_restrictScalars` (ring-change) + open-naturality square closed by `ext x; rfl`; faithfully implements movements (1)–(3)
- **notes**: no sorry — this is a major proof milestone; internally consistent

### `\lean{AlgebraicGeometry.gammaPushforwardNatIso}` (lem:gammaPushforwardNatIso)
- **Lean target exists**: yes (L664)
- **Signature matches**: yes — natural isomorphism of functors `pushforward (Spec.map φ) ⋙ moduleSpecΓFunctor R ≅ moduleSpecΓFunctor R' ⋙ restrictScalars φ.hom`
- **Proof follows sketch**: yes — `NatIso.ofComponents (fun N => gammaPushforwardIso φ N)` with naturality `ext x; rfl`
- **notes**: no sorry

### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (lem:pullback_spec_tilde_iso)
- **Lean target exists**: yes (L686)
- **Signature matches**: yes — `(pullback (Spec.map φ)).obj (tilde M) ≅ tilde ((extendScalars φ.hom).obj M)`; Lean's `extendScalars φ.hom M` is `R' ⊗_R M`, matching blueprint's `R' ⊗_R M`
- **Proof follows sketch**: yes — uniqueness-of-left-adjoints via `conjugateIsoEquiv` from `gammaPushforwardNatIso`
- **notes**: no sorry

### `\lean{AlgebraicGeometry.pullbackSpecIso}` (lem:pullbackSpecIso_mathlib)
- **Lean target exists**: yes, in Mathlib (not in this file)
- **Signature matches**: yes — correctly marked `\mathlibok`
- **Proof follows sketch**: N/A (Mathlib)

### `\lean{TensorProduct.AlgebraTensorModule.cancelBaseChange}` (lem:cancelBaseChange_mathlib)
- **Lean target exists**: yes, in Mathlib
- **Signature matches**: yes — correctly marked `\mathlibok`
- **Proof follows sketch**: N/A (Mathlib)

### `\lean{AlgebraicGeometry.pullback_fst_snd_specMap_tensor}` (lem:pullback_fst_snd_specMap_tensor)
- **Lean target exists**: yes (L706)
- **Signature matches**: yes — conjunction of `pullbackSpecIso.inv ≫ pullback.fst = Spec.map inclA` and `pullbackSpecIso.inv ≫ pullback.snd = Spec.map inclR'`; the tensor ring is `A ⊗[R] R'` (Lean/Mathlib convention), blueprint writes `R' ⊗_R A` — see tensor-order note below
- **Proof follows sketch**: yes — directly cites `pullbackSpecIso_inv_fst` and `pullbackSpecIso_inv_snd`
- **notes**: no sorry

### `\lean{AlgebraicGeometry.base_change_mate_domain_read}` (lem:base_change_mate_domain_read)
- **Lean target exists**: yes (L734)
- **Signature matches**: yes — `(moduleSpecΓFunctor R').obj ((pullback (Spec.map ψ)).obj ((pushforward (Spec.map φ)).obj (tilde M))) ≅ (extendScalars ψ.hom).obj ((restrictScalars φ.hom).obj M)`, i.e. `Γ_R'(g^*(f_* M̃)) ≅ R' ⊗_R M`
- **Proof follows sketch**: yes — chains `pushforward_spec_tilde_iso` then `pullback_spec_tilde_iso` then `tilde.toTildeΓNatIso`
- **notes**: no sorry

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read}` (lem:base_change_mate_codomain_read)
- **Lean target exists**: yes (L770)
- **Signature matches**: partial — blueprint states `(R' ⊗_R A) ⊗_A M`; Lean states `(A ⊗[R] R') ⊗_A M` (tensor factors swapped). See tensor-order assessment below.
- **Proof follows sketch**: yes — uses `pullback_fst_snd_specMap_tensor` to identify cone legs, then chains `pullback_spec_tilde_iso` and `pushforward_spec_tilde_iso` in the `A ⊗[R] R'` orientation; uses `pullbackIsoEquivalenceOfIso` to handle the `pullbackSpecIso` isomorphism
- **notes**: no sorry; the factor swap is a faithful re-orientation (see assessment below)

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` (lem:base_change_mate_generator_trace)
- **Lean target exists**: yes (L830)
- **Signature matches**: **partial** — blueprint statement claims the conjugated map EQUALS `cancelBaseChange⁻¹` (sends `r' ⊗ m ↦ (r' ⊗ 1) ⊗ m`); Lean records only `IsIso` of the conjugated map, not the literal formula
- **Proof follows sketch**: N/A — body is `:= by sorry` (known issue: "L4 residue")
- **notes**: The `IsIso` form is weaker than the blueprint's explicit formula. Unlike `pushforward_base_change_mate_cancelBaseChange`, there is **no `% NOTE:` in the chapter** documenting this deliberate weakening. See major finding §M1.

### `\lean{AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange}` (lem:pushforward_base_change_mate_cancelBaseChange)
- **Lean target exists**: yes (L869)
- **Signature matches**: yes — `IsIso` form (known issue: deliberate pin; `% NOTE:` at iter-002 and iter-003 in chapter)
- **Proof follows sketch**: yes — after iter-003 decomposition, the proof chains `base_change_mate_generator_trace` (sorry-bodied) and conjugates back via `simp [Category.assoc]` + `infer_instance`; direct proof body has no `sorry` literal; proof block `\leanok` at L1368 is consistent with direct-sorry-detection by `sync_leanok`
- **notes**: proof is transitively sorry-dependent (via `base_change_mate_generator_trace`); the proof block `\leanok` reflects that no `sorry` appears in the direct proof body, which is correct under textual sorry detection

### `\lean{AlgebraicGeometry.base_change_map_affine_local}` (lem:base_change_map_affine_local)
- **Lean target exists**: yes (L908)
- **Signature matches**: yes — takes `h : IsPullback`, `[IsAffineHom f]`, `[F.IsQuasicoherent]`, `H : ∀ U, IsIso (…app U)`, concludes `IsIso (pushforwardBaseChangeMap …)`
- **Proof follows sketch**: yes — one line: `(Modules.isIso_iff_isIso_app_affineOpens …).mpr H`
- **notes**: no sorry; trivial but correctly identified as a named locality reduction

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (lem:affine_base_change_pushforward)
- **Lean target exists**: yes (L920)
- **Signature matches**: yes — `IsIso (pushforwardBaseChangeMap f g f' g' h.w F)` for `[IsAffineHom f]`, `[F.IsQuasicoherent]`
- **Proof follows sketch**: partial — applies `base_change_map_affine_local` correctly (first obligation), then carries `:= sorry` for the per-affine-open identification of `(pushforwardBaseChangeMap…).app U` with the affine–affine chart map (second obligation, "affine reduction")
- **notes**: sorry by design (known issue); statement `\leanok` only is expected

### `\lean{LinearMap.tensorEqLocusEquiv}` (lem:flat_preserves_equalizer_mathlib)
- **Lean target exists**: yes, in Mathlib
- **Signature matches**: yes — correctly marked `\mathlibok`
- **Proof follows sketch**: N/A (Mathlib)

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (thm:flat_base_change_pushforward)
- **Lean target exists**: yes (L960)
- **Signature matches**: yes — `IsIso (pushforwardBaseChangeMap f g f' g' h.w F)` for `[Flat g]`, `[QuasiCompact f]`, `[QuasiSeparated f]`, `[F.IsQuasicoherent]`
- **Proof follows sketch**: N/A — body is `:= by sorry` with a comment sketching the Čech-free strategy (deferred lane; known issue)
- **notes**: sorry by design; statement `\leanok` only expected

---

## Tensor order assessment (directive question)

**Verdict: faithful re-orientation, not a genuine signature divergence.**

Mathlib's `pullbackSpecIso` for `Spec A ← Spec R → Spec R'` naturally produces `Spec(A ⊗[R] R')`, with `pullbackSpecIso.inv_fst` identifying `pullback.fst` with `Spec(A → A ⊗[R] R')` and `pullbackSpecIso.inv_snd` with `Spec(R' → A ⊗[R] R')`. The prover consistently used this `A ⊗[R] R'` convention throughout `pullback_fst_snd_specMap_tensor` and `base_change_mate_codomain_read`.

The blueprint writes `R' ⊗_R A` throughout (the codomain of `lem:base_change_mate_codomain_read` is `(R' ⊗_R A) ⊗_A M`; the generator formula is `r' ⊗ m ↦ (r' ⊗ 1) ⊗ m` with `(r' ⊗ 1) ∈ R' ⊗_R A`). These two conventions are canonically isomorphic via `TensorProduct.comm` (swapping factors) and the mathematics is identical:

- In the Lean `A ⊗[R] R'` convention: `r' ⊗ m ↦ (1_A ⊗ r') ⊗_A m` in `(A ⊗[R] R') ⊗_A M`
- In the blueprint `R' ⊗_R A` convention: `r' ⊗ m ↦ (r' ⊗ 1_A) ⊗_A m` in `(R' ⊗_R A) ⊗_A M`

Both are `cancelBaseChange⁻¹` in their respective conventions. The Lean code is internally consistent (all of `pullback_fst_snd_specMap_tensor`, `base_change_mate_codomain_read`, and `base_change_mate_generator_trace` use the same `A ⊗[R] R'` orientation). No mathematical content is lost or altered.

**However:** the chapter does not note this convention choice, creating a mental translation burden for a reader. See minor finding §m1.

---

## Red flags

### Placeholder / suspect bodies

The following carry `:= by sorry` bodies by design (covered by directive known issues):

- `base_change_mate_generator_trace` (L830): L4 residue; `IsIso` form stated; sorry expected
- `affineBaseChange_pushforward_iso` (L951): affine reduction obligation pending; sorry expected
- `flatBaseChange_pushforward_isIso` (L973): deferred lane; sorry expected

No additional placeholder bodies found. No `def Foo := True` patterns, no `Classical.choice _` on non-trivial claims, no axiom declarations in the file.

### Excuse-comments

None found that are not tied to known-design sorry bodies. The long status comment at L181–244 (the `STATUS (iter-234)` / `UPDATE (iter-236)` block) documents a historical dead end and the resolution that was implemented — it is a technical history note, not an excuse for wrong code. The implemented declarations it references (`gammaPushforwardIso`, `pushforward_spec_tilde_iso`) are sorry-free and correct.

### Axioms / Classical.choice

No `axiom` declarations found. No `Classical.choice` on substantive claims.

---

## Unreferenced declarations (informational)

| Declaration | Kind | Line | Assessment |
|---|---|---|---|
| `pullbackIsoEquivalenceOfIso` | `noncomputable def` | L750 | Helper: equivalence `Y.Modules ≌ X.Modules` for iso `f : X ⟶ Y`; used internally to construct `unit_iso` in `base_change_mate_codomain_read`. Coverage debt, already tracked per known issues. |
| `pullback_isEquivalence_of_iso` | `instance` | L759 | Derives `(pullback f).IsEquivalence` from `pullbackIsoEquivalenceOfIso`; used as an instance in the same proof. Coverage debt, tracked. |

Both are project-local helpers with no direct blueprint block; their purpose is clear from context and they are not substantive standalone results. Not must-fix.

---

## Blueprint adequacy for this file

- **Coverage**: 25/27 Lean declarations have a corresponding `\lean{...}` block in the chapter. The 2 unreferenced helpers (`pullbackIsoEquivalenceOfIso`, `pullback_isEquivalence_of_iso`) are tracked coverage debt, acceptable.

- **Proof-sketch depth**: **adequate**. The most complex proofs — especially `pushforward_spec_tilde_iso` (movements (1)–(3) with naturality transport) and `fromTildeΓ_app_isIso_of_isLocalizedModule` (triangle identity / uniqueness argument) — have detailed enough sketches that the formalized proofs are recognizably faithful to them. The extended remark on open-naturality in `lem:gammaPushforwardIsoAt` is exactly the ingredient that drives the localization transport in `pushforward_spec_tilde_iso`, and the formalization uses it correctly (`ext x; rfl` closes the naturality square because every constituent is identity-on-elements).

- **Hint precision**: **precise**. All 23 non-Mathlib `\lean{...}` names match exactly to declarations in the Lean file. No wrong-predicate or wrong-namespace mis-pins.

- **Generality**: **matches need**. The three locality criteria (`isIso_iff_isIso_stalkFunctor_map`, `isIso_of_isIso_app_of_isBasis`, `isIso_iff_isIso_app_affineOpens`) are stated at the right level of generality. `gammaPushforwardIsoAt` is stated for arbitrary opens (not just basic opens), which is the generality the `pushforward_spec_tilde_iso` proof needs.

- **Recommended chapter-side actions**:
  - **[major]** Add a `% NOTE:` comment at `lem:base_change_mate_generator_trace` (analogous to the one at `lem:pushforward_base_change_mate_cancelBaseChange`) documenting that the formalized Lean declaration records the `IsIso` corollary of the formula, not the literal `= cancelBaseChange⁻¹` equality. Without this note, a future prover reading the blueprint statement "sends r' ⊗ m ↦ (r' ⊗ 1) ⊗ m" as the formal claim will be confused when they find `IsIso` in the Lean.
  - **[minor]** Note the tensor order convention at the beginning of §"The section-level mate computation, decomposed": the Lean uses `A ⊗[R] R'` (Mathlib's `pullbackSpecIso` convention) while the prose writes `R' ⊗_R A`. A one-sentence note like "In Lean the tensor product ring appears as `A ⊗[R] R'` following Mathlib's `pullbackSpecIso` orientation; the formulas below with `R' ⊗_R A` are the same module up to commutativity" would eliminate the translation burden.
  - **[minor]** The `% NOTE (iter-002)` at `lem:pushforward_base_change_mate_cancelBaseChange` says "Statement \leanok reflects a sorry-bodied decl". After iter-003's decomposition the direct proof of `pushforward_base_change_mate_cancelBaseChange` is no longer sorry-bodied (the sorry lives in `base_change_mate_generator_trace`). Update the NOTE to reflect that the proof block `\leanok` at L1368 is correct post-iter-003, and the remaining sorry-dependency is transitively via `lem:base_change_mate_generator_trace`.

---

## Severity summary

**must-fix-this-iter**: 0 findings.
- All sorry-bodied declarations are covered by directive known issues.
- No signature mismatches with wrong types or wrong predicates.
- No fake / weakened-wrong definitions.
- No axioms.

**major**: 1 finding.
- **M1** — Missing `% NOTE:` at `lem:base_change_mate_generator_trace` (blueprint chapter side): The blueprint statement claims the conjugated map EQUALS `cancelBaseChange⁻¹` (a specific formula), but the Lean declaration `base_change_mate_generator_trace` records only `IsIso` of the conjugated map — a strictly weaker statement. The chapter has no annotation explaining this deliberate weakening, unlike the analogous `lem:pushforward_base_change_mate_cancelBaseChange` which has the iter-002 `% NOTE:`. A blueprint-writing pass should add the note to prevent confusion for future provers.

**minor**: 2 findings.
- **m1** — Tensor order convention gap: blueprint writes `R' ⊗_R A` throughout the codomain-read and generator-trace blocks; Lean uses `A ⊗[R] R'` (Mathlib natural convention). Faithful re-orientation confirmed; the chapter should add a convention note.
- **m2** — Stale NOTE text: `% NOTE (iter-002)` at `lem:pushforward_base_change_mate_cancelBaseChange` says "Statement \leanok reflects a sorry-bodied decl" — no longer accurate after iter-003 factored the sorry into `base_change_mate_generator_trace`. The NOTE should be refreshed.

**Overall verdict**: The Lean file faithfully follows the blueprint across all 25 declared items; all three sorry-bearing declarations are by design and covered by known issues; the major finding is a blueprint documentation gap (no `% NOTE:` at `lem:base_change_mate_generator_trace`) rather than a code correctness issue.
