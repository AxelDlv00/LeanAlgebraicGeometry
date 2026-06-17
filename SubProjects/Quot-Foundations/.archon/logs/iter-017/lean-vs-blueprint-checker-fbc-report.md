# Lean ↔ Blueprint Check Report

## Slug
fbc

## Iteration
017

## Files audited
- Lean: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (def:pushforward_base_change_map)
- **Lean target exists**: yes (line 79, `noncomputable def`)
- **Signature matches**: yes — `g^*(f_* F) → f'_*((g')^* F)` with explicit `comm : g' ≫ f = f' ≫ g`, matches blueprint
- **Proof follows sketch**: yes — built via `(pullbackPushforwardAdjunction g).homEquiv.symm` of the unit composed with `pushforwardComp`/`pushforwardCongr` isos; exactly as described
- **notes**: `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (lem:modules_isIso_iff_stalk)
- **Lean target exists**: yes (line 102, `theorem`)
- **Signature matches**: yes
- **Proof follows sketch**: yes — forward via `Functor.map_isIso`; backward via `TopCat.Presheaf.isIso_of_stalkFunctor_map_iso` + `isIso_iff_of_reflects_iso`
- **notes**: `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (lem:modules_isIso_of_isBasis)
- **Lean target exists**: yes (line 128, `theorem`)
- **Signature matches**: yes
- **Proof follows sketch**: yes — reduces to stalkwise bijection via `isIso_iff_isIso_stalkFunctor_map`; injectivity from `stalkFunctor_map_injective_of_isBasis`; surjectivity from `germ_exist_of_isBasis`
- **notes**: `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (lem:modules_isIso_iff_affineOpens)
- **Lean target exists**: yes (line 164, `theorem`)
- **Signature matches**: yes
- **Proof follows sketch**: yes — special case of `isIso_of_isIso_app_of_isBasis` with `isBasis_affineOpens`
- **notes**: `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (lem:globalSectionsIso_hom_comp_specMap_appTop)
- **Lean target exists**: yes (line 268, `theorem`)
- **Signature matches**: yes — `gsR ∘ (Spec φ)^#_⊤ = φ ∘ gsR'`
- **Proof follows sketch**: yes — via `ΓSpecIso_inv_naturality`
- **notes**: `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (lem:gammaPushforwardIso)
- **Lean target exists**: yes (line 288, `noncomputable def`)
- **Signature matches**: yes — `Γ_R((Spec φ)_* N) ≅ restrictScalars φ (Γ_R' N)`
- **Proof follows sketch**: yes — element-free route (b): `restrictScalarsComp'App` ×2 + `restrictScalarsCongr` from ring equation
- **notes**: `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (lem:gammaPushforwardTildeIso)
- **Lean target exists**: yes (line 313, `noncomputable def`)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `gammaPushforwardIso φ (tilde M) ≪≫ restrictScalars.mapIso (toTildeΓNatIso.app M).symm`
- **notes**: `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (lem:gammaPushforwardIsoAt)
- **Lean target exists**: yes (line 331, `noncomputable def`)
- **Signature matches**: yes — open-indexed generalization, `Γ((Spec φ)_* N, U) ≅ restrictScalars φ (Γ(N, (Spec φ)⁻¹ U))`
- **Proof follows sketch**: yes — identical construction to `gammaPushforwardIso` with `⊤` replaced by `U`
- **notes**: `\leanok` on statement. No sorry. Blueprint proof prose mentions that naturality in the open is a definitional `rfl`; Lean code confirms this.

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (lem:tildeRestriction_isLocalizedModule)
- **Lean target exists**: yes (line 483, `lemma`)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `toOpen ⊤` is bijective (localization at `powers 1`); triangle identity + `of_linearEquiv_right`
- **notes**: `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (lem:powers_restrictScalars)
- **Lean target exists**: yes (line 455, `lemma`)
- **Signature matches**: yes — converse of `of_restrictScalars`
- **Proof follows sketch**: yes — three conditions verified via `algebraMapSubmonoid` + scalar tower
- **notes**: `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (lem:fromTildeGamma_app_isIso_of_localized)
- **Lean target exists**: yes (line 367, `lemma`)
- **Signature matches**: yes
- **Proof follows sketch**: yes — triangle identity `L ∘ j = ρ`; both localizations of `Γ(N,⊤)` at `powers a`; uniqueness gives `L = e`, hence iso
- **notes**: `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (lem:pushforward_spec_tilde_iso_conditional)
- **Lean target exists**: yes (line 431, `noncomputable def`)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `fromTildeΓ_app_isIso_of_isLocalizedModule` over basic opens → `isIso_of_isIso_app_of_isBasis` → counit iso → compose with `tilde.functor.mapIso (gammaPushforwardTildeIso …)`
- **notes**: `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (lem:pushforward_spec_tilde_iso)
- **Lean target exists**: yes (line 538, `noncomputable def`)
- **Signature matches**: yes — `(Spec φ)_* (tilde M) ≅ tilde (restrictScalars φ M)`
- **Proof follows sketch**: yes — discharges `hloc` by `algebraize [φ.hom]`, uses `gammaPushforwardIsoAt` naturality square, `tildeRestriction_isLocalizedModule`, `powers_restrictScalars`, transport via `IsLocalizedModule.of_linearEquiv`
- **notes**: `\leanok` on statement. No sorry. Proof is the complex 3-movement argument described in the blueprint (movements 1–3).

### `\lean{AlgebraicGeometry.gammaPushforwardNatIso}` (lem:gammaPushforwardNatIso)
- **Lean target exists**: yes (line 667, `noncomputable def`)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `NatIso.ofComponents` with pointwise `rfl` naturality
- **notes**: `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (lem:pullback_spec_tilde_iso)
- **Lean target exists**: yes (line 689, `noncomputable def`)
- **Signature matches**: yes — `(Spec φ)^* (tilde M) ≅ tilde (extendScalars φ M)`
- **Proof follows sketch**: yes — uniqueness-of-left-adjoints via `conjugateIsoEquiv` applied to `gammaPushforwardNatIso`
- **notes**: `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.pullback_fst_snd_specMap_tensor}` (lem:pullback_fst_snd_specMap_tensor)
- **Lean target exists**: yes (line 709, `theorem`)
- **Signature matches**: yes — both cone legs identified with `Spec` of tensor inclusions
- **Proof follows sketch**: yes — `pullbackSpecIso_inv_fst`, `pullbackSpecIso_inv_snd`
- **notes**: `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.base_change_mate_domain_read}` (lem:base_change_mate_domain_read)
- **Lean target exists**: yes (line 737, `noncomputable def`)
- **Signature matches**: yes — `Γ_R'(g^*(f_* tilde M)) ≅ extendScalars ψ (restrictScalars φ M)`
- **Proof follows sketch**: yes — pushforward dict then pullback dict, then `tilde.toTildeΓNatIso.symm`
- **notes**: `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.pullbackIsoEquivalenceOfIso}` (lem:pullbackIsoEquivalenceOfIso)
- **Lean target exists**: yes (line 753, `noncomputable def`)
- **Signature matches**: yes
- **Proof follows sketch**: yes — assembles equivalence from `pullbackComp`, `pullbackCongr`, `pullbackId`
- **notes**: `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.pullback_isEquivalence_of_iso}` (lem:pullback_isEquivalence_of_iso)
- **Lean target exists**: yes (line 762, `instance`)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `.isEquivalence_functor` of `pullbackIsoEquivalenceOfIso`
- **notes**: `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read}` (lem:base_change_mate_codomain_read)
- **Lean target exists**: yes (line 773, `noncomputable def`)
- **Signature matches**: yes — `Γ_R'(f'_*(g')^* tilde M) ≅ restrictScalars includeRight (extendScalars includeLeft M)`
- **Proof follows sketch**: yes — uses `pullback_fst_snd_specMap_tensor` via `.1`/`.2` projections, then `pullbackCongr`/`pullbackComp` reindex + `pushforwardCongr`/`pushforwardComp` + dict isos
- **notes**: `\leanok` on statement. No sorry. The `.1`/`.2` projection design (vs `obtain`) is deliberate and noted in the Lean comment (makes the def definitionally equal to `base_change_mate_codomain_read_legs` for the `exact` in `base_change_mate_fstar_reindex` to work).

### `\lean{AlgebraicGeometry.base_change_mate_regroupEquiv}` (lem:base_change_mate_regroupEquiv)
- **Lean target exists**: yes (line 856, `noncomputable def`)
- **Signature matches**: yes — `(A ⊗_R R') ⊗_A M ≅ extendScalars ψ (restrictScalars φ M)` as `R'`-module
- **Proof follows sketch**: yes — identity-on-elements `A`-linear bridge `eT` resolves the diamond; core is `cancelBaseChange`; `TensorProduct.induction_on` discharges `map_smul'`
- **notes**: `\leanok` on statement. No sorry. Blueprint's `\uses{lem:base_change_regroup_linearEquiv, ...}` references a pure-blueprint helper that was inlined in Lean; see Blueprint Adequacy below.

### `\lean{AlgebraicGeometry.base_change_mate_unit_value}` (lem:base_change_mate_unit_value)
- **Lean target exists**: yes (line 987, `theorem`, `set_option maxHeartbeats 4000000`)
- **Signature matches**: yes — geometric adjunction unit read through tilde dicts = algebraic unit `η_M`
- **Proof follows sketch**: yes — Moves 1–4: `hunitL`, `hpullinv`, `huce` (conjugate-unit coherence), `hClaimA` (right-triangle identity), `hgPTI`, final `erw [β.hom.naturality_assoc]; erw [reassoc_of% huce]`
- **notes**: `\leanok` on statement. No sorry. Heartbeat budget 4M (recorded in Lean comment).

### `\lean{AlgebraicGeometry.base_change_mate_inner_value}` (def:base_change_mate_inner_value)
- **Lean target exists**: yes (line 1102, `noncomputable def`)
- **Signature matches**: yes — `R`-linear `m ↦ (1 ⊗ 1) ⊗ m` via `restrictScalars φ` of `extendRestrictScalarsAdj.unit` transported by ring equation `inclA ∘ φ = inclR' ∘ ψ`
- **Proof follows sketch**: yes — matches blueprint description
- **notes**: Blueprint marks with `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.pullbackPushforward_unit_comp}` (lem:pullbackPushforward_unit_comp)
- **Lean target exists**: yes (line 1144, `theorem`)
- **Signature matches**: yes — unit of composite adjunction factors via `unit_conjugateEquiv` + `conjugateEquiv_pullbackComp_inv`
- **Proof follows sketch**: yes — exactly as described
- **notes**: `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}` (lem:base_change_mate_fstar_reindex)
- **Lean target exists**: yes (line 1338, `theorem`, `set_option maxHeartbeats 1600000`)
- **Signature matches**: yes — section-level Seam-2 identity
- **Proof follows sketch**: partial — the proof body is `exact base_change_mate_fstar_reindex_legs ψ φ M _ _ hfst hsnd (IsPullback.of_hasPullback …).w`, which instantiates the abstract variable-legs version. This is exactly the blueprint's step-(i) design. Steps (ii) and the setup for step (iii) are inside `base_change_mate_fstar_reindex_legs`. The step-(iii) mate-unwinding crux inside `_legs` carries a `sorry`.
- **notes**: `\leanok` on statement. Blueprint correctly does NOT have `\leanok` on the proof block. The `sorry` is the expected Seam-2 step-(iii) crux (known scaffolding per directive).

### `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}` (lem:base_change_mate_gstar_transpose)
- **Lean target exists**: yes (line 1393, `theorem`)
- **Signature matches**: yes — Seam-3 identity
- **Proof follows sketch**: partial — `rw [Functor.map_comp]` reduces to the counit coherence; then `sorry` for the pullback-dictionary coherence identifying the conjugated `g^*`-leg with `extendScalars ψ ∘ ρ`
- **notes**: `\leanok` on statement. Blueprint correctly does NOT have `\leanok` on the proof block. The `sorry` is the expected Seam-3 crux (known scaffolding per directive).

### `\lean{AlgebraicGeometry.base_change_mate_section_identity}` (lem:base_change_mate_section_identity)
- **Lean target exists**: yes (line 1453, `theorem`)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `unfold pushforwardBaseChangeMap; rw [Adjunction.homEquiv_counit]; exact base_change_mate_gstar_transpose ψ φ M` — exactly the counit-factorization step (Seam 3) described in the blueprint
- **notes**: `\leanok` on statement. Proof transitively sorry-bearing via Seam-3. Blueprint correctly has no `\leanok` on proof block.

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` (lem:base_change_mate_generator_trace)
- **Lean target exists**: yes (line 1482, `theorem`)
- **Signature matches**: yes — `IsIso (Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt)`
- **Proof follows sketch**: yes — `rw [base_change_mate_section_identity]; infer_instance`
- **notes**: `\leanok` on statement. Transitively sorry-bearing. Blueprint correctly has no `\leanok` on proof block.

### `\lean{AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange}` (lem:pushforward_base_change_mate_cancelBaseChange)
- **Lean target exists**: yes (line 1519, `theorem`)
- **Signature matches**: yes — `IsIso (Γ(α))` via conjugation
- **Proof follows sketch**: yes — assembles `hconj` from `base_change_mate_generator_trace`; then `heq : Γα = D.hom ≫ (D.inv ≫ Γα ≫ C.hom) ≫ C.inv`; `infer_instance`
- **notes**: `\leanok` on statement. Transitively sorry-bearing. Blueprint correctly has no `\leanok` on proof block.

### `\lean{AlgebraicGeometry.base_change_map_affine_local}` (lem:base_change_map_affine_local)
- **Lean target exists**: yes (line 1558, `theorem`)
- **Signature matches**: yes — `IsAffineHom f`, `F.IsQuasicoherent`, per-affine-open hypothesis → global iso
- **Proof follows sketch**: yes — one-liner `(Modules.isIso_iff_isIso_app_affineOpens …).mpr H`
- **notes**: `\leanok` on statement. No sorry.

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (lem:affine_base_change_pushforward)
- **Lean target exists**: yes (line 1570, `theorem`)
- **Signature matches**: yes — `[IsAffineHom f]`, `[F.IsQuasicoherent]`, `IsPullback` → `IsIso (pushforwardBaseChangeMap …)`
- **Proof follows sketch**: partial — applies `base_change_map_affine_local`, then `intro U` leaves the per-`U` affine-reduction goal which is `sorry`. The `sorry` is the affine reduction step (restriction-compatibility of `pushforwardBaseChangeMap` for arbitrary `S, S', X`), a multi-hundred-LOC build.
- **notes**: `\leanok` on statement. Blueprint correctly has no `\leanok` on proof block. Known scaffolding per directive.

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (thm:flat_base_change_pushforward)
- **Lean target exists**: yes (line 1610, `theorem`)
- **Signature matches**: yes — `[Flat g]`, `[QuasiCompact f]`, `[QuasiSeparated f]`, `[F.IsQuasicoherent]` → iso
- **Proof follows sketch**: N/A (entire proof is `sorry` with a prose comment describing the Čech strategy)
- **notes**: `\leanok` on statement. Blueprint correctly has no `\leanok` on proof block. Known scaffolding (FBC-B) per directive.

---

## Red flags

*(No must-fix red flags found. All items below are informational.)*

### Placeholder / suspect bodies (informational — known scaffolding)

The following carry direct or transitive `sorry`s, all pre-disclosed as expected scaffolding in the directive:

- `base_change_mate_fstar_reindex_legs` at line 1324: `sorry` for step-(iii) mate-unwinding crux (expected Seam-2 crux).
- `base_change_mate_gstar_transpose` at line 1428: `sorry` for the pullback-dictionary counit coherence (expected Seam-3 crux).
- `affineBaseChange_pushforward_iso` at line 1601: `sorry` for the affine reduction (expected; see directive).
- `flatBaseChange_pushforward_isIso` at line 1623: `sorry` for the full FBC-B strategy (expected; see directive).

The following are transitively sorry-bearing (no direct `sorry` in their own proof body) but produce sorry-axiom output due to the above:
`base_change_mate_fstar_reindex`, `base_change_mate_section_identity`, `base_change_mate_generator_trace`, `pushforward_base_change_mate_cancelBaseChange`.

### Excuse-comments
None. The long STATUS blocks in the file-header `/-! ... -/` sections are iter-NNN provenance tracking (pre-existing, declared noise in directive). No declaration body carries a "TODO: replace with real def" or "this is wrong but works for now" annotation.

### Axioms
None.

---

## Unreferenced declarations (informational)

The following 5 declarations in the Lean file have no `\lean{...}` pin in the blueprint. All 5 are identified in the directive as **known coverage debt** (slated for the planner to blueprint next iter):

| Lean name | Line | Notes |
|---|---|---|
| `gammaMap_pushforwardComp_hom_eq_id` | 1174 | `private lemma`; step-(ii-a) atomic claim |
| `gammaMap_pushforwardComp_inv_eq_id` | 1182 | `private lemma`; step-(ii-b) atomic claim |
| `gammaMap_pushforwardCongr_hom` | 1193 | `private lemma`; step-(ii-c) atomic claim |
| `base_change_mate_codomain_read_legs` | 1210 | step-(i) abstract variable-legs codomain read |
| `base_change_mate_fstar_reindex_legs` | 1270 | step-(i+iii) abstract variable-legs reindex |

These are `private` lemmas or structural helpers extracted specifically for the Seam-2 decomposition. Their absence from the blueprint is expected and does not constitute a formalization error — the concrete theorems `base_change_mate_codomain_read` and `base_change_mate_fstar_reindex` ARE pinned and their relation to `…_legs` is documented in the blueprint's `% RECIPE` comments.

---

## Blueprint adequacy for this file

### Coverage
32/37 non-Mathlib Lean declarations have a corresponding `\lean{...}` block in the chapter. (The 5 missing are the known Seam-2 coverage debt above.) All 5 Mathlib-backed blocks are correctly marked `\mathlibok`. **Coverage is adequate** given the known debt situation.

### Seam-2 decomposition faithfulness (the primary check requested by the directive)

The chapter's description of the Seam-2 decomposition is **accurate and faithful** to the landed `…_legs` implementation:

- **Step (i) (abstract variable-legs restatement)**: The blueprint prose (lem:base_change_mate_fstar_reindex proof, "(i) Abstract variable-legs restatement") precisely describes the structural device: lift legs to free variables so `subst` acts on a well-typed motive. The Lean `base_change_mate_fstar_reindex_legs` does exactly this (line 1240: `intro g' f' hfst hsnd; subst hfst; subst hsnd`). The reduction-to-`…_legs` in `base_change_mate_fstar_reindex` (via `exact base_change_mate_fstar_reindex_legs …`) is correctly described as "the instantiation at `g' = pullback.fst`, `f' = pullback.snd`." ✓

- **Step (ii) (Γ-collapse of transparent coherences)**: The blueprint correctly states that `pushforwardComp.inv` and `pushforwardCongr` collapse to identity/eqToHom repackaging under `moduleSpecΓFunctor`, handled by the three private lemmas. The Lean code at line 1305-1310 uses `simp only [gammaMap_pushforwardComp_inv_eq_id, gammaMap_pushforwardCongr_hom]`. ✓

  **One minor prose gap**: The blueprint's step-(ii) description says "The two pushforward-composition factors" collapse, implying both `.hom` and `.inv` collapse at the same point. The Lean code comment at line 1306-1309 records a discrimination-tree miss: `gammaMap_pushforwardComp_hom_eq_id` does NOT fire under `simp` at this position and collapses later inside step (iii). The blueprint does not document this tactic-level detail. This is **minor** — mathematical content is correct; the blueprint is a mathematical, not tactic, description.

- **Step (iii) (reduction to Seam 1 via leg-reindex engine)**: The blueprint correctly describes `pullbackPushforward_unit_comp` as the engine (line 1454–1484), and the Lean sets up `key := pullbackPushforward_unit_comp e.hom (Spec.map inclA) (tilde M)` before the `sorry`. The outstanding crux (mate-unwinding of the `e`-unit absorption and Seam-1 identification) is faithfully described in the blueprint and accurately labeled as the remaining obligation. ✓

### Proof-sketch depth
**Adequate.** The chapter provides enough detail that a prover can formalize the non-sorry declarations correctly. The Seam-2 decomposition, in particular, is described at a level that guided the implementation to exactly the right structure. The `% RECIPE` block in `lem:base_change_mate_fstar_reindex` is unusually precise (names specific Mathlib lemmas, calls out the dead end of naive leg-rewriting, itemizes 4 steps) and is consistent with the implementation.

### Hint precision
**Precise.** All `\lean{...}` hints name the exact Lean declarations. No cases of wrong or ambiguous Mathlib predicate.

### One structural note: `lem:base_change_regroup_linearEquiv`
The blueprint's `\uses{lem:base_change_regroup_linearEquiv, lem:isPushout_cancelBaseChange_mathlib}` in `lem:base_change_mate_regroupEquiv` references a pure-blueprint helper with no `\lean{}` tag and no corresponding Lean declaration. The `base_change_mate_regroupEquiv` Lean proof inlines this construction directly. This is a **minor** blueprint housekeeping issue: either `lem:base_change_regroup_linearEquiv` should be removed from `\uses` (since it is not a Lean obligation), or annotated to clarify it is an inline helper. No formalization error.

### Generality
**Matches need.** All declarations are at the appropriate level of generality for what the project consumes downstream.

### Recommended chapter-side actions

1. **(Next iter, expected)** Add `\lean{}` pins for the 5 Seam-2 declarations: `base_change_mate_codomain_read_legs`, `base_change_mate_fstar_reindex_legs`, and the three private step-(ii) atomic claims. The private lemmas may be wrapped in a single blueprint block or grouped under a `\begin{lemma}[Γ-collapse of pushforward coherences]` block if the planner prefers to expose them at that level.

2. **(Minor, optional)** Add a note to the step-(ii) prose in `lem:base_change_mate_fstar_reindex` clarifying that `pushforwardComp.hom` collapses inside step (iii) rather than at the step-(ii) `simp` invocation (discrimination-tree limitation in the tactic engine).

3. **(Minor, optional)** Clarify `lem:base_change_regroup_linearEquiv` in `\uses` of `lem:base_change_mate_regroupEquiv` — either remove the reference or annotate it as "inline helper, no separate Lean declaration."

---

## Severity summary

- **must-fix-this-iter**: None.
- **major**: None.
- **minor**: (1) Tactic-level detail of `gammaMap_pushforwardComp_hom_eq_id` discrimination-tree miss not documented in blueprint step-(ii) prose; (2) stale `\uses{lem:base_change_regroup_linearEquiv}` reference in `lem:base_change_mate_regroupEquiv`; (3) 5 new Seam-2 declarations without `\lean{}` pins (expected coverage debt, slated for next iter).

**Overall verdict**: The Lean file faithfully follows the blueprint in all substantive respects. The Seam-2 decomposition (steps i/ii/iii) in the chapter accurately describes the landed `base_change_mate_fstar_reindex_legs` implementation and the concrete reduction in `base_change_mate_fstar_reindex`. All outstanding `sorry`s are expected scaffolding (known cruxes: step-(iii) mate-unwinding, Seam-3, affine reduction, FBC-B). No red flags. Coverage debt for 5 new Seam-2 declarations is known and expected.
