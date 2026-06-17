# Blueprint-clean directive — iter-215

## Chapter edited this iter (focus here)

`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` received two writer rounds this iter:
1. A freshness pass (corrected the stale "no stalk infrastructure" claim; added the d.1-core
   `lem:stalk_linear_map` block; split d.1 into done/bridge/d.2; named the `WEqualsLocallyBijective`
   hypothesis).
2. A locally-trivial-first refinement (added the PRIMARY locally-trivial proof route to
   `lem:islocallyinjective_whisker_of_W`; reframed `lem:tensorobj_isoclass_commgroup` to build the
   group directly on invertible iso-classes à la `Module.Invertible`; added a "Two-tier strategy"
   paragraph; consistency-check upkeep).

## What to enforce

Standard blueprint purity on this chapter (and a light scan of siblings if anything looks off):
- Strip any Lean tactic syntax / code that leaked into prose (Mathlib *declaration/file names* used
  as software references — e.g. `Module.Invertible`, `LocalizedMonoidal`, `tensorObj_restrict_iso`,
  `Mathlib/RingTheory/PicardGroup.lean` — are ACCEPTABLE as named concepts/pointers and should be
  kept; what to strip is tactic strings, `by ...` blocks, `:= ...` term syntax, Lean proof code).
- Verify `% SOURCE` / `% SOURCE QUOTE` blocks on edited declarations are intact and verbatim (the
  writers were told to leave existing Stacks/Kleiman quote blocks untouched).
- Remove project-history verbosity / iteration narrative if any crept into the prose (iter-NNN
  references in rendered text).
- Confirm LaTeX environment balance for real (non-comment) environments.

Do NOT add or remove `\leanok`/`\mathlibok`. Do NOT change mathematical content or statements.
Report any insertions/removals you make.
