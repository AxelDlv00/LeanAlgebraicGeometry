# Blueprint-clean directive — bc253

## Chapter to clean (ONLY this file)
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Context
The blueprint-writer (bw253) just made four targeted edits this iter:
1. Rewrote the D1′ fourth-square proof of `lem:pullback_tensor_map_natural` (whisker-exchange route →
   section-level descent route).
2. Added three statement-only `\lean{}`-pinned helper blocks:
   `lem:sheafify_tensor_unit_iso_natural`, `lem:pullback_val_iso_natural`,
   `lem:scheme_modules_hom_local_section`.
3. Expanded sub-step (a) (HEq → IsCompatible bridge) in the `lem:sheafofmodules_hom_of_local_compat`
   proof.
4. Polished the `lem:dual_unit_iso` proof prose + dropped one `\uses` entry.

## Your job
Enforce blueprint purity ON THE bw253-EDITED BLOCKS specifically (you may scan the whole chapter, but
the edits are concentrated in the four blocks above). In particular:
- **Strip Lean-syntax leakage** that crossed the "mathematical intent, not tactic strings" line. The
  edits legitimately name a few Lean *principles* as signposts (`PresheafOfModules.Hom.ext`,
  `ModuleCat.hom_ext`, `TensorProduct` induction, `Subsingleton.elim`, `eqToHom`) — these are
  acceptable as "the formalization proceeds via …" pointers. But remove any actual tactic-sequence
  prose, `simp only [...]`/`erw [...]` fragments, or step-by-step Lean recipe that leaked into the
  rendered prose. The mathematical content (the fourth square reduces to bilinear sectionwise
  η-naturality; the HEq collapses to genuine equality via thin-poset uniqueness) must remain.
- **Remove project-history verbosity**: trim any `% NOTE (iter-NNN)` comments that are now redundant
  with the corrected prose (the writer already trimmed the iter-252 notes to short iter-253 pointers;
  drop them entirely if the prose now stands on its own).
- **Verify LaTeX validity**: `\begin`/`\end` balance, `\label`/`\lean`/`\uses`/`\cref` well-formed,
  the three new blocks parse. (The writer flagged a PRE-EXISTING false-positive at ~line 1632 inside a
  `% SOURCE QUOTE:` comment of `lem:tensorobj_inverse_invertible` — leave that alone; it is unrelated.)
- **Do NOT touch `\leanok`/`\mathlibok` markers** (sync owns `\leanok`, review owns `\mathlibok`).
- **Do NOT alter mathematical content** — you are a purity/format gate, not a math editor.

## Report
List what you stripped/trimmed per block, and confirm the four edited blocks are math-pure and LaTeX-valid.
