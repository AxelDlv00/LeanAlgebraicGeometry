# Lean Audit Report

## Slug
iter037

## Iteration
037

## Scope
- files audited: 2 (per directive scope)
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean`

- **outdated comments**: 3 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 2 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **Line 31 — stale API name in docstring.** The docstring for the `overEquivalence` continuity section says "CompatiblePreserving is automatic for the cover-dense functors of an equivalence, so `Functor.IsContinuous` follows." This is inaccurate: the Mathlib lemma actually used (`Functor.IsCoverDense.isContinuous`, confirmed by LSP hover) requires `[G.IsCoverDense K]`, `[G.IsLocallyFull K]`, and `[G.IsLocallyFaithful K]` — not `CompatiblePreserving`. `CompatiblePreserving` appears in a separate Mathlib file and is not invoked here. The underlying claim (equivalences provide all required instances automatically) is mathematically correct, but the named predicate is wrong. A reader following the comment will look for a `CompatiblePreserving` instance that plays no role in this proof.
  - **Line 16 — module header understates file scope.** The header says "Route-P step P1a" but the file now hosts five distinct topic groups: P0 topology (`exists_finite_basicOpen_subcover`), P1b algebra (`SpanCoverLocalization`), P1a modules restriction, B3 topology (`overEquivalence` continuity, new this iter), and B2 presentation transport (`presentationOverBasicOpen`, new this iter). The label "P1a" is stale; it should at minimum say "P0/P1a/P1b + B2/B3 bricks".
  - **Lines 123–149 — section header claims B2–B4, delivers only B2.** The section is headed "Route B presentation transport (B2–B4)" but contains exactly one declaration (`presentationOverBasicOpen`) labelled as "step B2". B3 and B4 are aspirational. This will mislead a reader looking for B3/B4 in this section.
  - **Line 126 — `set_option backward.isDefEq.respectTransparency false` on `presentationOverBasicOpen` with no explanatory comment.** The option is scoped to a single `noncomputable def` and enables Lean to recognise the definitional equality `e.functor.obj (M.over W.left) =?= (M.over U).over W` at higher transparency (needed because `pushforward (𝟙 _)` reduces to the identity sheaf only under `all`-transparency). LSP axiom check confirms the declaration is axiom-clean (only `propext`, `Classical.choice`, `Quot.sound`), so no false math is hidden. However, the option is silently masking a transparency gap that could be addressed by a `show`/`change` + `ext` reduction, or at minimum documented with a one-line `-- needed because ...` comment. The current absence of documentation makes the hack invisible to a future maintainer.
  - **Line 46 — `show` used to change goal (Mathlib linter warning).** `show y.1 ∈ W.left` inside `overEquivalence_functor_coverPreserving` is flagged by the Mathlib style linter (`linter.style.show`): the `show` tactic changed the goal rather than simply annotating it. Mathlib style requires `change` for goal changes; `show` is for readability-only annotations. The proof is correct Lean but violates Mathlib style.
  - **Line 30 — line length exceeds 100 characters.** Mathlib style linter warning (trivial).
  - **No axiom concerns.** All six declarations introduced this iter (`overEquivalence_functor_coverPreserving`, `overEquivalence_inverse_coverPreserving`, `overEquivalence_functor_isContinuous`, `overEquivalence_inverse_isContinuous`, `presentationOverBasicOpen`, plus the preexisting P1a/P1b group) are axiom-clean per `lean_verify` (standard axioms only, no sorry, no unauthorized axioms).
  - **`overEquivalence_*_isContinuous` instances do not circularly assume what they prove.** Both `isContinuous` instances are derived via `Functor.IsCoverDense.isContinuous`, which takes the `CoverPreserving` proof as an explicit argument and infers `IsCoverDense`, `IsLocallyFull`, `IsLocallyFaithful` from the standard Mathlib equivalence-of-sites instances. There is no circularity: the `CoverPreserving` witnesses are distinct prior declarations, and the three typeclass instances are inferred from the fact that both functors are part of an equivalence (confirmed: Lean accepted the elaboration without any additional manual instance).
  - **`presentationOverBasicOpen` proof chain is sound.** `Presentation.ofIsIso` (confirmed by LSP hover) maps a presentation of the source along an iso to a presentation of the target; direction matches (`iso : e.inverse.obj ((M.over U).over W) ≅ M.over W.left`, `P2` a presentation of the source). The `letI e` equivalence from `pushforwardPushforwardEquivalence` is the same equivalence used to construct `e.inverse.obj`; `e.fullyFaithfulFunctor.preimageIso` is valid because equivalences are fully faithful.

---

### `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`

- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - Both new declarations (`coversTop_iSup_eq_top` private, `qcoh_finite_presentation_cover`) compile without any diagnostics (LSP reports no warnings or errors). Axiom-clean per `lean_verify` (standard axioms only).
  - `coversTop_iSup_eq_top` (lines 527–536): proof correctly destructs the `GrothendieckTopology.CoversTop` condition at `⊤`, extracts the covering sieve member, and returns the index. No issues.
  - `qcoh_finite_presentation_cover` (lines 547–555): correctly chains `hF.nonempty_quasicoherentData` → `coversTop_iSup_eq_top` → `exists_finite_basicOpen_subcover` → existential packaging. The explicit universe pinning `QuasicoherentData.{u, u, u, u}` is documented as necessary in project memory and does not hide false content.
  - The `Handoff` prose section (lines 559–605) accurately describes the current Mathlib gap and what steps 2–3 have formalised vs step 1 remaining. No overclaims.
  - Module header correctly scopes the file to the affine quasi-coherence structure theorem (Stacks 01HV/01I8) and is accurate throughout.

---

## Must-fix-this-iter

None. All new declarations are axiom-clean, no suspect proof bodies, no sorry, no excuse-comments, no weakened-wrong definitions.

---

## Major

- `QcohRestrictBasicOpen.lean:31` — Docstring for the `overEquivalence` continuity section names `CompatiblePreserving` as the predicate that makes `IsContinuous` automatic for equivalences. This is wrong: the actual Mathlib lemma (`Functor.IsCoverDense.isContinuous`) requires `IsLocallyFull` and `IsLocallyFaithful` (not `CompatiblePreserving`). The comment names a predicate that plays no role in the proof. Fix: replace with "these instances are automatically inferred from the fact that both functors are part of an equivalence (providing `IsCoverDense`, `IsLocallyFull`, `IsLocallyFaithful`)."

- `QcohRestrictBasicOpen.lean:126` — `set_option backward.isDefEq.respectTransparency false` on `presentationOverBasicOpen` is undocumented. The math is correct (no false axioms), but the transparency gap being bridged is invisible to a future maintainer. A `-- needed: e.functor.obj (M.over W.left) is definitionally (M.over U).over W only at all-transparency` comment or a `change` tactic should document or eliminate the need.

---

## Minor

- `QcohRestrictBasicOpen.lean:16` — Module header "Route-P step P1a" is stale; file now contains P0/P1a/P1b and B2/B3 bricks.
- `QcohRestrictBasicOpen.lean:123` — Section header "Route B presentation transport (B2–B4)" overclaims; only B2 is present.
- `QcohRestrictBasicOpen.lean:46` — `show` tactic used to change goal; Mathlib style requires `change`. Linter warning confirmed by LSP.
- `QcohRestrictBasicOpen.lean:30` — Line exceeds 100-character Mathlib style limit. Linter warning confirmed by LSP.

---

## Excuse-comments (always called out separately)

None.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 4
- **excuse-comments**: 0

Overall verdict: Both files are axiom-clean with no sorry and no unauthorized axioms; the two major findings are a stale API-name in a docstring (`CompatiblePreserving` vs `IsLocallyFull`/`IsLocallyFaithful`) and an undocumented transparency option on `presentationOverBasicOpen` — neither blocks downstream work but both should be fixed before the file exits the project's active zone.
