# Lean ↔ Blueprint Check Report

## Slug
fbc

## Iteration
016

## Files audited
- Lean: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

All 31 project-local Lean declarations (excluding Mathlib-backed `\mathlibok` anchors) are checked below. Declarations with no issues are grouped for brevity; individual entries are given for everything with a finding.

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (def:pushforward_base_change_map)
- **Lean target exists**: yes (line 79)
- **Signature matches**: yes — `g^*(f_* F) ⟶ f'_*((g')^* F)` with `comm : g' ≫ f = f' ≫ g`, matches prose.
- **Proof follows sketch**: N/A (definition); construction matches blueprint's adjoint-mate description.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (lem:modules_isIso_iff_stalk)
- **Lean target exists**: yes (line 102)
- **Signature matches**: yes
- **Proof follows sketch**: yes — forward/backward directions match blueprint.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (lem:modules_isIso_of_isBasis)
- **Lean target exists**: yes (line 128)
- **Signature matches**: yes
- **Proof follows sketch**: yes — injectivity/surjectivity via basis, matches blueprint.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (lem:modules_isIso_iff_affineOpens)
- **Lean target exists**: yes (line 164)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Clean.

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (lem:globalSectionsIso_hom_comp_specMap_appTop)
- **Lean target exists**: yes (line 268)
- **Signature matches**: yes — ring commutativity square `gsR ≫ appTop = φ ≫ gsR'`, matches blueprint.
- **Proof follows sketch**: yes — via `ΓSpecIso_inv_naturality`.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (lem:gammaPushforwardIso)
- **Lean target exists**: yes (line 288)
- **Signature matches**: yes
- **Proof follows sketch**: yes — restriction-of-scalars tower route matches blueprint.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (lem:gammaPushforwardTildeIso)
- **Lean target exists**: yes (line 313)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Clean.

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (lem:gammaPushforwardIsoAt)
- **Lean target exists**: yes (line 331)
- **Signature matches**: yes — open-indexed generalization matches blueprint.
- **Proof follows sketch**: yes — same construction as `gammaPushforwardIso` evaluated at `U`.
- **notes**: Clean. The open-naturality remark in the blueprint proof aligns with the Lean pointwise-rfl naturality in `gammaPushforwardNatIso`.

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (lem:tildeRestriction_isLocalizedModule)
- **Lean target exists**: yes (line 483)
- **Signature matches**: yes
- **Proof follows sketch**: yes — triangle identity + bijectivity of `toOpen ⊤`.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (lem:powers_restrictScalars)
- **Lean target exists**: yes (line 455)
- **Signature matches**: yes
- **Proof follows sketch**: yes — three conditions checked directly.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (lem:fromTildeGamma_app_isIso_of_localized)
- **Lean target exists**: yes (line 367)
- **Signature matches**: yes
- **Proof follows sketch**: yes — triangle identity forces `L = e`, unique localization isomorphism.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (lem:pushforward_spec_tilde_iso_conditional)
- **Lean target exists**: yes (line 431)
- **Signature matches**: yes
- **Proof follows sketch**: yes — basis-local criterion + counit iso + `gammaPushforwardTildeIso`.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (lem:pushforward_spec_tilde_iso)
- **Lean target exists**: yes (line 538)
- **Signature matches**: yes
- **Proof follows sketch**: yes — discharges `hloc` via `algebraize` + `powers_restrictScalars` + naturality of `{e_U}`.
- **notes**: No sorry. Clean.

### `\lean{AlgebraicGeometry.gammaPushforwardNatIso}` (lem:gammaPushforwardNatIso)
- **Lean target exists**: yes (line 667)
- **Signature matches**: yes
- **Proof follows sketch**: yes — naturality is pointwise rfl, matches blueprint.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (lem:pullback_spec_tilde_iso)
- **Lean target exists**: yes (line 689)
- **Signature matches**: yes — `(Spec φ)^*(tilde M) ≅ tilde (R' ⊗_R M)`, matches blueprint.
- **Proof follows sketch**: yes — uniqueness-of-left-adjoints via `conjugateIsoEquiv` + `gammaPushforwardNatIso`.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.pullback_fst_snd_specMap_tensor}` (lem:pullback_fst_snd_specMap_tensor)
- **Lean target exists**: yes (line 709)
- **Signature matches**: yes — conjunction identifying both cone legs with Spec of tensor inclusions.
- **Proof follows sketch**: yes — uses `pullbackSpecIso_inv_fst`/`_inv_snd`.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.base_change_mate_domain_read}` (lem:base_change_mate_domain_read)
- **Lean target exists**: yes (line 737)
- **Signature matches**: yes — `Γ(g^*(f_* tilde M)) ≅ R' ⊗_R M`.
- **Proof follows sketch**: yes
- **notes**: Clean.

### `\lean{AlgebraicGeometry.pullbackIsoEquivalenceOfIso}` (lem:pullbackIsoEquivalenceOfIso)
- **Lean target exists**: yes (line 753)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Clean.

### `\lean{AlgebraicGeometry.pullback_isEquivalence_of_iso}` (lem:pullback_isEquivalence_of_iso)
- **Lean target exists**: yes (line 762), as `instance` rather than `theorem`
- **Signature matches**: yes (semantically — an instance IS a proof)
- **Proof follows sketch**: yes
- **notes**: Blueprint calls it a "lemma"; Lean has `instance`. Minor naming drift, no content issue.

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read}` (lem:base_change_mate_codomain_read)
- **Lean target exists**: yes (line 773)
- **Signature matches**: yes — `Γ(f'_*(g')^* tilde M) ≅ (A ⊗_R R') ⊗_A M`.
- **Proof follows sketch**: yes — leg identification via `pullback_fst_snd_specMap_tensor` then both affine dictionaries.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.base_change_mate_regroupEquiv}` (lem:base_change_mate_regroupEquiv)
- **Lean target exists**: yes (line 852)
- **Signature matches**: yes — `(A ⊗_R R') ⊗_A M ≅ R' ⊗_R M` as R'-modules.
- **Proof follows sketch**: yes — `cancelBaseChange` + `A`-action bridge `eT`, matches blueprint's "lone residual obstruction" description.
- **notes**: Clean. Fully proved, no sorry.

### `\lean{AlgebraicGeometry.base_change_mate_unit_value}` (lem:base_change_mate_unit_value)
- **Lean target exists**: yes (line 983)
- **Signature matches**: yes — identifies geometric unit with algebraic unit `η_M`.
- **Proof follows sketch**: yes — `adjL`/`adjR` composition units + `conjugateEquiv` coherence (`huce`), matches blueprint.
- **notes**: Clean. Fully proved, no sorry.

### `\lean{AlgebraicGeometry.base_change_mate_inner_value}` (def:base_change_mate_inner_value)
- **Lean target exists**: yes (line 1098)
- **Signature matches**: yes — `R`-linear map `ρ : restrictScalars φ M ⟶ restrictScalars ψ (restrictScalars inclR' (extendScalars inclA M))`.
- **Proof follows sketch**: yes — `restrictScalars φ` of algebraic unit, transported via ring equation.
- **notes**: Clean.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}` (lem:base_change_mate_fstar_reindex) — **SORRY**
- **Lean target exists**: yes (line 1168)
- **Signature matches**: yes
- **Proof follows sketch**: **partial** — sorry at line 1248. See Red Flags.
- **notes**: `\leanok` at statement level is consistent (sorry present). The proof has the leg-identification scaffold (`hfst`, `hsnd`), `Functor.map_comp` split, and `key := pullbackPushforward_unit_comp e.hom (Spec.map inclA) (tilde M)` in place; however, the sorry persists because wiring `key` into the goal requires `rw [hfst]`/`rw [hsnd]` on legs that appear in dependent positions (`IsPullback.of_hasPullback …`, `gammaPushforwardIso ψ (pushforward (pullback.snd …))`), and all such rewrites fail with "motive is not type correct." This RESIDUAL WALL is not resolved by the current blueprint recipe.

### `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}` (lem:base_change_mate_gstar_transpose) — **SORRY**
- **Lean target exists**: yes (line 1258)
- **Signature matches**: yes
- **Proof follows sketch**: **partial** — sorry at line 1293. `Functor.map_comp` split applied; the remaining crux is the pullback-dictionary coherence: conjugating `Γ(g^*(inner)) ≫ Γ(ε_g)` by `Θ_src`/`Θ_tgt` should turn `g^* = (Spec ψ)^*` of a tilde into `extendScalars ψ ∘ ρ` via `pullback_spec_tilde_iso ψ` (built via `conjugateIsoEquiv`) and the counit-triangle identity. This concrete coherence is not described in the blueprint at the Lean level.
- **notes**: `\leanok` at statement level consistent. Transitively sorry blocks `base_change_mate_section_identity`, `base_change_mate_generator_trace`, and `pushforward_base_change_mate_cancelBaseChange`.

### `\lean{AlgebraicGeometry.base_change_mate_section_identity}` (lem:base_change_mate_section_identity)
- **Lean target exists**: yes (line 1318)
- **Signature matches**: yes
- **Proof follows sketch**: yes structurally — `unfold pushforwardBaseChangeMap`, `rw [Adjunction.homEquiv_counit]`, `exact base_change_mate_gstar_transpose`. Transitively sorry.
- **notes**: Proof structure is correct and minimal; depends entirely on Seam 3 closing.

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` (lem:base_change_mate_generator_trace)
- **Lean target exists**: yes (line 1347)
- **Signature matches**: yes — `IsIso (Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt)`.
- **Proof follows sketch**: yes structurally — `rw [base_change_mate_section_identity]; infer_instance`. Transitively sorry.
- **notes**: One-liner corollary of the section identity, exactly as blueprint describes.

### `\lean{AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange}` (lem:pushforward_base_change_mate_cancelBaseChange)
- **Lean target exists**: yes (line 1384)
- **Signature matches**: yes
- **Proof follows sketch**: yes structurally — conjugation by `D`/`C`, then `infer_instance`. Transitively sorry via `generator_trace`.
- **notes**: Blueprint's `\leanok` at statement level is consistent. Proof structure is correct.

### `\lean{AlgebraicGeometry.base_change_map_affine_local}` (lem:base_change_map_affine_local)
- **Lean target exists**: yes (line 1423)
- **Signature matches**: yes
- **Proof follows sketch**: yes — one-line application of `Modules.isIso_iff_isIso_app_affineOpens`.
- **notes**: Clean. Fully proved.

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (lem:affine_base_change_pushforward) — **SORRY**
- **Lean target exists**: yes (line 1435)
- **Signature matches**: yes
- **Proof follows sketch**: **partial** — applies `base_change_map_affine_local` (correct first step) then sorry at line 1466. The remaining obligation is the affine reduction: restricting to an affine `U ⊆ S'` and identifying `(pushforwardBaseChangeMap …).app U` with the affine–affine base-change map over the restricted square. This restriction-compatibility is Mathlib-absent and is not yet blueprinted.
- **notes**: `\leanok` at statement level consistent. Blueprint proof describes this "restriction step" in prose but doesn't name it as a lemma requiring formalization.

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (thm:flat_base_change_pushforward) — **SORRY**
- **Lean target exists**: yes (line 1475)
- **Signature matches**: yes
- **Proof follows sketch**: **no proof yet** — sorry at line 1488. Blueprint proof is detailed (separated and quasi-separated Mayer–Vietoris cases), but Lean body is a comment with `sorry`.
- **notes**: `\leanok` at statement level consistent. Blueprint adequacy here is good conceptually; no Lean engineering attempt exists yet.

---

## Red flags

### Placeholder / suspect bodies

| Declaration | Line | Observation |
|---|---|---|
| `base_change_mate_fstar_reindex` | 1248 | `:= sorry` — Seam 2 pseudofunctor reindex unresolved |
| `base_change_mate_gstar_transpose` | 1293 | `:= sorry` — Seam 3 g^*-transpose unresolved |
| `affineBaseChange_pushforward_iso` | 1466 | `:= sorry` — affine reduction restriction step unresolved |
| `flatBaseChange_pushforward_isIso` | 1488 | `:= sorry` — flat case not started |

All four are acknowledged in the blueprint at the statement level (`\leanok` = at-least-sorry-present). No proof block has a false `\leanok`.

**Transitive sorry chain**: `base_change_mate_gstar_transpose` → `base_change_mate_section_identity` → `base_change_mate_generator_trace` → `pushforward_base_change_mate_cancelBaseChange` — all transitively sorry despite their proof skeletons being correct.

### Excuse-comments
None. The REMAINING/PARTIAL comments accurately describe engineering status and don't claim correctness where sorry is present.

### Axioms / Classical.choice
None detected. `pullbackPushforward_unit_comp` and all upstream lemmas use only Mathlib-legitimate reasoning.

---

## Unreferenced declarations (informational)

### `AlgebraicGeometry.pullbackPushforward_unit_comp` (line 1140)

**Status**: NO `\lean{...}` pin anywhere in the blueprint chapter.

**What it states**: For composable scheme morphisms `a : X₁ ⟶ X₂`, `b : X₂ ⟶ X₃` and a module `N` on `X₃`, the unit of the `(pullback (a ≫ b) ⊣ pushforward (a ≫ b))`-adjunction factors through the units of `a` and `b` together with `pushforwardComp`/`pullbackComp` coherences:
```
unit_b.app N ≫ (pushforward b).map (unit_a.app ((pullback b).obj N)) ≫ (pushforwardComp a b).hom.app _
  = unit_{a≫b}.app N ≫ (pushforward (a≫b)).map ((pullbackComp a b).inv.app N)
```

**Role**: This is the **Seam-2 leg-reindex engine** — it is the concrete Lean formulation of the abstract mate identity ("pseudofunctoriality of the pullback–pushforward unit") that Step 2 of the `lem:base_change_mate_fstar_reindex` recipe requires. The prover (iter-016) extracted it as a standalone lemma from `CategoryTheory.unit_conjugateEquiv` + `Scheme.Modules.conjugateEquiv_pullbackComp_inv`.

**Proof status**: **Fully proved, no sorry** (lines 1150–1157, uses only Mathlib lemmas).

**Where it should be pinned**: A new `\begin{lemma}` block should be added to the blueprint chapter in the "Section-level mate computation, decomposed" subsection, **immediately before** `lem:base_change_mate_fstar_reindex`. Suggested placement and content:
- Label: `lem:pullbackPushforward_unit_comp`
- `\lean{AlgebraicGeometry.pullbackPushforward_unit_comp}`
- Prose: "Pseudofunctoriality of the pullback–pushforward unit: for composable morphisms `a : X₁ → X₂`, `b : X₂ → X₃` and a module `N` on `X₃`, the unit of the `(a ≫ b)`-adjunction factors, via the pushforward-composition coherences, through the `b`-unit followed by the `b`-pushforward of the `a`-unit."
- `\uses{}` : the `Adjunction.comp_unit_app` and `conjugateEquiv_pullbackComp_inv` Mathlib lemmas (as `\mathlibok` anchors if not already pinned), plus `lem:base_change_mate_fstar_reindex` should gain `\uses{lem:pullbackPushforward_unit_comp}`.

The blueprint's Lean signature pinned in the `% LEAN SIGNATURE` comment for `lem:base_change_mate_fstar_reindex` should also be updated to include `pullbackPushforward_unit_comp` in the recipe.

---

## Blueprint adequacy for this file

### Coverage
30/31 project-local Lean declarations have a corresponding `\lean{...}` block in the chapter. One substantive declaration is unreferenced:
- `pullbackPushforward_unit_comp` (line 1140) — a proved, axiom-clean helper that is the Seam-2 engine.

### Proof-sketch depth
**Under-specified** for Seam 2 and Seam 3.

**Seam 2 (`lem:base_change_mate_fstar_reindex`)**: The blueprint provides a four-step `% RECIPE` comment and a prose proof sketch. Both are at the conceptual level:
1. Step 2 ("unit transport via conjugate calculus") names `conjugateEquiv_pullbackComp_inv` and `unit_conjugateEquiv` but does NOT name `pullbackPushforward_unit_comp` as the concrete lemma implementing this step.
2. The `% DEAD END` comment warns against naive `rw [hfst]`/`rw [hsnd]` but provides NO concrete alternative route: the blueprint says "Closing Seam 2 therefore needs an abstract restatement of `codomain_read` / the whole chain with the two legs as *variables*…" but this restructuring (making legs substitutable by abstracting them out of dependent types) is not described. A prover reading the chapter would not know how to proceed past the `DEAD END`.
3. Consequence: **the sorry at line 1248 persists even with `pullbackPushforward_unit_comp` in hand**, proving that the blueprint's recipe is incomplete for the actual Lean proof.

**Seam 3 (`lem:base_change_mate_gstar_transpose`)**: The blueprint proof says "Conjugation by the section dictionaries. The domain identification already incorporates the pullback dictionary … which reads g^* = (Spec ψ)^* of a tilde as extension of scalars along ψ; the residual content is the counit-triangle identity together with the naturality of the dictionaries." This is too abstract. The concrete Lean challenge is: `pullback_spec_tilde_iso ψ` is built via `conjugateIsoEquiv` (not as a direct computation), so its interaction with the adjunction counit is not a bare `simp` / `rfl` and requires abstract conjugate-adjunction coherence that the blueprint does not identify. The sorry at line 1293 confirms the blueprint's description is insufficient.

### Hint precision
**Loose** for Seam 2 and Seam 3. The `\lean{...}` pins for `base_change_mate_fstar_reindex` and `base_change_mate_gstar_transpose` correctly name the Lean declarations, but the proof body descriptions do not give enough detail for the Lean-level engineering (dependent-type wall in Seam 2, counit-naturality coherence in Seam 3).

### Generality
Matches need — no generality gap detected.

### Recommended chapter-side actions

**Must-fix (required to unblock these sorries):**

1. **Pin `pullbackPushforward_unit_comp`**: Add a `\begin{lemma}` block with `\lean{AlgebraicGeometry.pullbackPushforward_unit_comp}` before `lem:base_change_mate_fstar_reindex`. The lemma is fully proved and is the concrete Lean form of Step 2 of the Seam-2 recipe.

2. **Expand `lem:base_change_mate_fstar_reindex` proof sketch for the dependent-type wall**: The `% DEAD END` / `% RECIPE` comment correctly identifies the problem. The blueprint proof prose should explicitly describe the restructuring solution: `base_change_mate_codomain_read` (or the whole Seam-2 goal) needs to be restated with the two legs `g'`/`f'` as abstracted variables (equal to `e.hom ≫ Spec ι_A` / `e.hom ≫ Spec ι_{R'}` by `subst` or `conv`) so that `pullbackPushforward_unit_comp` can be applied without triggering the "motive is not type correct" wall from dependent `IsPullback.of_hasPullback` terms.

3. **Expand `lem:base_change_mate_gstar_transpose` proof sketch for Seam 3**: The blueprint should name the concrete Mathlib coherence that identifies the `pullback_spec_tilde_iso ψ`-conjugated transpose with `extendScalars ψ ∘ ρ`. Specifically: since `pullback_spec_tilde_iso` is built as `((conjugateIsoEquiv adjL adjR).symm (gammaPushforwardNatIso ψ)).symm.app`, the correct Lean route uses `Adjunction.homEquiv_counit` (factoring the base-change map as `g^*(inner) ≫ counit`) followed by the abstract `unit_conjugateEquiv` identity to replace `g^*(inner)` by `extendScalars ψ ∘ ρ`. The blueprint should state this step as: "the counit-triangle identity for the composed adjunction `(tilde ⊣ Γ) ∘ (pullback ψ ⊣ pushforward ψ)` reads `pullback_spec_tilde_iso ψ` composed with the counit of `extendRestrictScalarsAdj ψ.hom` as the identity, which identifies `Γ(ε_g)` with the counit of the module-level adjunction."

---

## Severity summary

| Finding | Severity |
|---|---|
| `pullbackPushforward_unit_comp` (line 1140) has no `\lean{...}` blueprint pin; it is a proved, axiom-clean, substantive helper feeding Seam 2 | **major** |
| Blueprint proof sketch for Seam 2 (`lem:base_change_mate_fstar_reindex`) is under-specified: missing the dependent-type wall restructuring that the sorry at line 1248 exposes | **must-fix-this-iter** |
| Blueprint proof sketch for Seam 3 (`lem:base_change_mate_gstar_transpose`) is under-specified: the concrete counit-naturality coherence for `pullback_spec_tilde_iso ψ` (built via `conjugateIsoEquiv`) is not described, leaving the sorry at line 1293 unguided | **must-fix-this-iter** |
| `affineBaseChange_pushforward_iso` sorry (line 1466) — the restriction-compatibility of `pushforwardBaseChangeMap` across affine opens is Mathlib-absent and not yet blueprinted as a named lemma | **major** |
| `flatBaseChange_pushforward_isIso` sorry (line 1488) — proof not started; blueprint proof is conceptually adequate (Mayer–Vietoris + flat equalizer) but requires Čech/sheaf-condition infrastructure | **major** (expected open obligation) |
| `pullback_isEquivalence_of_iso` is an `instance` in Lean but a "lemma" in the blueprint | **minor** |

**Overall verdict**: The Lean file faithfully follows the blueprint's conceptual architecture, and all signatures match. The two Seam-2 and Seam-3 sorries have root-cause in genuine blueprint under-specification: the chapter correctly identifies the four-step recipe and flags the dead end, but fails to provide the Lean-level restructuring (Seam 2: make legs substitutable to avoid dependent-type motive errors) and the abstract coherence identification (Seam 3: how `pullback_spec_tilde_iso ψ`'s `conjugateIsoEquiv` construction interacts with the adjunction counit). A blueprint-writing pass pinning `pullbackPushforward_unit_comp` and expanding the Seam-2 and Seam-3 proof sketches is a must-fix blocker for iter-017. — 31 declarations checked, 4 sorries (2 direct, 2 in transitive chain from Seam 3), 2 must-fix blueprint gaps.
