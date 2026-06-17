# Lean Audit Report

## Slug
iter202

## Iteration
202

## Scope
- files audited: 45 (all `.lean` files under `AlgebraicJacobian/` plus root `AlgebraicJacobian.lean`)
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `TensorObjSubstrate` is properly added at line 20, between `RelPicFunctor` and `FGAPicRepresentability`. Import order is consistent.

---

### AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
- **outdated comments**: 10+ flagged (see notes)
- **suspect definitions**: none
- **dead-end proofs**: none — all sorry references in comment blocks
- **bad practices**: none
- **excuse-comments**: none (despite language that resembles them, the code bodies are correct)
- **notes**:
  - **Key finding: file is sorry-free in proof bodies.** A grep for `^\s*sorry\b` and `:= sorry\b` and the broader `\bsorry\b` (excluding comment contexts) returns ZERO hits in actual Lean code. Every `sorry` occurrence in the file is inside a `-- ...`, `/-! ... -/`, or `/-- ... -/` comment block. This is confirmed by reading the proof bodies directly.
  - **L40–42 (major stale)**: Header comment says "remaining five typed `sorry` bodies (`depth`, `depth_eq_smallest_ext_index`, `depth_of_short_exact`, `auslander_buchsbaum_formula`, `CohenMacaulay.of_regular`) are substantive multi-iter content and stay gated on dedicated body lanes." All five now have genuine closed proof bodies. This header is severely outdated.
  - **L144 (major stale)**: Docstring for `depth` says "the body stays a typed `sorry` until an iter-180+ body lane fills the supremum-with-`IM=M` clause directly." The actual body at L148–152 is a proper `if … then … else sSup {…}` definition, not a sorry.
  - **L285 (major stale)**: "Residual `sorry`s (2 named inline branches):" inside the docstring of `depth_eq_smallest_ext_index`. The inline branches (forward direction L367–488, backward direction L489–619) are both completely filled in with substantive proof code — no sorry.
  - **L365 (major stale)**: `-- body remaining as \`sorry\`.` appears as a `--` comment inside the forward-direction branch of `depth_eq_smallest_ext_index`. The branch is fully closed. The comment is stale.
  - **L638 (major stale)**: "`ext_vanish_of_natCast_lt_depth` Body is kernel-clean modulo the typed sorry of `depth_eq_smallest_ext_index`." Since `depth_eq_smallest_ext_index` is now closed, this qualification is stale.
  - **L1706–1713 (major stale)**: The structural section header describes `auslander_buchsbaum_formula_succ_pd` as "a single named typed-`sorry` declaration with a precise iter-196+ re-engagement plan." The proof at L1815–2029 is fully closed (Nat induction on `k`, base case via matrix-collapse and LES, inductive step via syzygy descent).
  - **L2043–2048 (major stale)**: Main theorem comment says `auslander_buchsbaum_formula_succ_pd` "packages the entire substrate gap (4 named Mathlib-absent pieces) into a single typed `sorry`." It doesn't — the proof is closed.
  - **L2133 (major stale)**: "For the iter-175 file-skeleton the carrier definition is a typed `sorry` at the `Prop` level." `CohenMacaulay` is a `class` with a meaningful field `depth_eq_krullDim`, not a sorry.
  - **L2239 (major stale)**: `finrank_cotangentSpace_quot_span_singleton_succ` docstring says "assembled body left as a single named typed sorry." The proof body (L2276–2494) is long but closed.
  - **L2523 (major stale)**: "`exists_isSMulRegular_quotient_isRegularLocal_succ` (typed `sorry`, Stacks 00NQ + 00NU consolidated)." That declaration is now fully proved.
  - **L3387 (major stale)**: "`exists_isRegular_of_regularLocal` (the lower bound, typed `sorry` on the Mathlib gap `IsRegularLocalRing ⟹ IsDomain` + regular-quotient induction)." The grep confirms no sorry in the proof body.
  - **Closed-proof soundness**: `auslander_buchsbaum_formula_succ_pd` (L1801) uses `induction k generalizing M`. Base case (`k = 0`, `pd M = 1`): invokes `exists_minimalSurjection_finite_localRing`, `hasProjectiveDimensionLT_succ_of_projectiveDimension_eq`, `hasProjectiveDimensionLT_ker_of_surjection`, `Module.free_of_flat_of_isLocalRing`, `exists_ne_zero_ext_of_depth_eq`, and `ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator`. Inductive step (`k → succ k`): invokes `exists_minimalSurjection_finite_localRing`, `projectiveDimension_ker_eq_of_surjection`, `depth_ses_ineqs_of_surjection_finite_localRing`, and `enat_ab_inductive_combine`. No circular dependency: the proof calls only upstream helpers in the same file, none of which calls `auslander_buchsbaum_formula_succ_pd`.
  - **De-privatized declarations check**: The 3 declarations that had `private` removed are well-formed and in use:
    - `depth_eq_of_linearEquiv` (L814): used in the `n=0` base case of `auslander_buchsbaum_formula` at L2099.
    - `depth_pi_const_eq_depth_of_nonempty` (L988): used at L1393, L1428, L1895, L1898, L2106.
    - `auslander_buchsbaum_formula_succ_pd` (L1801): used at L2113 by `auslander_buchsbaum_formula`.
    - (`regularLocal_quotient_isRegularLocal_of_notMemSq` at L2626 may also have been de-privatized; it is used at L2813, L2902, L3011 — all legitimate.)
  - **4 new helper lemmas**: `depth_ses_ineqs_of_surjection_finite_localRing` (L1406), `exists_ne_zero_ext_of_depth_eq` (L1444), `ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator` (L1551, private), `enat_ab_inductive_combine` (L1620, private). All four are axiom-clean and each is used exactly in the new proof.
  - **L1844**: `congrArg Subtype.val (Subsingleton.elim (⟨x, hx⟩ : LinearMap.ker f) 0)` — syntactically valid use of `Subsingleton.elim`. The subterm `0 : LinearMap.ker f` is well-typed as the zero element of the submodule type.
  - The `notMem_minimalPrimes_of_regularLocal_succ` proof (L2793–2959) uses an intricate prime-avoidance argument. The overall structure is mathematically sound: prime avoidance → Nakayama → domain.
  - No `axiom`, `native_decide`, or `admit` tokens detected.

---

### AlgebraicJacobian/Albanese/CodimOneExtension.lean
- **outdated comments**: none in the §3.B section (new this iter)
- **suspect definitions**: none
- **dead-end proofs**: none in §3.B
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **§3.B (iter-202, 4 new axiom-clean declarations)**:
    - `exists_submersivePresentation_of_isStandardSmoothOfRelativeDimension` (L994, private): `h.out` — 1-line field extraction, axiom-clean. ✓
    - `isLocalization_atPrime_stalk_of_affineOpen` (L1008, public): `hV.isLocalization_stalk ⟨z, hzV⟩` — 1-line re-export, axiom-clean. ✓
    - `open_eq_top_of_subsingleton` (L1019, private): proof via `Subsingleton.elim`, axiom-clean. ✓
    - `gammaSpecField_ringEquiv` (L1035, public): proof via `open_eq_top_of_subsingleton` + `Scheme.ΓSpecIso`, axiom-clean. ✓
  - Pre-existing sorries: `isRegularLocalRing_stalk_of_smooth` (L1262, Stacks 00TT gap), `extend_of_codimOneFree_of_smooth` (L1459), `indeterminacy_pure_codim_one_into_grpScheme` (L1534). All are narrow typed sorry at designed residual sites; no change this iter.
  - Stage comment at L213–215 ("Stages 3-4 remain a single scoped `sorry` inside the main theorem") accurately describes the current state.
  - No `axiom`, `native_decide`, or `admit`.

---

### AlgebraicJacobian/RiemannRoch/WeilDivisor.lean
- **outdated comments**: none in the new declarations
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **`Scheme.PrimeDivisor.functionFieldIso_compat` (L572)**: New theorem (public). Proof uses `TopCat.Presheaf.stalk_hom_ext` + `simp` with Lean's `germ_stalkSpecializes_assoc` and `germ_stalkIso_hom_assoc`, then an equality of `germ_stalkSpecializes` compositions. The proof structure is a germ-universal chase — mathematically sound for the stated commutativity of the diagram. The `hcongr` auxiliary (L584–586) is a `rfl` definitional equality between `stalkCongr` and `stalkSpecializes`, which is plausible but not independently verified by this audit; if it fails, the `simp` calls would propagate the error.
  - **`Scheme.PrimeDivisor.order_eq_order_restrict` (L603)**: New theorem (public). Proof correctly unfolds `Scheme.RationalMap.order`, uses `functionFieldIso_compat` to discharge `h_compat`, and delegates to `ordFrac_stalkIso_naturality`. Logically sound.
  - Pre-existing sorry: `rationalMap_order_finite_support` (L831), the `f ≠ 0` branch. No change this iter.
  - No `axiom`, `native_decide`, or `admit`.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- **outdated comments**: none (new file, no stale history)
- **suspect definitions**: none (signatures are plausible stubs)
- **dead-end proofs**: none beyond designed stubs
- **bad practices**: 1 flagged (see notes)
- **excuse-comments**: none
- **notes**:
  - **New file, 6 typed-sorry stubs + 1 bodied helper**. The file is explicitly a scaffold with iter-203+ targets.
  - **Signature well-formedness**:
    - `tensorObj : {X : Scheme} → X.Modules → X.Modules → X.Modules` — correct type for a tensor product.
    - `tensorObj_functoriality : (M ⟶ M') → (N ⟶ N') → (tensorObj M N ⟶ tensorObj M' N')` — correct bifunctor morphism type.
    - `monoidalCategory : MonoidalCategory (X.Modules)` — reasonable typeclass instance.
    - `tensorObj_isLocallyTrivial : IsLocallyTrivial M → IsLocallyTrivial N → IsLocallyTrivial (tensorObj M N)` — correct predicate-preservation statement.
    - `exists_tensorObj_inverse : IsLocallyTrivial L → ∃ Linv, IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ 𝟙_ (X.Modules))` — the `𝟙_ (X.Modules)` requires `MonoidalCategory (X.Modules)`, which is provided by the `monoidalCategory` sorry-instance. The statement is well-typed under that assumption.
    - `tensorObjOnProduct` (L191–193): the only non-sorry body, using `tensorObj` and `tensorObj_isLocallyTrivial`. Correctly constructs a `LineBundle.OnProduct` from two sorry-valued terms. Transitively sorry but well-formed as a stub.
    - `addCommGroup_via_tensorObj : AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))` — deliberately a `noncomputable def` (not `instance`) to avoid a diamond with the pre-existing `PicSharp.addCommGroup` sorry-instance in `RelPicFunctor.lean`. This design choice is correct.
  - **`def` vs `instance` choices**: `tensorObj` and `tensorObj_functoriality` as `noncomputable def` is appropriate (constructions). `monoidalCategory` as `noncomputable instance` is appropriate for typeclass synthesis. `addCommGroup_via_tensorObj` as `def` (not `instance`) is the correct choice to avoid a diamond — explicitly noted in the docstring.
  - **Shadow/conflict check**: The file claims `MonoidalCategory (X.Modules)` is a gap in Mathlib at commit `b80f227`. The project's own analysis (supported by the description that only `PresheafOfModules.Monoidal.tensorObj` exists at the presheaf level) is that no conflicting Mathlib instance exists. Accepted.
  - **Bad practice (minor)**: `noncomputable instance monoidalCategory … := sorry` is a typeclass instance with a sorry body. In Lean 4, this means any typeclass search for `MonoidalCategory X.Modules` will silently succeed using this instance, regardless of correctness. For now, all downstream proofs that USE this instance are themselves `:= sorry`, so no false closed theorems result. However, if any future axiom-clean proof accidentally synthesizes `MonoidalCategory X.Modules` via this instance, it would silently incorporate a sorry. This is a structural risk.
  - No `axiom` or `native_decide`.

---

### AlgebraicJacobian/Albanese/CoheightBridge.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing file, no changes this iter. Reviewed lightly; no issues detected.

---

### AlgebraicJacobian/Albanese/AlbaneseUP.lean
- **outdated comments**: none new
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing sorry stubs (L183, L250, L300, L335, L373, L417, L458) — all designed. `bundle : Bundle C := sorry` (L183) is a typed sorry that is a known gap.

---

### AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean
- **outdated comments**: none detected
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing sorry stubs (L155, L294). `IsReduced A.left := sorry` (L155) is a typeclass field sorry — pre-existing. No changes this iter.

---

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: none detected in scope
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing sorry stubs (L438, L646, L1008). Not modified this iter.

---

### AlgebraicJacobian/RiemannRoch/RRFormula.lean
- **outdated comments**: none detected
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing sorry at L335. Not modified this iter.

---

### AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean
- **outdated comments**: none detected
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing sorries (L477, L919, L976). Not modified this iter. The comment at L153 referencing a sorry-carrying statement is a pre-existing docstring.

---

### AlgebraicJacobian/RiemannRoch/OCofP.lean
- **outdated comments**: none detected
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing sorries (L1154, L1219, L1548). Not modified this iter.

---

### AlgebraicJacobian/RiemannRoch/H1Vanishing.lean
- **outdated comments**: none detected
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing sorries (L178, L618). Not modified this iter.

---

### AlgebraicJacobian/RiemannRoch/OcOfD.lean
- **outdated comments**: none detected
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing sorries (L195, L244). Not modified this iter.

---

### AlgebraicJacobian/Picard/RelPicFunctor.lean
- **outdated comments**: none new
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing sorry stubs; `addCommGroup` sorry at ~L235 is the target of the new `TensorObjSubstrate.lean`. The comment at L315 accurately describes the sorry state.

---

### AlgebraicJacobian/Picard/FGAPicRepresentability.lean
- **outdated comments**: none detected
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing sorry stubs in typeclass constructors (L125, L344, L441, L497). Isolated as described in the file header.

---

### AlgebraicJacobian/Picard/IdentityComponent.lean
- **outdated comments**: none detected
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing sorries (L479, L595, L635, L707, L743, L784, L837, L855, L880). Not modified this iter.

---

### AlgebraicJacobian/Picard/QuotScheme.lean
- **outdated comments**: none detected
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing sorries (L173, L212, L248, L275, L330, L1227, L1278, L1328). Not modified this iter.

---

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: none detected
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing sorries (L215, L259, L288, L320, L366, L408, L451). Not modified this iter.

---

### AlgebraicJacobian/Picard/Pic0AbelianVariety.lean
- **outdated comments**: none detected
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing sorries (L149, L171, L190, L209, L238). Not modified this iter.

---

### AlgebraicJacobian/Picard/RelativeSpec.lean, LineBundlePullback.lean
- **outdated comments**: none detected
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing files. Not modified this iter. Lightly scanned; no issues detected.

---

### AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean, ChartIso.lean, GmScaling.lean, Points.lean, Cross01Substrate.lean
- **outdated comments**: none detected
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing sorry stubs in GmScaling.lean (L771, L944) and BareScheme.lean (L220). Not modified this iter.

---

### AlgebraicJacobian/Genus0BaseObjects.lean, Genus.lean, Rigidity.lean, RigidityKbar.lean, RigidityLemma.lean, Differentials.lean, Jacobian.lean, AbelJacobi.lean
- **outdated comments**: none detected
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing files with pre-existing sorry stubs. `Jacobian.lean` has sorries at L236 and L274; `RigidityKbar.lean` at L88. None modified this iter.

---

### AlgebraicJacobian/Cohomology/* (SheafCompose, StructureSheafAb, MayerVietorisCore, MayerVietorisCover, StructureSheafModuleK, and subcategories)
- **outdated comments**: none detected
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing files. Not modified this iter. Lightly scanned.

---

### AlgebraicJacobian/Cotangent/GrpObj.lean, ChartAlgebra.lean
- **outdated comments**: minor in ChartAlgebra (L25 references old `: True := sorry` placeholders from iter-145 as historical context — acceptable)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pre-existing files. Not modified this iter.

---

## Must-fix-this-iter

None.

The `auslander_buchsbaum_formula_succ_pd` proof is closed with no accidental `sorry`/`admit`, no circular dependency, and no weakened-wrong definition. All 4 new helper lemmas and 4 §3.B bridge declarations are axiom-clean. The TensorObjSubstrate.lean stubs are well-typed with no shadow/conflict against existing Mathlib declarations. No excuse-comments in the sense of admitting wrong code were found.

---

## Major

- `AuslanderBuchsbaum.lean:40–42` — File header states "remaining five typed `sorry` bodies (`depth`, `depth_eq_smallest_ext_index`, `depth_of_short_exact`, `auslander_buchsbaum_formula`, `CohenMacaulay.of_regular`) are substantive multi-iter content." A sorry-grep of the entire file in proof positions returns ZERO hits — ALL five are now closed. This header is severely outdated and will mislead the plan agent into thinking major content is still sorry.

- `AuslanderBuchsbaum.lean:144` — Docstring for `depth` says "the body stays a typed `sorry`." The actual body (L148–152) is a proper definition. Stale.

- `AuslanderBuchsbaum.lean:285,365` — Section docstring says "Residual `sorry`s (2 named inline branches)" and a `--` comment says "body remaining as `sorry`." The proof of `depth_eq_smallest_ext_index` (L367–619) has both branches fully closed. Stale.

- `AuslanderBuchsbaum.lean:638` — "Body is kernel-clean modulo the typed sorry of `depth_eq_smallest_ext_index`." Since that theorem is now closed, the qualification is stale.

- `AuslanderBuchsbaum.lean:1706–1713` — The `auslander_buchsbaum_formula_succ_pd` structural section header describes this as "a single named typed-`sorry` declaration." It is not. The proof is closed. Stale.

- `AuslanderBuchsbaum.lean:2043–2048` — Main theorem comment describes `auslander_buchsbaum_formula_succ_pd` as packaging the gap "into a single typed `sorry`." It doesn't. Stale.

- `AuslanderBuchsbaum.lean:2239` — `finrank_cotangentSpace_quot_span_singleton_succ` docstring: "assembled body left as a single named typed sorry." The proof body (L2276–2494) is closed. Stale.

- `AuslanderBuchsbaum.lean:2523` — "`exists_isSMulRegular_quotient_isRegularLocal_succ` (typed `sorry`, Stacks 00NQ + 00NU consolidated)." The grep confirms this declaration has no sorry body. Stale.

- `AuslanderBuchsbaum.lean:3387,3390` — Comments describe `exists_isRegular_of_regularLocal` as "the lower bound, typed `sorry`" and claim the only residual sorry in `CohenMacaulay.of_regular` is the named helper. The grep shows no sorry in proof positions. Stale.

- `TensorObjSubstrate.lean:146` — `noncomputable instance monoidalCategory … := sorry` is a typeclass instance with a sorry body. While all downstream callers are also sorry stubs, any future axiom-clean proof that unintentionally synthesizes `MonoidalCategory X.Modules` (e.g., via `inferInstance` in a new file) would silently succeed by using this sorry-instance, producing a false closed proof. This is a structural contamination risk.

---

## Minor

- `AuslanderBuchsbaum.lean:365` — The inline `-- body remaining as \`sorry\`.` comment is placed inside a proof tactic block, not a docstring. A reader parsing proof structure could mistake it for an annotation about the proof step, not a historical note. Recommend removal.

- `AuslanderBuchsbaum.lean:1707` — "rather than an opaque inline `sorry` at the case-split site" is referring to the old design. Now the proof IS at the case-split site and is not opaque. Confusing phrasing.

- `TensorObjSubstrate.lean:191–193` — `tensorObjOnProduct` has a non-sorry body that calls `tensorObj` (sorry) and `tensorObj_isLocallyTrivial` (sorry). The result is transitively sorry, which a reader might not immediately recognize given the non-sorry body. A short comment noting this would aid comprehension.

- `WeilDivisor.lean:584–586` — `have hcongr : ∀ {a b : X} (e : Inseparable a b), (X.presheaf.stalkCongr e).hom = X.presheaf.stalkSpecializes e.ge := by intros; rfl` — the `rfl` claim that `stalkCongr e = stalkSpecializes e.ge` is a definitional equality assertion. This is plausible but could be fragile if Mathlib changes the definition of `stalkCongr`. No immediate concern, minor code smell.

- `CodimOneExtension.lean` — The §3.B docstring (L959–984) is lengthy and accurate, but the four declarations at L994–1040 are arguably over-documented given their one-line proof bodies. No functional issue.

---

## Excuse-comments (always called out separately)

None. Every `sorry`-referencing comment found in the codebase falls into one of:
1. A stale status description (the code used to be sorry but is now closed), or
2. An accurate description of a pre-existing sorry stub at a designed residual site.

No comment in the form "this is wrong but we're leaving it" was found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 10 (all stale-documentation findings in AuslanderBuchsbaum.lean plus the monoidalCategory instance risk)
- **minor**: 4
- **excuse-comments**: 0 (none found)

Overall verdict: The iter-202 code changes are mathematically sound — `auslander_buchsbaum_formula_succ_pd` is genuinely closed with no accidental sorry, the 4 new helper lemmas are axiom-clean, the CodimOneExtension §3.B declarations are axiom-clean, the WeilDivisor new declarations are axiom-clean, and the TensorObjSubstrate stubs have well-formed signatures with no Mathlib conflicts. The principal concern is that `AuslanderBuchsbaum.lean` has accumulated ~10 major stale comments describing proof bodies as sorry when they are not, which will mislead the plan agent; these should be swept before the next planning iteration.
