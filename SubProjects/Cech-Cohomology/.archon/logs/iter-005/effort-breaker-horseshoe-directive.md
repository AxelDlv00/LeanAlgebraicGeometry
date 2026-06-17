# Effort Breaker Directive

## Slug
horseshoe

## Target
`lem:injective_resolution_of_ses`

(in `blueprint/src/chapters/Cohomology_AcyclicResolution.tex`, statement at L190–222,
proof at L224–248. Lean target name preserved: `CategoryTheory.InjectiveResolution.ofShortExact`.)

## IMPORTANT — treat this target as UNPROVEN
The block currently carries `\leanok` on both its statement (L190) and proof (L226).
**These are FALSE-DONE markers** (DAG poisoning): the named declaration
`CategoryTheory.InjectiveResolution.ofShortExact` does NOT exist in Lean
(`lean_verify`: "Unknown constant"). `sync_leanok` was fooled by a backtick code-fence in
the `.lean` strategy comment; that root cause is being fixed in the same iteration by a
separate refactor, after which sync_leanok will strip the markers. **Do NOT treat the
horseshoe as done.** Your job is to decompose its proof into independently-formalizable
sub-lemmas so the prover can build it piece by piece. Do NOT touch `\leanok` yourself
(sync_leanok owns it); you may leave the existing `% NOTE:` at L194–202 in place.

## Granularity
Fine — one mathematical claim per lemma. A prior monolithic `mathlib-build` attempt
(iter-004) declined this target wholesale: it is a single large ℕ-recursion with no
sorry-free partial fragment. Break it at the seams below so each piece is a small,
self-contained Lean goal.

## Proof structure (the seams to cut along)
The horseshoe builds, from a SES `0 → A → B → C → 0`, a degreewise-split SES of injective
resolutions `0 → I_A → I_B → I_C → 0`. The construction (a ℕ-recursion modelled on
Mathlib's `InjectiveResolution.ofCocomplex` / `exact_f_d` / `ofCocomplex_exactAt_succ`,
`Mathlib/CategoryTheory/Abelian/Injective/Resolution.lean:270–352`) decomposes as:

1. **Inputs / setup.** Choose `I_A := InjectiveResolution.of A` and
   `I_C := InjectiveResolution.of C` (enough injectives), or take them as hypotheses.
   In each degree set `I_B^n := I_A^n ⊞ I_C^n` (biproduct), injective as a finite
   biproduct of injectives (`Injective.instBiprod`). The degree-`n` maps `I_A^n → I_B^n`,
   `I_B^n → I_C^n` are `biprod.inl` / `biprod.snd`, so each degree is **split** by the
   Mathlib biproduct splitting (`Mathlib/Algebra/Homology/ShortComplex/Exact.lean:648`).

2. **Per-stage cosyzygy short exact sequence + its monomorphism.** Carry, at stage `n`,
   a short exact sequence `0 → Kₐⁿ → Kᵦⁿ → K_cⁿ → 0` (the cosyzygies), with monos
   `Kₐⁿ ↪ I_A^n`, `K_cⁿ ↪ I_C^n`. The induced mono `Kᵦⁿ ↪ I_A^n ⊞ I_C^n` is
   `biprod.lift (Injective.factorThru α S.f) (S.g ≫ γ)`; that it is mono is **already
   proven** as `CategoryTheory.mono_biprod_lift_factorThru_of_exact`
   (`AcyclicResolution.lean:181`) — reuse it, do not re-derive. Its cokernel gives the
   next stage `Kᵦⁿ⁺¹` and feeds the recursion.

3. **The off-diagonal twist `τ` and the differential.** The augmentation `B → I_B^0` and
   each off-diagonal component `τⁿ : I_C^n ⟶ I_A^{n+1}` come from `Injective.factorThru`
   against the stage-`n` cosyzygy SES (target summand `I_A^{n+1}` injective, source map a
   mono). The differential `d_{I_B}^n : I_B^n → I_B^{n+1}` is the matrix
   `[[d_A, τ], [0, d_C]]`. Separate claims: (3a) the augmentation/τ lifts exist;
   (3b) the assembled `d` satisfies `d ∘ d = 0` (chain-complex law); (3c) `inl`/`snd`
   are chain maps for these differentials.

4. **`I_B` resolves `B` (exactness).** From the degreewise-split SES of complexes
   `0 → I_A → I_B → I_C → 0` and the complex-level homology LES
   (`lem:homology_long_exact_sequence`: `homology_exact₁/₂/₃` + `δ`), the outer complexes
   being acyclic resolutions forces `I_B` acyclic in positive degrees with `H^0 = B`.
   This is the "`InjectiveResolution B`" packaging claim.

5. **Output packaging.** Assemble (1)–(4) into `InjectiveResolution.ofShortExact`
   producing the `InjectiveResolution B` together with the `ShortComplex (CochainComplex
   𝒜 ℕ)` whose `.ShortExact` holds and is degreewise split (this is what the downstream
   `rightDerivedShiftIsoOfSplitResolutionSES`, `AcyclicResolution.lean:153`, consumes).

Cut into sub-lemmas at (1) splitting-per-degree, (2) per-stage mono (already a Lean decl —
give it a thin blueprint anchor pointing at `mono_biprod_lift_factorThru_of_exact`),
(3a) lift existence, (3b) `d∘d=0`, (3c) chain-map laws, (4) resolves-B, then rewrite the
target's proof as "by (1)…(5)". Where a step maps onto a Mathlib result used as-is
(e.g. the biproduct splitting, `Injective.instBiprod`), write it as a `\mathlibok`
**Mathlib dependency anchor** (`\lean{<real Mathlib name>}`, `\textit{Provided by Mathlib.}`,
no proof) — but ONLY if the Mathlib name genuinely exists in that form; otherwise leave it
as a project sub-lemma to prove. Name each new sub-lemma's `\lean{}` by convention
(e.g. `CategoryTheory.InjectiveResolution.ofShortExact_twist`,
`..._dComp`, `..._chainMap`, `..._resolvesMiddle`) and list them in your report's Notes for
the planner to confirm/scaffold.

## Strategy context
This is the P4 phase: the one abstract homological-algebra lemma "a `G`-acyclic resolution
computes `G.rightDerived`" (Stacks Tag 015E), the kernel of the whole project. Every
consumer of the horseshoe is ALREADY built and axiom-clean in `AcyclicResolution.lean`
(`rightDerivedShiftIsoOfSplitResolutionSES` and friends); the horseshoe object is the SOLE
remaining gap in the entire P4 chain. Decomposing it well is the highest-value action
available — small ready pieces let the next prover round make incremental axiom-clean
progress instead of stalling on the monolith again.

## References
- `references/homological-acyclic-derived.tex`: Stacks Tags 0157 / 015C / 015D / 015E
  (the F-acyclic / Leray-acyclicity material). The horseshoe itself is the dual of the
  projective Horseshoe Lemma (Weibel, *An Introduction to Homological Algebra*, Lemma
  2.2.8 — the proof block already cites this). You do not need a new source for the
  decomposition; the seams are structural (the ℕ-recursion), not a new theorem. If you
  judge a sub-step needs a verbatim source quote you lack, spawn a `reference-retriever`
  (you have `references/**` in your write-domain), wait, read it, then cite.
