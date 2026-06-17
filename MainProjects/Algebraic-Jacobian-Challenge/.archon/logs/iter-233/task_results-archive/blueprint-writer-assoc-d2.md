# Blueprint Writer Report

## Slug
assoc-d2

## Status
INCOMPLETE — core reroute (Tasks 1a, 2a, 3-structure, 2b-`\uses`) APPLIED;
three prose items (Task 2b proof-body, Task 1b, Task 4) and the Task 3 verbatim
Stacks citation NOT completed. Cause: the tool **read** channel in this session
delivered output only once (a single large batch early on) and then stopped
returning any output for subsequent `Read`/`Bash`/`Grep` calls. Edits (`Write`/
`Edit`) appear to execute (no errors surfaced), but I could not re-read the file
to verify them, nor read the regions/reference still needed for the remaining
prose. I declined to blind-edit prose I cannot see in a 3700-line document.

**A verification pass in a healthy session is required** (confirm the applied
edits compiled/are well-formed, then finish the four sub-items below).

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes applied (verbatim-anchored from a confirmed early read; UNVERIFIED post-edit)
- **Task 1a** — Rewrote the "Superseded route ... must not be formalized"
  paragraph that precedes `lem:flat_whisker_localizer` → "Closed standalone
  result --- off the critical path": states the lemma IS formalized/sorry-free
  but is off-path because the associator now goes via the d.2 stalk route. Left
  the identical (correct) paragraph before `lem:whisker_of_W` untouched. Also
  replaced the stale `% SUPERSEDED ... still backing the current
  tensorObj_assoc_iso proof` comment above the lemma.
- **Task 2a** — `lem:tensorobj_assoc_iso`:
  - statement `\uses` repointed to `{def:scheme_modules_tensorobj,
    lem:islocallyinjective_whiskerleft_via_stalk, lem:stalk_tensor_commutation}`;
  - proof fully rewritten: the presheaf associator
    `PresheafOfModules.monoidalCategoryStruct.associator` exists for ALL modules;
    the substrate is its sheafification; transport across `L = sheafification`
    needs `F ◁ toSheafify ∈ J.W`, supplied unconditionally by the new d.2 lemma;
    hence the associator is unconditional. Drops the flat / open-`_of_W` /
    direct-gluing framing. Notes the group law consumes only existence.
- **Task 3 (structure)** — Inserted new
  `\section{Varying-ring stalk--tensor commutation (the ``d.2'' Mathlib gap)}`
  `\label{sec:tensorobj_stalk_tensor}`, before `lem:tensorobj_assoc_iso`, with:
  - `\lemma \label{lem:stalk_tensor_commutation}`
    `\lean{PresheafOfModules.stalkTensorIso}` + proof sketch (filtered-colimit /
    tensor-commutes-with-filtered-colimits over the varying base ring);
  - `\lemma \label{lem:islocallyinjective_whiskerleft_via_stalk}`
    `\lean{PresheafOfModules.isLocallyInjective_whiskerLeft_of_W}` + proof sketch
    (J.W ⇒ stalkwise iso; (F◁g)_x ≅ id⊗g_x via the commutation; functors
    preserve isos ⇒ stalkwise iso ⇒ in J.W ⇒ locally injective).
- **`% archon:covers`** — added a second line
  `% archon:covers AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean`.
- **Task 2b (partial)** — `lem:tensorobj_assoc_iso_invertible`: replaced
  `lem:tensorobj_restrict_iso, lem:flat_whisker_localizer}` →
  `lem:tensorobj_assoc_iso}` in BOTH its statement and proof `\uses` (drops the
  off-path `lem:flat_whisker_localizer`, points at the now-unconditional
  general associator). **The false "invertible ⟹ flat ⟹ sectionwise flat"
  argument in the proof BODY was NOT yet deleted** (needs the full prose I could
  not read).

## NOT completed (require a follow-up pass)
1. **Task 2b proof body** — delete the "invertible ⟹ locally free rank 1 ⟹ each
   `M(U)` flat over `𝒪_X(U)` ⟹ feed `lem:flat_whisker_localizer`" argument and
   the Stacks-0B8M flatness framing from `lem:tensorobj_assoc_iso_invertible`'s
   proof; replace with a one-line "specialize the unconditional
   `lem:tensorobj_assoc_iso` to invertible `M,N,P`".
2. **Task 1b** — in `sec:tensorobj_consistency_check`, rewrite the bullet that
   says `lem:flat_whisker_localizer` "is superseded on the critical path by the
   flatness-free `_of_W` variants": neither the flat whiskering NOR the `_of_W`
   whiskering is on the critical path any longer; the associator is realized
   unconditionally via the d.2 stalk-tensor commutation
   (`lem:islocallyinjective_whiskerleft_via_stalk`).
3. **Task 4** — on `thm:rel_pic_addcommgroup_via_tensorobj`, add the one-line
   prose note that its `\uses` of `lem:tensorobj_isoclass_commgroup` is DEFERRED
   and will repoint to `thm:pic_commgroup` when the carrier group lands (do NOT
   change the `\uses` this iter).
4. **Task 3 citation** — `lem:stalk_tensor_commutation` carries a
   `% SOURCE: ... VERBATIM SOURCE QUOTE could not be retrieved` placeholder
   instead of a real `% SOURCE QUOTE:`. The classical fact
   `(F ⊗_{O_X} G)_x = F_x ⊗_{O_{X,x}} G_x` is in the Stacks "Modules on Ringed
   Spaces" chapter, which is almost certainly the locally-present
   `references/stacks-modules.tex` (already cited elsewhere in this chapter for
   the f^*⊣f_* adjunction). A follow-up pass must open that file, find the
   tensor-product/stalk lemma, and paste the verbatim quote + `\textit{Source:}`
   line. I did NOT fabricate a quote (citation hard rule).

## Cross-references introduced (verify they resolve)
- New labels `lem:stalk_tensor_commutation`, `lem:islocallyinjective_whiskerleft_via_stalk`,
  `sec:tensorobj_stalk_tensor` — created in the Task 3 insertion; consumed by the
  rewritten `lem:tensorobj_assoc_iso` (`\uses` + `\cref`) and by the Task 1a
  paragraph. **If the Task 3 insertion edit somehow did not apply, these become
  dangling — verify first thing in the follow-up.**
- `lem:tensorobj_assoc_iso` added to `lem:tensorobj_assoc_iso_invertible`'s `\uses`.

## References consulted
- `references/summary.md` — confirms `references/stacks-modules.tex` is the local
  "Modules on Ringed Spaces" Stacks chapter (the Task 3 citation target).
- `references/stacks-modules.tex` — TARGET for the Task 3 verbatim quote; could
  NOT be opened successfully this session (read channel down), so no quote taken.

## Macros needed
- None new. (`\Scheme`, `\mathtt`, `\cref`, `\otimes^{p}` notation all already in use.)

## Notes for Plan Agent
- Potential `\lean{}` collision: the new `lem:islocallyinjective_whiskerleft_via_stalk`
  uses `\lean{PresheafOfModules.isLocallyInjective_whiskerLeft_of_W}` per the
  directive; if the pre-existing `lem:islocallyinjective_whisker_of_W` block also
  claims that same Lean name, the review/sync phase should reconcile (the
  directive's intent is that the NEW block is the one the closed proof backs).
- Strongly recommend re-running blueprint-review after the follow-up pass: this
  iteration's edits were applied without post-edit read verification.

## Strategy-modifying findings
None. The reroute is a faithful realization of the directive's d.2 plan; no
strategy-level contradiction surfaced. The only blocker was an environment
(tool-output) failure, not a mathematical one.
