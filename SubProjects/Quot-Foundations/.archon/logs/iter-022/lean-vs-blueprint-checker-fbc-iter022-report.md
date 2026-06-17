# Lean ↔ Blueprint Check Report

## Slug
fbc-iter022

## Iteration
022

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (1811 lines)
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (2754 lines)

---

## Directive focus

`base_change_mate_gstar_transpose` / `lem:base_change_mate_gstar_transpose`:
- (a) Statement match with blueprint
- (b) Blueprint proof sketch adequacy for remaining ~150-LOC telescoping (steps 2–3)
- (c) No fake/placeholder statements

---

## Per-declaration (focus lemma)

### `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}` (blueprint: `lem:base_change_mate_gstar_transpose`)

- **Lean target exists**: yes — `theorem base_change_mate_gstar_transpose` at FlatBaseChange.lean:1490
- **Signature matches**: yes — the Lean signature matches the blueprint's `% LEAN SIGNATURE` comment (blueprint lines 2006–2015) exactly:
  ```
  {R R' A : CommRingCat.{u}} (ψ : R ⟶ R') (φ : R ⟶ A) (M : ModuleCat.{u} A) :
    (base_change_mate_domain_read ψ φ M).inv ≫
      (moduleSpecΓFunctor (R := R')).map (... pullback(Spec ψ)*(θ_in) ≫ counit_g ...) ≫
      (base_change_mate_codomain_read ψ φ M).hom
      = (base_change_mate_regroupEquiv ψ φ M).inv
  ```
- **Proof follows blueprint sketch**: partial — the prover executed step 1 (counit split: `rw [Functor.map_comp]` + `rw [Iso.inv_comp_eq, ← Iso.eq_comp_inv]`, FlatBaseChange.lean:1513–1520) and the beginning of step 2 (conjugate-counit scaffold: `adjL`, `adjR`, `β`, `hpullinv`, `W`, `huce`, `hcounitL`, `hcounitR` established, FlatBaseChange.lean:1552–1589). The proof ends in `sorry` at line 1613.
- **Notes**:
  - Steps 2b (inline derivation of `Γ_R(θ_in) = ρ`) and 3 (generator close `extendScalars ψ(ρ) ≫ ε^alg = regroupEquiv.inv`) are not yet executed.
  - The Lean comment at lines 1600–1612 explicitly names the two remaining sub-tasks: (a) the inner reindex `Γ_R(θ_in) = ρ` must be reproven **inline** (not via the sorry-backed `base_change_mate_fstar_reindex`); (b) the generator close `extendScalars ψ(ρ) ≫ ε^alg = regroupEquiv.inv` via one-generator `ext`.

---

## Per-declaration (surrounding context — all `\lean{...}` blocks checked)

| Blueprint label | Lean declaration | Exists? | Signature OK? | Proof complete? |
|---|---|---|---|---|
| `def:pushforward_base_change_map` | `pushforwardBaseChangeMap` (L79) | yes | yes | yes |
| `lem:modules_isIso_iff_stalk` | `Modules.isIso_iff_isIso_stalkFunctor_map` (L102) | yes | yes | yes |
| `lem:modules_isIso_of_isBasis` | `Modules.isIso_of_isIso_app_of_isBasis` (L128) | yes | yes | yes |
| `lem:modules_isIso_iff_affineOpens` | `Modules.isIso_iff_isIso_app_affineOpens` (L164) | yes | yes | yes |
| `lem:globalSectionsIso_hom_comp_specMap_appTop` | `globalSectionsIso_hom_comp_specMap_appTop` (L268) | yes | yes | yes |
| `lem:gammaPushforwardIso` | `gammaPushforwardIso` (L288) | yes | yes | yes |
| `lem:gammaPushforwardTildeIso` | `gammaPushforwardTildeIso` (L313) | yes | yes | yes |
| `lem:gammaPushforwardIsoAt` | `gammaPushforwardIsoAt` (L331) | yes | yes | yes |
| `lem:tildeRestriction_isLocalizedModule` | `tildeRestriction_isLocalizedModule` (L483) | yes | yes | yes |
| `lem:powers_restrictScalars` | `IsLocalizedModule.powers_restrictScalars` (L455) | yes | yes | yes |
| `lem:fromTildeGamma_app_isIso_of_localized` | `fromTildeΓ_app_isIso_of_isLocalizedModule` (L367) | yes | yes | yes |
| `lem:pushforward_spec_tilde_iso_conditional` | `pushforward_spec_tilde_iso_of_isLocalizedModule` (L431) | yes | yes | yes |
| `lem:pushforward_spec_tilde_iso` | `pushforward_spec_tilde_iso` (L538) | yes | yes | yes |
| `lem:gammaPushforwardNatIso` | `gammaPushforwardNatIso` (L667) | yes | yes | yes |
| `lem:pullback_spec_tilde_iso` | `pullback_spec_tilde_iso` (L689) | yes | yes | yes |
| `lem:pullbackSpecIso_mathlib` | `pullbackSpecIso` | yes (Mathlib) | N/A | N/A |
| `lem:cancelBaseChange_mathlib` | `TensorProduct.AlgebraTensorModule.cancelBaseChange` | yes (Mathlib) | N/A | N/A |
| `lem:isPushout_cancelBaseChange_mathlib` | `Algebra.IsPushout.cancelBaseChange` | yes (Mathlib) | N/A | N/A |
| `lem:pullback_fst_snd_specMap_tensor` | `pullback_fst_snd_specMap_tensor` (L709) | yes | yes | yes |
| `lem:base_change_mate_domain_read` | `base_change_mate_domain_read` (L737) | yes | yes | yes |
| `lem:pullbackIsoEquivalenceOfIso` | `pullbackIsoEquivalenceOfIso` (L753) | yes | yes | yes |
| `lem:pullback_isEquivalence_of_iso` | `pullback_isEquivalence_of_iso` (L762) | yes | yes | yes |
| `lem:base_change_mate_codomain_read` | `base_change_mate_codomain_read` (L773) | yes | yes | yes |
| `lem:base_change_mate_codomain_read_legs` | `base_change_mate_codomain_read_legs` (L1210) | yes | yes | yes (superseded) |
| `lem:base_change_mate_regroupEquiv` | `base_change_mate_regroupEquiv` (L856) | yes | yes | yes |
| Mathlib anchors (3 lemmas) | `unit_conjugateEquiv`, `comp_unit_app`, `conjugateEquiv_pullbackComp_inv` | yes (Mathlib) | N/A | N/A |
| `lem:pullbackPushforward_unit_comp` | `pullbackPushforward_unit_comp` (L1144) | yes | yes | yes |
| `lem:gammaMap_pushforwardComp_hom_eq_id` | `gammaMap_pushforwardComp_hom_eq_id` (L1174, private) | yes | yes | yes |
| `lem:gammaMap_pushforwardComp_inv_eq_id` | `gammaMap_pushforwardComp_inv_eq_id` (L1182, private) | yes | yes | yes |
| `lem:gammaMap_pushforwardCongr_hom` | `gammaMap_pushforwardCongr_hom` (L1193, private) | yes | yes | yes |
| `lem:base_change_mate_fstar_reindex_legs_unitExpand` | `base_change_mate_fstar_reindex_legs_unitExpand` (L1273) | yes | yes | yes |
| `lem:base_change_mate_fstar_reindex_legs_gammaDistribute` | `base_change_mate_fstar_reindex_legs_gammaDistribute` (L1304) | yes | yes | yes |
| `lem:base_change_mate_fstar_reindex_legs` | `base_change_mate_fstar_reindex_legs` (L1333) | yes | yes | **NO** (sorry L1421) |
| `lem:base_change_mate_fstar_reindex` | `base_change_mate_fstar_reindex` (L1435) | yes | yes | **NO** (sorry via `_legs`) |
| `lem:base_change_mate_unit_value` | `base_change_mate_unit_value` (L987) | yes | yes | yes |
| `def:base_change_mate_inner_value` | `base_change_mate_inner_value` (L1102) | yes | yes | yes |
| **`lem:base_change_mate_gstar_transpose`** | **`base_change_mate_gstar_transpose` (L1490)** | **yes** | **yes** | **NO (sorry L1613)** |
| `lem:base_change_mate_section_identity` | `base_change_mate_section_identity` (L1638) | yes | yes | effectively NO (delegates to gstar_transpose) |
| `lem:base_change_mate_generator_trace` | `base_change_mate_generator_trace` (L1667) | yes | yes | effectively NO |
| `lem:pushforward_base_change_mate_cancelBaseChange` | `pushforward_base_change_mate_cancelBaseChange` (L1704) | yes | yes | effectively NO |
| `lem:base_change_map_affine_local` | `base_change_map_affine_local` (L1743) | yes | yes | yes |
| `lem:affine_base_change_pushforward` | `affineBaseChange_pushforward_iso` (L1755) | yes | yes | **NO (sorry L1786)** |
| `lem:flat_preserves_equalizer_mathlib` | `LinearMap.tensorEqLocusEquiv` | yes (Mathlib) | N/A | N/A |
| `thm:flat_base_change_pushforward` | `flatBaseChange_pushforward_isIso` (L1795) | yes | yes | **NO (sorry L1808)** |

---

## Red flags

### Placeholder / suspect bodies

1. **`base_change_mate_gstar_transpose`** at FlatBaseChange.lean:1613: body ends `:= sorry`. Blueprint (`lem:base_change_mate_gstar_transpose`) claims this as "the live remaining crux of the affine section-level computation" with a substantive 3-step proof (counit split, conjugate-counit coherence, generator close). **This iter's prover work landed step 1 and the scaffold for step 2; steps 2b and 3 remain.**

2. **`base_change_mate_fstar_reindex_legs`** at FlatBaseChange.lean:1421: body ends `:= sorry`. Blueprint labels this lemma "Superseded" (it is a dead-code link of an abandoned route), so it is not on the live proof path. The sorry is expected here but should be removed when dead code is pruned.

3. **`affineBaseChange_pushforward_iso`** at FlatBaseChange.lean:1786: body ends `:= sorry`. Blueprint's `lem:affine_base_change_pushforward` has a substantive proof sketch; the proof block lacks `\leanok` in the blueprint, correctly marking it as outstanding. The Lean docstring also explicitly flags this as "remaining multi-hundred-LOC build" for the affine reduction (restriction-compatibility of `pushforwardBaseChangeMap`).

4. **`flatBaseChange_pushforward_isIso`** at FlatBaseChange.lean:1808: body ends `:= sorry`. Blueprint's `thm:flat_base_change_pushforward` has a substantive proof sketch (Čech-free Mayer–Vietoris induction); proof block lacks `\leanok`.

### Excuse-comments
- FlatBaseChange.lean:1382–1421: long comment block explaining why the step-(iii) mate-unwinding crux in `base_change_mate_fstar_reindex_legs` is sorry'd, naming the "BLOCKER" and explaining the blocking wall. This is consistent with the blueprint's "Superseded" label — not alarming, but confirms a known debt.
- FlatBaseChange.lean:1537–1549: extended comment in `base_change_mate_gstar_transpose` explains that `base_change_mate_fstar_reindex` is sorry-backed and therefore cannot be cited; the content must be reproven inline. This is an honest accounting of what remains.
- FlatBaseChange.lean:1774–1785: comment in `affineBaseChange_pushforward_iso` explains the remaining "AFFINE REDUCTION" obligation and its Mathlib-absent inputs. Matches blueprint.

### Private vs. blueprint-referenced declarations (minor)
- `gammaMap_pushforwardComp_hom_eq_id`, `gammaMap_pushforwardComp_inv_eq_id`, `gammaMap_pushforwardCongr_hom` are declared `private` in Lean (lines 1174, 1182, 1193) but the blueprint uses their fully-qualified names in `\lean{...}` tags. Private declarations are not externally accessible. **Minor** — these are internal helpers used only within this file, so the blueprint's `\lean{...}` tag is technically incorrect (private names cannot be resolved by external tools), but the formalization is functionally sound.

---

## Unreferenced declarations (informational)

- `base_change_mate_inner_value` is in the blueprint as `def:base_change_mate_inner_value` ✓
- `pullbackIsoEquivalenceOfIso` and `pullback_isEquivalence_of_iso` are both in the blueprint ✓
- `base_change_mate_codomain_read_legs` is in the blueprint (labeled "Superseded") ✓
- Detailed iter-history comments embedded in the docstrings (STATUS iter-234, UPDATE iter-236, etc. at lines 183–248, and the `set_option maxHeartbeats` annotations) are project-workflow notes, not red flags.

No substantive declarations appear to be missing from the blueprint.

---

## Blueprint adequacy for this file

### Coverage
41/41 substantive Lean declarations have a corresponding `\lean{...}` block in the chapter (or are Mathlib-backed with `\mathlibok`). 0 unreferenced substantive declarations. Coverage: **full**.

### Proof-sketch depth: **under-specified** for `lem:base_change_mate_gstar_transpose`

This is the specific adequacy finding requested by the directive. Detailed assessment:

**Step 1 (counit split)**: The blueprint recipe says to use `Adjunction.homEquiv_counit`. Adequate — already executed by the prover. ✓

**Step 2 (conjugate-counit coherence)**: The blueprint recipe (blueprint `% RECIPE` comment, lines 2019–2031) says:
> "The residual is the counit-triangle identity / dictionary naturality, yielding `extendScalars ψ ∘ ρ` (ρ : m ↦ (1⊗1)⊗m, the affine unit value `base_change_mate_unit_value`)."

The scaffold established by the prover (iter-022) derives `huce` (the master counit-transport identity from `conjugateEquiv_counit_symm`) and splits `adjL.counit` and `adjR.counit`. What remains is to derive `Γ_R(θ_in) = ρ` **inline** (since `base_change_mate_fstar_reindex` is sorry-backed and therefore cannot be cited). This sub-derivation requires applying:
- `base_change_mate_fstar_reindex_legs_unitExpand` (expand the g'-unit)
- `base_change_mate_fstar_reindex_legs_gammaDistribute` (distribute through Γ)
- `gammaMap_pushforwardComp_{hom,inv}_eq_id` + `gammaMap_pushforwardCongr_hom` (Γ-collapse of transparent coherences)
- `pullbackPushforward_unit_comp` (leg-reindex engine)
- `base_change_mate_unit_value` (Seam 1 value of the affine unit)

None of this sub-derivation is sketched within the proof of `lem:base_change_mate_gstar_transpose` itself. The blueprint recipe says "yielding extendScalars ψ ∘ ρ" as if this follows directly from the counit-triangle identity, but the prover's Lean comment at lines 1537–1544 makes clear that `Γ_R(θ_in) = ρ` is itself a multi-step ~150-LOC argument that does not fall out automatically. The proof sketch is **too thin at step 2** for a prover to close the proof without knowing to reproduce the superseded seam-2 telescoping inline.

**Step 3 (generator close)**: Blueprint says: "On the generator r'⊗m the conjugated map returns (1⊗r')⊗m, which is precisely the inverse of the regrouping isomorphism; both maps are R'-linear and agree on generators, so they coincide." This is clear — the cited `base_change_mate_regroupEquiv` is fully proved. **Adequate** for step 3 assuming step 2 is complete. ✓

**Verdict on proof-sketch depth**: **under-specified** for step 2. The `lem:base_change_mate_gstar_transpose` proof sketch must be expanded to explicitly direct the prover to:
1. Reproduce the `Γ_R(θ_in) = ρ` sub-claim inline using the atomic lemmas `base_change_mate_fstar_reindex_legs_unitExpand`, `base_change_mate_fstar_reindex_legs_gammaDistribute`, the three Γ-collapse lemmas, `pullbackPushforward_unit_comp`, and `base_change_mate_unit_value`.
2. Describe how `huce` (already set up by the scaffold) is used to replace `Γ_R(ε_g)` with the algebraic counit, leaving `extendScalars ψ(ρ)` on the LHS.

### Hint precision: **precise**
All `\lean{...}` hints name the correct Lean declarations (modulo the private-vs-public minor issue for three helpers). No wrong Mathlib predicates.

### Generality: **matches need**
No parallel API introduced outside the blueprint's scope.

### Recommended chapter-side actions
1. **Expand `lem:base_change_mate_gstar_transpose` proof sketch** to explicitly describe the inline derivation of `Γ_R(θ_in) = ρ` as a sub-procedure: cite `base_change_mate_fstar_reindex_legs_unitExpand`, `base_change_mate_fstar_reindex_legs_gammaDistribute`, the Γ-collapse atoms, `pullbackPushforward_unit_comp`, and `base_change_mate_unit_value`. This closes the "too thin at step 2" gap without requiring the sorry-backed `base_change_mate_fstar_reindex` to be fixed first.
2. **Add `\uses` entries** to `lem:base_change_mate_gstar_transpose` for the atomic lemmas listed above (currently only `lem:base_change_mate_unit_value` is listed but the full seam-2 toolkit is needed).
3. **Optional**: Correct the `\lean{...}` tags for `gammaMap_pushforwardComp_hom_eq_id`, `gammaMap_pushforwardComp_inv_eq_id`, `gammaMap_pushforwardCongr_hom` to note they are `private` declarations (or promote them to non-private if external blueprint reference is intended).

---

## Severity summary

### must-fix-this-iter

1. **`base_change_mate_gstar_transpose` at FlatBaseChange.lean:1613**: `:= sorry` on the live-crux lemma that feeds `base_change_mate_section_identity` directly. The blueprint labels it "the live remaining crux of the affine section-level computation" with a substantive 3-step proof sketch; the Lean body is a partial scaffold ending in `sorry`. Proof-blocks of `base_change_mate_section_identity`, `base_change_mate_generator_trace`, and `pushforward_base_change_mate_cancelBaseChange` are all effectively sorry-backed through this one sorry.

2. **Blueprint adequacy failure**: The proof sketch of `lem:base_change_mate_gstar_transpose` is **under-specified** for step 2 — it does not describe how to derive `Γ_R(θ_in) = ρ` inline, which is the genuine ~150-LOC telescoping the prover needs. A blueprint-writing subagent should expand the proof sketch before the next prover iteration.

### major

3. **`affineBaseChange_pushforward_iso` at FlatBaseChange.lean:1786**: `:= sorry` on a major theorem. The restriction-compatibility of `pushforwardBaseChangeMap` (the "obligation 1" affine reduction) is Mathlib-absent and requires multi-hundred-LOC formalization. Blueprint has a proof sketch but no `\leanok` on the proof block — correctly marked as outstanding.

4. **`flatBaseChange_pushforward_isIso` at FlatBaseChange.lean:1808**: `:= sorry` on the main theorem. Blueprint has a proof sketch (Čech-free Mayer–Vietoris induction) but no `\leanok` on the proof block — correctly marked as outstanding. Depends on the affine lemma above.

5. **`base_change_mate_fstar_reindex_legs` at FlatBaseChange.lean:1421**: sorry on a superseded (dead-code) route. The blueprint labels it "Superseded" and it is not on the live proof path. The sorry is expected but should be cleaned up when dead code is pruned.

### minor

6. **Three private lemmas** (`gammaMap_pushforwardComp_hom_eq_id`, `gammaMap_pushforwardComp_inv_eq_id`, `gammaMap_pushforwardCongr_hom`) declared `private` in Lean but referenced by full name in `\lean{...}` blueprint tags. Functionally fine (all internal to this file) but blueprint hint is technically incorrect.

---

**Overall verdict**: One must-fix-this-iter sorry in `base_change_mate_gstar_transpose` (the live crux, prover landed step-1 scaffold only) plus a must-fix blueprint-adequacy gap in its proof sketch for step 2; two major downstream sorries (`affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`) correctly marked as outstanding in the blueprint; one minor hint-precision issue on private declarations. — 44 declarations checked, 5 red flags (2 must-fix, 2 major, 1 minor).
