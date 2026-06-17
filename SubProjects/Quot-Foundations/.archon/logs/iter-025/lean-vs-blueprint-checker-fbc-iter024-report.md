# Lean ↔ Blueprint Check Report

## Slug
fbc-iter024

## Iteration
025

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration (focus blocks per directive)

### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_eUnit}` (chapter: `lem:base_change_mate_inner_eCancel_eUnit`)
- **Lean target exists**: yes — line 1498
- **Signature matches**: yes
  - Lean: `{X Y : Scheme.{u}} (e : X ⟶ Y) [IsIso e] (N : Y.Modules) : IsIso ((Scheme.Modules.pullbackPushforwardAdjunction e).unit.app N)`
  - Blueprint `% LEAN SIGNATURE` comment reproduces this verbatim. ✓
- **Proof follows sketch**: yes — `haveI := pullback_isEquivalence_of_iso e; infer_instance`. Blueprint says "Since `e` is an isomorphism its pullback functor is an equivalence; the unit of an adjunction whose left adjoint is an equivalence is an isomorphism — a single instance-resolution step." Exact match.
- **Axiom-clean**: yes (no sorry, no axiom introduction)
- **notes**: Declared as `theorem` (not `private`/`lemma`), consistent with the blueprint's role description as a standalone cancellation input. The `[IsIso e]` typeclass hypothesis matches the `e : X ⟶ Y` + `IsIso` packaging the blueprint prescribes.

---

### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_pushforwardComp}` (chapter: `lem:base_change_mate_inner_eCancel_pushforwardComp`)
- **Lean target exists**: yes — line 1510
- **Signature matches**: yes
  - Lean: `{X₁ X₂ : Scheme.{u}} {R A : CommRingCat.{u}} (a : X₁ ⟶ X₂) (b : X₂ ⟶ Spec A) (φ : R ⟶ A) (M : X₁.Modules) : (moduleSpecΓFunctor (R := R)).map ((Scheme.Modules.pushforward (Spec.map φ)).map ((Scheme.Modules.pushforwardComp a b).hom.app M)) = 𝟙 _`
  - Blueprint `% LEAN SIGNATURE` comment reproduces this verbatim. ✓
- **Proof follows sketch**: yes — `have h : (Scheme.Modules.pushforwardComp a b).hom.app M = 𝟙 _ := rfl; rw [h]; exact ...map_id...map_id`. Blueprint: "The section value of pushforwardComp is the identity at every open, so its (Spec φ)_*-image is identity by functoriality, and its Γ-image is identity by functoriality again — two applications of the functorial identity law." Exact match.
- **Axiom-clean**: yes
- **notes**: The `private` modifier is missing in the blueprint's role description (the blueprint describes it as a public theorem), but this is a minor naming-mode inconsistency with no mathematical content.

---

### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_pullbackComp}` (chapter: `lem:base_change_mate_inner_eCancel_pullbackComp`)
- **Lean target exists**: yes — line 1527
- **Signature matches**: yes
  - Lean: `{R R' A : CommRingCat.{u}} (ψ : R ⟶ R') (φ : R ⟶ A) (M : ModuleCat.{u} A) : letI ... (Scheme.Modules.pullbackComp e.hom (Spec.map inclA)).hom.app (tilde M) ≫ (Scheme.Modules.pullbackComp e.hom (Spec.map inclA)).inv.app (tilde M) = 𝟙 _`
  - Blueprint `% LEAN SIGNATURE` comment reproduces this verbatim including the `letI` scaffolding. ✓
- **Proof follows sketch**: yes — `exact (Scheme.Modules.pullbackComp _ _).hom_inv_id_app (tilde M)`. Blueprint: "Both factors are the hom and inverse of one and the same isomorphism; their composite is the identity by the hom–inverse law — a single application of the hom–inverse identity." Exact match.
- **Axiom-clean**: yes
- **notes**: The `letI` wrapping of `Algebra` instances in the statement follows the project's standard pattern for avoiding typeclass conflicts; the blueprint's comment documents this. Clean.

---

### `\lean{AlgebraicGeometry.base_change_mate_gstar_generator_close}` (chapter: `lem:base_change_mate_gstar_generator_close`)
- **Lean target exists**: yes — line 1545
- **Signature matches**: yes — the Lean statement matches the blueprint's informal description (extension of scalars along ψ of the inner value ρ, post-composed with the algebraic counit ε^alg, equals the inverse regrouping isomorphism `base_change_mate_regroupEquiv.inv`). ✓
- **Proof follows sketch**: **partial** — the blueprint describes an `ext`-check "on the generators `r' ⊗ m`", asserting both sides send `r' ⊗ m ↦ (1 ⊗ r') ⊗ m`. The Lean proof uses `ext x`, then `erw [ModuleCat.ExtendRestrictScalarsAdj.Counit.map_apply_one_tmul]` to immediately reduce to the `1 ⊗ₜ x` generator (the counit evaluator handles the leading `r'`), then `change` + `rfl`. The mathematical content is the same — both sides agree on module generators — but the Lean uses a more efficient route through the `one_tmul` evaluator rather than checking general `r' ⊗ m` by `smul`-algebra. The `rfl` close confirms the carrier-level identity.
- **Axiom-clean**: yes — closed by `rfl` after the `ext`/`erw`/`change` scaffold, exactly as the directive says
- **notes**: The blueprint description of the proof ("check on generators `r' ⊗ m`") is slightly looser than the Lean implementation ("check on `1 ⊗ₜ x` via counit evaluator"). Both are valid and the mathematical claim is faithfully described. No concern.

---

### `\lean{AlgebraicGeometry.base_change_mate_inner_value_eq}` (chapter: `lem:base_change_mate_inner_value_eq`, and the narrative nodes `lem:base_change_mate_inner_unitReduce` / `lem:base_change_mate_inner_eCancel`)
- **Lean target exists**: yes — line 1583
- **Signature matches**: yes — the Lean statement (inner composite θ_in, read on Spec R sections through Γ-pushforward dictionaries with codomain pinned by `base_change_mate_codomain_read`, equals `base_change_mate_inner_value` = ρ) matches the blueprint's `lem:base_change_mate_inner_value_eq` statement. ✓
- **Proof follows sketch**: **partial (sorry at line 1627)** — step (ii) Γ-collapse is done (using `gammaMap_pushforwardComp_inv_eq_id` and `gammaMap_pushforwardCongr_hom`), consistent with the blueprint. The remaining telescoping carries `sorry`. See Blueprint adequacy section for analysis of what is and isn't described.
- **Axiom-clean**: no — `sorry` at line 1627 (known PARTIAL per directive)
- **notes**: The `\lean{}` pin is shared across three blueprint nodes (`lem:base_change_mate_inner_unitReduce`, `lem:base_change_mate_inner_eCancel`, `lem:base_change_mate_inner_value_eq`), all deliberately pinned to the same Lean declaration. This is a documented design decision (assembly-narrative nodes with no dedicated Lean decls). No issue.

---

## Red flags

### Placeholder / suspect bodies
- `base_change_mate_inner_value_eq` at line 1627: `sorry` — the blueprint claims a substantive proof (the eCancel telescoping). This is a **known PARTIAL** per the directive; re-reported here for completeness but NOT as a new finding. The sorry corresponds exactly to the literal-form lock blocker described in the directive.
- `base_change_mate_gstar_transpose` at line 1810: `sorry` — known, gated on `inner_value_eq`. Not re-reported per directive.
- `base_change_mate_fstar_reindex_legs` at line 1421: `sorry` — known dead code. Not re-reported per directive.

### Excuse-comments
None beyond the documented sorry explanations, which are accurate engineering notes rather than "wrong but works for now" comments.

### Axioms / Classical.choice on non-trivial claims
None introduced this iteration. The three eCancel atoms are all `theorem` declarations closed without axioms.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file are not directly `\lean{...}`-referenced in the blueprint but are internal helpers:

- `gammaMap_pushforwardComp_hom_eq_id` (line 1174, `private`) — referenced indirectly through `lem:gammaMap_pushforwardComp_hom_eq_id` which does have a `\lean{}` pin. No gap.
- `gammaMap_pushforwardComp_inv_eq_id` (line 1182, `private`) — same, `lem:gammaMap_pushforwardComp_inv_eq_id` is pinned.
- `gammaMap_pushforwardCongr_hom` (line 1193, `private`) — same, `lem:gammaMap_pushforwardCongr_hom` is pinned.
- `base_change_mate_codomain_read_legs`, `base_change_mate_fstar_reindex_legs_unitExpand`, `base_change_mate_fstar_reindex_legs_gammaDistribute`, `base_change_mate_fstar_reindex_legs`, `base_change_mate_fstar_reindex` — all pinned in the blueprint as "Superseded" nodes retained pending dead-code removal.
- `pullbackIsoEquivalenceOfIso`, `pullback_isEquivalence_of_iso` — both pinned in the blueprint.
- `base_change_mate_gstar_counit_transport` — pinned as `lem:base_change_mate_gstar_counit_transport`. ✓

No substantive unreferenced declarations found.

---

## Blueprint adequacy for this file

### Coverage
All substantive Lean declarations have a corresponding `\lean{...}` block in the chapter. Coverage: approximately 30/30 declarations covered (helpers via private lemmas, public theorems via named blocks). ✓

### Proof-sketch depth: **adequate for formalized content; under-specified for the remaining sorry in `inner_value_eq`**

**What is adequately described:**
- The three eCancel atoms have exact LEAN SIGNATURE comments and precise proof sketches — these were clearly written against live Lean goal states. A prover can formalize them directly.
- `gstar_generator_close`: the `ext`-on-generators description accurately conveys the mathematical content; the `rfl`-by-carrier-identity close is implicit but follows naturally.
- The step-(ii) Γ-collapse in `inner_value_eq` (using `gammaMap_pushforwardComp_inv_eq_id` and `gammaMap_pushforwardCongr_hom`) is correctly prescribed.
- The Seam 1 application (`base_change_mate_unit_value`) and ring-equation transport landing on ρ are correctly described.

**What is under-specified (critical for the remaining sorry):**

The blueprint's `lem:base_change_mate_inner_value_eq` proof sketch prescribes, after the step-(ii) Γ-collapse:
1. Apply `lem:pullbackPushforward_unit_comp` (= `unitExpand`) to distribute the bare g'-unit.
2. Apply the three eCancel atoms to cancel three of the four factors.
3. Evaluate the surviving (Spec ιA)-unit via Seam 1.

**The blueprint does not address the literal-form lock blocker:**

After the step-(ii) `simp only [gammaMap_pushforwardComp_inv_eq_id, gammaMap_pushforwardCongr_hom, Category.assoc]`, the surviving goal carries the `(g')`-unit with `g'` locked as the literal `(pullbackSpecIso ↑R ↑A ↑R').hom ≫ Spec.map (CommRingCat.ofHom Algebra.TensorProduct.includeLeftRingHom)`. The pattern `(pullbackPushforwardAdjunction (?a ≫ ?b)).unit.app ?N` in `unitExpand` cannot match this locked composite — `rw`/`simp only` with `unitExpand` or `gammaDistribute` fails with "did not find pattern" (documented in project memory `fbc-subst-legs-literal-form-lock`; confirmed in the Lean comment at line 1412–1420).

Two known-viable routes are NOT prescribed in the blueprint:
1. **Pre-subst route:** Invoke `pullbackPushforward_unit_comp e.hom (Spec.map inclA)` and distribute through `(Spec φ)_* ⋙ Γ` BEFORE the legs lock to `pullback.fst`/`pullback.snd` (i.e., before the step-(ii) Γ-collapse in the current form). This keeps the unit in composite form when the distribution lemmas are applied.
2. **Conv/position route:** Use `conv`/`Eq.mpr`-based congruence to target the locked factor by position rather than by pattern, then apply the eCancel atoms directly.

Without one of these prescriptions, a prover following the blueprint as written will implement step-(ii) first, hit the exact same wall as the current Lean code, and find the eCancel atoms inapplicable.

**Secondary imprecision (minor):** The blueprint states `lem:gammaMap_pushforwardCongr_hom` "yields the identity morphism", but the Lean declaration returns `eqToHom (by rw [hfg])`. In the application context (`simp only [gammaMap_pushforwardCongr_hom, ...]` in `inner_value_eq`), the `eqToHom` with a refl-able hypothesis absorbs correctly; the practical impact is zero. But the blueprint's "= id" language is imprecise — it should say "yields `eqToHom` of the object equality induced by `hfg`" to match the Lean signature exactly.

### Hint precision: **precise for the three eCancel atoms; imprecise for `gammaMap_pushforwardCongr_hom`**

The three eCancel atoms have exact LEAN SIGNATURE comments embedded in their blueprint blocks — the highest possible precision. `gstar_generator_close` has its Lean signature in the `\lean{}` tag (no explicit comment needed). `gammaMap_pushforwardCongr_hom` has `\lean{AlgebraicGeometry.gammaMap_pushforwardCongr_hom}` correctly, but the statement in the blueprint ("= id") does not match the Lean ("= eqToHom (by rw [hfg])") — minor.

### Generality: **matches need** — no parallel APIs introduced.

### Recommended chapter-side actions
A blueprint-writing subagent should add the following to the proof of `lem:base_change_mate_inner_value_eq`:

1. **Prescribe the pre-subst strategy:** Before or instead of the step-(ii) Γ-collapse, apply `pullbackPushforward_unit_comp e.hom (Spec.map inclA) (tilde M)` to the unit factor while `g'` is still a composite free variable, distribute through `(Spec.map φ)_*` and `Γ` by functoriality, and THEN apply the step-(ii) Γ-collapse — ensuring the unit distribution has already fired before the literal-form lock sets in. Alternatively, note that a `conv`/position-based rewrite targeting the unit factor by term position (not by syntactic pattern) avoids the lock.

2. **Update `lem:gammaMap_pushforwardCongr_hom`** to say "yields the canonical `eqToHom` of the object equality" rather than "yields the identity morphism" — to match the Lean statement and avoid confusion for a prover who checks the Lean signature against the prose.

---

## Severity summary

- **must-fix-this-iter**: None. The three eCancel atoms are axiom-clean with exact blueprint-matching signatures. `gstar_generator_close` is faithfully described and closed by `rfl`. The known sorries in `inner_value_eq` / `gstar_transpose` / dead-code `_fstar_reindex_legs` are pre-authorized known issues per the directive.
- **major**: Blueprint `lem:base_change_mate_inner_value_eq` is mathematically correct but **under-specified for the literal-form lock tactical detail** that is the actual blocker for the remaining sorry. A prover following the blueprint as written would implement step-(ii) first and then find the eCancel atoms cannot be applied to the locked-form goal. The chapter should prescribe either the pre-subst distribution order or the `conv`/position approach.
- **minor**: (1) `lem:gammaMap_pushforwardCongr_hom` blueprint says "yields the identity" but Lean gives `eqToHom`; effectively equivalent in context but imprecise. (2) `lem:base_change_mate_gstar_generator_close` proof sketch describes checking on general `r' ⊗ m` generators while Lean routes through `1 ⊗ₜ x` via the `one_tmul` counit evaluator — different but mathematically equivalent proof strategy.

**Overall verdict**: The three new `inner_eCancel` atoms are axiom-clean with signatures and proof sketches that exactly match their blueprint blocks; `gstar_generator_close` is faithfully described and confirmed closed by `rfl`; the blueprint for `inner_value_eq` correctly describes the mathematical telescoping route but is under-specified on the tactical detail of the literal-form lock, which is precisely what blocks the remaining sorry — a blueprint-writing pass should add the pre-subst or `conv`/position prescription.
