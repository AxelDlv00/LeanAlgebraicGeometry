# Lean Audit Report

## Slug
ts237

## Iteration
237

## Scope
- files audited: 3
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (minor erw fragility, documented)
- **excuse-comments**: none
- **notes**:
  - **Line 16 — module docstring stale.** The bullet point reads `FlatWhisker / WhiskerOfW (route-(e) flatness-free whiskering; one open sorry isLocallyInjective_whiskerLeft_of_W)`. The `isLocallyInjective_whiskerLeft_of_W` sorry has been closed this iteration; the phrase "one open sorry" is now inaccurate and should be removed/updated to "axiom-clean".
  - **`isLocallyInjective_whiskerLeft_of_W` body (lines 478–572)**: Genuinely non-trivial proof — three-case TensorProduct induction (`zero`/`tmul`/`add`), uses `isIso_stalkFunctor_map_of_W` (d.1), `stalkTensorIso` (d.2), and `stalkLinearEquivOfIsIso`. Not vacuous. No `trivial`/`True.intro`/`Classical.choice` shortcuts observed.
  - **Specialization soundness**: The `WhiskerOfW` section specializes `{X : TopCat.{u}} {R : X.Presheaf CommRingCat.{u}}` from the earlier general-site `{C : Type u} [Category.{v'} C]` frame. The consumer (`TensorObjSubstrate.lean` lines 370–376) calls these as `PresheafOfModules.W_whiskerRight_of_W (R := X.presheaf)` for `X : Scheme` — correct, since `X.toTopCat : TopCat` and `X.presheaf : X.Opens → CommRingCat`. No information is silently dropped that the consumer needs: the flat variants remain for general sites and are a separate family.
  - **`W_whiskerLeft_of_W` / `W_whiskerRight_of_W` (lines 579–608)**: Both are real non-trivial constructions using `isLocallyInjective_whiskerLeft_of_W` + `isLocallySurjective_whiskerLeft` (left) and the braiding conjugation pattern (right). Structurally mirrors `W_whiskerLeft/Right_of_flat` — sound.
  - **New stalk-bridge declarations (lines 389–447)**: `isLocallyInjective_of_injective_stalk`, `injective_stalk_of_isLocallyInjective`, `isIso_stalkFunctor_map_of_W` — all genuine, each ~15–25 lines, no vacuous tactic. `isIso_stalkFunctor_map_of_W` at line 444 uses `ConcreteCategory.isIso_iff_bijective` correctly.
  - **`erw` in `isLocallyInjective_whiskerLeft_of_W` (lines 508–509, 533)**: Used for the documented reason that `+`/`0` instances on the defeq carriers `(toPresheaf _).obj (F ⊗ M)` vs `(Monoidal.tensorObj F M).presheaf` differ syntactically. The proof uses `have`-term distribution via `map_add` / `map_zero` rather than `rw [map_add]` on the `AddCommGrpCat` hom — fragile but consciously documented at lines 504–506. No unwarranted overuse.
  - **`set` bindings (lines 491–496)**: Scoped identifiers used throughout the proof. No orphaned `set`/`clear_value` left.

---

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: none (STATUS block is historical but self-dated and accurate as written)
- **suspect definitions**: none (see notes on pre-existing sorries)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **`globalSectionsIso_hom_comp_specMap_appTop` (lines 265–271)**: Genuine, non-trivial. Calls `Scheme.ΓSpecIso_inv_naturality` with `rfl`-reductions for the `globalSectionsIso` ↔ `ΓSpecIso` identification. Correct.
  - **`gammaPushforwardIso` (lines 285–302)**: Route (b) element-free construction. Both towers peel by `rfl`; `ModuleCat.restrictScalarsComp'App` collapses each; `eqToIso` bridges via `globalSectionsIso_hom_comp_specMap_appTop`. Axiom-clean. The `hcomp` hypothesis at line 295 is genuinely required and correctly constructed via `congr(...)`.
  - **`gammaPushforwardTildeIso` (lines 310–316)**: Honest corollary of `gammaPushforwardIso` + `tilde.toTildeΓNatIso`. One-liner composite; not vacuous.
  - **`affineBaseChange_pushforward_iso` sorry (line 470)**: Pre-existing. The sorry is reached only after `rw [Modules.isIso_iff_isIso_app_affineOpens]; intro U`, i.e. after a genuine reduction step. The surrounding comment (lines 456–469) accurately describes the remaining gap (affine dictionary for tilde-modules). NOT silently widened: no new hypothesis has been removed or weakened.
  - **`flatBaseChange_pushforward_isIso` sorry (line 492)**: Pre-existing. Body comment (lines 484–491) gives a detailed Stacks-sourced strategy note. Honest; scope not widened.
  - **`fromTildeΓ_app_isIso_of_isLocalizedModule` (lines 331–375)**: Non-trivial. The `clear_value ρ` at line 353 is appropriate — it prevents `ρ` from being unfolded by unification when constructing `hρinst`. The triangle-identity step (`htri` at line 357) is honest. The final bijectivity comes from a `LinearEquiv` composite of two `IsLocalizedModule.iso`s — sound.
  - **`pushforward_spec_tilde_iso_of_isLocalizedModule` (lines 395–410)**: Conditional on `hloc`; the docstring accurately describes `hloc` as "the only outstanding obligation." No circularity: the `hloc` hypothesis is an explicit input, not derived from the conclusion.
  - **`IsLocalizedModule.powers_restrictScalars` (lines 419–438)**: Implements all three `IsLocalizedModule` fields (`map_units`, `surj`, `exists_of_eq`) by transporting from the hypothesis along `algebraMap`. Proof is mechanically sound.
  - **STATUS block (lines 181–244)**: Long historical note; accurately self-identifies as iter-234/236 updates. Not misleading (the `gammaPushforwardIso` it describes as axiom-clean is indeed present and clean). No cleanup required as code artefact, though a future refactor could trim it.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean (consumer)

- **outdated comments**: 4 flagged
- **suspect definitions**: none (pre-existing sorries; see notes)
- **dead-end proofs**: none
- **bad practices**: 1 flagged (unused hypotheses, documented)
- **excuse-comments**: none
- **notes**:
  - **Lines 43–48 — STATUS block stale.** The sentence reads: "The remaining typed-`sorry` residuals are the `⊗`-inverse lane (`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`) and the route-(e) whiskering residual `isLocallyInjective_whiskerLeft_of_W`." After iter-237, `isLocallyInjective_whiskerLeft_of_W` is closed; the phrase "and the route-(e) whiskering residual `isLocallyInjective_whiskerLeft_of_W`" should be removed.
  - **Lines 305–308 — `tensorObj_assoc_iso` docstring stale.** The status says: "it is `sorry`-transitive only through the route-(e) residual `isLocallyInjective_whiskerLeft_of_W`." With that residual now closed, `tensorObj_assoc_iso` is no longer sorry-transitive through it. The sentence should be updated to reflect axiom-clean status.
  - **Lines 308–313 — `tensorObj_assoc_iso` docstring step descriptions wrong.** Step 1 reads: "(P flat ⇒ right-whiskered `η ∈ J.W` by `W_whiskerRight_of_flat`)", and Step 3 reads: "(M flat)". The actual proof at lines 370–376 uses `PresheafOfModules.W_whiskerRight_of_W` and `PresheafOfModules.W_whiskerLeft_of_W` — neither requires flatness. The docstring's flat-route description is actively incorrect for the current proof.
  - **Lines 317–340 — `tensorObj_assoc_iso` docstring flatness-residual block stale.** This block describes "the flatness feeding steps 1 and 3" as "the genuine residual" and details why sectionwise flatness fails. Since route (d) resolves the associator without flatness, the entire block is now misleading noise.
  - **Lines 342–344 — Unused hypotheses `hM`, `hN`, `hP` in `tensorObj_assoc_iso`.** The signature carries `(hM : LineBundle.IsLocallyTrivial M) (hN : ...) (hP : ...)` but the proof body at lines 362–384 never references them (the `W_whisker*_of_W` lemmas hold for arbitrary `F`, not just locally-trivial ones). The body comment at line 348–350 acknowledges this explicitly ("are retained to match the blueprint pin"). Minor code smell; intentional per blueprint constraints.
  - **`exists_tensorObj_inverse := sorry` (line 717)**: Pre-existing load-bearing sorry. Body comment (lines 699–716) honestly documents the two remaining bridges (C and A) and flags the dead-end shortcut. Not widened this iter.
  - **`addCommGroup_via_tensorObj := sorry` (line 763)**: Pre-existing load-bearing sorry. Documented as iter-204+ closure target for the RPF sorry. Not widened this iter.
  - **`tensorObj_assoc_iso` body (lines 344–384)**: Consumer successfully uses the newly closed `W_whiskerRight_of_W` and `W_whiskerLeft_of_W` (lines 372, 375). No stale references to `_of_flat` in the proof body itself (only in the docstring — flagged above). The `letI instMS` carrier bridge (lines 351–353) is still present and necessary for the `MonoidalCategoryStruct` instance.

---

## Must-fix-this-iter

*Pre-existing load-bearing sorries — not newly introduced, but classified per auditor mandate.*

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:717` — `exists_tensorObj_inverse := sorry` on a load-bearing claim. Why must-fix: `:= sorry` on a substantive theorem; the line bundle group-inverse lane depends on it.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:763` — `addCommGroup_via_tensorObj := sorry` on a load-bearing claim. Why must-fix: `:= sorry` on the top-level `AddCommGroup` target for the relative Picard quotient.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:470` — `affineBaseChange_pushforward_iso` proof body contains `sorry`. Why must-fix: theorem is unproved; sorry reached after partial reduction.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:492` — `flatBaseChange_pushforward_isIso` proof body is `sorry`. Why must-fix: the main flat-base-change theorem is unproved.

---

## Major

- `AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean:16` — Module docstring bullet "one open sorry `isLocallyInjective_whiskerLeft_of_W`" is stale; the sorry is now closed. Creates confusion about the file's completeness status.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:43` — STATUS block erroneously lists `isLocallyInjective_whiskerLeft_of_W` among the remaining typed-sorry residuals.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:305` — `tensorObj_assoc_iso` docstring says the declaration is "sorry-transitive only through the route-(e) residual `isLocallyInjective_whiskerLeft_of_W`"; this is stale — the declaration is now transitively sorry-free through the closed whisker lemma.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:309` — `tensorObj_assoc_iso` docstring describes Steps 1 and 3 using `W_whiskerRight_of_flat` / "(P flat)" and "(M flat)" respectively, but the actual proof (lines 372, 375) uses `W_whiskerRight_of_W` / `W_whiskerLeft_of_W` with no flatness. The step descriptions directly contradict the proof.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:317` — `tensorObj_assoc_iso` docstring block "The genuine residual is now the flatness feeding steps 1 and 3" describes a problem that has been resolved; the whole block is now misleading.

---

## Minor

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:342` — `hM`, `hN`, `hP` declared in `tensorObj_assoc_iso` signature but unused in the proof body. Body comment acknowledges this as intentional (blueprint-pin conformance). Creates a potential linter warning.
- `AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean:508` — `erw [map_zero ...]` + `have`-term distribution chains in the `add`/`zero` cases of `isLocallyInjective_whiskerLeft_of_W` are fragile (syntactic carrier defeq wall). Justified by the documented comment at lines 504–506; not a bug but a maintenance risk if the defeq changes.

---

## Excuse-comments (always called out separately)

None found across all three audited files.

---

## Severity summary

- **must-fix-this-iter**: 4 — all pre-existing load-bearing sorries; classified per auditor mandate. Plan agent already tracks these as the primary open obligations.
- **major**: 5 — four stale comments (including two that actively mis-describe the `tensorObj_assoc_iso` proof's route) plus one that creates false sorry-status impression.
- **minor**: 2 — unused hypotheses (documented intentional) and fragile `erw` pattern (justified).
- **excuse-comments**: 0

**Overall verdict**: The three new declarations in Vestigial.lean (`isLocallyInjective_whiskerLeft_of_W`, `W_whiskerLeft/Right_of_W`) and the three in FlatBaseChange.lean are genuine non-vacuous constructions, and the FlatBaseChange sorries are honestly documented. The main actionable issue is a cluster of stale docstring content in TensorObjSubstrate.lean — particularly lines 309 and 317–340 where the `tensorObj_assoc_iso` docstring still describes the old flatness-based route (d.e) and flatness residual, actively contradicting the actual proof which uses the new `_of_W` lemmas.
