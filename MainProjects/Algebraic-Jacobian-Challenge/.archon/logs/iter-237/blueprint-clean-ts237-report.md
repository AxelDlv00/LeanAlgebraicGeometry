# blueprint-clean report — iter-237

## Summary

Three targeted edits across two chapters. No Lean tactic strings or project-history
narrative in the new lemma blocks themselves; issues found in one pre-existing NOTE
that the current writer preserved, and one implementation-note paragraph added to the
rewritten proof.

---

## `Picard_TensorObjSubstrate.tex`

### Change 1 — Removed `% NOTE (iter-236)` block

**Location:** inside `\begin{lemma}[lem:stalk_tensor_commutation]`, between the
`\lean{...}` and `\uses{...}` declarations.

**Issue:** Seven-line comment contained:
- explicit iteration number `iter-236` (project-history narrative)
- Lean axiom list `{propext, Classical.choice, Quot.sound}` (implementation detail)
- Lean identifiers in backtick syntax: `` `stalkTensorIso` ``, `` `stalkTensorBilin` `` etc.

**Action:** Removed the block entirely; `\lean{...}` is now directly followed by
`\uses{...}`.

---

### Change 2 — Rewrote closing paragraph of `lem:islocallyinjective_whiskerleft_via_stalk` proof

**Location:** Last paragraph of the proof block (the three-movement proof newly written
by `d2wiring`).

**Issue:** The paragraph opened with "The Lean lemma is stated over a general site",
contained the Lean-style assignment `R := X.\mathtt{presheaf}`, and cited the Lean
consumer names `\mathtt{W\_whiskerLeft\_of\_W}` / `\mathtt{W\_whiskerRight\_of\_W}`
with the phrasing "already instantiate at \(X.\mathtt{presheaf}\)". These are
implementation-level notes about the Lean declaration, not pure mathematics.

**Action:** Replaced with:

> The statement holds over any Grothendieck site \(J\) satisfying
> \(J.\mathtt{WEqualsLocallyBijective}\,\mathtt{Ab}\), and is applied in particular
> at the topological site \(\mathtt{Opens}\,X\) of a scheme, where the stalk
> arguments of (a)--(c) are available and through which the unconditional associator
> \cref{lem:tensorobj_assoc_iso} is realized.

---

## `Cohomology_FlatBaseChange.tex`

### Change 3 — Added missing `\uses` dependency in `lem:pushforward_spec_tilde_iso` proof

**Location:** `\uses{...}` in the `\begin{proof}` block of `lem:pushforward_spec_tilde_iso`.

**Issue:** The rewritten proof (by `fbcqc`) explicitly invokes
`Lemma~\ref{lem:gammaPushforwardTildeIso}` to construct the comparison morphism `α`,
but the `\uses{}` declaration only listed `lem:modules_isIso_of_isBasis`. This is a
LaTeX cross-reference inconsistency.

**Action:** Changed to `\uses{lem:modules_isIso_of_isBasis, lem:gammaPushforwardTildeIso}`.

---

## Validation

### New lemma blocks — no issues found

All four blocks added/rewritten by the writers this iteration were checked:

- `lem:W_implies_stalkwise_iso` — clean mathematical prose; the Lean identifiers
  cited (`\mathtt{TopCat.Presheaf.isIso\_iff\_...}` etc.) follow the established
  `\mathtt{...}` style throughout the file.
- `lem:stalk_tensor_commutation_naturality_right` — clean; germ-level computation
  cites Lean names in the established style.
- Three Γ-fragment lemmas in FlatBaseChange (`lem:globalSectionsIso_hom_comp_specMap_appTop`,
  `lem:gammaPushforwardIso`, `lem:gammaPushforwardTildeIso`) — clean; proofs are pure
  algebra/adjunction arguments.
- Rewritten proof of `lem:pushforward_spec_tilde_iso` — clean after the `\uses` fix above.

### `% SOURCE QUOTE` blocks

All pre-existing `% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:` blocks were left
byte-intact. No new blocks in the added content (all new blocks are bespoke and
correctly carry no SOURCE lines).

### `\leanok` / `\mathlibok` markers

None added or removed.

### Off-path duplicate `lem:islocallyinjective_whisker_of_W`

Preserved as instructed.

---

## Files modified

- `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (2 edits)
- `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (1 edit)
