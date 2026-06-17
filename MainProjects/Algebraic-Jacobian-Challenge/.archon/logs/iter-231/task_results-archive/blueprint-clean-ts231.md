# blueprint-clean — ts231

## File cleaned
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## What was done

### Target block: `lem:dual_isLocallyTrivial`
(The plan agent's edit targeted label `lem:dual_restrict_iso`, which does not exist in the
current file; the semantically equivalent block in the chapter is `lem:dual_isLocallyTrivial`,
at lines ~2907–3008. The plan agent's Edit call failed because the old_string did not match.
The blueprint-clean pass applied the intended correction directly to the correct block.)

**Statement `\uses{}` fixed (line 2912):**
Removed `lem:open_immersion_slice_sheaf_equiv` — this entry was spurious because the correct
proof does not use that equivalence (confirmed empirically in iter-230; the analogist
report ts231ih also confirmed it as the wrong level).

**Statement-level NOTE stripped (lines 2913–2936 → 3 lines):**
The verbose 24-line developer note (iter-228 tag, Lean identifier names such as
`pushforward beta`, `restrictScalars`, `restrictScalarsRingIsoDualEquiv`,
reference to `task_results/.../TensorObjSubstrate.lean.md`) was replaced with a
minimal source citation block. The `% SOURCE QUOTE:` was verified against
`references/stacks-modules.tex` L4207–4211 and is authentic.

**Proof `\uses{}` fixed (line 2956):**
Same removal of `lem:open_immersion_slice_sheaf_equiv`.

**Wrong proof paragraph replaced (old lines 3002–3038 → ~30 lines):**
The old content was:
1. A 11-line `% NOTE` comment (iter-230 label, Lean goal expressions
   `(PresheafOfModules.pushforward β).obj (dual M.val)`, references to internal tool logs
   `lean_goal`/`lean_multi_attempt`/`overSliceSheafEquiv`).
2. A mathematically incorrect paragraph claiming the residual is discharged by
   `lem:open_immersion_slice_sheaf_equiv` (the fixed-value-category sheaf-site equivalence
   — confirmed wrong in iter-230: 3 mismatches — sheaf vs presheaf level, fixed vs
   varying-ring module action, slice site shape mismatch).

Replaced with:
1. A correct mathematical proof recipe: the residual is the classical presheaf-level
   comparison `f_* ℋom(A, 𝒪) ≅ ℋom(f_*A, f_*𝒪)`, constructed objectwise via the
   ring-isomorphism transport `lem:restrictscalars_ringiso_dualequiv` and thinness of
   `Opens`.
2. A concise italic route note "(iter-230, settled empirically)" warning against the
   wrong approach — no Lean identifiers, no internal file references.

### Light pass over rest of chapter
- One pre-existing `% NOTE (iter-224):` block at ~line 2615 (now 2615 after edits)
  has project-history content and Lean identifier names (`internalHomEvalApp`,
  `whnf heartbeat-bomb`). It lives entirely in `%` comments (not rendered) and
  the directive says not to rewrite unrelated blocks; left as-is.
- No fabricated `% SOURCE QUOTE` blocks found during the pass.
- No Lean tactic syntax in rendered prose was introduced by the cleaned block.

## Residual notes for prover
- The proof body (pre-existing content, Steps 1–3 + H1, lines ~2944–2976) still
  uses `\mathtt{...}` formatting for Lean names (`restrictFunctorIsoPullback`,
  `pushforwardPushforwardAdj`, `Adjunction.leftAdjointUniq`, `restrictScalars`,
  `Over`) in rendered prose. This is the chapter's established style and out of scope
  for this pass.
- The new recipe requires building the presheaf-level comparison objectwise
  (`lem:restrictscalars_ringiso_dualequiv` + thinness); this is a ~150–300 LOC
  build not yet in the project. The proof block is correct but sorry-bearing.

## `\leanok` / `\mathlibok` markers
None added or removed.
