# Blueprint Writer Directive

## Slug
acyclic-coverage

## Target chapter
blueprint/src/chapters/Cohomology_AcyclicResolution.tex

## Strategy context
This chapter (`% archon:covers AlgebraicJacobian/Cohomology/AcyclicResolution.lean`)
contains the abstract homological-algebra theorem "a `G`-acyclic resolution computes
`G.rightDerived`" (Leray's acyclicity, Stacks 015E) — the P4 phase. Its mathematical
roadmap is COMPLETE and correct: every named lemma has a statement, proof sketch,
sources, and accurate `\uses{}`. **This is NOT a math-content round.** The chapter is
missing nothing mathematically.

The single remaining task is **1-to-1 Lean ↔ blueprint coverage hygiene**. During P4
formalization the prover created ~43 internal helper declarations in
`AcyclicResolution.lean` that have NO blueprint entry. `leandag` reports them as
`lean_aux` nodes (Lean decls with no `\lean{}` pointing at them), which blocks the DAG's
1-to-1 completeness criterion. Each is already proved sorry-free in Lean (effort 0); they
need blueprint entries solely so the graph is complete and the dependency edges are real.

## Required content

Read the Lean file `AlgebraicJacobian/Cohomology/AcyclicResolution.lean` for the exact
signatures and docstrings of every declaration named below. Then give each of the
following uncovered Lean declarations a blueprint home. Two mechanisms — choose per the
guidance:

**(A) FOLD definitional/component helpers into the `\lean{}` list of the existing block
they belong to.** `leandag` matches *every* comma-separated name in a `\lean{...}` to that
block (this is how `horseshoeτ`, `twistPair`, `twistedBiprodD_comp` are already covered).
A pure projection/`rfl`/component lemma that is a definitional unfolding of an
already-blueprinted named construction should simply be appended to that construction's
`\lean{}` list — it shares that block's `\uses{}` and needs no new prose. Use this for the
horseshoe-internal cluster below.

Fold these into the **existing** horseshoe blocks (pick the block whose construction each
realizes; read the Lean to confirm which):
- `lem:horseshoe_twist` (the augmentation+twist construction) — append the augmentation and
  twist internals: `horseshoeβ₁`, `f_comp_horseshoeβ₁`, `horseshoeH`, `g_comp_horseshoeH`,
  `horseshoeH_comp_d`, `horseshoeτZero`, `horseshoeτZero_hf`, `horseshoeτ_zero`,
  `horseshoeβ_comp_d`, `horseshoeβ_fst`, `horseshoeβ_snd`, `ιC0`, `ιC0_comp_d`,
  `ιC0_comp_τZero`, `ιC_comp_horseshoeτZero`.
- `lem:horseshoe_chainMap` (the middle complex + degreewise SES + chain maps) — append:
  `horseshoeMid`, `horseshoeSES`, `horseshoeSES_splitting`, `horseshoeι`,
  `horseshoeι_f_zero`, `mono_horseshoeβ`.
- `lem:horseshoe_resolvesMiddle` (the proof that the middle complex resolves B, via the
  homology LES / quasi-iso transfer) — append: `horseshoeφ`, `horseshoeφ_comm₁₂`,
  `horseshoeφ_comm₂₃`, `horseshoeφ_τ₁`, `horseshoeφ_τ₂`, `horseshoeφ_τ₃`,
  `quasiIso_horseshoeι`, `single₀_hom_ext`.
  (Read the Lean to confirm `horseshoeφ` and the `_τ₁/₂/₃` legs are the map-of-SESs used to
  transfer the quasi-iso; place them in whichever of horseshoe_chainMap/resolvesMiddle
  matches their actual role. The split between the three blocks is a judgement call — the
  goal is that every listed name lands in exactly one block whose math it implements.)

**(B) ADD a small number of NEW dedicated blocks** for the genuinely substantive
uncovered declarations that deserve their own statement (these were explicitly flagged as
un-blueprinted by prior reviews):

1. **The `TwistedBiprod` abstraction layer** — add a short subsection (e.g. "The twisted
   biproduct complex") with:
   - A `\begin{definition}` `\label{def:twisted_biprod}` `\lean{CategoryTheory.twistedBiprod}`
     for the twisted biproduct cochain complex: given two cochain complexes `K`, `L` in `ℕ`
     degree and a twist family `τⁿ : Lⁿ → Kⁿ⁺¹` satisfying the cocycle identity, the complex
     with terms `Kⁿ ⊞ Lⁿ` and matrix differential `[[d_K, τ],[0, d_L]]`. Append to its
     `\lean{}` the component/projection names: `twistedBiprod_X`, `twistedBiprod_d`,
     `twistedBiprodD`, `twistedBiprodD_fst`, `twistedBiprodD_snd`. `\uses{lem:horseshoe_twist}`
     for the cocycle hypothesis (or state the cocycle identity as a free hypothesis — match
     the Lean signature). This is the injective-free abstraction the horseshoe specializes;
     note in the prose that `lem:horseshoe_dComp` (`twistedBiprodD_comp`) and
     `lem:horseshoe_chainMap` (`twistedBiprodInl`/`twistedBiprodSnd`/`twistedBiprodSplitting`)
     are its differential-squares-to-zero and chain-map/splitting facts.
   - A companion `\begin{lemma}` `\label{lem:twisted_biprod_incl_proj}`
     `\lean{CategoryTheory.twistedBiprodInl_f}` for the inclusion/projection component
     identities, appending `twistedBiprodSnd_f` and `twistedBiprodInl_comp_Snd` to its
     `\lean{}`. One-line statement (the inclusion is `biprod.inl` degreewise, the projection
     is `biprod.snd`, and their composite is zero) + a one-line proof. `\uses{def:twisted_biprod}`.

2. **Degreewise-split SES of complexes ⇒ short exact** — a `\begin{lemma}`
   `\label{lem:shortExact_of_degreewise_splitting}`
   `\lean{CategoryTheory.shortExact_of_degreewise_splitting}`: a short complex of cochain
   complexes that is split in each degree is short exact (degreewise mono/epi/exact).
   Append the map-level variant `shortExact_map_mapHomologicalComplex_of_degreewise_splitting`
   to the `\lean{}` (it states the same for the image under an additive functor applied
   degreewise — read the Lean to phrase precisely; if its content is distinct enough, give it
   its own one-line companion block instead). `\uses{}` whatever degreewise-splitting datum
   it consumes. This is the fact used in `lem:acyclic_dimension_shift` that an additive `G`
   preserves the degreewise-split SES.

3. **Vanishing homology of an applied right-acyclic complex** — a `\begin{lemma}`
   `\label{lem:isZero_homology_of_acyclic}`
   `\lean{CategoryTheory.Functor.isZero_homology_mapHomologicalComplex_of_isRightAcyclic}`:
   read the Lean signature and docstring to state it precisely (it concerns the vanishing of
   homology of `G` applied to a complex of right-`G`-acyclic objects, or similar).
   `\uses{def:right_acyclic}` plus whatever it needs.

4. **Resolution-level dimension shift across a split-resolution SES** — a `\begin{lemma}`
   `\label{lem:right_derived_shift_split_resolution}`
   `\lean{CategoryTheory.Functor.rightDerivedShiftIsoOfSplitResolutionSES}`: the
   resolution-level precursor of `lem:acyclic_dimension_shift`. Read the Lean signature; it
   produces the shift isomorphisms from a degreewise-split SES of injective resolutions
   (before specializing to the object-level statement). `\uses{lem:injective_resolution_of_ses,
   lem:homology_long_exact_sequence}` plus the degreewise-split SES lemma from (2). Wire
   `lem:acyclic_dimension_shift`'s `\uses{}` to point at THIS block as well, since
   `rightDerivedShiftIsoOfAcyclic` is built by specializing it (confirm against the Lean).

5. **Middle-term quasi-isomorphism transfer** — a `\begin{lemma}`
   `\label{lem:quasiIso_tau2}`
   `\lean{HomologicalComplex.HomologySequence.quasiIso_τ₂}`: the homology four-lemma window —
   given a short exact sequence of cochain complexes whose outer maps `τ₁`, `τ₃` are
   quasi-isomorphisms, the middle map `τ₂` is a quasi-isomorphism. This is a project-local
   supplement to Mathlib (Mathlib had only `quasiIso_τ₃`). It is used inside the proof of
   `lem:horseshoe_resolvesMiddle` (`quasiIso_horseshoeι`). Add `\uses{lem:homology_long_exact_sequence}`,
   and add `\uses{lem:quasiIso_tau2}` to `lem:horseshoe_resolvesMiddle`. Source: it is a
   standard homology long-exact-sequence consequence — no external reference is strictly
   required, but you may cite the same Stacks/derived material the LES rests on if natural;
   otherwise mark `\textit{Source: project-local supplement (homology long exact sequence).}`

For every NEW block: concise mathematical statement, a `\label{}`, the exact `\lean{}`,
accurate `\uses{}`, and a **one-to-three-line informal proof** (these are all proved in Lean;
a brief honest sketch — "By the matrix form of the differential…", "By the homology long
exact sequence and vanishing of the outer terms…" — is correct and sufficient). Do NOT write
"Proved directly in Lean" as the entire proof for a NEW substantive block; give the actual
short mathematical reason. (Folded component lemmas under (A) need no new prose at all.)

## Out of scope
- Do NOT alter any existing statement, proof sketch, or source citation of the already-present
  named lemmas (`lem:horseshoe_twist`, `lem:acyclic_dimension_shift`,
  `lem:acyclic_resolution_computes_derived`, etc.) beyond (i) appending names to their
  `\lean{}` lists per (A) and (ii) adding the new `\uses{}` edges named in (B4)/(B5).
- Do NOT touch `\leanok` markers (managed by sync_leanok).
- Do NOT add new mathematical content beyond covering the listed helpers.
- Do NOT edit other chapters or `content.tex`.
- The protected goal lives in a different chapter; nothing here is protected.

## References
The helpers are internal plumbing of constructions already cited in this chapter. No NEW
external source is required — the existing `% SOURCE:` blocks on the parent lemmas
(referencing `references/homological-acyclic-derived.tex`, Stacks Tags 0157/015C/015D/015E/
05TA) cover the mathematics. For the new substantive blocks (B1–B5), the dual Horseshoe Lemma
attribution (Weibel, Lemma 2.2.8, dual) already used in the chapter applies; reuse it where
relevant. Only add a `% SOURCE:` block if you introduce genuinely externally-sourced content
(you should not need to). If you find you do need a source not in `references/`, dispatch a
reference-retriever (your write-domain includes `references/**`).

## Expected outcome
After this round, `leandag build` followed by `archon dag-query unmatched` reports ZERO
`lean_aux` nodes from `AcyclicResolution.lean` — every one of the ~43 helper declarations is
either folded into an existing block's `\lean{}` list (component helpers) or covered by one of
the ~6 new dedicated blocks (B1–B5). No new broken `\uses{}`, no new isolated blocks. The
chapter's mathematical content is otherwise unchanged.
