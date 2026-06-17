# Lean Audit Report

## Slug
iter028

## Iteration
028

## Scope
- files audited: 3
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 2 flagged
- **bad practices**: 1 flagged
- **excuse-comments**: 0 flagged (none in the strict "placeholder / temporary wrong def" sense; the extensive blocker-analysis comments are engineering documentation, not excuse-comments)
- **notes**:
  - **Sorry inventory (confirmed):** 4 sorries at lines 1445, 1817, 1995, 2017.
    - Line 1445 — in `base_change_mate_fstar_reindex_legs`: the `erw [unitExpand]` unlock succeeded this iter but the eCancel telescoping (steps ii+iii) is still unfinished.
    - Line 1817 — in `base_change_mate_gstar_transpose`: the conjugate-counit scaffold is in place (iter-022 recipes 1 complete), residual crux (recipe steps 2-3, the ~150-LOC inner-reindex + generator close) outstanding.
    - Line 1995 — in `affineBaseChange_pushforward_iso`: the affine-reduction ("obligation 1") is unfinished; the per-affine-open restriction-compatibility of `pushforwardBaseChangeMap` is Mathlib-absent.
    - Line 2017 — in `flatBaseChange_pushforward_isIso`: deferred stub, Čech infrastructure absent.
  - **FALSE "sorry-free" claim — `base_change_mate_section_identity` (line 1844):** Docstring at line 1837 reads "This theorem itself is **sorry-free**." Proof body is `unfold pushforwardBaseChangeMap; rw [Adjunction.homEquiv_counit]; exact base_change_mate_gstar_transpose ψ φ M`. But `base_change_mate_gstar_transpose` (line 1694) ends in `sorry` at line 1817. The theorem is **transitively sorry-backed one hop away**. The "sorry-free" label is false and will mislead downstream planning that treats the section identity as proved.
  - **FALSE "sorry-free" claim — `pushforward_base_change_mate_cancelBaseChange` (line 1913):** Docstring at line 1907 reads "This theorem itself is **sorry-free**." Proof: `haveI hconj := base_change_mate_generator_trace ψ φ M` + `rw [heq]; infer_instance`. `base_change_mate_generator_trace` (line 1873) proves `rw [base_change_mate_section_identity]; infer_instance`. `base_change_mate_section_identity` → `gstar_transpose` → sorry@1817. The sorry chain is `cancelBaseChange` (3 hops) → sorry@1817. The "sorry-free" label is false.
  - **Dead `have hpfc` before sorry (lines 1431–1444) in `base_change_mate_fstar_reindex_legs`:** An intermediate `have hpfc := gammaMap_pushforwardComp_hom_eq_id _ _ _` is introduced but immediately followed by `sorry` at line 1445 with a comment explaining why `hpfc` cannot be applied (`rw`/`simp`/`erw` all fail due to the `X.Modules` instance diamond). The `hpfc` term is never referenced in the proof. This is dead code; Lean 4 may issue an "unused variable" lint warning. The accompanying comment is accurate and not an excuse-comment, but the dead local should be removed.
  - **Transitive sorry status of `base_change_mate_inner_value_eq` (line 1608):** Proof is `exact base_change_mate_fstar_reindex ψ φ M`; `fstar_reindex` (line 1459) calls `fstar_reindex_legs` (line 1335) which has sorry@1445. Two-hop chain. Docstring makes no "sorry-free" claim (correct), but the proof comment ("CASCADE") implicitly treats this as a stable reduction rather than flagging the sorry dependency.
  - **Transitive sorry status of `base_change_mate_generator_trace` (line 1873):** Proof → `section_identity` → `gstar_transpose` → sorry@1817. No false claim in docstring.
  - **STATUS block for `pushforward_spec_tilde_iso` (lines 235–247) is ACCURATE:** Claims "fully proved, no sorry". Verified chain: `pushforward_spec_tilde_iso` (line 538) → `pushforward_spec_tilde_iso_of_isLocalizedModule` (line 431) → `fromTildeΓ_app_isIso_of_isLocalizedModule` (line 367) + `Modules.isIso_of_isIso_app_of_isBasis` (line 128); none of these contain a sorry. The STATUS block does not overstate.
  - **`affineBaseChange_pushforward_iso` and `flatBaseChange_pushforward_isIso`:** Both end in `sorry`; their docstrings accurately describe this as an outstanding obligation. No false "sorry-free" claim.
  - `set_option maxHeartbeats` usages (lines 979, 1325, 1449): all carry explaining comments (conjugate-unit erw budget; post-subst distribution + eCancel; exact-onto-legs defeq check). No bare unexplained heartbeat overrides.

---

### AlgebraicJacobian/Picard/QuotScheme.lean

- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged (the 4 sorries are documented protected stubs)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **Sorry inventory (confirmed):** 4 sorries at lines 126, 165, 201, 228 — in `hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable` respectively. All are documented skeleton stubs with `iter-177+` body notes; none pretend to be proved.
  - **New helper `isLocalizedModule_basicOpen_of_presentation` (line 686) is genuine:** Proof `haveI : IsIso M.fromTildeΓ := isIso_fromTildeΓ_of_presentation M _P; exact isLocalizedModule_restrict_of_isIso_fromTildeΓ M f`. Composition of two proved, sorry-free theorems. Not a placeholder.
  - **New helper `map_units_restrict_basicOpen` (line 705) is genuine:** Proof `rintro ⟨x, n, rfl⟩; simpa using (tilde.isUnit_algebraMap_end_basicOpen M f).pow n`. Concrete Mathlib application. Not a placeholder.
  - **No stray scaffolding:** No `example`, `#check`, `Scratch`, or orphaned `-- TODO`-style placeholders in the file. Only `set_option autoImplicit false`.
  - **Predicates (`IsLocallyFreeOfRank`, `annihilator`, `schematicSupport`, `HasProperSupport`) are substantive:** Each uses a non-trivial Mathlib construction (`Scheme.IdealSheafData.ofIdeals`, `subscheme`, `IsProper`). The `annihilator_ideal_le` auxiliary lemma is a one-line `IdealSheafData.ideal_ofIdeals_le` proof — correct. The downstream characterization `annihilator_ideal` (reverse inclusion) is acknowledged as blocked on QCoh localization bridge; the comment is accurate engineering documentation.
  - **`annihilator_isLocalizedModule_eq_map` (Module level, line 362):** Substantial proof using `IsLocalization`/`IsLocalizedModule` API. No sorry. Appears correct.

---

### AlgebraicJacobian/Picard/GrassmannianCells.lean

- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **Sorry inventory (confirmed):** 0 sorries in the file. ✓
  - **New declaration `chartTransition'` (line 834) is genuine:** Defined as a concrete composition `awayPullbackIso.hom ≫ Spec.map cocycleΘIJ ≫ Spec.map awayMulCommEquiv ≫ awayPullbackIso.inv`. Well-typed; uses the previously proved `cocycleΘIJ` and `awayMulCommEquiv`.
  - **New declaration `awayMulCommEquiv_comp_algebraMap` (line 847) is genuine:** Short proof via `IsLocalization.algEquiv.commutes`. Correct.
  - **New declaration `chartTransition'_ringIdentity` (line 861) is genuine:** Proof by `IsLocalization.ringHom_ext` reducing to the already-proved `awayInclLeft_comp_algebraMap` / `transitionMap`/`cocycleΘIJ` `lift_comp` identities. Correct structure.
  - **New declaration `chartTransition'_fac` (line 884) is genuine:** The `set_option maxHeartbeats 1600000 in` at line 876 carries the required explaining comment: "The `erw` through the `HasPullback` instance diamond on the heavy `MvPolynomial` localisation objects is defeq-expensive; the raised limit covers it." The proof uses `erw [awayPullbackIso_inv_snd]` followed by `exact congrArg (_ ≫ ·) hXY`. Acceptable use of `erw` for a genuine defeq diamond (documented `GR pullback instance diamond` memory). ✓
  - **`set_option maxHeartbeats 1600000` (line 876):** Single occurrence in the file, carries explaining comment. ✓
  - **HANDOFF comment (lines 918–941) is ACCURATE:** The comment says `cocycle`, `theGlueData`, and `Grassmannian.scheme` are not yet added. Inspection of the file confirms: neither `cocycle` (the GlueData field), nor `theGlueData`, nor a `Grassmannian.scheme` definition appears. The comment correctly describes the mathematical path forward (ring-hom ext → matrix-cocycle identity → GlueData assembly). No false claim of existence.
  - The existing declarations `universalMatrix`, `minorDet`, `universalMinor`, `universalMinorInv`, `imageMatrix`, `transitionPreMap`, `transitionMap`, `cocycleΘIJ`/`ΘJK`/`ΘIK`, and `cocycleCondition` from prior iterations are all sorry-free and structurally sound.

---

## Must-fix-this-iter

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:1837` — Docstring of `base_change_mate_section_identity` (defined at line 1844) asserts "This theorem itself is **sorry-free**." The proof `exact base_change_mate_gstar_transpose ψ φ M` defers immediately to a theorem with `sorry` at line 1817. The theorem is **transitively sorry-backed**. Why must-fix: planning agents and blueprint-marker logic that treat this declaration as proved will build on a false premise. The "sorry-free" label must be corrected (the accurate statement is "this theorem's proof body has no inline sorry; the crux lives in `base_change_mate_gstar_transpose`").

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:1907` — Docstring of `pushforward_base_change_mate_cancelBaseChange` (defined at line 1913) asserts "This theorem itself is **sorry-free**." The proof chains `generator_trace` → `section_identity` → `gstar_transpose` → sorry@1817. The theorem is **transitively sorry-backed** (3 hops). Why must-fix: the theorem is a key lemma whose `IsIso` conclusion is consumed by `affineBaseChange_pushforward_iso`; falsely marking it proved creates incorrect dependency accounting. The label must be corrected.

---

## Major

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:1608` — `base_change_mate_inner_value_eq` is **transitively sorry-backed** (→ `fstar_reindex` → `fstar_reindex_legs` → sorry@1445). The docstring does not claim "sorry-free," so this is not a false-label issue, but the proof comment ("CASCADE (iter-028): this theorem has the SAME statement as `base_change_mate_fstar_reindex`... `exact base_change_mate_fstar_reindex ψ φ M`") is presented as a clean resolution of "Seam A" without flagging the sorry. Readers may not realise this is sorry-backed. Noted because the `gstar_transpose` proof comment at line 1741 explicitly warns *against* citing the sorry-backed `fstar_reindex` for a closely related claim; the current arrangement makes the sorry chain non-obvious.

---

## Minor

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:1431` — Dead `have hpfc` in `base_change_mate_fstar_reindex_legs`: `have hpfc := gammaMap_pushforwardComp_hom_eq_id _ _ _` is introduced at line 1431 but is never referenced before the `sorry` at line 1445. Lean 4 may emit an "unused variable" lint warning. The accompanying analysis comment is accurate; the dead local should be deleted to keep the scaffolding clean.

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:1873` — `base_change_mate_generator_trace` is transitively sorry-backed (→ `section_identity` → `gstar_transpose` → sorry@1817) but its docstring makes no sorry-free claim. Noting for completeness since this theorem is cited by `cancelBaseChange` and appears in the public API surface.

---

## Excuse-comments (always called out separately)

None. The project's extensive blocker-analysis comments (e.g. lines 1382–1430 in `FlatBaseChange.lean`) are technical engineering notes explaining specific instance-diamond failure modes. They are not admissions that a definition is wrong or that a deadline-dodging placeholder is in use; they are accurate reports of Lean elaboration obstacles. No comment in any of the three files qualifies as an excuse-comment.

---

## Severity summary

- **must-fix-this-iter**: 2
  - `FlatBaseChange.lean:1837` — false "sorry-free" claim on `base_change_mate_section_identity`
  - `FlatBaseChange.lean:1907` — false "sorry-free" claim on `pushforward_base_change_mate_cancelBaseChange`
- **major**: 1
  - `FlatBaseChange.lean:1608` — `inner_value_eq` sorry chain non-obvious in proof comment
- **minor**: 2
  - `FlatBaseChange.lean:1431` — dead `have hpfc` before sorry@1445
  - `FlatBaseChange.lean:1873` — `generator_trace` sorry chain undocumented (no false claim, but worth noting)
- **excuse-comments**: 0

**Overall verdict:** FlatBaseChange.lean has two docstrings that falsely call transitively sorry-backed theorems "sorry-free"; these must be corrected before those declarations can be treated as proved by the plan agent. QuotScheme.lean and GrassmannianCells.lean are clean: the two new QuotScheme helpers are genuine, all four GrassmannianCells new declarations are sorry-free and well-commented, and the HANDOFF note is accurate.
