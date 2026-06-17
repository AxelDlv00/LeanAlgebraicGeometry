# Blueprint-clean report — slug `cov`, iter-047

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Scope
Two new lemma blocks (`lem:isScalarTower_restrictScalars_obj`, `lem:tileReconcileEquiv`) and the
edited `\uses{}` edges on `lem:tile_section_localization` (proof block), all introduced by the
iter-047 blueprint-writer round (slug `coverage-debt`).

## Findings and edits

### 1. `lem:isScalarTower_restrictScalars_obj` — statement
**Leakage:** `\(\mathrm{IsScalarTower}\,R\,S\)` — a Lean typeclass name embedded in the statement
text.

**Fix:** Removed the typeclass name; the scalar-tower property is now expressed purely in terms of
the factorisation of the R-action through the S-action:

> …carries a scalar-tower structure: the restricted R-action factors through the S-action via the
> algebra map R → S.

---

### 2. `lem:isScalarTower_restrictScalars_obj` — proof
**Leakage (a):** `(\text{algebraMap}\,r)` — Lean function call syntax in the proof body.

**Leakage (b):** "the scalar-tower criterion that builds `\(\mathrm{IsScalarTower}\,R\,S\)` from an
algebra map whose induced action agrees with the ambient S-action" — this is a description of Lean's
typeclass instance-synthesis constructor, not a mathematical argument.

**Fix:** Replaced with a clean mathematical proof: named the algebra map φ: R→S, wrote r·m = φ(r)·m
as the definition of restriction of scalars, and derived the scalar-tower property directly. The
Lean typeclass name is gone.

---

### 3. `lem:tileReconcileEquiv` — statement
**Leakage:** "(the two apply identities)" — a parenthetical referencing the Lean `_apply` and
`_symm_apply` sibling-lemma names.

**Fix:** Removed the parenthetical; the sentence now reads "The forward and inverse maps are each
the identity on elements."

---

### 4. `lem:tileReconcileEquiv` — proof
**Leakage (a):** `\(\mathrm{modulesSpecToSheaf} \circ \mathrm{restrict}\)` — two Lean functor
identifiers used as inline math in the proof body.

**Leakage (b):** "(a definitional equality)" — type-theory jargon (definitional vs propositional
equality in DTT) with no mathematical content for the blueprint reader.

**Leakage (c):** "on the nose" — informal phrasing.

**Fix:** Replaced the whole phrase with: "…by construction of the restriction functor. The
underlying map is therefore the identity, and it is additive."

---

## `\uses{}` edges on `lem:tile_section_localization`
The proof-block `\uses{}` list was edited to add `lem:tileReconcileEquiv` and
`lem:isScalarTower_restrictScalars_obj`. These are clean label-reference additions — no prose
leakage.

## Source-quote discipline
No new lemma block derived from an external reference; no `% SOURCE QUOTE:` obligation arises.
Existing source-quote blocks in the chapter are untouched.

## Markers
`\leanok` status on all blocks is unchanged (not touched, as instructed). The keystone block and
kernel-comparison block were not touched.

## Status
CLEAN — no Lean leakage remains in the iter-047 additions.
