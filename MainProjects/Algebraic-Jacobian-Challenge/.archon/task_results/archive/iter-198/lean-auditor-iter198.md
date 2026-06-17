# Lean Audit Report

## Slug
iter198

## Iteration
198

## Scope
- files audited: 43
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Import aggregation only; no declarations.

---

### AlgebraicJacobian/Picard/RelPicFunctor.lean *(edited this iter)*
- **outdated comments**: 1 flagged
- **suspect definitions**: 2 flagged
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 1 flagged
- **notes**:
  - **L268–269**: `-- TODO (Scheme.Modules monoidal-structure gate): close once Mathlib ships...` followed by `exact sorry`. This is a must-fix excuse-comment on the load-bearing `addCommGroup` instance body. Pre-existing; carried from iter-196/197.
  - **L327–330 (`PicSharp`)**: Body is `(CategoryTheory.Functor.const _).obj (AddCommGrpCat.of (PUnit.{u+2}))` — a constant functor at the trivial abelian group. This is NOT the relative Picard presheaf. Type is substantively correct, body is semantically vacuous. The docstring at L312–326 is transparent ("iter-198 Lane RPF closure: the body is a Functor.const-style trivial functor"), but when `sync_leanok` marks the proof block `\leanok`, the blueprint will overstate mathematical progress. **Major**: declares a sorry-free placeholder body for a load-bearing definition.
  - **L372–377 (`PicSharp.functorial`)**: Body is `0` (zero `AddMonoidHom`). The codomain's `Zero` instance derives from the `addCommGroup` instance (which carries `exact sorry`), so `PicSharp.functorial` inherits a `sorryAx` taint. The docstring correctly identifies this ("inherits a `sorryAx` taint via the file-local `addCommGroup` instance"). **Major**: the taint means `PicSharp.functorial` is not axiom-clean despite appearing as a closed declaration.
  - **L421–424 (`PicSharp.presheaf`)**: Re-exports `PicSharp _C`, which is the const-PUnit functor above. Axiom-clean, tautological. Minor.
  - **L486–490 (`PicSharp.etSheaf`)**: Sheafifies `PicSharp.presheaf _C` — the sheafification of a const-PUnit presheaf. Axiom-clean. Tautological because the input is the PUnit placeholder. Minor.
  - **L539–544 (`PicSharp.etSheaf_group_structure`)**: Witnesses `Nonempty (presheaf ⟶ etSheaf.obj)` via the zero natural transformation `⟨0⟩`. Axiom-clean. The type is `Nonempty` (existential), so the zero witness is entirely consistent — but it doesn't exhibit the sheafification unit with its universal property. Minor.
  - **L105**: Rename of `etSheafUnit` to `etSheaf_group_structure` is properly documented. No issue.
  - **Headline laundering assessment**: The 5 placeholder closures together constitute **soft laundering** — sorry count drops by 5, `\leanok` will fire on proof blocks, but zero mathematical content is added. The file is fully transparent about the placeholder nature *within itself*, but downstream blueprint consumers (and the dashboard) will misread the state. The single real sorry that matters is the `addCommGroup` body at L269.

---

### AlgebraicJacobian/Albanese/CodimOneExtension.lean *(edited this iter)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (named-but-unused binding)
- **excuse-comments**: none
- **notes**:
  - **L373–400 (`finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq`)**: New axiom-clean substrate helper for Stage 6.B RHS. Hypothesis shape (`[Module.Free Sₘ ...]` + `hrank : Module.rank ... = n`) is exactly what Stages 5a+5b provide — load-bearing connection is genuine. Body: `Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq`. Correct.
  - **L423–435 (`finrank_residueField_tensor_kaehlerDifferential_of_isStandardSmoothOfRelativeDimension`)**: Second Stage 6.B helper. Axiom-clean. Composes the first helper with `rank_kaehlerDifferential`. Correct.
  - **L454–459 (`exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth`)**: 4-line unpacking of `IsStandardSmooth.out`. Axiom-clean. Closes the iter-193 "sub-gap (i)" correctly.
  - **L552–554**: `have _hflat : ((X.hom.stalkMap z).hom).Flat := ...` — the underscore prefix `_` acknowledges it is not used downstream in the current proof path. Stage 1 (smooth ⟹ flat) is scaffolded but the current regularity route goes through Kähler differentials, not flatness. The `_` suppresses the Lean unused-variable warning but the dead binding is still present. **Minor** bad practice.
  - **L498–543 (docstring of `isRegularLocalRing_stalk_of_smooth`)**: Accurately documents sub-gaps (ii.A) and (ii.B) remaining. No over-promise. The trailing `sorry` at L662 is correctly described as "residual Stage 6 gap."
  - **L622–661 (body comment in `isRegularLocalRing_stalk_of_smooth`)**: Structural-blocker analysis is honest. Lists what Mathlib has (`exact_mapBaseChange_map`) vs. what is missing (assembled iso form). No excuse-language.

---

### AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean *(edited this iter)*
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **~L1241 (docstring of `auslander_buchsbaum_formula_succ_pd`)**: The header "All four pieces are absent:" is now **stale** — gap (4) ("Depth-drops-by-one") was closed this iter by `depth_quotSMulTop_succ_eq_depth_of_isSMulRegular`. The body comment at L1293–1312 correctly says "(4) — CLOSED iter-198", but the docstring header still says "All four pieces are absent." **Major** outdated comment — actively misleads a reader scanning the docstring.
  - **~L1259–1262 (re-engagement plan in docstring)**: The bullet "iter-196 first slice: piece (4)" is stale — piece (4) landed iter-198, not iter-196. **Minor** scheduling drift in docstring.
  - **L1020–1172 (`depth_quotSMulTop_succ_eq_depth_of_isSMulRegular`)**: New axiom-clean helper. Packages the SES `0 → M →[x] M → M/xM → 0` LES-of-Ext argument. Uses `IsSMulRegular.smulShortComplex_shortExact`, `ext_smul_eq_zero_of_mem_annihilator`, existing `covariant_sequence_exact*` infrastructure. Well-structured; no unused `letI`/`haveI`. Correctly closes gap (4).
  - **L1136–1172 (`exists_isSMulRegular_of_one_le_depth`)**: New axiom-clean companion helper. Clean sSup unfolding argument. No unused bindings.
  - **L1283 (`auslander_buchsbaum_formula_succ_pd`)**: Still `sorry` body. The body comment is accurately updated (gap (4) closed, gaps (1)(2)(3) still open). Pre-existing; no new issue.
  - **L562–574**: These are internal proof-tactic lines (NOT a docstring). The directive's claim about a "docstring at L562-574" does not correspond to a docstring in the current file — the location contains tactic code inside `exists_isSMulRegular_of_depth_one`'s proof. No finding here.

---

### AlgebraicJacobian/RiemannRoch/WeilDivisor.lean *(edited this iter)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L233–240 (`order_zero`)**: Axiom-clean. `map_zero` + `WithZero.log_zero`. Correct.
  - **L246–255 (`order_mul_of_ne_zero`)**: Axiom-clean. `map_mul` + `WithZero.log_mul`. Hypotheses `hf : f ≠ 0` and `hg : g ≠ 0` are required by `WithZero.log_mul` — correctly threaded. Not a Mathlib duplicate.
  - **L265–272 (`order_inv`)**: Axiom-clean. `map_inv₀` + `WithZero.log_inv`. Handles the `f = 0` junk case correctly. Not a Mathlib duplicate.
  - **L279–288 (`order_units_inv`)**: Axiom-clean. Unit specialisation of `order_inv`. Correct; not a duplicate.
  - **L478–483 (`degree_neg`)**: Axiom-clean. `map_neg` on `degree_hom`. Correct; not a Mathlib duplicate.
  - **L488–491 (`degree_sub`)**: Axiom-clean. `map_sub` on `degree_hom`. Correct; not a Mathlib duplicate.
  - **L326–365 (structural-blocker comment on `rationalMap_order_finite_support` non-zero branch)**: The reformatted comment is honest. It explains WHY the sorry cannot close without `[CompactSpace X]`/`[IsNoetherian X]` and gives a concrete resolution path ("iter-199+: strengthen the typeclass"). No excuse-language. The diagnosis is mathematically accurate — a counter-example to the current weak hypothesis is explicitly constructible.
  - **L365 (`· sorry`)**: Pre-existing sorry. The L316–324 `f = 0` branch closed axiom-clean (iter-192). The `f ≠ 0` branch honestly documented.

---

### AlgebraicJacobian/Albanese/AlbaneseUP.lean *(unchanged this iter)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 1 flagged (pre-existing)
- **notes**:
  - **L179–183 (`bundle := sorry`)**: "File-internal **placeholder carrier** for `Pic⁰_{C/k̄}` — a typed `sorry` pending the A.3 row chapter." Docstring admits the definition is a placeholder. Per auditor rules, this is an excuse-comment on a load-bearing definition. **Must-fix**, pre-existing, carried from iter-196/197. No change this iter; confirmed still open.

---

### AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean *(unchanged this iter)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `isReduced_of_smooth_over_field`: named Mathlib-gap sorry, properly documented (Stacks `034V`/`02G4`). Not an excuse-comment — the name and docstring are honest about the gap.
  - `av_codimOneFree_of_indeterminacy`: sorry in branch 2, well-documented dependency chain. Clean.

---

### AlgebraicJacobian/AbelianVarietyRigidity.lean *(unchanged this iter)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `kbarChart1Ring_specMap_fac`: sorry at L438, well-documented structural sorry. Pre-existing.
  - `iotaGm_chart1_appIso_eval`: sorry at L646, well-documented. Pre-existing.
  - `isRegularInCodimOneProjectiveLineBar`: axiom-clean modulo the Stacks 02IZ coheight-topology bridge (handled via explicit per-step sorry analysis in the body). The DVR transport via `hspecstalk.symm` and stalk-iso chain is a careful and honest scaffold.

---

### AlgebraicJacobian/Picard/LineBundlePullback.lean *(unchanged this iter)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All pinned declarations carry sorry bodies. Pre-existing file-skeleton; each sorry is a documented Mathlib gap.

---

### AlgebraicJacobian/Picard/FGAPicRepresentability.lean *(unchanged this iter)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All 6 pinned declarations carry sorry bodies (`⟨sorry⟩` patterns). Per iter-196 carrier-soundness probe, these are isolated to Prop-valued fields. Pre-existing.

---

### AlgebraicJacobian/Picard/RelativeSpec.lean *(unchanged this iter)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File-skeleton with sorry bodies. Pre-existing.

---

### AlgebraicJacobian/Picard/IdentityComponent.lean *(unchanged this iter)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File-skeleton with sorry bodies. Pre-existing.

---

### AlgebraicJacobian/Picard/QuotScheme.lean *(unchanged this iter)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File-skeleton with sorry bodies. Pre-existing.

---

### AlgebraicJacobian/Picard/Pic0AbelianVariety.lean *(unchanged this iter)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File-skeleton. Pre-existing.

---

### AlgebraicJacobian/Picard/FlatteningStratification.lean *(unchanged this iter)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File-skeleton. Pre-existing.

---

### AlgebraicJacobian/RiemannRoch/RRFormula.lean *(unchanged this iter)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File-skeleton with sorry bodies. Pre-existing.

---

### AlgebraicJacobian/RiemannRoch/OcOfD.lean *(unchanged this iter)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File-skeleton. Pre-existing.

---

### AlgebraicJacobian/RiemannRoch/OCofP.lean *(unchanged this iter)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File-skeleton. Pre-existing.

---

### AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean *(unchanged this iter)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File-skeleton. Pre-existing.

---

### AlgebraicJacobian/RiemannRoch/H1Vanishing.lean *(unchanged this iter)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File-skeleton with 8 sorry-body declarations. Pre-existing.

---

### AlgebraicJacobian/Albanese/CoheightBridge.lean *(unchanged this iter)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Four declarations including the axiom-clean `ringKrullDim_stalk_eq_coheight` bridge. Pre-existing; no new issues.

---

### AlgebraicJacobian/Genus.lean, AlgebraicJacobian/Genus0BaseObjects.lean, AlgebraicJacobian/Genus0BaseObjects/*.lean *(unchanged this iter)*
- **notes**: Pre-existing; no new issues from iter-198.

---

### AlgebraicJacobian/Cohomology/*.lean, AlgebraicJacobian/Cotangent/*.lean *(unchanged this iter)*
- **notes**: Pre-existing file-skeletons and axiom-clean infrastructure. No new issues.

---

### AlgebraicJacobian/Rigidity.lean, AlgebraicJacobian/RigidityKbar.lean, AlgebraicJacobian/RigidityLemma.lean *(unchanged this iter)*
- **notes**: Pre-existing axiom-clean rigidity infrastructure (iters 157–162). No new issues.

---

### AlgebraicJacobian/AbelJacobi.lean, AlgebraicJacobian/Jacobian.lean, AlgebraicJacobian/Differentials.lean *(unchanged this iter)*
- **notes**: Pre-existing file-skeletons. No new issues.

---

## Must-fix-this-iter

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:268–269` — `-- TODO (Scheme.Modules monoidal-structure gate): close once Mathlib ships...` followed by `exact sorry` on the body of the `addCommGroup` instance. This is an excuse-comment ("TODO: close once...") on a load-bearing definition. Per auditor rules, TODO-excuse-comments on substantive claims are must-fix regardless of the technical justification. Why must-fix: the comment explicitly admits the body is wrong/pending; the definition is the gating sorry for the entire RelPicFunctor.lean file.

- `AlgebraicJacobian/Albanese/AlbaneseUP.lean:179–183` — `noncomputable def bundle : Bundle C := sorry` with docstring "File-internal **placeholder carrier** for `Pic⁰_{C/k̄}` — a typed `sorry` pending the A.3 row chapter." The phrase "placeholder carrier... pending" is an admission that the definition is a stand-in. Why must-fix: `bundle` is the gating definition for all six pinned declarations in AlbaneseUP.lean; its sorry body propagates `sorryAx` through every derived instance. (Pre-existing; carried from iter-196/197.)

---

## Major

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:327–330` — `PicSharp` defined as `(CategoryTheory.Functor.const _).obj (AddCommGrpCat.of (PUnit.{u+2}))`. The type is correct and substantive; the body is a constant functor at the trivial group, not the relative Picard presheaf. When `sync_leanok` fires on the proof block (no sorry), the blueprint will mark this as "proof closed" — but the math content is absent. This is soft headline laundering: the sorry-count drops by 1, the `\leanok` marker fires, but the declared functor does not implement `T ↦ Pic(C×T) / π_T^* Pic(T)`.

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:372–377` — `PicSharp.functorial := 0`. The zero `AddMonoidHom` is technically a valid body for the type, but (a) it doesn't implement the descended pullback action, and (b) because the codomain's `Zero` instance derives from the sorry-body `addCommGroup` instance, `PicSharp.functorial` inherits `sorryAx` taint — it is NOT axiom-clean despite lacking an explicit sorry. The file header claim "PicSharp.functorial inherits a `sorryAx` taint" correctly identifies this. The Lean elaborator accepts the body, but `#print axioms PicSharp.functorial` will show `sorryAx`. This distinction matters: the blueprint's `\leanok` sync does not check for `sorryAx`, only for `sorry` in the source.

- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:~L1240–1242` — The docstring header of `auslander_buchsbaum_formula_succ_pd` reads "All four pieces are absent:" — this was accurate before iter-198 but is now stale. Gap (4) ("Depth-drops-by-one") was closed this iter by `depth_quotSMulTop_succ_eq_depth_of_isSMulRegular`. The body comment at L1293–1312 is correctly updated ("(4) — CLOSED iter-198"), but the public docstring is inconsistent. A reader scanning the declaration docstring will have a false picture of the residual gap count.

---

## Minor

- `AlgebraicJacobian/Albanese/CodimOneExtension.lean:553–554` — `have _hflat : ((X.hom.stalkMap z).hom).Flat := stalkMap_flat_of_smooth X z`. The underscore prefix acknowledges the binding is unused in the current proof path (the regularity chain routes through Kähler differentials, not flatness). Stage 1 is scaffolded as a named have-binding but contributes nothing to the proof goal. Leaving it here documents the Stage 1 scaffolding but introduces a dead binding.

- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:~L1259–1262` — Re-engagement plan schedule in the docstring of `auslander_buchsbaum_formula_succ_pd`: the bullet "iter-196 first slice: piece (4)" is now stale — piece (4) landed iter-198 (2 iters behind schedule). The schedule should be updated to reflect the actual iter-198 delivery.

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:421–424, 486–490, 539–544` — `PicSharp.presheaf`, `PicSharp.etSheaf`, and `PicSharp.etSheaf_group_structure` are tautological consequences of the PUnit placeholder bodies. `presheaf := PicSharp _C` (const-PUnit), `etSheaf` = sheafification of const-PUnit, `etSheaf_group_structure = ⟨0⟩`. These are minor relative to the PicSharp/functorial major findings, but they add to the sorry-count illusion.

---

## Excuse-comments (always called out separately)

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:268–269`: "TODO (Scheme.Modules monoidal-structure gate): close once Mathlib ships a monoidal-category instance on `Scheme.Modules` (or once the project-side `Scheme.Modules.tensorObj` lemma lands)." — attached to the body of `PicSharp.addCommGroup`, the gating sorry for the entire file. Severity: must-fix-this-iter (carried from iter-196/197).

- `AlgebraicJacobian/Albanese/AlbaneseUP.lean:179–183`: "File-internal **placeholder carrier** for `Pic⁰_{C/k̄}` — a typed `sorry` pending the A.3 row chapter." — attached to `def bundle : Bundle C := sorry`, the gating sorry for all six AlbaneseUP pins. The word "placeholder" is an explicit admission. Severity: must-fix-this-iter (carried from iter-196/197).

---

## Headline question: iter-198 verdict on RelPicFunctor placeholder closures

**Between legitimate progress and headline laundering — closer to the laundering end for RelPicFunctor.lean, genuine progress in the other three files.**

**RelPicFunctor.lean:** The 5 "closures" (PicSharp, functorial, presheaf, etSheaf, etSheaf_group_structure) are sorry-free in source but carry no mathematical content. The constant-PUnit functor satisfies the type of `PicSharp` without implementing the relative Picard presheaf; the zero AddMonoidHom satisfies the type of `functorial` without implementing the descent of the pullback action. When `sync_leanok` runs, five `\leanok` markers will be added to proof blocks in the blueprint chapter. This is soft laundering: the sorry-count drops by 5, the progress dashboard shows green, but the math does not advance. The mitigating factor is that the file is completely transparent about the placeholder nature (each docstring explicitly says "iter-198 Lane RPF closure: the body is a ... trivial ... placeholder"), so a careful reader of the Lean source is not deceived. Only the blueprint-facing metrics are misleading.

The single remaining sorry in `addCommGroup` is the honest sorry — it is the actual Mathlib-gap gate, and the five closures are pure scaffolding around it. The pattern is not fraudulent (the types are substantive and correct), but it constitutes **metric gaming**: five sorry closures that advance the sorry count without advancing the proof.

**CodimOneExtension.lean, AuslanderBuchsbaum.lean, WeilDivisor.lean:** All 11 new declarations (3+2+6) in these files are axiom-clean, load-bearing, and advance the proof chain. This is genuine substrate progress.

---

## Severity summary

- **must-fix-this-iter**: 2 — these block downstream work in their files until addressed.
  - `RelPicFunctor.lean:268–269` — excuse-comment + `exact sorry` on `addCommGroup` (gating sorry for file).
  - `AlbaneseUP.lean:179–183` — excuse-comment + `bundle := sorry` (gating sorry for file).
- **major**: 3
  - `RelPicFunctor.lean:327–330` — `PicSharp` placeholder body (soft headline laundering).
  - `RelPicFunctor.lean:372–377` — `PicSharp.functorial := 0` inherits `sorryAx` taint.
  - `AuslanderBuchsbaum.lean:~L1241` — Stale docstring "All four pieces are absent."
- **minor**: 3
  - `CodimOneExtension.lean:553–554` — `_hflat` named-but-unused in current proof path.
  - `AuslanderBuchsbaum.lean:~L1259–1262` — Re-engagement schedule stale.
  - `RelPicFunctor.lean:421–544` — Tautological placeholder re-exports (presheaf, etSheaf, etSheaf_group_structure).
- **excuse-comments**: 2 (both also counted under must-fix-this-iter above).

**Overall verdict:** Genuine substrate progress in CodimOneExtension, AuslanderBuchsbaum, and WeilDivisor (11 new axiom-clean lemmas); soft headline laundering in RelPicFunctor (5 sorry-free but mathematically vacuous closures that will misrepresent blueprint progress). The two pre-existing must-fix issues (RelPicFunctor `addCommGroup` and AlbaneseUP `bundle`) remain open.
