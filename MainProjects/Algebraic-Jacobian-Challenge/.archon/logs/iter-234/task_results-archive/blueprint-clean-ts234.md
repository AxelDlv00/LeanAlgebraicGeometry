# blueprint-clean report — slug ts234

## Summary

Both chapters were reviewed and cleaned. Six targeted edits were made to
`Picard_TensorObjSubstrate.tex`; `Cohomology_FlatBaseChange.tex` required no
changes for the writer-introduced content.

---

## Chapter 1: `Picard_TensorObjSubstrate.tex` (writer `d2-sketch`)

### Edits applied

**1. `% NOTE` on `lem:stalk_tensor_commutation` — cleaned**

The writer added a `% NOTE (iter-234): partial —` comment containing:
- Iteration number reference `(iter-234)` → removed
- Status phrase "are formalized" → removed
- Lean type annotation `: (A ⊗ᵖ B).stalk x ⟶ A_x ⊗_{R_x} B_x` → removed
- `axiom-clean,` jargon → removed
- "The pinned full iso `stalkTensorIso` does NOT yet exist:" → removed
- "is blocked on" project-status phrase → removed
- "Hence this block stays unmarked." (meta-marker commentary) → removed

Retained: the list of identifier names (`stalkTensorBilin`, `stalkTensorDescU`,
`stalkTensorDesc`, `stalkTensorDesc_germ_tmul`, `stalkTensorDescU_smul`,
`stalkTensorIso`) and a clean description of which stages are assembled and
which remain.

**2. Proof intro of `lem:stalk_tensor_commutation` — cleaned**

"stages (i)--(ii) ... are already in place" → "Stages (i)--(ii) construct ..."
(removed project-history phrase "already in place"; also removed orphaned
"in the order in which it is built;" preamble).

**3. Stage (i) header — cleaned**

`(\mathtt{stalkTensorBilin}, \mathtt{stalkTensorDescU}; done)` → removed "; done"
(project-status annotation within proof body).

**4. Stage (ii) header — cleaned**

`(\mathtt{stalkTensorDesc}, \mathtt{stalkTensorDesc\_germ\_tmul}; done)` → removed "; done".

**5. Stage (iii) proof body — cleaned**

- "only fires after a small \(\mathtt{RingEquiv}\)/\(\mathtt{eqToHom}\) bridge" →
  changed to "applies only after inserting a canonical \(\mathtt{RingEquiv}\) bridge"
  (removed Lean tactic jargon "fires"; removed `eqToHom` which is a Lean-internal
  construction, replaced by the mathematically meaningful "canonical RingEquiv bridge").
- "already used for the d.1 stalk map" → "used for the d.1 stalk map"
  (removed "already").

**6. `lem:stalk_tensor_desc_forward` — cleaned**

Last sentence "It is recorded here as a separate machine-readable pin because the
partial formalization supplies this map before the full iso `stalkTensorIso` exists."
→ removed entirely (project-history narration; the statement block is
self-descriptive as the forward half of `lem:stalk_tensor_commutation`).

### SOURCE QUOTE validation

The `% SOURCE QUOTE` on `lem:stalk_tensor_commutation` (Stacks
`lemma-stalk-tensor-product`) was **NOT altered** by the writer. Verified against
`references/stacks-modules.tex` lines 2332–2344: the blueprint quote is
byte-for-byte identical to the reference source.

### Archon-original blocks — citation check

`lem:stalk_tensor_desc_forward` carries **no** `% SOURCE` / `% SOURCE QUOTE`
lines — correct, as directed (Archon-original, no external source required).

### Residual contradiction: `lem:islocallyinjective_whisker_of_W`

**This contradiction is still present and reads as contradictory.**

The block at `\label{lem:islocallyinjective_whisker_of_W}` is in a double bind:

1. Its pre-block preamble reads *"Off-path duplicate --- the full-generality
   packaging, not to be formalized."*
2. Yet the block carries `\leanok` (indicating the declaration is formalized).
3. Its **PRIMARY** proof route ("F locally trivial — the consumer's case; no
   stalks, no (d.2)") explicitly claims to be "exactly the hypothesis its sole
   consumer — the associator `lem:tensorobj_assoc_iso` — supplies," describing a
   proof that requires only `lem:tensorobj_restrict_iso` and the unitor.
4. However, `lem:tensorobj_assoc_iso`'s `\uses` lists
   `lem:islocallyinjective_whiskerleft_via_stalk`, not
   `lem:islocallyinjective_whisker_of_W`.
5. Meanwhile `lem:islocallyinjective_whiskerleft_via_stalk` claims to "discharge
   the open left-whiskering obligation `\cref{lem:islocallyinjective_whisker_of_W}`
   that the unconditional associator consumes" — yet the associator's `\uses`
   does not mention that obligation's label, only the live lemma's.

The contradiction is therefore three-layered:
- Marker vs. preamble: `\leanok` present on a block declared "not to be formalized."
- PRIMARY proof vs. `\uses` chain: the PRIMARY route claims to close the
  associator's obligation via a locally-trivial path, but the associator cites only
  the d.2 path.
- `whiskerleft_via_stalk` phrasing: says it "discharges the obligation of
  `whisker_of_W`," implying a dependency that is absent from the `\uses` graph.

Per directive, the block was **not deleted** — structural deletion is deferred.

---

## Chapter 2: `Cohomology_FlatBaseChange.tex` (writer `fbc-locality`)

### Locality-of-isomorphisms subsection (three new lemmas)

The three new Archon-original lemma blocks:
- `lem:modules_isIso_iff_stalk` (`\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}`)
- `lem:modules_isIso_of_isBasis` (`\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}`)
- `lem:modules_isIso_iff_affineOpens` (`\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}`)

All three correctly carry **no** `% SOURCE` / `% SOURCE QUOTE` lines — correct
(Archon-original supplements; the preamble explicitly notes they carry no external
citation). Proof bodies are clean mathematical prose with no Lean tactic syntax.

### Updated affine proof first-reduction step

The new first-reduction paragraph — "By Lemma~\ref{lem:modules_isIso_iff_affineOpens}
it suffices to prove ..." — is clean mathematical language. No leakage introduced.

**No edits required** for this chapter.

---

## Status

| Check | Result |
|---|---|
| `lem:stalk_tensor_commutation` SOURCE QUOTE intact | PASS (byte-for-byte match) |
| `lem:stalk_tensor_desc_forward` no SOURCE/SOURCE QUOTE | PASS (confirmed absent) |
| Three FBC locality lemmas no SOURCE/SOURCE QUOTE | PASS (confirmed absent) |
| No `\leanok`/`\mathlibok` added or removed | PASS |
| Lean tactic syntax stripped | PASS (6 edits applied) |
| Project-history narration stripped | PASS |
| Contradiction in `lem:islocallyinjective_whisker_of_W` | NOTED (not deleted — deferred) |
