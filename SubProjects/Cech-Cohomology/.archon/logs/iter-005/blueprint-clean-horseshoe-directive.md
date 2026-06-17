# Blueprint Clean Directive

## Slug
horseshoe

## Chapter
`blueprint/src/chapters/Cohomology_AcyclicResolution.tex`

## Context
An `effort-breaker` round this iteration decomposed the monolithic dual-Horseshoe lemma
(`lem:injective_resolution_of_ses`) into a new `\subsection{The horseshoe construction,
step by step}` (chapter L190–462) containing seven `\uses`-linked sub-lemmas
(`lem:horseshoe_biprod_injective`, `…_degree_split`, `…_stage_mono`, `…_twist`, `…_dComp`,
`…_chainMap`, `…_resolvesMiddle`). Clean the chapter — concentrate on that new subsection,
but pass over the whole file.

## Tasks (your standard gate)
1. **Strip Lean/process leakage.** The new subsection and its intro contain
   implementation-process phrasing that must become timeless mathematics — e.g.:
   - "is a single \(\mathbb{N}\)-recursion (modelled on Mathlib's
     \texttt{InjectiveResolution.ofCocomplex}) with no sorry-free partial fragment when
     attempted wholesale. We therefore isolate its independent moving parts …" (L192–195) —
     rewrite as a mathematical statement (the construction proceeds by induction on degree;
     we isolate its parts as the lemmas below), dropping the Lean/prover-process framing
     ("sorry-free partial fragment", "attempted wholesale", "modelled on Mathlib's …").
   - Any other "the prover", "the recursion bookkeeping", `\texttt{InjectiveResolution.…}`
     Mathlib-name mentions used as *implementation* notes (as opposed to a genuine
     `\mathlibok` dependency anchor) → convert to plain mathematics or remove.
   - The `% NOTE (iter-004 review): … FALSE-DONE markers …` comment block at L411–419 is a
     review annotation about a marker-sync artifact; LEAVE IT (it is a `%`-comment, harmless
     in output, and documents a known issue being resolved this iter). Do NOT remove it.
2. **Citation discipline.** The two `\mathlibok` anchors (`lem:horseshoe_biprod_injective`
   → `Injective.instBiprod`; `lem:horseshoe_degree_split` →
   `ShortComplex.Splitting.ofHasBinaryBiproduct`) are Mathlib dependency anchors and need no
   `% SOURCE QUOTE` (they are Mathlib-provided, not external-source results). The new
   project sub-lemmas are pieces of the dual Horseshoe Lemma (dual of Weibel, *An
   Introduction to Homological Algebra*, Lemma 2.2.8); the parent block already carries that
   inline citation and the sub-lemmas inherit it — do NOT fabricate a verbatim `% SOURCE
   QUOTE` for them (none exists; the horseshoe is the one genuinely-new structural
   construction). Only add/repair a quote where a block genuinely derives from a source file
   already in `references/`.
3. **Trim verbosity** in the new subsection where prose is redundant, keeping every
   mathematical step.
4. **Fix LaTeX** — confirm balanced `\begin`/`\end`, braces, and that all `\uses{}` /
   `\label{}` cross-references resolve.

## Do NOT
- Do NOT touch `\leanok` markers anywhere (sync_leanok owns them; the false markers on
  `lem:injective_resolution_of_ses` are being auto-resolved this iter via a Lean-side fence
  fix — leave them).
- Do NOT change any `\lean{}` target name or any `\label{}`.
- Do NOT weaken or restate any lemma; this is a purity/format pass only.
