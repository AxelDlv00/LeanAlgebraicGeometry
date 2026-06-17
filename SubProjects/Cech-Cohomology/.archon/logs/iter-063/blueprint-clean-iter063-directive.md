# Blueprint-clean directive — iter-063

**Chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (only this file).

A blueprint-writer pass this iter edited this chapter:
- Rewrote the proof of `lem:pushforward_slice_pullback_iso` onto the `leftAdjointUniq` route + added a new
  sub-lemma `lem:pushforward_slice_two_adjunction` and Mathlib anchors.
- Expanded `lem:pushPull_binary_coprod_prod` to the `q_*`-coherence assembly + added a new sub-lemma
  `lem:pushPull_binary_leg_coherence`.
- Bundled coverage-debt helper names into existing `\lean{...}` lists.

Enforce blueprint purity on the edited blocks (and lightly across the chapter):
- Strip any Lean tactic syntax / Lean-identifier leakage that crept into the prose proofs (the writer was
  given Lean lemma names as guidance — those belong in `\uses{}`/`\lean{}`/`\mathlibok` anchors and as
  named references in prose, NOT as tactic snippets or `by ...` blocks).
- Remove project-history / iteration-narrative verbosity ("the iter-062 prover found…", "churning", etc.)
  if any leaked into the prose.
- Verify every `\uses{}` label introduced this iter resolves to a real `\label{}` in some chapter; fix
  dangling refs.
- Confirm `% SOURCE`/`% SOURCE QUOTE` citations on the edited blocks are intact (do not fabricate; if a
  quote is missing and you cannot verify it locally, leave a `% NOTE:` rather than inventing one).
- Do NOT touch `\leanok`. You MAY keep `\mathlibok` on the genuine Mathlib anchors the writer added.

Keep edits minimal and surgical.
