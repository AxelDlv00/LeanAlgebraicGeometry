# Blueprint Writer Report

## Slug
ts-step7

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

- **Added lemma (the `rfl` linchpin)** — `\begin{lemma}` /
  `\label{lem:sheafification_comp_pullback_eq_leftadjointuniq}` /
  `\lean{AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_eq_leftAdjointUniq}`,
  placed immediately BEFORE `lem:leftadjointuniq_app_unit_eta`. States that the canonical
  "sheafify-then-pullback" comparison `sheafificationCompPullback φ` equals
  `Adjunction.leftAdjointUniq A B`, where `A` is the (sheafification on X) ∘ (sheaf-level
  pullback–pushforward of φ) composite adjunction and `B` is the (presheaf-level
  pullback–pushforward of φ') ∘ (sheafification on Y) composite. Proof sketch: the two
  composites have a definitionally equal right adjoint (pushforward commutes with the
  forgetful-to-presheaves on the nose), so `leftAdjointUniq A B` is defined and unfolds to the
  same morphism as the comparison; equality holds by reflexivity. No `\leanok` added.
  - Proof sketch added: Y (definitional-right-adjoint / reflexivity argument).

- **Revised** `lem:leftadjointuniq_app_unit_eta` (step 4) — added
  `lem:sheafification_comp_pullback_eq_leftadjointuniq` to BOTH the statement `\uses{}` and the
  proof `\uses{}`, and added a `\cref` to it in the proof prose where
  `sheafificationCompPullback φ` is rewritten to `Adjunction.leftAdjointUniq A B`.

- **Retyped** `lem:epsilon_presheaf_to_sheaf_unit` (step 7) — DELETED the
  `% NOTE (iter-248 review)` block. Replaced the ill-typed sheaf-level
  `ε(pushforward φ) = unitToPushforwardObjUnit φ` statement with a `.val`-level
  (underlying-presheaf) reconciliation: the presheaf lax unit `ε(pushforward φ')` and the
  sheaf-level `unitToPushforwardObjUnit φ` agree after applying the forgetful `(-).val`,
  acting on sections as the ring map `φ.hom.app X` —
  `(unitToPushforwardObjUnit φ).val.app X a = φ.hom.app X a`. Added the sentence noting the
  exact Lean form is the `.val`-level reconciliation because there is no `LaxMonoidal` instance
  on the sheaf pushforward (only `PresheafOfModules.pushforward φ'` carries the presheaf lax
  unit), reconciled via the sheafification ↔ pushforward compatibility. Proof retyped to a
  sectionwise argument bottoming out in `φ.hom.app X`, then tracing the sheafification
  reconciliation back to the step-6 presheaf head `ε(pushforward φ')`. `\lean{…epsilonPresheafToSheafUnit}`
  pin kept; `\label` kept. No sheaf-level `ε` remains in this block.

## New linchpin block coordinates
- `\label{lem:sheafification_comp_pullback_eq_leftadjointuniq}`
- `\lean{AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_eq_leftAdjointUniq}`

## Confirmation: step-7 block no longer references sheaf-level `ε`
Confirmed. `grep` shows the only surviving `ε(pushforward φ)` (sheaf-level) is at the assembly
lemma `lem:eta_bridge_unit_square` step-7 PROSE (line ~3578), which the directive explicitly
placed out of scope. The retyped `lem:epsilon_presheaf_to_sheaf_unit` block itself uses only the
presheaf-level `ε(pushforward φ')` and the `.val`-level form.

## Cross-references introduced
- `\uses{lem:sheafification_comp_pullback_eq_leftadjointuniq}` added to statement + proof of
  `lem:leftadjointuniq_app_unit_eta` — target is the new block in this same chapter. OK.
- New block's `\cref` targets (`sheafificationAdjunction`, `pullbackPushforwardAdjunction`) are
  inline `\mathtt{}` Lean-name references, not `\uses{}` edges; no new dangling `\uses{}`.

## `\uses{}` edges dropped
None. The directive's contingency (drop `lem:presheaf_pushforward_laxmonoidal` if it has no
`\label`) did NOT trigger: `lem:presheaf_pushforward_laxmonoidal` has a `\label` at line 2716, so
it was kept in the step-7 block's `\uses{}`.

## References consulted
None — this material is Archon-original categorical mate-calculus with no external source, so no
`% SOURCE`/`% SOURCE QUOTE` lines were required (per directive).

## Macros needed (if any)
None.

## Notes for Plan Agent
- The assembly lemma `lem:eta_bridge_unit_square` step-7 PROSE still writes the sheaf-level
  `ε(pushforward φ) = unitToPushforwardObjUnit φ` (line ~3578). This was out of scope for this
  round, but it is the same ill-typed sheaf-`ε` notation just removed from the step-7 lemma block.
  If you want the chapter fully consistent, a follow-up directive could retype that one prose
  sentence to the `.val`-level reconciliation as well (it is narrative, not a `\lean`-pinned
  statement, so it does not block the prover — but it reads inconsistently with the now-corrected
  `lem:epsilon_presheaf_to_sheaf_unit`).

## Strategy-modifying findings
None.
