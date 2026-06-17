# Blueprint-clean report — iter-233 — Picard_TensorObjSubstrate.tex

## Citation validation: `lem:stalk_tensor_commutation`

**PASS.** The `% SOURCE QUOTE:` block quotes `references/stacks-modules.tex` L2332–L2344,
lemma `lemma-stalk-tensor-product`. Verified against the file:

- `\label{lemma-stalk-tensor-product}` is at line 2333 (grep confirms).
- Content of L2332–2344 matches the quoted block verbatim:
  `\begin{lemma}` … `Let $(X, \mathcal{O}_X)$ be a ringed space.` …
  `(\mathcal{F} \otimes_{\mathcal{O}_X} \mathcal{G})_x = \mathcal{F}_x
  \otimes_{\mathcal{O}_{X, x}} \mathcal{G}_x` …
  `\end{lemma}`

No discrepancy found. The `\textit{Source: …}` attribution line in the chapter is
consistent.

---

## Fixes applied (4 edits)

### Fix 1 — `lem:stalk_linear_map`: removed stale "not to be formalized" annotation

**Problem.** The introductory paragraph before `lem:stalk_linear_map` (old text) said:
> "Superseded route --- off path, not to be formalized. … The group law never invokes
> stalks: the associator is built by direct gluing (via lem:tensorobj_restrict_iso).
> This block is retained for the historical record only and must not be formalized."

This is factually wrong post this-iter edit: `lem:stalk_linear_map` is now in the
`\uses{}` of both `lem:stalk_tensor_commutation` and
`lem:islocallyinjective_whiskerleft_via_stalk` — both live lemmas in the new d.2
section (`sec:tensorobj_stalk_tensor`). The "must not be formalized" label is stale.

**Fix.** Replaced with accurate description identifying the lemma as a live d.1
ingredient consumed by the d.2 route. Also updated the `% SUPERSEDED route …`
comment inside the lemma and the body text (lines 1103–1108) to reflect that the
four declarations are consumed by `lem:stalk_tensor_commutation` and
`lem:islocallyinjective_whiskerleft_via_stalk`, not by `lem:islocallyinjective_whisker_of_W`.

### Fix 2 — `lem:flat_whisker_localizer`: updated stale "live route" claim

**Problem.** The lemma body said:
> "the live whiskering-stability data for J.W.IsMonoidal (route~(e)) are the
> flatness-free variants W_whiskerLeft_of_W / W_whiskerRight_of_W (lem:whisker_of_W)
> … superseded on the critical path by the _of_W variants of lem:whisker_of_W."

With this iter's changes, `lem:whisker_of_W` is NOT the live superseder; the actual
live route closes the whiskering obligation via the d.2 stalk–tensor commutation
`lem:islocallyinjective_whiskerleft_via_stalk`.

**Fix.** Replaced with: "the live whiskering-stability obligation for the unconditional
associator is closed for an arbitrary whiskering object F by the stalk–tensor
commutation lem:islocallyinjective_whiskerleft_via_stalk (sec:tensorobj_stalk_tensor)
… superseded on the critical path by the d.2 route of sec:tensorobj_stalk_tensor."

### Fix 3 — `lem:tensorobj_isoclass_commgroup`: removed stale "group law never invokes d.2" claim

**Problem.** The "lower-risk path" paragraph said:
> "The only remaining obligations … lem:tensorobj_restrict_iso (which the primary
> whisker route of lem:islocallyinjective_whisker_of_W also now consumes) and …
> lem:tensorobj_inverse_invertible. In particular the group law never invokes the
> stalk–tensor commutation (d.2) over a varying ring."

Both claims are now stale:
- The parenthetical about "primary whisker route of lem:islocallyinjective_whisker_of_W"
  is stale; the assoc now goes through d.2 rather than the PRIMARY route of that lemma.
- "The group law never invokes d.2" is false: the group law's uses chain now
  transitively passes through `lem:tensorobj_assoc_iso` →
  `lem:islocallyinjective_whiskerleft_via_stalk` → `lem:stalk_tensor_commutation`.

**Fix.** Replaced with: "The only remaining obligations … lem:tensorobj_restrict_iso
and … lem:tensorobj_inverse_invertible. The associator lem:tensorobj_assoc_iso is
supplied by the unconditional route of sec:tensorobj_stalk_tensor and transitively
invokes the d.2 stalk–tensor commutation lem:stalk_tensor_commutation."

### Fix 4 — Consistency check section: updated stale `lem:flat_whisker_localizer` description

**Problem.** The `sec:tensorobj_consistency_check` bullet said lem:flat_whisker_localizer
is "superseded on the critical path by the flatness-free _of_W variants lem:whisker_of_W."
This is stale for the same reason as Fix 2.

**Fix.** Updated to "superseded on the critical path by the d.2 route of
sec:tensorobj_stalk_tensor (lem:islocallyinjective_whiskerleft_via_stalk)."

---

## Flagged contradictions (not fixed — per directive)

### Flag A — `lem:tensorobj_assoc_iso` proof: two inconsistent route descriptions

The proof of `lem:tensorobj_assoc_iso` opens with:
> "Realization (route~(e), unconditional via d.2). … The transport requires the
> left-whisker … (route~(e), via lem:whisker_of_W, lem:islocallyinjective_whisker_of_W);
> that single open left-whiskering obligation is now closed … by the d.2 stalk–tensor
> commutation lem:islocallyinjective_whiskerleft_via_stalk."

But then the proof closes with:
> "The vestigial whiskering / (J.W).IsMonoidal / stalk apparatus
> (lem:whisker_of_W, lem:islocallyinjective_whisker_of_W, lem:jw_ismonoidal) plays
> no part in this proof and is superseded."

**Contradiction:** the opening paragraph says `lem:whisker_of_W` and
`lem:islocallyinjective_whisker_of_W` are involved (as the route whose obligation
d.2 closes), while the closing paragraph says they "play no part." The `\uses{}` field
agrees with the closing paragraph (includes `lem:islocallyinjective_whiskerleft_via_stalk`
but not `lem:whisker_of_W`). The opening paragraph should either be reworded to say
"this closes the same obligation that those lemmas were meant to handle, without
invoking them" or the closing paragraph should be softened.

### Flag B — `sec:tensorobj_route_e` claims "no stalk machinery"

The section header and intro (lines 1026–1041) say:
> "which uses no (J.W).IsMonoidal, no LocalizedMonoidal, and no stalk machinery."
> "Accordingly the whiskering-stability lemmas and the stalk apparatus of this section
> are vestigial and must not be re-attempted."

But the new live route (`sec:tensorobj_stalk_tensor`) IS stalk apparatus. The phrase
"no stalk machinery" now conflicts with the fact that the assoc's `\uses{}` includes
`lem:islocallyinjective_whiskerleft_via_stalk` whose proof is entirely stalkwise.
The section statement needs to be qualified: it is the *LocalizedMonoidal /
JW.IsMonoidal* apparatus that is vestigial, not all stalk machinery.

### Flag C — `sec:tensorobj_motivation` (line 133): "stalk apparatus is vestigial"

The motivation section says:
> "The whole LocalizedMonoidal / J.W.IsMonoidal / stalk apparatus is therefore
> vestigial for the group law and off the critical path."

The "stalk apparatus" part is now partially false: the d.2 stalk–tensor commutation
IS on the critical path for the associator (which is on the critical path for the
group law). The sentence should be qualified to refer only to the
LocalizedMonoidal/JW.IsMonoidal portion as vestigial.

### Flag D — `lem:stalk_linear_map` placement inside `sec:tensorobj_route_e`

`lem:stalk_linear_map` is physically located inside `sec:tensorobj_route_e`
("Superseded route --- this entire section is off path"). But it is now a live
ingredient of the d.2 route. Its placement gives a misleading signal to the prover
that the lemma need not be formalized. Consider moving it to
`sec:tensorobj_stalk_tensor` or adding a section-level caveat.

---

## No Lean leakage found

The new `sec:tensorobj_stalk_tensor` (lem:stalk_tensor_commutation,
lem:islocallyinjective_whiskerleft_via_stalk) contains no Lean tactic syntax in
prose. Lean declaration references (in `\mathtt{…}`) are standard blueprint notation.
The "(d.1)" / "(d.2)" route labels are used consistently throughout the chapter.

## Summary

- **Citation**: PASS (verbatim match confirmed).
- **Lean leakage**: none found in new or existing prose.
- **Fixed**: 4 stale passages updated to reflect the live d.2 route.
- **Flagged**: 4 internal contradictions about which whiskering/stalk route is
  "on the critical path" — the most load-bearing is Flag A
  (lem:tensorobj_assoc_iso proof's two inconsistent descriptions), which the
  blueprint-writer should resolve in the next iteration.
