# Blueprint writer directive — iter-199 (slug: `rpf-placeholder-note`)

## Target chapter

`blueprint/src/chapters/Picard_RelPicFunctor.tex` ONLY. Do NOT
modify other chapters.

## Strategy context (narrow slice)

iter-198 dispatched a prover lane on this chapter and closed 5 of 6
sorries via **placeholder bodies**:

- `PicSharp` (L327-330 in Lean): body is
  `(CategoryTheory.Functor.const _).obj (AddCommGrpCat.of PUnit.{u+2})`
  — the constant functor at the trivial group. This is NOT the
  relative Picard presheaf the chapter describes
  (`T ↦ Pic(C ×_k T) / π_T^* Pic(T)`).
- `PicSharp.functorial` (L372-377 in Lean): body is `0` (the zero
  AddMonoidHom). This is NOT the pullback-descended map. The
  declaration inherits `sorryAx` via the file-local `addCommGroup`
  sorry (the codomain's `Zero` instance derives from the sorry-body
  `addCommGroup`).
- `PicSharp.presheaf` (L421-424 in Lean): body is `PicSharp _C`,
  re-exporting the constant-functor placeholder.
- `PicSharp.etSheaf` (L486-490 in Lean): sheafifies the constant
  PUnit presheaf — sheafification machinery is correct, input is
  wrong.
- `PicSharp.etSheaf_group_structure` (L539-544 in Lean): body is
  `⟨0⟩` (zero natural transformation as Nonempty witness). The
  intended type is the canonical sheafification unit; the Lean
  type was weakened to `Nonempty (presheaf ⟶ etSheaf.obj)`.

The single remaining sorry (`addCommGroup` body, L235) is gated on
an upstream Mathlib `Scheme.Modules` monoidal-structure gap (no
project-side path in iter-198).

The lean-vs-blueprint-checker `rpf-iter198` flagged a
**semantic-laundering risk**: 4 of the 5 closures (PicSharp,
presheaf, etSheaf, etSheaf_group_structure) are sorry-free
(`{propext, Classical.choice, Quot.sound}` axiom triple). If the
deterministic `sync_leanok` phase scans only for source-level
sorries, it will add `\leanok` to the proof blocks of
`thm:rel_pic_sharp_presheaf` and
`thm:rel_pic_etale_sheaf_group_structure` on the next sync —
falsely indicating closed proofs.

## Required edits

### 1. Add `% NOTE: placeholder body — DO NOT promote \leanok` annotations

For each of the 5 declarations corresponding to a placeholder body
(NOT `addCommGroup` — that one carries an honest `sorry` and is
correctly tracked), add a single-line `% NOTE: (iter-199 plan agent)
...` LaTeX comment immediately before the `\begin{proof}` block (or,
for definition-style blocks, immediately after the `\end{definition}`
closer). The NOTE should:

- Name the placeholder shape (e.g. "constant PUnit functor",
  "zero AddMonoidHom").
- Name the gating Mathlib gap (`Scheme.Modules` monoidal structure
  for `addCommGroup`).
- State that the proof block must NOT carry `\leanok` until the body
  is replaced with the mathematically correct construction.

The blocks needing NOTEs:
- `def:rel_pic_sharp` (PicSharp).
- `lem:rel_pic_sharp_functorial` (PicSharp.functorial — also
  flag the `sorryAx` typeclass leak).
- `thm:rel_pic_sharp_presheaf` (PicSharp.presheaf).
- `def:rel_pic_etale_sheafification` (PicSharp.etSheaf).
- `thm:rel_pic_etale_sheaf_group_structure` (PicSharp.etSheaf_group_structure).

These NOTEs do NOT modify the existing prose; they augment it with
sync_leanok-deterring annotations that the deterministic
sync_leanok phase + the review agent both honor.

### 2. Resolve the type-weakening mismatch on
`thm:rel_pic_etale_sheaf_group_structure`

The chapter prose currently says "the canonical morphism … is a
homomorphism of group presheaves … each \(T\) the value
\(\Pic^\sharp_{(C/k)\et}(T)\) is naturally an abelian group whose
structure maps make \(T \mapsto \Pic^\sharp_{(C/k)\et}(T)\) a
presheaf to \(\AddCommGroup\)." This implies a full morphism with
universal property.

The Lean type is `Nonempty (presheaf C ⟶ (etSheaf C J).obj)` — just
existence of SOME morphism, not the canonical sheafification unit.

**Pick one** resolution and apply it:

(a) **WEAKEN the chapter prose** to match the Lean type. State that
    `thm:rel_pic_etale_sheaf_group_structure` currently records the
    weaker `Nonempty (...)` existence of a morphism, and that the
    canonical sheafification unit (with universal property) is
    deferred until iter-200+ when the upstream `Scheme.Modules`
    monoidal structure is available. Add a separate
    `\begin{theorem}\label{thm:rel_pic_etale_sheaf_unit_canonical}`
    block stating the intended canonical-morphism + universal-property
    version (unmarked / no `\lean{...}` pin) so a future writer has
    something to formalize against.

(b) **UPGRADE the chapter** to state both versions: the current
    (weaker) `Nonempty` form (matching the iter-198 Lean closure),
    AND the intended canonical morphism with universal property as
    a separate forward-looking lemma block (unmarked).

Pick (a) for parsimony (one canonical block + one forward-looking).

### 3. Refresh stale Lean-side cross-references

The lean-vs-blueprint-checker found:
- `RelPicFunctor.lean:505-508` says "This statement does NOT have an
  explicit `\lean{...}` pin in the blueprint" — incorrect since
  iter-198 added the pin. This is a Lean-side comment; the
  blueprint chapter does NOT need to flag this, but verify nothing
  in the chapter references the absent pin.

(Skip this if the chapter is consistent.)

### 4. (Optional, low-priority) Internal-consistency cleanup

If you spot any stale references to `LineBundle.OnProduct` typed
sorry (iter-176 framing, obsolete iter-188) within the chapter
prose, refresh to the current `Scheme.Modules` monoidal-structure
gap framing.

## Out-of-scope (do NOT do)

- Do NOT modify `\leanok` or `\mathlibok` markers anywhere in the
  chapter. Those are managed by the deterministic `sync_leanok` and
  the review agent.
- Do NOT modify the Lean file `RelPicFunctor.lean`. Your
  write-domain is restricted to the chapter file.
- Do NOT add or remove `\lean{...}` pins. They are correct as-is
  per iter-198 (including the `etSheafUnit` → `etSheaf_group_structure`
  rename).
- Do NOT introduce new sources or quotes; the existing citation
  block is complete.

## References available locally

- `references/kleiman-picard.md` → `references/kleiman-picard-src/kleiman-picard.tex` (Pic^♯ definition, etale sheafification paragraph at L1311-L1328).
- Mathlib `CategoryTheory.Sheafification`,
  `CategoryTheory.GrothendieckTopology.Plus`,
  `AlgebraicGeometry.Scheme.etaleTopology`,
  `AlgebraicGeometry.AffineZariskiSite` (for context only —
  blueprint should not embed Lean API names beyond the existing
  `\lean{...}` pins).

## Verification

After landing the NOTE annotations + type-weakening resolution,
re-read the chapter to confirm:
- Each placeholder block carries a sync_leanok-deterring NOTE.
- `thm:rel_pic_etale_sheaf_group_structure` prose matches the Lean
  type, with the canonical-unit version deferred to a separate
  forward-looking block.
- No new typos or LaTeX errors introduced.

Report back: which blocks got NOTEs (5 blocks expected), which
resolution path (a or b) was applied for the type-weakening, and
any unanticipated findings during the audit.
