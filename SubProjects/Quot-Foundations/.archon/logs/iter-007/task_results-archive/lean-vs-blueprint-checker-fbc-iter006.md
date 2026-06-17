# Lean ↔ Blueprint Check Report

## Slug
fbc-iter006

## Iteration
006

## Files audited
- Lean: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

All 27 project-local `\lean{...}`-tagged declarations are checked below.
Three Mathlib anchors (`pullbackSpecIso`, `cancelBaseChange`, `LinearMap.tensorEqLocusEquiv`) carry `\mathlibok` and are not re-verified here.

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (def:pushforward_base_change_map)
- **Lean target exists**: yes (line 79)
- **Signature matches**: yes — `g^*(f_* F) ⟶ f'_*((g')^* F)`, with `comm : g' ≫ f = f' ≫ g` matching the blueprint adjoint-mate description.
- **Proof follows sketch**: yes — uses `pullbackPushforwardAdjunction`, `pushforward.map unit`, `pushforwardComp`, `pushforwardCongr`, exactly the blueprint's "adjoint of f_*(unit)" structure.
- **notes**: no sorry; fully closed.

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (lem:modules_isIso_iff_stalk)
- **Lean target exists**: yes (line 102)
- **Signature matches**: yes
- **Proof follows sketch**: yes — packages M, N as `TopCat.Sheaf`, applies `isIso_of_stalkFunctor_map_iso`, reflects back via `toPresheaf`. Matches the blueprint forward/converse argument.
- **notes**: no sorry; fully closed.

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (lem:modules_isIso_of_isBasis)
- **Lean target exists**: yes (line 128)
- **Signature matches**: yes
- **Proof follows sketch**: yes — reduces to `isIso_iff_isIso_stalkFunctor_map`, then uses `stalkFunctor_map_injective_of_isBasis` / `germ_exist_of_isBasis` for injectivity/surjectivity. Matches blueprint.
- **notes**: no sorry; fully closed.

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (lem:modules_isIso_iff_affineOpens)
- **Lean target exists**: yes (line 164)
- **Signature matches**: yes
- **Proof follows sketch**: yes — uses `isIso_of_isIso_app_of_isBasis` with `isBasis_affineOpens`. Matches blueprint.
- **notes**: no sorry; fully closed.

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (lem:globalSectionsIso_hom_comp_specMap_appTop)
- **Lean target exists**: yes (line 268)
- **Signature matches**: yes — ring equation `gsR ∘ (Spec φ)^♯_⊤ = φ ∘ gsR'`.
- **Proof follows sketch**: yes — reduces to `ΓSpecIso_inv_naturality` via the `rfl` identifications of both global-sections isos with the ΓSpec inverse.
- **notes**: no sorry; fully closed.

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (lem:gammaPushforwardIso)
- **Lean target exists**: yes (line 288)
- **Signature matches**: yes — `Γ((Spec φ)_* N) ≅ restrictScalars φ (Γ N)`.
- **Proof follows sketch**: yes — route (b): two `restrictScalarsComp'App` plus `restrictScalarsCongr hcomp`.
- **notes**: no sorry; fully closed.

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (lem:gammaPushforwardTildeIso)
- **Lean target exists**: yes (line 313)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `gammaPushforwardIso φ (tilde M)` composed with `tilde.toTildeΓNatIso.app M`.
- **notes**: no sorry; fully closed.

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (lem:gammaPushforwardIsoAt)
- **Lean target exists**: yes (line 331)
- **Signature matches**: yes — `Γ((Spec φ)_* N, U) ≅ restrictScalars φ (Γ(N, (Spec φ)⁻¹ U))`.
- **Proof follows sketch**: yes — identical construction to `gammaPushforwardIso` with `⊤` replaced by `U`.
- **notes**: no sorry; fully closed. Blueprint notes open-naturality as a prose remark; the Lean constructs this transparently (each component is `rfl` on elements).

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (lem:fromTildeGamma_app_isIso_of_localized)
- **Lean target exists**: yes (line 367)
- **Signature matches**: yes
- **Proof follows sketch**: yes — uses `toOpen_fromTildeΓ_app` triangle identity, then `IsLocalizedModule.iso` uniqueness.
- **notes**: no sorry; fully closed.

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (lem:pushforward_spec_tilde_iso_conditional)
- **Lean target exists**: yes (line 431)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `isIso_of_isIso_app_of_isBasis` over basic opens, then `asIso (fromTildeΓ _).symm ≪≫ tilde.functor.mapIso gammaPushforwardTildeIso`.
- **notes**: no sorry; fully closed.

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (lem:powers_restrictScalars)
- **Lean target exists**: yes (line 455)
- **Signature matches**: yes — `A`-linear `f` exhibits `N` as localization at `algebraMapSubmonoid A S`; then `f.restrictScalars R` exhibits `N` as localization at `S`.
- **Proof follows sketch**: yes — three defining conditions verified directly.
- **notes**: no sorry; fully closed.

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (lem:tildeRestriction_isLocalizedModule)
- **Lean target exists**: yes (line 483)
- **Signature matches**: yes
- **Proof follows sketch**: yes — uses bijectivity of `toOpen M ⊤` (localization at `powers 1`) and the triangle identity `toOpen_res`.
- **notes**: no sorry; fully closed.

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (lem:pushforward_spec_tilde_iso)
- **Lean target exists**: yes (line 538)
- **Signature matches**: yes — `(Spec φ)_* (tilde M) ≅ tilde (restrictScalars φ M)`.
- **Proof follows sketch**: yes — the 3-movement structure (e_{D(a)}, naturality square, `powers_restrictScalars` transport) is formalized exactly. `algebraize [φ.hom]` supplies the scalar-tower; `of_linearEquiv` transports across the isos.
- **notes**: no sorry; fully closed. This is the most significant clean proof in the file.

### `\lean{AlgebraicGeometry.gammaPushforwardNatIso}` (lem:gammaPushforwardNatIso)
- **Lean target exists**: yes (line 667)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `NatIso.ofComponents`, naturality by `ext x; rfl`.
- **notes**: no sorry; fully closed.

### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (lem:pullback_spec_tilde_iso)
- **Lean target exists**: yes (line 689)
- **Signature matches**: yes — `(Spec φ)^* (tilde M) ≅ tilde (extendScalars φ M)`.
- **Proof follows sketch**: yes — uniqueness-of-left-adjoints via `conjugateIsoEquiv` applied to `gammaPushforwardNatIso`.
- **notes**: no sorry; fully closed.

### `\lean{AlgebraicGeometry.pullback_fst_snd_specMap_tensor}` (lem:pullback_fst_snd_specMap_tensor)
- **Lean target exists**: yes (line 709)
- **Signature matches**: yes — identifies both cone legs with `Spec` of the tensor inclusions.
- **Proof follows sketch**: yes — `pullbackSpecIso_inv_fst` / `_inv_snd` cited directly.
- **notes**: no sorry; fully closed.

### `\lean{AlgebraicGeometry.base_change_mate_domain_read}` (lem:base_change_mate_domain_read)
- **Lean target exists**: yes (line 737)
- **Signature matches**: yes — `Θ_src : Γ(g^*(f_* M^~)) ≅ extendScalars ψ (restrictScalars φ M)`.
- **Proof follows sketch**: yes — composed from `pushforward_spec_tilde_iso`, `pullback_spec_tilde_iso`, `tilde.toTildeΓNatIso`.
- **notes**: no sorry; fully closed.

### `\lean{AlgebraicGeometry.pullbackIsoEquivalenceOfIso}` (lem:pullbackIsoEquivalenceOfIso)
- **Lean target exists**: yes (line 753)
- **Signature matches**: yes
- **Proof follows sketch**: yes — pseudofunctor coherences `pullbackComp`, `pullbackCongr`, `pullbackId`.
- **notes**: no sorry; fully closed.

### `\lean{AlgebraicGeometry.pullback_isEquivalence_of_iso}` (lem:pullback_isEquivalence_of_iso)
- **Lean target exists**: yes (line 762, as `instance`)
- **Signature matches**: yes
- **Proof follows sketch**: yes — one line `(pullbackIsoEquivalenceOfIso f).isEquivalence_functor`.
- **notes**: no sorry; fully closed.

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read}` (lem:base_change_mate_codomain_read)
- **Lean target exists**: yes (line 773)
- **Signature matches**: yes — `Θ_tgt : Γ(f'_*(g')^* M^~) ≅ restrictScalars inclR' (extendScalars inclA M)`.
- **Proof follows sketch**: yes — uses `pullback_fst_snd_specMap_tensor` to identify the cone legs, then `pullback_spec_tilde_iso` / `pushforward_spec_tilde_iso` and the `pullbackIsoEquivalenceOfIso` unit.
- **notes**: no sorry; fully closed.

### `\lean{AlgebraicGeometry.base_change_mate_regroupEquiv}` (lem:base_change_mate_regroupEquiv)
- **Lean target exists**: yes (line 853)
- **Signature matches**: yes — `restrictScalars inclR' (extendScalars inclA M) ≅ extendScalars ψ (restrictScalars φ M)`; this is `(A ⊗_R R') ⊗_A M ≅ R' ⊗_R M` as R'-modules, matching the blueprint.
- **Proof follows sketch**: **partial** — the additive equivalence `g` (via `comm ≪≫ congr eT ≪≫ cancelBaseChange ≪≫ comm`) is correctly constructed. The single residual: the `map_smul'` goal for the `R'`-linearity of `g` is `sorry` (line 939).
- **notes**: **Red flag**: the direct proof body contains `:= sorry` at line 939 on a substantive `R'`-linearity goal. The blueprint statement carries `\leanok` (declaration is formalized), and the proof block has no `\leanok` — these markers are correctly synchronized. However, see the Blueprint Adequacy section for the critical finding that the blueprint's prescribed route is technically non-viable.

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace_eq}` (lem:base_change_mate_generator_trace_eq)
- **Lean target exists**: yes (line 957)
- **Signature matches**: yes — `Θ_src.inv ≫ Γ(α) ≫ Θ_tgt = regroupEquiv.inv`, matching the blueprint's "conjugated map = regroup⁻¹".
- **Proof follows sketch**: **partial** — the structural reduction `ext x` (landed this iteration, matching the blueprint's ModuleCat hom-extensionality step) is in place. The residual per-generator identity `(Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt)(1 ⊗ x) = regroupEquiv.inv (1 ⊗ x)` is `sorry` (line 985).
- **notes**: **Red flag**: `:= sorry` at line 985 on the concrete generator identity. Blueprint statement `\leanok`; proof block no `\leanok` — markers correctly synchronized.

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` (lem:base_change_mate_generator_trace)
- **Lean target exists**: yes (line 997)
- **Signature matches**: yes — `IsIso (Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt)`.
- **Proof follows sketch**: yes — `rw [base_change_mate_generator_trace_eq]; infer_instance`. The direct proof body is sorry-free; a transitive sorry propagates from `generator_trace_eq`.
- **notes**: blueprint statement `\leanok` (correct). Proof block no `\leanok` (correct, transitive sorry present).

### `\lean{AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange}` (lem:pushforward_base_change_mate_cancelBaseChange)
- **Lean target exists**: yes (line 1034)
- **Signature matches**: yes — `IsIso (Γ(pushforwardBaseChangeMap))`.
- **Proof follows sketch**: yes — assembles via `base_change_mate_generator_trace` by conjugation (`D.hom ≫ conj ≫ C.inv`). Direct body sorry-free; transitive sorry via `generator_trace_eq`.
- **notes**: blueprint statement `\leanok` (correct); proof block no `\leanok` (correct).

### `\lean{AlgebraicGeometry.base_change_map_affine_local}` (lem:base_change_map_affine_local)
- **Lean target exists**: yes (line 1073)
- **Signature matches**: yes — locality-reduction theorem.
- **Proof follows sketch**: yes — one-liner applying `isIso_iff_isIso_app_affineOpens`.
- **notes**: no sorry; fully closed.

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (lem:affine_base_change_pushforward)
- **Lean target exists**: yes (line 1085)
- **Signature matches**: yes — `IsIso (pushforwardBaseChangeMap f g f' g' h.w F)` under `[IsAffineHom f]`, `[F.IsQuasicoherent]`.
- **Proof follows sketch**: **partial** — `base_change_map_affine_local` is applied (the locality reduction). The residual per-open `U` goal (affine reduction: identify `(pushforwardBaseChangeMap).app U` with the affine–affine map, then apply `pushforward_base_change_mate_cancelBaseChange`) is `sorry` (line 1116).
- **notes**: **Red flag**: `:= sorry` at line 1116. Blueprint statement `\leanok`; proof block no `\leanok` — markers correctly synchronized.

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (thm:flat_base_change_pushforward)
- **Lean target exists**: yes (line 1125)
- **Signature matches**: yes — `IsIso (pushforwardBaseChangeMap f g f' g' h.w F)` under `[Flat g]`, `[QuasiCompact f]`, `[QuasiSeparated f]`.
- **Proof follows sketch**: N/A — the proof body is `:= sorry` (line 1138); the body contains an extensive comment with the Čech-free Mayer–Vietoris strategy which matches the blueprint proof.
- **notes**: **Red flag**: `:= sorry` at line 1138. Blueprint statement `\leanok`; proof block no `\leanok` — markers correctly synchronized.

---

## Red flags

### Placeholder / suspect bodies

| Declaration | Line | Nature |
|---|---|---|
| `base_change_mate_regroupEquiv` | 939 | `:= sorry` on the `map_smul'` (R'-linearity) sub-goal of a noncomputable `def`. Blueprint claims a substantive bundled iso. |
| `base_change_mate_generator_trace_eq` | 985 | `:= sorry` on the per-generator identity after `ext x`. Blueprint claims a concrete generator computation. |
| `affineBaseChange_pushforward_iso` | 1116 | `:= sorry` on the per-affine-open goal after applying `base_change_map_affine_local`. Blueprint claims the restriction-compatibility step closes the lemma. |
| `flatBaseChange_pushforward_isIso` | 1138 | `:= sorry` on the full proof body. Blueprint claims the Čech-free Mayer–Vietoris argument closes the theorem. |

**Severity assessment**: All four sorries are **known, documented blockers** — not silent failures. The blueprint statement blocks each carry `\leanok` (declaration formalized), and the proof blocks correctly carry no `\leanok`. The sorries on `affineBaseChange_pushforward_iso` and `flatBaseChange_pushforward_isIso` are structural stubs (the proofs are correctly framed around unfinished prerequisites). The sorries on `base_change_mate_regroupEquiv` and `base_change_mate_generator_trace_eq` are the genuine open cruxes this iteration focussed on.

### Excuse-comments
None. All lengthy comments in the Lean file are documentation of proof strategy and blockers — they correctly describe the mathematical situation and intended approach. No comments excuse incorrect or wrong code.

### Axioms / Classical.choice on non-trivial claims
None found. No `axiom` declarations in the file.

---

## Unreferenced declarations (informational)

All declarations in the Lean file are referenced from a `\lean{...}` block in the blueprint. Coverage is complete: 27/27 project-local declarations, plus 3 Mathlib anchors with `\mathlibok`.

---

## Blueprint adequacy for this file

### Coverage
**27/27** Lean declarations have a corresponding `\lean{...}` block (or `\mathlibok`) in the chapter. Zero unreferenced substantive declarations; zero helpers that should be promoted but aren't.

### Proof-sketch depth: **under-specified (two blocks)**

#### Finding 1 — `lem:base_change_mate_regroupEquiv`: WRONG proof prescription (must-fix-this-iter)

The blueprint proof says:
> "The object-level ModuleCat isomorphism is obtained directly from the standalone R'-linear equivalence of Lemma~\ref{lem:base_change_regroup_linearEquiv} by `LinearEquiv.toModuleIso`; the separate compilation unit normalises the `Module A (A ⊗_R R')` instance diamond so the bundled `map_smul'` discharges without the carrier-instance obstruction."

This prescription is **technically non-viable**, as confirmed by the iter-006 prover work. The Lean file (lines 912–916) explains why:

> "It does NOT transfer by the documented one-liner `exact LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)`: the helper's source `(A ⊗[R] R') ⊗[A] M` uses the CANONICAL `Algebra A (A ⊗[R] R')` (leftAlgebra) action, whereas the object carrier `(extendScalars includeLeftRingHom).obj M` tensors over the `restrictScalars includeLeftRingHom` A-action; the two `⊗[A]` carriers are genuinely DIFFERENT types (the A-module is an instance argument of TensorProduct), so the helper's `≃ₗ` is not defeq to the object `≃ₗ` even across the import boundary."

**Even though `RegroupHelper.lean` is a separate compiled module** (imported at line 7 of the Lean file), the type-level incompatibility is a genuine type difference, not a reduction issue. The diamond is structural: `ModuleCat.extendScalars includeLeftRingHom` uses the `restrictScalars includeLeftRingHom` A-module structure on `A ⊗[R] R'`, while `base_change_regroup_linearEquiv` tensors over the canonical `Algebra.TensorProduct.leftAlgebra` A-action. These are distinct `TensorProduct` instantiations and cannot be reconciled by cross-module normalization.

The Lean file's current approach (constructing the additive equivalence `g` with `eT` as an A-linear bridge, then calling `LinearEquiv.toModuleIso` on a fresh record literal) correctly assembles the additive part. The `map_smul'` blocker is that `letI instLHS`/`instRHS` declarations compile to opaque aux-defs, preventing `ModuleCat.restrictScalars.smul_def` / `ExtendScalars.smul_tmul` from firing.

**What the blueprint needs**: A corrected proof sketch that:
1. Acknowledges the A-module diamond is a genuine type incompatibility, not a reduction issue.
2. Proposes a viable route. Two candidates identified in the Lean file comments:
   - A project-local `ModuleCat`-level Beck–Chevalley iso for the mixed `restrictScalars ∘ extendScalars` square (keeping generators typed at the object, avoiding the inline `letI` opaqueness).
   - A `TensorProduct.ext`-style linearity check that keeps the generator `(a ⊗ₜ s) ⊗ₜ m` typed at the full object throughout, so `smul_def`/`smul_tmul` can fire.

#### Finding 2 — `lem:base_change_mate_generator_trace_eq`: under-specified (major)

The blueprint proof gives a 3-step informal trace:
1. Unit η' on M is base-change unit `m ↦ (1⊗1)⊗m`.
2. Apply `f_* = restr_φ` and pseudofunctor identities; reindex target as codomain read.
3. Transpose under `(g^* ⊣ g_*)` for ψ: `r' ⊗ m ↦ r' · ((1⊗1)⊗m) = (1⊗r')⊗m`.

The prover has executed the `ext x` reduction (reducing to a per-generator goal) but the concrete goal is blocked at the Lean API level. The Lean file comment (lines 967–983) identifies the precise gap: **"mate-unwinding coherence over the generic pullback square is Mathlib-absent"** — there is no Mathlib lemma that computes the value of `moduleSpecΓFunctor.map (pushforwardBaseChangeMap …)` applied to a generator directly in terms of the base-change unit and the adjunction API.

The blueprint NOTE comment (lines 1374–1381) already says:
> "NOTE (iter-003): the Lean decl formalizes the `IsIso (Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt)` corollary... With the generator identification (lem:base_change_mate_generator_trace_eq) the residual obstacle is gone: the conjugate equals a LinearEquiv... so this is a one-line `rw` + `infer_instance`."

This note is **about `base_change_mate_generator_trace`** (the IsIso corollary), not about `base_change_mate_generator_trace_eq` (the generator equality). The residual obstacle is INSIDE `generator_trace_eq`.

**What the blueprint needs**: Sub-lemma decomposition for `lem:base_change_mate_generator_trace_eq` with:
- Sub-lemma A: the value of `(g')^*`-unit applied to `tilde M` through `Θ_tgt` on a generator `x` equals `(1 ⊗ 1) ⊗ x`. This requires identifying `pullbackPushforwardAdjunction g'` unit's app on `tilde M` with the base-change unit — probably via `pullback_spec_tilde_iso` naturality at the unit.
- Sub-lemma B: applying `(g^* ⊣ g_*)` adjunction transpose to an R-linear map `u` gives `r' ⊗ m ↦ r' · u(m)` — this is the standard adjunction transpose formula in terms of module elements; a named Lean sub-lemma for this specific case would isolate the Mathlib-absent plumbing.
- Sub-lemma C: the pseudofunctor reindex step (step 2) only needs the commutativity `pushforwardComp` and `pushforwardCongr` naturality, which are in the Lean file already — this step likely closes by `simp` / `category_theory` once the other two are isolated.

### Hint precision: **precise**
All `\lean{...}` hints name the correct Lean declaration. No incorrect Mathlib predicate substitutions or ambiguous names.

### Generality: **matches need**
No parallel API was invented to cover a gap in the blueprint's generality level.

### Recommended chapter-side actions for a blueprint-writer subagent

1. **[must-fix-this-iter] `lem:base_change_mate_regroupEquiv` proof block**: Replace the `LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)` prescription with a correct one. The A-module diamond between `leftAlgebra` (used by `base_change_regroup_linearEquiv`) and `restrictScalars includeLeftRingHom` (used by `extendScalars includeLeftRingHom`) is a genuine type incompatibility, confirmed non-reducible even across import boundaries. Propose either: (a) a `TensorProduct.ext`-style approach that keeps generators typed at the full object throughout, or (b) a project-local `ModuleCat`-level Beck–Chevalley iso for the `restrictScalars ∘ extendScalars` square as an independent helper.

2. **[major] `lem:base_change_mate_generator_trace_eq` proof block**: Expand the 3-step sketch into 3 named sub-lemma calls with Lean signatures. The key sub-lemmas are: (A) unit-on-generator identification (value of `pullbackPushforwardAdjunction g'` unit at `tilde M` on generators through `Θ_tgt`); (B) adjunction-transpose formula for `(g^* ⊣ g_*)` at the module-element level; (C) pseudofunctor reindex step (this likely closes by existing Lean API already in the file). Without these named sub-lemmas the prover cannot break the `ext x` goal into independently closable pieces.

---

## Severity summary

| Finding | Severity | Description |
|---|---|---|
| Blueprint proof of `lem:base_change_mate_regroupEquiv` prescribes `LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)`, confirmed non-viable due to genuine `Module A (A ⊗_R R')` type incompatibility | **must-fix-this-iter** | Wrong proof prescription blocks the prover from following the blueprint |
| Blueprint proof of `lem:base_change_mate_generator_trace_eq` is a 3-step informal sketch without Lean-level sub-lemma structure for the adjunction-mate unwind | **major** | Proof sketch too high-level to break the `ext x` sorry into closable pieces |
| Four sorries in the Lean file (`base_change_mate_regroupEquiv` map_smul', `base_change_mate_generator_trace_eq` generator identity, `affineBaseChange_pushforward_iso` affine reduction, `flatBaseChange_pushforward_isIso`) | informational | All are known, documented blockers; `\leanok` markers are correctly synchronized |

**Overall verdict**: The Lean file faithfully follows the blueprint structure — all 27 declarations exist with correct signatures, no fake statements or excuse-comments — but the blueprint has one must-fix-this-iter finding (the `lem:base_change_mate_regroupEquiv` proof prescription is technically wrong) and one major finding (the `lem:base_change_mate_generator_trace_eq` sketch needs sub-lemma decomposition), both of which block prover progress on the two open FBC cruxes; a blueprint-writer expansion is needed before the next prover iteration can close these sorries.
