# Blueprint Writer Report

## Slug
differentials-iter121

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Differentials.tex

## Changes Made

- **Revised** proof of `lem:appLE_isLocalization` (the M1.b proof skeleton). The previous one-paragraph proof referenced "a cofinality-of-directed-colimit lemma that may need to be supplied" without a proof shape. The new proof has a concrete four-step decomposition:
  - *Step 1 — Cofinality of basic opens.* Quasi-compactness of `f V` selects a finite sub-cover among `{D(g_i)}`; product `g = ∏ g_i` gives `D(g) = ⋂ D(g_i) ⊆ W` with `f V ⊆ D(g)`. Named Mathlib pieces: `PrimeSpectrum.isBasis_basic_opens` (or `Opens.exists_finset_inf_le_basicOpen`). Bridge identity `f V ⊆ D(g) ⟺ appLE(g) ∈ B^×` cites `AlgebraicGeometry.Scheme.preimage_basicOpen_eq_basicOpen` + `AlgebraicGeometry.IsAffineOpen.basicOpen_eq_iff_isUnit`.
  - *Step 2 — Single-element localization.* Each `O_S(D(g)) = A_g` via `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen [verified]`.
  - *Step 3 — Colimit of single-element localizations.* `colim_{g ∈ M} A_g = Localization M A`. Names the Mathlib gap explicitly (lemma "colimit over inclusion of generated submonoids = localization at full submonoid" may need supplying); flags candidate home `Mathlib.RingTheory.Localization.Submonoid`.
  - *Step 4 — Assemble.* The presheaf-side `A_colim` is the directed colimit over the cofinal subsystem, hence equals `Localization M A` via `IsLocalization M A_colim`.
  - *Mathlib-gap summary* names `CategoryTheory.Functor.Final` as the cofinality machinery and `Mathlib.AlgebraicGeometry.Presheaf.InverseImage` / `Mathlib.AlgebraicGeometry.Morphisms.Cofinality` as wrapper homes.
  - Adds a *Cross-chapter parallel* sentence pointing at `Jacobian.tex § C.2` (M2.a `Hom(ℙ¹_k, A) = A(k)`) — one sentence only, as directed.
  - Stacks Tag 02M5 cited as the topological analogue.

- **Revised** `\uses{...}` on `lem:kaehler_localization_subsingleton`. Was `\uses{lem:appLE_isLocalization}` (logically backwards: kernel of localization is independent of appLE setup). Now `\uses{}` (empty, per directive). The opposite direction `\uses{lem:appLE_isLocalization}` correctly remains on `thm:relativeDifferentialsPresheaf_iso_kaehler_appLE` (Step M1.b consumer).

- **Revised** Section heading "Converse direction --- out of autonomous-loop scope" → "Converse direction (milestone M4)" (label `sec:converse-out-of-scope` kept intact so the two existing `\ref` sites in the chapter intro and § "Smoothness criterion" continue to resolve). Added a leading paragraph: "This direction is recorded as an optional future milestone M4 (see `STRATEGY.md`). Closure requires the deformation-theoretic hypothesis `Subsingleton (Algebra.H1Cotangent A B)` ..." per the directive's verbatim phrasing.

- **Revised** in-body "is out of autonomous-loop scope" in `rem:converse_lemma_hypotheses` → "is the content of milestone M4."

- **Revised** Section heading "Content out of autonomous-loop scope" → "Content scheduled for later milestones". Added a leading paragraph framing the roadmap progression M1 → M2/M3 → M4 → M5+, and tagged each of the four bullets with an explicit milestone number: M5 (sheaf condition), M6 (cotangent exact sequence), M7 (cotangent space at section), M8 (Serre-duality genus identity). The "outside autonomous-loop scope" and "Out of autonomous-loop scope" phrases in those bullets were rewritten to "the deferred work for this milestone" / removed entirely; the "cannot be expressed within the autonomous-loop's Mathlib snapshot" phrase changed to "cannot yet be expressed within the project's Mathlib snapshot."

## Cross-references introduced

- `\uses{}` (empty) on `lem:kaehler_localization_subsingleton` — replaces an incorrect backwards dependency. No new lookups needed.
- Cross-chapter `\S~C.2` reference to `Jacobian.tex` from the `lem:appLE_isLocalization` proof. This is intentional one-sentence orientation, not a `\uses{...}` link (the cross-chapter parallel is informational, not a logical dependency).
- `\ref{sec:converse-out-of-scope}` from the new roadmap paragraph in "Content scheduled for later milestones" — resolves to the renamed M4 section in the same file.

## Macros needed
- None. The new proof uses only macros already in use in this chapter (`\struct`, `\Spec`, standard math env macros).

## Reference-retriever dispatches
- None. All Mathlib lemma names cited are either already named in the prior version of this chapter or are the directive's verbatim suggestions; no external textbook material was needed beyond Stacks Tag 02M5 (cited only as an analogue) and Hartshorne (already in `summary.md`'s ambient context).

## Notes for Plan Agent

- The "out of autonomous-loop scope" framing appeared at six occurrences total in the original chapter (directive said "four times"); I updated all six for consistency. Two of them were section headings (now renamed), one was an inline phrase in `rem:converse_lemma_hypotheses` (now "is the content of milestone M4"), and three were in the tail-section bullets (rewritten in place). If the reviewer prefers a stricter four-edit reading, the body-level rewrites can be partially reverted — but the resulting chapter would be inconsistent with the two new section headings, so I judged six-of-six was the better outcome.
- The intro paragraph (line 6) and the Section-2 paragraph (line ~46) both contain prose phrases like "is documented separately in Section~\ref{sec:converse-out-of-scope}". Since the directive said only to update the section headings (and not the cross-reference label), the body text remains accurate after the heading rename — those `\ref`s resolve to "Section X" which now reads "Converse direction (milestone M4)" in the rendered output. No edit was needed there. If the reviewer wants the label itself renamed (to e.g. `sec:converse-m4`), a second pass would update those two `\ref` sites plus the label.
- The M1.b proof skeleton names `IsLocalization.Away g A_g` (Step 2) and a candidate "colimit of single-element localizations = localization at submonoid" lemma (Step 3). The Step 3 lemma's exact Mathlib name in snapshot `b80f227` is not verified — this is flagged explicitly in the proof as a potential Mathlib gap, with `Mathlib.RingTheory.Localization.Submonoid` named as the candidate home. The next iteration's prover lane on M1.b should verify whether this lemma exists or whether the project needs to supply it.
- Empty `\uses{}` syntax: I followed the directive literally. Some `leanblueprint` versions treat `\uses{}` and an omitted `\uses` identically; if the rendering pass complains, the fix is to delete the line entirely (the underlying dependency graph is the same).

## Strategy-modifying findings

None. The Step 3 Mathlib-gap surfaced in M1.b is consistent with what `STRATEGY.md` already anticipates ("Mathlib contribution candidate of milestone M1"). The roadmap progression M1 → M2/M3 → M4 → M5+ used in the new "Content scheduled for later milestones" section reflects the iter-121 STRATEGY.md pivot as paraphrased in the directive; the writer made no independent strategy decisions.
