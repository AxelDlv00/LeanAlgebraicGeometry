# blueprint-clean bc252 — report

**Target:** `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Scope

Three bw252 edits were reviewed:
1. New `lem:dual_unit_iso` block (statement + proof, lines ~5499–5526)
2. (A)+(B) two-leg rewrite of the `lem:dual_restrict_iso` Step-4 proof (lines ~5426–5497)
3. One new sentence in the `lem:pullback_tensor_map_natural` proof (lines ~3336–3341)

---

## `\uses{}`/`\cref{}` validation

All new cross-references verified as resolving to existing labels:

| New usage | Resolved label (line) |
|---|---|
| `lem:internal_hom_eval` | 5078 ✓ |
| `lem:internal_hom_isSheaf` | 5147 ✓ |
| `lem:tensorobj_unit_iso` | 1563 ✓ |
| `lem:open_immersion_slice_sheaf_equiv` | 5318 ✓ (added by this pass) |
| `lem:presheaf_pushforward_adj_substrate` | 720 ✓ (added by this pass) |
| `lem:restrictscalars_ringiso_strongmonoidal` | 800 ✓ (added by this pass) |
| `lem:restrictscalars_ringiso_dualequiv` | 5206 ✓ (pre-existing) |

---

## `lem:dual_unit_iso` — CLEAN (no changes)

The new block is source-free (Archon-original project lemma, as directed). No Lean-elaboration
idiom detected. The statement and proof read as pure mathematics.

---

## `lem:dual_restrict_iso` — 5 fixes applied

### Fix 1 — Lean dot-accessor `f.\mathtt{opensFunctor}` (Leg A, line 5444)
Removed the Lean struct-field accessor from the prose description of the direct-image functor.

- **Before:** `direct-image-of-opens functor \(f.\mathtt{opensFunctor}\) is fully faithful`
- **After:** `direct-image functor on open sets is fully faithful`

### Fix 2 — Typography: `.\mathtt{hom}_V` → `.\mathrm{hom}_V` (Leg B, line 5456)
The component accessor `.hom` is typeset `\mathrm{hom}` throughout the pre-existing blueprint
(e.g., lines 551, 586, 3407). The new text used `\mathtt{hom}`.

### Fix 3 — Removed parenthetical Lean name with no blueprint label (Leg B, line 5459)
`(\(\mathtt{restrictScalars\_isEquivalence\_of\_ringEquiv}\))` has no `\label{}` in the file and
appears only in the new prose. Stripped; the mathematical claim ("restriction of scalars along a
ring isomorphism is an equivalence") stands without it.

### Fix 4 — "tensor lane's H2 step" → `\cref{lem:restrictscalars_ringiso_strongmonoidal}` (Leg B, line 5462–5463)
"The ring-iso tensor equivalence that closed the tensor lane's H2 step" is project-internal
terminology. Replaced with a proper cross-reference to the relevant blueprint lemma
(`lem:restrictscalars_ringiso_strongmonoidal`).

### Fix 5 — "tensor lane's H2 step (Lean name)" → `\cref{lem:presheaf_pushforward_adj_substrate}` (line 5470–5471)
"The tensor lane's H2 step (\(\mathtt{restrictScalarsMonoidalOfBijective}\))" replaced with
"the strong-monoidal restriction (\cref{lem:presheaf_pushforward_adj_substrate})". The Lean
declaration `restrictScalarsMonoidalOfBijective` is documented under that label; using the label
is the correct blueprint citation. Project-internal label "H2" also removed.

### Fix 6 — `\mathtt{overSliceSheafEquiv}` → `\cref{lem:open_immersion_slice_sheaf_equiv}` (caution paragraph, line 5479–5480)
The declaration `overSliceSheafEquiv` has a blueprint label at line 5318. The em-dash
inline-name construction was replaced with a `\cref{}` reference in a prepositional phrase.

- **Before:** `--- the sheaf-level \(\mathtt{overSliceSheafEquiv}\) ---`
- **After:** `of \cref{lem:open_immersion_slice_sheaf_equiv}`

---

## `lem:pullback_tensor_map_natural` — 1 fix applied

### Fix 7 — `\mathtt{sheafification.map}\,p` (D1′ new sentence, line 3340)
Lean field-accessor notation (`\mathtt{sheafification.map}`) replaced with standard mathematical
phrasing.

- **Before:** `\(\eta\) followed by \(\mathtt{sheafification.map}\,p\))`
- **After:** `\(\eta\) followed by the sheafification of \(p\))`

---

## `\leanok`/`\mathlibok` — not touched

No markers were added or removed.

## SOURCE/SOURCE QUOTE blocks — not touched

All pre-existing `% SOURCE` / `% SOURCE QUOTE` citation blocks were left verbatim.

## Source-quote check for `lem:dual_unit_iso`

This is an Archon-original lemma (evaluation-at-1 on the internal-hom unit). No external source
is required or appropriate; the block is correctly left source-free.

---

## Summary

7 surgical fixes applied. The three bw252 edits now read as mathematics throughout: no Lean
elaboration idioms remain in the new prose, no project-internal step labels remain, and all
cross-references use proper `\cref{}` pointing to verified blueprint labels.
