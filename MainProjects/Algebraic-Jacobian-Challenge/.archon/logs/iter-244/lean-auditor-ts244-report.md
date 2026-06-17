# Lean Audit Report

## Slug
ts244

## Iteration
244

## Scope
- files audited: 1 (directive narrowed to one file)
- files skipped (per directive): all other project `.lean` files — scope restricted by directive to TensorObjSubstrate.lean

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 1 flagged (L43-46 — false causal link)
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 1 flagged (34× deprecated `Sheaf.val` API)
- **excuse-comments**: 0
- **notes**:
  - **PullbackLanDecomposition section (L1237–1298): signatures are honest.** Every declaration (`pullback0`, `extendScalars`, `pullback0Adjunction`, `extendScalarsAdjunction`, `pullbackLanDecomposition`) declares real mathematical types (functors, adjunctions, nat-isos). No placeholder or vacuous statements.
  - **`_root_.PresheafOfModules` qualifiers are consistent.** They appear in 10+ sites (L159, L246, L295, L501, L1064, L1142, L1213 etc.) and consistently resolve `PresheafOfModules` at the root namespace to avoid shadowing by the project's `AlgebraicGeometry` namespace. No inconsistency or wrong-namespace masking found.
  - **`pushforward₀IsRightAdjoint` (L1245-1247): genuinely proved.** `inferInstanceAs (pushforward.{u} (𝟙 (F.op ⋙ R))).IsRightAdjoint` — lean_hover at L1247 col 3 confirms the inferred type resolves to `(pushforward₀ F R).IsRightAdjoint`. Axiom check: propext, Classical.choice, Quot.sound only (no sorry, no foreign axioms). The underlying defeq `pushforward₀ F R = pushforward (𝟙 (F.op ⋙ R))` (since `restrictScalars 𝟙 = 𝟭`) is real.
  - **`restrictScalarsIsRightAdjoint` (L1251-1254): genuinely proved.** `inferInstanceAs (pushforward.{u} (F := 𝟭 C) φ).IsRightAdjoint` — axiom check: standard only. The defeq `restrictScalars φ = pushforward (F := 𝟭) φ` is real.
  - **`pullbackLanDecomposition` (L1291-1297): axiom-clean.** The `Iso.refl (pushforward φ)` argument works because `pushforward φ = pushforward₀ F R ⋙ restrictScalars φ` holds definitionally — confirmed by the file compiling with zero errors.
  - **`tensorObj_assoc_iso` unconditional claim: verified accurate.** `lean_verify` reports standard axioms only (no sorryAx). The proof at L321-361 uses `W_whiskerRight_of_W`, `W_whiskerLeft_of_W`, `isIso_sheafification_map_of_W` — none of which require flatness or local triviality. The docstring's claim "UNCONDITIONAL and axiom-clean (iter-238 ROUTE (d))" is correct.
  - **FILE HEADER claim about `isLocallyInjective_whiskerLeft_of_W` (L43-46): MISLEADING.** The header says "The route-(e) whiskering residual `isLocallyInjective_whiskerLeft_of_W` was CLOSED iter-237 in Vestigial.lean, **so** `tensorObj_assoc_iso` is now unconditional". The causal "so" is wrong: the ROUTE (d) proof of `tensorObj_assoc_iso` (L321-361) does NOT use `isLocallyInjective_whiskerLeft_of_W` (confirmed by grep — the name appears only in the comment at L45). ROUTE (d) uses an independent path via Mathlib's `W_whisker*` lemmas. The header's "so" implies closing that lemma was the enabling step for `tensorObj_assoc_iso`, which is factually incorrect for the current proof.
  - **Cross-file observation (Vestigial.lean, outside audit scope but relevant to header accuracy):** `isLocallyInjective_whiskerLeft_of_W` is axiom-clean (verified; standard axioms only). Vestigial.lean's own header still says "one open sorry `isLocallyInjective_whiskerLeft_of_W`" — stale. And Vestigial.lean's docstring for that lemma says it is "the single residual ingredient of the associator `tensorObj_assoc_iso` under ROUTE (d)" — also stale, since the actual ROUTE (d) proof doesn't use it.
  - **`exists_tensorObj_inverse` (L672-694): honest typed sorry.** `lean_verify` confirms `sorryAx`. Statement type is correct: `∃ Linv : X.Modules, LineBundle.IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf)`. Body comment (L678-693) accurately describes the two remaining bridges (C: `dual_isLocallyTrivial`, A: `homOfLocalCompat`) and names the forbidden shortcut. Not laundered.
  - **`addCommGroup_via_tensorObj` (L1328-1331): honest typed sorry.** `lean_verify` confirms `sorryAx`. Return type is `AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))` — the correct consumer target. Not laundered. The `@[implicit_reducible]` retention is explained (linter warning on `def` of class type without it).
  - **Deprecated API: 34 occurrences of `CategoryTheory.Sheaf.val`** (compiler warnings at L141, 157, 197, 209, 244, 261, 263, 273, 275, 283, 285, 293, 328, 331, 336, 355, 357, 1065, 1067, 1070, 1072, 1073, 1076, 1078, 1094, 1096, 1183, 1189, 1205). Mathlib has deprecated `.val` on `Sheaf` in favour of `ObjectProperty.obj`. All usages are syntactically `.val` on `X.ringCatSheaf` or `X.ringCatSheaf.val`. Non-blocking now but will become a hard break on a future Mathlib bump.
  - **`pullbackObjUnitToUnit_comp` proof (L902-988):** uses `erw` at L975-988. Comment explains why (`SheafOfModules` compositions are defeq-but-not-syntactic). The explanation is accurate. Acceptable, but noteworthy as a smell.
  - **Long-line linter warnings at L483-485** (inside `isIso_of_isIso_restrict` proof, column > 100). Minor style issue.
  - **No must-fix issues found.** No wrong definitions, no axiom abuse, no excuse-comments, no laundered sorries, no dead-end scaffolding on any critical path.

---

## Must-fix-this-iter

None.

---

## Major

- `TensorObjSubstrate.lean:43-46` — File header's causal "so" between `isLocallyInjective_whiskerLeft_of_W` being closed and `tensorObj_assoc_iso` becoming unconditional is factually wrong. The ROUTE (d) proof (L321-361) doesn't use that lemma at all. A reader tracing the proof history would conclude the wrong thing about the architecture. Should be corrected to reflect that ROUTE (d) is independent of the ROUTE (e) `isLocallyInjective_whiskerLeft_of_W` ingredient.

- `TensorObjSubstrate.lean` (34 sites) — `CategoryTheory.Sheaf.val` is deprecated; compiler emits 34 warnings. Replacement is `ObjectProperty.obj`. Not blocking today but accumulates debt against Mathlib compatibility.

---

## Minor

- `TensorObjSubstrate.lean:483-485` — Three lines exceed the 100-character Mathlib style limit (linter warning).
- `TensorObjSubstrate.lean:902-988` (`pullbackObjUnitToUnit_comp`) — `erw` used in 5 places where `rw` fails due to defeq-not-syntactic `SheafOfModules` composition forms. Acceptable given the explanation, but a candidate for simplification if Mathlib adds lemmas at the right syntactic form.

---

## Excuse-comments (always called out separately)

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2 (misleading header comment; 34 deprecated-API warnings)
- **minor**: 2 (long lines; `erw` usage in pullbackObjUnitToUnit_comp)
- **excuse-comments**: 0

Overall verdict: File is fundamentally sound — no laundered sorries, no wrong definitions, PullbackLanDecomposition section is axiom-clean with genuine `inferInstanceAs` proofs and honest signatures; the two sorries are properly typed and accurately documented. Main actionable issue is a stale/misleading causal claim in the file header, plus accumulated deprecated-API warnings.
