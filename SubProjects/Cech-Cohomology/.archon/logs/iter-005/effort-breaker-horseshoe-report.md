# Effort Breaker Report

## Slug
horseshoe

## Target
`lem:injective_resolution_of_ses` (`CategoryTheory.InjectiveResolution.ofShortExact`)
in `blueprint/src/chapters/Cohomology_AcyclicResolution.tex`.

## Status
COMPLETE — the monolithic dual-Horseshoe proof is re-expressed as a 7-link
`\uses`-chain of fine-grained sub-lemmas. Statement and `\lean{}` of the target are
unchanged; `\leanok` markers untouched (left to `sync_leanok`). No broken `\uses`
(`archon dag-query gaps` → 0).

## Effort before → after
- target `effort_local`: 1754 → 1228 (its proof body is now pure glue).
- largest single sub-goal now `lem:horseshoe_twist` at 1567 < the old 1754 monolith;
  remaining provable atoms are smaller still (1370 / 939 / 529).
- sub-lemmas added: 7 (2 genuine Mathlib anchors, 1 existing-project-decl anchor,
  4 new provable sub-goals).

## Chain added (target ← L7 ← … ← L1)
Inserted under a new `\subsection{The horseshoe construction, step by step}`, before the
target lemma. All effort numbers from `archon dag-query node` after `archon dag-graph`.

1. `\label{lem:horseshoe_biprod_injective}` `\lean{CategoryTheory.Injective.instBiprod}`
   — `\mathlibok` anchor: a finite biproduct of injectives is injective ⇒ each
   `I_B^n = I_A^n ⊕ I_C^n` is injective. (effort 0; Mathlib name **verified present**.)
2. `\label{lem:horseshoe_degree_split}`
   `\lean{CategoryTheory.ShortComplex.Splitting.ofHasBinaryBiproduct}` — `\mathlibok`
   anchor: the biproduct short complex `P → P⊕Q → Q` has a canonical `Splitting`, so each
   degree `0 → I_A^n → I_B^n → I_C^n → 0` is split. (effort 0; Mathlib name **verified
   present**.)
3. `\label{lem:horseshoe_stage_mono}`
   `\lean{CategoryTheory.mono_biprod_lift_factorThru_of_exact}` — per-stage monomorphism
   `B → P ⊞ Q = biprod.lift (factorThru α S.f) (S.g ≫ γ)`. **Already proven** in
   `AcyclicResolution.lean:181`; given a thin blueprint block + informal proof so the graph
   anchors to it. (NOT `\mathlibok` — it is a project decl; `sync_leanok` will `\leanok` it.)
   `\uses{lem:horseshoe_biprod_injective}`. (effort 0 — matched to existing decl.)
4. `\label{lem:horseshoe_twist}`
   `\lean{CategoryTheory.InjectiveResolution.ofShortExact_twist}` — (3a) existence of the
   off-diagonal twist `τ^n : I_C^n → I_A^{n+1}` and augmentation `β : B → I_B^0` with the
   cocycle identity `τ^{n+1} ∘ d_C^n = − d_A^{n+1} ∘ τ^n`, by `Injective.factorThru`.
   `\uses{lem:horseshoe_stage_mono}`. (effort 1567 — the genuine recursion kernel.)
5. `\label{lem:horseshoe_dComp}`
   `\lean{CategoryTheory.InjectiveResolution.ofShortExact_dComp}` — (3b) the matrix
   differential `[[d_A, τ],[0, d_C]]` satisfies `d∘d = 0` (off-diagonal cancels by the
   cocycle identity). `\uses{lem:horseshoe_twist}`. (effort 529.)
6. `\label{lem:horseshoe_chainMap}`
   `\lean{CategoryTheory.InjectiveResolution.ofShortExact_chainMap}` — (3c) the biproduct
   coprojection `ι : I_A → I_B` and projection `π : I_B → I_C` are chain maps and recover
   the degreewise splitting. `\uses{lem:horseshoe_dComp}`. (effort 939.)
7. `\label{lem:horseshoe_resolvesMiddle}`
   `\lean{CategoryTheory.InjectiveResolution.ofShortExact_resolvesMiddle}` — (4) `I_B^•`
   with augmentation `β` is an injective resolution of `B`, via the homology LES applied to
   the degreewise-split SES of complexes.
   `\uses{lem:horseshoe_chainMap, lem:homology_long_exact_sequence}`. (effort 1370.)

Target `lem:injective_resolution_of_ses` proof rewritten to "by (1)…(4)/anchors", with
the chain added to the **statement** `\uses` (see Notes — leandag only edges off
statement-block `\uses`):
`\uses{lem:horseshoe_biprod_injective, lem:horseshoe_degree_split, lem:horseshoe_stage_mono,
lem:horseshoe_twist, lem:horseshoe_dComp, lem:horseshoe_chainMap,
lem:horseshoe_resolvesMiddle, lem:right_derived_injective_resolution}`.
Verified: target `dep_count` = 8, all 7 chain edges present, `gaps` = 0.

## Still hard (re-break candidates)
- `lem:horseshoe_twist` (effort 1567) — the irreducible heart (the ℕ-recursion + cocycle
  bookkeeping). It is now a *single* mathematical claim (existence of `τ`/`β` with the
  cocycle identity), so it is as atomic as the construction allows; the remaining size is
  inherent recursion bookkeeping, not further-splittable prose. If the prover stalls on it,
  the next finer break would be: (4a) augmentation `β` alone (base stage), (4b) the
  inductive `τ^{n+1}` lift given `τ^{≤n}`, (4c) the cocycle identity for the constructed
  lift — re-dispatch the breaker on `lem:horseshoe_twist` with that 3-way split.
- `lem:horseshoe_resolvesMiddle` (effort 1370) — a clean LES application; should be
  tractable as one goal once 1–6 exist. Not flagged for re-break.

## Could not decompose (strategy items)
- None. Every gap the monolith crossed is covered by a chain link; the conservation check
  passes (mono → twist/cocycle → d²=0 → chain maps → resolves-B → package).

## References consulted
- Directive's structural seams (1)–(5) used verbatim as the cut points. Per the directive,
  no new source quote was needed: the seams are structural (the ℕ-recursion), and the parent
  block already cites the dual of Weibel, *An Introduction to Homological Algebra*, Lemma
  2.2.8. New sub-lemmas inherit that inline citation; no `% SOURCE QUOTE` was fabricated
  (the parent itself carries none — it is the one genuinely-new structural construction).
- No `reference-retriever` spawned (not required).

## Notes for dispatcher
- **`\lean{}` names assigned by convention (please confirm / scaffold the Lean stubs):**
  - `CategoryTheory.InjectiveResolution.ofShortExact_twist`
  - `CategoryTheory.InjectiveResolution.ofShortExact_dComp`
  - `CategoryTheory.InjectiveResolution.ofShortExact_chainMap`
  - `CategoryTheory.InjectiveResolution.ofShortExact_resolvesMiddle`
  These four are the new provable obligations. Their final signatures depend on how the
  prover models the recursion (likely `(I_A : InjectiveResolution A) (I_C : InjectiveResolution C)`
  + a per-stage cosyzygy carrier, as the `.lean` strategy block at
  `AcyclicResolution.lean:222–288` already sketches: `horseshoe_τ`, `horseshoe_d`, …). The
  blueprint names above are the *targets*; the prover may realize each via several helper
  lemmas (e.g. `horseshoe_τ` + a cocycle lemma feeding `..._twist`).
- **Anchors needing NO scaffolding** (already exist / Mathlib): `Injective.instBiprod`,
  `ShortComplex.Splitting.ofHasBinaryBiproduct` (both `\mathlibok`, verified via
  `lean_verify`), and `mono_biprod_lift_factorThru_of_exact` (project decl, present).
- **leandag edge semantics (important for whoever edits this chapter next):** the DAG edges
  are built from each block's **statement-block `\uses` only** — proof-block `\uses` are NOT
  read by `leandag` (confirmed empirically: the target's proof `\uses` produced no edges; an
  identical list in the statement `\uses` did). I therefore placed the full chain in the
  target's statement `\uses` (mirrored in the proof `\uses` for human readers). Existing
  blocks in this chapter that only list deps in their *proof* `\uses` (e.g.
  `lem:acyclic_dimension_shift` → `lem:injective_resolution_of_ses`) are consequently
  *missing that edge in the graph* — a pre-existing latent issue, not introduced here, worth
  a cleanup pass.
- **No macros needed.** Chapter LaTeX balanced (13 `lemma`, 8 `proof` envs; braces OK).
- `\leanok` left entirely untouched on target statement + proof (the known FALSE-DONE
  markers); `sync_leanok` will strip them once the `.lean` code-fence root cause is fixed
  this iteration, after which the four new sub-goals become the live frontier.
